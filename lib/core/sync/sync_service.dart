import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../auth/auth_storage.dart';
import '../database/app_database.dart';
import 'sync_repository.dart';

enum SyncStatus { idle, syncing, success, error }

enum SyncEtapa {
  verificandoServidor,
  buscandoDiferencas,
  enviandoDados,
  baixandoDados,
  salvandoLocal,
  concluido,
}

class SyncProgresso {
  final SyncEtapa etapa;
  final int? total;
  final int? atual;
  final String mensagem;

  const SyncProgresso({
    required this.etapa,
    required this.mensagem,
    this.total,
    this.atual,
  });

  double? get percentual =>
      (total != null && total! > 0) ? (atual ?? 0) / total! : null;
}

class SyncService {
  final AppDatabase _db;
  final SyncRepository _repo;
  final Future<void> Function(DateTime) _salvarLastSync;

  /// Chamado quando o servidor retorna 401 — token expirado.
  /// O chamador deve redirecionar para /login.
  final Future<void> Function()? onTokenExpirado;

  final ValueNotifier<SyncStatus> status = ValueNotifier(SyncStatus.idle);
  final ValueNotifier<SyncProgresso?> progresso = ValueNotifier(null);
  String? ultimoErro;
  int ultimoEnviados = 0;
  int ultimoRecebidos = 0;

  Timer? _timer;

  SyncService({
    required AppDatabase db,
    required SyncRepository repo,
    required Future<void> Function(DateTime) salvarLastSync,
    this.onTokenExpirado,
  })  : _db = db,
        _repo = repo,
        _salvarLastSync = salvarLastSync;

  void iniciar(Duration intervalo) {
    _timer?.cancel();
    _timer = Timer.periodic(intervalo, (_) => sincronizar());
  }

  void parar() {
    _timer?.cancel();
    _timer = null;
  }

  void _emitir(SyncEtapa etapa, String msg, {int? total, int? atual}) {
    progresso.value = SyncProgresso(
      etapa: etapa,
      mensagem: msg,
      total: total,
      atual: atual,
    );
  }

