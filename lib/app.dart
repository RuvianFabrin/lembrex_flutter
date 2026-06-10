import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/auth/auth_storage.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers/database_provider.dart';
import 'core/utils/platform_utils.dart';
import 'features/auth/cadastro_page.dart';
import 'features/auth/lock_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/setup_pin_page.dart';
import 'features/registro/registro_edit_page.dart';
import 'features/sync/sync_provider.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/layout_wrapper.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// Mapa categoriaId → nome legível — usado ao navegar via notificação
const _nomeCategoria = {
  'CAT001': 'Nota Livre',
  'CAT002': 'Evento',
  'CAT003': 'Contato',
  'CAT004': 'Financeiro',
  'CAT005': 'Saúde',
  'CAT006': 'Documento',
  'CAT007': 'Tarefa',
  'CAT008': 'Aprendizado',
};

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  DateTime? _ultimaAtividade;
  static const _tempoLimite = Duration(minutes: 5);
  String? _rotaInicial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(syncServiceProvider);
    _resolverRotaInicial();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _resolverRotaInicial() async {
    final token = await AuthStorage.lerToken();
    if (mounted) {
      setState(() => _rotaInicial = token != null ? '/lock' : '/login');
    }

    // Verifica se o app foi aberto via toque em notificação (cold start)
    if (!isDesktop) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processarPayloadPendente();
      });
    }
  }

  Future<void> _processarPayloadPendente() async {
    final payload = NotificationService.pendingPayload;
    if (payload == null || payload.isEmpty) return;
    NotificationService.pendingPayload = null;

    // Aguarda o navegador estar pronto
    final nav = navigatorKey.currentState;
    if (nav == null) return;

    final db = ref.read(databaseProvider);
    final registro = await db.registrosDao.buscarPorId(payload);
    if (registro == null) return;
    if (!mounted) return;

    nav.push(MaterialPageRoute(
      builder: (_) => RegistroEditPage(
        categoriaId: registro.categoriaId,
        categoriaTitulo: _nomeCategoria[registro.categoriaId] ?? registro.categoriaId,
        registro: registro,
      ),
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _ultimaAtividade = DateTime.now();
    }
    if (state == AppLifecycleState.resumed) {
      if (_rotaInicial != '/login' && _ultimaAtividade != null) {
        final inativo =
            DateTime.now().difference(_ultimaAtividade!) > _tempoLimite;
        if (inativo) {
          navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/lock', (_) => false);
        }
      }

      // Verifica payload pendente ao voltar ao foreground (background tap)
      if (!isDesktop) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _processarPayloadPendente();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_rotaInicial == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: SizedBox.shrink()),
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Lembrex',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: _rotaInicial,
      routes: {
        '/login': (_) => const LoginPage(),
        '/cadastro': (_) => const CadastroPage(),
        '/setup-pin': (ctx) => SetupPinPage(
              rotaAposSalvar: ModalRoute.of(ctx)?.settings.arguments as String?,
            ),
        '/lock': (_) => const LockPage(),
        '/dashboard': (_) => const LayoutWrapper(),
      },
    );
  }
}
