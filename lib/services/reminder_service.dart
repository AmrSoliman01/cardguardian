import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/repos/ledger_repo.dart';

/// Local due-date reminders. Notification text never includes amounts, so
/// nothing sensitive shows on the lock screen.
class ReminderService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return (await android?.requestNotificationsPermission()) ??
        (await ios?.requestPermissions(alert: true, sound: true)) ??
        false;
  }

  /// Replaces all scheduled reminders with ones for [dues].
  Future<void> schedule(
    List<DueItem> dues, {
    required String Function(DueItem d, int daysBefore) title,
    required String body,
  }) async {
    await _init();
    await _plugin.cancelAll();
    final now = tz.TZDateTime.now(tz.local);
    var id = 1;
    for (final d in dues.take(20)) {
      for (final daysBefore in const [3, 0]) {
        final day = d.dueDate.subtract(Duration(days: daysBefore));
        final at = tz.TZDateTime(tz.local, day.year, day.month, day.day, 10);
        if (at.isBefore(now)) continue;
        await _plugin.zonedSchedule(
          id: id++,
          scheduledDate: at,
          title: title(d, daysBefore),
          body: body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'due_dates',
              'Due dates',
              importance: Importance.high,
              visibility: NotificationVisibility.private,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