  /// [manual] = true quando disparado pelo botão — reporta erros ao usuário.
  /// [manual] = false (background) — faz ping primeiro; sem resposta, aborta silenciosamente.
  Future<void> sincronizar({bool manual = false}) async {
    if (status.value == SyncStatus.syncing) return;
    status.value = SyncStatus.syncing;
    ultimoErro = null;
    ultimoEnviados = 0;
    ultimoRecebidos = 0;
    progresso.value = null;

    try {
      // Etapa 1: verifica disponibilidade do servidor
      _emitir(SyncEtapa.verificandoServidor, 'Verificando servidor...');
      final disponivel = await _repo.ping();
      if (!disponivel) {
        if (!manual) {
          status.value = SyncStatus.idle;
          progresso.value = null;
          return;
        }
        throw const SyncException('Servidor não está respondendo');
      }

      // Etapa 2: calcular diferenças
      _emitir(SyncEtapa.buscandoDiferencas, 'Calculando diferenças...');
      final lastSync = await _ultimoSync();
      final paraEnviar = lastSync != null
          ? await _db.registrosDao.listarModificadosApos(lastSync)
          : await _db.select(_db.registros).get();

      // Etapa 3: enviar dados locais
      if (paraEnviar.isNotEmpty) {
        _emitir(
          SyncEtapa.enviandoDados,
          'Enviando ${paraEnviar.length} registro(s) para o servidor...',
          total: paraEnviar.length,
          atual: 0,
        );
        await _repo.push(paraEnviar);
        ultimoEnviados = paraEnviar.length;
        _emitir(
          SyncEtapa.enviandoDados,
          'Enviando ${paraEnviar.length} registro(s) para o servidor...',
          total: paraEnviar.length,
          atual: paraEnviar.length,
        );
      } else {
        _emitir(SyncEtapa.enviandoDados, 'Nada para enviar');
      }

      // Marca o instante após o push — o pull usa esse ponto como novo lastSync,
      // evitando que os registros recém-enviados voltem como "novidade" do servidor.
      final inicio = DateTime.now().toUtc();

      // Etapa 4: baixar novidades — usa lastSync (anterior ao push) para não perder
      // registros que outros dispositivos enviaram enquanto este estava offline.
      _emitir(SyncEtapa.baixandoDados, 'Baixando atualizações do servidor...');
      final recebidos = await _repo.pull(lastSync);
      ultimoRecebidos = recebidos.length;

      // Etapa 5: salvar localmente (só aplica se o servidor tem versão mais nova)
      if (recebidos.isNotEmpty) {
        _emitir(
          SyncEtapa.salvandoLocal,
          'Verificando ${recebidos.length} registro(s) recebido(s)...',
          total: recebidos.length,
          atual: 0,
        );
        int aplicados = 0;
        for (var i = 0; i < recebidos.length; i++) {
          final atualizado = await _db.registrosDao.upsert(_jsonParaCompanion(recebidos[i]));
          if (atualizado) aplicados++;
          if (i % 10 == 0 || i == recebidos.length - 1) {
            _emitir(
              SyncEtapa.salvandoLocal,
              'Verificando ${recebidos.length} registro(s) recebido(s)...',
              total: recebidos.length,
              atual: i + 1,
            );
          }
        }
        ultimoRecebidos = aplicados;
      } else {
        _emitir(SyncEtapa.salvandoLocal, 'Nenhuma novidade do servidor');
      }

      // Etapa 6: concluído
      await _salvarLastSync(inicio);
      _emitir(
        SyncEtapa.concluido,
        'Concluído — ${paraEnviar.length} enviado(s), ${recebidos.length} recebido(s)',
      );
      status.value = SyncStatus.success;
    } on SyncException catch (e) {
      if (e.mensagem.contains('401')) {
        await AuthStorage.limpar();
        await onTokenExpirado?.call();
        status.value = SyncStatus.error;
        ultimoErro = 'Sessão expirada. Faça login novamente.';
        return;
      }
      if (!manual) {
        status.value = SyncStatus.idle;
        progresso.value = null;
        return;
      }
      ultimoErro = e.mensagem;
      status.value = SyncStatus.error;
    } catch (e) {
      if (!manual) {
        status.value = SyncStatus.idle;
        progresso.value = null;
        return;
      }
      ultimoErro = e.toString();
      status.value = SyncStatus.error;
    }
  }

  Future<DateTime?> _ultimoSync() async {
    // Busca via shared_preferences indiretamente — o chamador injeta via lastSyncAt
    // Para simplificar, guardamos a data como propriedade mutável.
    return _lastSyncAt;
  }

  DateTime? _lastSyncAt;

  void setLastSyncAt(DateTime? dt) => _lastSyncAt = dt;

  void resetLastSync() => _lastSyncAt = null;

  static RegistrosCompanion _jsonParaCompanion(Map<String, dynamic> json) {
    return RegistrosCompanion(
      id: Value(json['id'] as String),
      categoriaId: Value(json['categoria_id'] as String),
      titulo: Value((json['titulo'] as String?) ?? ''),
      conteudo: Value((json['conteudo'] as String?) ?? ''),
      extras: Value((json['extras'] as String?) ?? '{}'),
      deletado: Value((json['deletado'] == 1 || json['deletado'] == true)),
      data: json.containsKey('data')
          ? Value(json['data'] != null ? DateTime.tryParse(json['data'] as String) : null)
          : const Value.absent(),
      lembrete: json.containsKey('lembrete')
          ? Value(json['lembrete'] != null ? DateTime.tryParse(json['lembrete'] as String) : null)
          : const Value.absent(),
      createdAt: json['created_at'] != null
          ? Value(DateTime.parse(json['created_at'] as String).toLocal())
          : const Value.absent(),
      updatedAt: json['updated_at'] != null
          ? Value(DateTime.parse(json['updated_at'] as String).toLocal())
          : const Value.absent(),
    );
  }
}
