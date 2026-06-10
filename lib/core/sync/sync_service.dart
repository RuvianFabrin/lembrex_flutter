import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../auth/auth_storage.dart';
import '../database/app_database.dart';
import 'sync_repository.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncService {
  final AppDatabase _db;
  final SyncRepository _repo;
  final Future<void> Function(DateTime) _salvarLastSync;

  /// Chamado quando o servidor retorna 401 — token expirado.
  /// O chamador deve redirecionar para /login.
  final Future<void> Function()? onTokenExpirado;

  final ValueNotifier<SyncStatus> status = ValueNotifier(SyncStatus.idle);
  String? ultimoErro;

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

  /// [manual] = true quando disparado pelo botão — reporta erros ao usuário.
  /// [manual] = false (background) — faz ping primeiro; sem resposta, aborta silenciosamente.
  Future<void> sincronizar({bool manual = false}) async {
    if (status.value == SyncStatus.syncing) return;
    status.value = SyncStatus.syncing;
    ultimoErro = null;

    try {
      // Background: verifica disponibilidade antes de tentar sync
      if (!manual) {
        final disponivel = await _repo.ping();
        if (!disponivel) {
          status.value = SyncStatus.idle;
          return;
        }
      }

      final inicio = DateTime.now().toUtc();

      // 1. Buscar último sync
      final lastSync = await _ultimoSync();

      // 2. Push — registros locais modificados desde lastSync
      final paraEnviar = lastSync != null
          ? await _db.registrosDao.listarModificadosApos(lastSync)
          : await _db.select(_db.registros).get();
      await _repo.push(paraEnviar);

      // 3. Pull — novidades do servidor
      final recebidos = await _repo.pull(lastSync);
      for (final json in recebidos) {
        await _db.registrosDao.upsert(_jsonParaCompanion(json));
      }

      // 4. Atualizar lastSync
      await _salvarLastSync(inicio);
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
        // Erro de rede em background: não polui o status, só descarta
        status.value = SyncStatus.idle;
        return;
      }
      ultimoErro = e.mensagem;
      status.value = SyncStatus.error;
    } catch (e) {
      if (!manual) {
        status.value = SyncStatus.idle;
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
