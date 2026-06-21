import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:alarm/alarm.dart';

import 'theme/app_theme.dart';
import 'l10n/strings.dart';
import 'main_navigation.dart';
import 'services/storage_service.dart';
import 'services/alarm_service.dart';
import 'services/prayer_service.dart';
import 'screens/alarm_ringing_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Channel shared with native MainActivity (volume keys + full-screen intent).
const MethodChannel _nativeChannel = MethodChannel('fajr_app/volume');

/// On Android 14+, the full-screen-alert permission is restricted and often
/// OFF. Without it, the Adhan screen won't pop up over the lock screen — only
/// a notification shows. This checks it and, if missing, asks the user to
/// enable it (opening the exact settings page).
Future<void> _ensureFullScreenIntent() async {
  try {
    final allowed = await _nativeChannel
            .invokeMethod<bool>('isFullScreenIntentAllowed') ??
        true;
    if (allowed) return;
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    await showDialog(
      context: ctx,
      builder: (c) => AlertDialog(
        backgroundColor: AppTheme.navyCard,
        title: Text(tr('fsi_title'),
            style: const TextStyle(color: AppTheme.goldSoft)),
        content: Text(
          tr('fsi_body'),
          style: const TextStyle(color: AppTheme.cream, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(tr('later'),
                style: const TextStyle(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(c);
              _nativeChannel.invokeMethod('openFullScreenIntentSettings');
            },
            child: Text(tr('open_settings')),
          ),
        ],
      ),
    );
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting('ar', null);
  } catch (_) {}
  for (final l in ['en', 'fa', 'tr']) {
    try {
      await initializeDateFormatting(l, null);
    } catch (_) {}
  }
  try {
    await StorageService().init();
  } catch (_) {}

  // Decide the app language: saved choice, else the phone's language, else Arabic.
  try {
    final saved = StorageService().savedLanguage;
    if (saved != null && kSupportedLangs.contains(saved)) {
      appLang.value = saved;
    } else {
      var dev = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      if (dev == 'ku') dev = 'ckb'; // map Kurdish to Sorani
      appLang.value = kSupportedLangs.contains(dev) ? dev : 'ar';
    }
  } catch (_) {
    appLang.value = 'ar';
  }
  try {
    await AlarmService().init();
  } catch (_) {}

  // When an alarm rings (app open OR launched by the alarm), show our screen.
  Alarm.ringing.listen((alarmSet) {
    for (final alarm in alarmSet.alarms) {
      final payload = alarm.payload ?? '';
      final isMain = payload.startsWith(AlarmService.payloadMain);
      final key = payload.contains(':') ? payload.split(':').last : 'fajr';
      final name = tr('prayer_$key');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => AlarmRingingScreen(
            alarmId: alarm.id,
            isMain: isMain,
            prayerName: name,
          ),
        ),
      );
    }
  });

  runApp(const FajrApp());
}

class FajrApp extends StatefulWidget {
  const FajrApp({super.key});

  @override
  State<FajrApp> createState() => _FajrAppState();
}

class _FajrAppState extends State<FajrApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await AlarmService().requestPermissions();
      } catch (_) {}
      try {
        await AlarmService().rescheduleAll();
      } catch (_) {}
      // Give system permission dialogs a moment, then check full-screen alert.
      await Future.delayed(const Duration(milliseconds: 800));
      await _ensureFullScreenIntent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        // ckb (Sorani Kurdish) isn't a Material locale; use Arabic as the RTL
        // base for Material widgets while our own strings stay Kurdish.
        final materialLocale = lang == 'ckb' ? 'ar' : lang;
        return MaterialApp(
          title: tr('app_title'),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: AppTheme.dark,
          locale: Locale(materialLocale),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
            Locale('fa'),
            Locale('tr'),
          ],
          builder: (context, child) {
            return Directionality(
              textDirection:
                  isRtlLang(lang) ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          home: const MainNavigation(),
        );
      },
    );
  }
}
