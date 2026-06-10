import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../core/auth/auth_storage.dart';
import '../../core/providers/database_provider.dart';
import '../../core/sync/sync_repository.dart';
import '../../core/sync/sync_service.dart';
import '../configuracoes/configuracoes_provider.dart';

/// Provider singleton do SyncService — inicializado uma vez, reutilizado em todo o app.
final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);

  final cfg = ref.watch(configuracoesProvider).valueOrNull;
  final repo = SyncRepository(
    baseUrl: cfg?.apiUrl ?? 'http://localhost:38080',
  );

  final service = SyncService(
    db: db,
    repo: repo,
    salvarLastSync: (dt) =>
        ref.read(configuracoesProvider.notifier).atualizarLastSync(dt),
    onTokenExpirado: () async {
      // Só redireciona se o usuário já estava logado (token existia antes do 401)
      final token = await AuthStorage.lerToken();
      if (token == null) return; // sync rodou sem sessão — ignora silenciosamente
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (_) => false);
    },
  );

  // Propaga lastSyncAt do prefs para o service
  service.setLastSyncAt(cfg?.lastSyncAt);

  // Inicia timer com intervalo salvo
  final intervalo = cfg?.intervaloMinutos ?? 5;
  service.iniciar(Duration(minutes: intervalo));

  ref.onDispose(service.parar);

  return service;
});
