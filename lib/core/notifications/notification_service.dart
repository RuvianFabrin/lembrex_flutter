import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final _plugin = FlutterLocalNotificationsPlugin();

const _androidChannel = AndroidNotificationDetails(
  'lembrex_lembretes',
  'Lembretes',
  channelDescription: 'Notificações de lembrete do Lembrex',
  importance: Importance.high,
  priority: Priority.high,
);

const _notificationDetails = NotificationDetails(android: _androidChannel);

class NotificationService {
  /// Payload da notificação que iniciou o app (cold start). Lido uma única vez.
  static String? pendingPayload;

  /// Inicializa o plugin. Deve ser chamado no main() antes de runApp().
  static Future<void> inicializar({
    void Function(NotificationResponse)? onNotificationTap,
  }) async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    // Captura payload de cold start (app foi aberto pelo toque na notificação)
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      pendingPayload = launchDetails?.notificationResponse?.payload;
    }
  }

  /// Solicita permissões necessárias no Android 12+/13+.
  static Future<void> solicitarPermissoes() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.requestNotificationsPermission();
    await androidPlugin.requestExactAlarmsPermission();
  }

  /// Agenda uma notificação exata. Se [dataHora] já passou, não faz nada.
  static Future<void> agendar({
    required String registroId,
    required String titulo,
    required String corpo,
    required DateTime dataHora,
  }) async {
    final agora = tz.TZDateTime.now(tz.local);
    final alvo = tz.TZDateTime.from(dataHora, tz.local);
    if (alvo.isBefore(agora)) return;

    final id = _idPara(registroId);
    await _plugin.zonedSchedule(
      id,
      titulo,
      corpo,
      alvo,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: registroId,
    );
  }

  /// Cancela a notificação associada ao registro.
  static Future<void> cancelar(String registroId) async {
    await _plugin.cancel(_idPara(registroId));
  }

  /// Converte o id String do registro em int seguro para o plugin.
  static int _idPara(String registroId) =>
      registroId.hashCode & 0x7FFFFFFF;
}
