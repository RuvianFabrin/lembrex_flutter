import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_service.dart';
import 'sync_provider.dart';

/// Abre o dialog de progresso e aguarda o usuário fechar manualmente.
/// Retorna o SyncStatus final.
Future<SyncStatus> mostrarSyncProgressDialog(BuildContext context, WidgetRef ref) async {
  final service = ref.read(syncServiceProvider);

  // Dispara a sincronização antes de abrir o dialog
  service.sincronizar(manual: true);

  final result = await showDialog<SyncStatus>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _SyncProgressDialog(service: service),
  );

  return result ?? service.status.value;
}

class _SyncProgressDialog extends StatefulWidget {
  final SyncService service;

  const _SyncProgressDialog({required this.service});

  @override
  State<_SyncProgressDialog> createState() => _SyncProgressDialogState();
}

class _SyncProgressDialogState extends State<_SyncProgressDialog> {
  SyncProgresso? _progresso;
  SyncStatus _status = SyncStatus.syncing;

  @override
  void initState() {
    super.initState();
    widget.service.progresso.addListener(_onProgresso);
    widget.service.status.addListener(_onStatus);
  }

  @override
  void dispose() {
    widget.service.progresso.removeListener(_onProgresso);
    widget.service.status.removeListener(_onStatus);
    super.dispose();
  }

  void _onProgresso() => setState(() => _progresso = widget.service.progresso.value);
  void _onStatus() => setState(() => _status = widget.service.status.value);

  @override
  Widget build(BuildContext context) {
    final concluido = _status == SyncStatus.success || _status == SyncStatus.error;
    final erro = _status == SyncStatus.error;

    return AlertDialog(
      title: Row(
        children: [
          if (!concluido)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else
            Icon(
              erro ? Icons.error_outline : Icons.check_circle_outline,
              color: erro ? Colors.red : Colors.green,
              size: 22,
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              erro
                  ? 'Erro na sincronização'
                  : (_status == SyncStatus.success ? 'Sincronização concluída' : 'Sincronizando...'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EtapaItem(
              etapa: SyncEtapa.verificandoServidor,
              label: 'Verificando servidor',
              progresso: _progresso,
              status: _status,
            ),
            _EtapaItem(
              etapa: SyncEtapa.buscandoDiferencas,
              label: 'Calculando diferenças',
              progresso: _progresso,
              status: _status,
            ),
            _EtapaItem(
              etapa: SyncEtapa.enviandoDados,
              label: 'Enviando dados',
              progresso: _progresso,
              status: _status,
            ),
            _EtapaItem(
              etapa: SyncEtapa.baixandoDados,
              label: 'Baixando atualizações',
              progresso: _progresso,
              status: _status,
            ),
            _EtapaItem(
              etapa: SyncEtapa.salvandoLocal,
              label: 'Salvando localmente',
              progresso: _progresso,
              status: _status,
            ),
            const SizedBox(height: 12),
            // Mensagem de detalhe atual
            if (_progresso != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _progresso!.mensagem,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_progresso!.percentual != null) ...[
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: _progresso!.percentual,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_progresso!.atual} / ${_progresso!.total}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ),
            if (_status == SyncStatus.success) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withAlpha(80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Enviados ao servidor: ${widget.service.ultimoEnviados}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '• Recebidos do servidor: ${widget.service.ultimoRecebidos}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (widget.service.ultimoEnviados == 0 && widget.service.ultimoRecebidos == 0)
                      Text(
                        '• Tudo já estava sincronizado',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                  ],
                ),
              ),
            ],
            if (erro && widget.service.ultimoErro != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withAlpha(80)),
                ),
                child: Text(
                  widget.service.ultimoErro!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red.shade700),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: concluido
          ? [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_status),
                child: const Text('OK'),
              ),
            ]
          : null,
    );
  }
}

class _EtapaItem extends StatelessWidget {
  final SyncEtapa etapa;
  final String label;
  final SyncProgresso? progresso;
  final SyncStatus status;

  const _EtapaItem({
    required this.etapa,
    required this.label,
    required this.progresso,
    required this.status,
  });

  _EtapaEstado get _estado {
    if (progresso == null) return _EtapaEstado.aguardando;

    final etapaAtual = progresso!.etapa;
    final idx = SyncEtapa.values.indexOf(etapa);
    final idxAtual = SyncEtapa.values.indexOf(etapaAtual);

    if (etapaAtual == SyncEtapa.concluido && etapa != SyncEtapa.concluido) {
      return _EtapaEstado.concluida;
    }
    if (status == SyncStatus.error && idx >= idxAtual) {
      return idx == idxAtual ? _EtapaEstado.erro : _EtapaEstado.aguardando;
    }
    if (idx < idxAtual) return _EtapaEstado.concluida;
    if (idx == idxAtual) return _EtapaEstado.emProgresso;
    return _EtapaEstado.aguardando;
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estado;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: switch (estado) {
              _EtapaEstado.concluida => const Icon(Icons.check_circle, color: Colors.green, size: 18),
              _EtapaEstado.emProgresso => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              _EtapaEstado.erro => const Icon(Icons.cancel, color: Colors.red, size: 18),
              _EtapaEstado.aguardando => Icon(
                  Icons.radio_button_unchecked,
                  size: 18,
                  color: Theme.of(context).colorScheme.outline,
                ),
            },
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: switch (estado) {
                _EtapaEstado.concluida => Colors.green.shade700,
                _EtapaEstado.emProgresso => Theme.of(context).colorScheme.primary,
                _EtapaEstado.erro => Colors.red.shade700,
                _EtapaEstado.aguardando => Theme.of(context).colorScheme.outline,
              },
              fontWeight: estado == _EtapaEstado.emProgresso ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

enum _EtapaEstado { aguardando, emProgresso, concluida, erro }
