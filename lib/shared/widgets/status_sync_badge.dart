import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_service.dart';
import '../../features/sync/sync_provider.dart';

class SyncStatusBadge extends ConsumerStatefulWidget {
  const SyncStatusBadge({super.key});

  @override
  ConsumerState<SyncStatusBadge> createState() => _SyncStatusBadgeState();
}

class _SyncStatusBadgeState extends ConsumerState<SyncStatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotacao;

  @override
  void initState() {
    super.initState();
    _rotacao = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // Escuta mudanças de status para controlar a animação
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncServiceProvider).status.addListener(_onStatusChange);
    });
  }

  void _onStatusChange() {
    if (!mounted) return;
    final s = ref.read(syncServiceProvider).status.value;
    if (s == SyncStatus.syncing) {
      _rotacao.repeat();
    } else {
      _rotacao.stop();
      _rotacao.reset();
    }
    setState(() {});
  }

  @override
  void dispose() {
    // Seguro remover — se o provider já foi descartado o ValueNotifier não existe mais
    try {
      ref.read(syncServiceProvider).status.removeListener(_onStatusChange);
    } catch (_) {}
    _rotacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(syncServiceProvider);
    final status = service.status.value;

    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _rotacao,
      builder: (_, __) {
        Widget icon;
        Color cor;
        String tooltip;

        switch (status) {
          case SyncStatus.syncing:
            icon = RotationTransition(
              turns: _rotacao,
              child: const Icon(Icons.sync),
            );
            cor = colorScheme.primary;
            tooltip = 'Sincronizando...';
          case SyncStatus.success:
            icon = const Icon(Icons.cloud_done_outlined);
            cor = Colors.green;
            tooltip = 'Sincronizado';
          case SyncStatus.error:
            icon = const Icon(Icons.sync_problem_outlined);
            cor = colorScheme.error;
            tooltip = service.ultimoErro ?? 'Erro de sincronização';
          case SyncStatus.idle:
            icon = const Icon(Icons.sync);
            cor = colorScheme.onSurfaceVariant;
            tooltip = 'Sincronização';
        }

        return IconButton(
          icon: IconTheme(data: IconThemeData(color: cor), child: icon),
          tooltip: tooltip,
          onPressed: status == SyncStatus.error
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(service.ultimoErro ?? 'Erro desconhecido')),
                  )
              : null,
        );
      },
    );
  }
}
