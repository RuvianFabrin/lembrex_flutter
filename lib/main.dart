import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz_lib;
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'core/utils/platform_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR');
  await dotenv.load(fileName: '.env');

  // Inicializa timezone e notificações (apenas Android)
  if (!isDesktop) {
    tz.initializeTimeZones();
    tz_lib.setLocalLocation(tz_lib.getLocation('America/Sao_Paulo'));

    await NotificationService.inicializar(
      onNotificationTap: _onNotificationTap,
    );
    await NotificationService.solicitarPermissoes();
  }

  if (isDesktop) {
    await _initDesktop();
  }

  runApp(const ProviderScope(child: App()));
}

/// Recebe toque na notificação com app em foreground ou background.
/// O payload contém o registroId.
@pragma('vm:entry-point')
void _onNotificationTap(NotificationResponse response) {
  final registroId = response.payload;
  if (registroId == null || registroId.isEmpty) return;

  // Navega via navigatorKey — funciona se o app já está na memória
  WidgetsBinding.instance.addPostFrameCallback((_) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/dashboard',
      (_) => false,
    );
    // Guarda para o App processar após o dashboard estar montado
    NotificationService.pendingPayload = registroId;
  });
}

Future<void> _initDesktop() async {
  await windowManager.ensureInitialized();

  const options = WindowOptions(
    title: 'Lembrex',
    size: Size(1200, 750),
    minimumSize: Size(900, 600),
    center: true,
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
