import 'package:flutter/widgets.dart';

/// Supported language codes. ckb = Kurdish (Sorani, Arabic script, RTL).
const List<String> kSupportedLangs = ['ar', 'en', 'fa', 'tr', 'ckb'];

/// Display names for the language picker.
const Map<String, String> kLangNames = {
  'ar': 'العربية',
  'en': 'English',
  'fa': 'فارسی',
  'tr': 'Türkçe',
  'ckb': 'کوردی',
};

bool isRtlLang(String lang) =>
    lang == 'ar' || lang == 'fa' || lang == 'ckb';

/// The active language. MaterialApp listens to this and rebuilds on change.
final ValueNotifier<String> appLang = ValueNotifier<String>('ar');

/// Convert Arabic-Indic / Persian digits to Western digits (app uses Western).
String wd(String s) {
  const map = {
    '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
    '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
    '۰': '0', '۱': '1', '۲': '2', '۳': '3', '۴': '4',
    '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9',
  };
  final b = StringBuffer();
  for (final ch in s.split('')) {
    b.write(map[ch] ?? ch);
  }
  return b.toString();
}

/// UI strings: key -> { lang -> text }.
/// NOTE: Farsi (fa) and Kurdish Sorani (ckb) should be reviewed by a native
/// speaker before public release — religious terms need care.
const Map<String, Map<String, String>> _t = {
  'app_title': {
    'ar': 'منبه الفجر',
    'en': 'Fajr Alarm',
    'fa': 'بیدارباش فجر',
    'tr': 'Fajr Alarmı',
    'ckb': 'ئاگادارکەرەوەی بەیانی',
  },
  'nav_home': {
    'ar': 'الرئيسية', 'en': 'Home', 'fa': 'خانه', 'tr': 'Ana Sayfa',
    'ckb': 'سەرەکی',
  },
  'nav_calendar': {
    'ar': 'التقويم', 'en': 'Calendar', 'fa': 'تقویم', 'tr': 'Takvim',
    'ckb': 'ساڵنامە',
  },
  'nav_alarm': {
    'ar': 'المنبه', 'en': 'Alarm', 'fa': 'هشدار', 'tr': 'Alarm',
    'ckb': 'ئاگادارکەرەوە',
  },
  'nav_settings': {
    'ar': 'الإعدادات', 'en': 'Settings', 'fa': 'تنظیمات', 'tr': 'Ayarlar',
    'ckb': 'ڕێکخستن',
  },
  'today_times': {
    'ar': 'أوقات اليوم', 'en': "Today's Times", 'fa': 'اوقات امروز',
    'tr': 'Bugünün Vakitleri', 'ckb': 'کاتەکانی ئەمڕۆ',
  },
  'qibla_direction': {
    'ar': 'اتجاه القبلة', 'en': 'Qibla Direction', 'fa': 'جهت قبله',
    'tr': 'Kıble Yönü', 'ckb': 'ئاراستەی قیبلە',
  },
  'next_prayer': {
    'ar': 'الصلاة القادمة', 'en': 'Next Prayer', 'fa': 'نماز بعدی',
    'tr': 'Sonraki Namaz', 'ckb': 'نوێژی داهاتوو',
  },
  'remaining_time': {
    'ar': 'الوقت المتبقي', 'en': 'Time Remaining', 'fa': 'زمان باقی‌مانده',
    'tr': 'Kalan Süre', 'ckb': 'کاتی ماوە',
  },
  'language': {
    'ar': 'اللغة', 'en': 'Language', 'fa': 'زبان', 'tr': 'Dil',
    'ckb': 'زمان',
  },
  // Prayer names
  'prayer_fajr': {
    'ar': 'الفجر', 'en': 'Fajr', 'fa': 'صبح', 'tr': 'Sabah', 'ckb': 'بەیانی',
  },
  'prayer_dhuhr': {
    'ar': 'الظهر', 'en': 'Dhuhr', 'fa': 'ظهر', 'tr': 'Öğle', 'ckb': 'نیوەڕۆ',
  },
  'prayer_asr': {
    'ar': 'العصر', 'en': 'Asr', 'fa': 'عصر', 'tr': 'İkindi', 'ckb': 'عەسر',
  },
  'prayer_maghrib': {
    'ar': 'المغرب', 'en': 'Maghrib', 'fa': 'مغرب', 'tr': 'Akşam',
    'ckb': 'مەغریب',
  },
  'prayer_isha': {
    'ar': 'العشاء', 'en': 'Isha', 'fa': 'عشا', 'tr': 'Yatsı', 'ckb': 'عیشا',
  },
  // Full-screen-intent dialog
  'fsi_title': {
    'ar': 'إذن مهم للمنبه', 'en': 'Important alarm permission',
    'fa': 'مجوز مهم هشدار', 'tr': 'Önemli alarm izni',
    'ckb': 'مۆڵەتی گرنگ بۆ ئاگادارکەرەوە',
  },
  'fsi_body': {
    'ar': 'حتى تظهر شاشة المنبه فوق الشاشة المقفلة عند الأذان، يجب تفعيل «التنبيهات في وضع ملء الشاشة». اضغط «فتح الإعدادات»، ثم فعّل التطبيق.',
    'en': 'For the alarm screen to appear over the lock screen at prayer time, enable full-screen alerts. Tap "Open settings", then enable the app.',
    'fa': 'برای اینکه صفحه هشدار هنگام اذان روی صفحه قفل ظاهر شود، هشدارهای تمام‌صفحه را فعال کنید. روی «باز کردن تنظیمات» بزنید و برنامه را فعال کنید.',
    'tr': 'Alarm ekranının ezan vaktinde kilit ekranının üzerinde görünmesi için tam ekran uyarılarını etkinleştirin. "Ayarları aç" düğmesine dokunun ve uygulamayı etkinleştirin.',
    'ckb': 'بۆ ئەوەی شاشەی ئاگادارکەرەوە لە کاتی بانگدا لەسەر شاشەی داخراو دەربکەوێت، ئاگادارییە تەواوشاشەییەکان چالاک بکە. لە «کردنەوەی ڕێکخستن» بدە و بەرنامەکە چالاک بکە.',
  },
  'later': {
    'ar': 'لاحقًا', 'en': 'Later', 'fa': 'بعداً', 'tr': 'Sonra',
    'ckb': 'دواتر',
  },
  'open_settings': {
    'ar': 'فتح الإعدادات', 'en': 'Open settings', 'fa': 'باز کردن تنظیمات',
    'tr': 'Ayarları aç', 'ckb': 'کردنەوەی ڕێکخستن',
  },
  'hijri_suffix': {
    'ar': 'هـ', 'en': 'AH', 'fa': 'ﻫ.ق', 'tr': 'H', 'ckb': 'ك',
  },
  // ---- Alarm settings ----
  'alarm_title': {
    'ar': 'المنبه', 'en': 'Alarm', 'fa': 'هشدار', 'tr': 'Alarm', 'ckb': 'ئاگادارکەرەوە',
  },
  'prayers_adhan': {
    'ar': 'أذان الصلوات', 'en': 'Prayer Adhan', 'fa': 'اذان نمازها',
    'tr': 'Namaz Ezanı', 'ckb': 'بانگی نوێژەکان',
  },
  'fajr_prealarm': {
    'ar': 'التنبيه المبكر للفجر', 'en': 'Fajr Pre-Alarm',
    'fa': 'هشدار زودهنگام فجر', 'tr': 'Sabah Ön Alarmı',
    'ckb': 'ئاگاداری پێشوەختەی بەیانی',
  },
  'prealarm_before': {
    'ar': 'قبل {n} دقيقة من الفجر', 'en': '{n} minutes before Fajr',
    'fa': '{n} دقیقه قبل از فجر', 'tr': "Sabahtan {n} dakika önce",
    'ckb': '{n} خولەک پێش بەیانی',
  },
  'minutes_label': {
    'ar': 'الدقائق:', 'en': 'Minutes:', 'fa': 'دقیقه:', 'tr': 'Dakika:',
    'ckb': 'خولەک:',
  },
  'vibration_on_alarm': {
    'ar': 'الاهتزاز عند التنبيه', 'en': 'Vibrate on alarm',
    'fa': 'لرزش هنگام هشدار', 'tr': 'Alarmda titreşim',
    'ckb': 'لەرزین لە کاتی ئاگادارکردنەوە',
  },
  'sounds': {
    'ar': 'الأصوات', 'en': 'Sounds', 'fa': 'صداها', 'tr': 'Sesler',
    'ckb': 'دەنگەکان',
  },
  'fajr_adhan_sound': {
    'ar': 'صوت أذان الفجر', 'en': 'Fajr adhan sound', 'fa': 'صدای اذان فجر',
    'tr': 'Sabah ezanı sesi', 'ckb': 'دەنگی بانگی بەیانی',
  },
  'prealarm_sound': {
    'ar': 'صوت التنبيه المبكر', 'en': 'Pre-alarm sound',
    'fa': 'صدای هشدار زودهنگام', 'tr': 'Ön alarm sesi',
    'ckb': 'دەنگی ئاگاداری پێشوەختە',
  },
  'not_selected': {
    'ar': 'لم يتم الاختيار', 'en': 'Not selected', 'fa': 'انتخاب نشده',
    'tr': 'Seçilmedi', 'ckb': 'هەڵنەبژێردراوە',
  },
  'all_alarms_updated': {
    'ar': 'تم تحديث جميع التنبيهات', 'en': 'All alarms updated',
    'fa': 'همه هشدارها به‌روزرسانی شد', 'tr': 'Tüm alarmlar güncellendi',
    'ckb': 'هەموو ئاگادارکەرەوەکان نوێکرانەوە',
  },
  'error_prefix': {
    'ar': 'خطأ: ', 'en': 'Error: ', 'fa': 'خطا: ', 'tr': 'Hata: ',
    'ckb': 'هەڵە: ',
  },
  'save_update_alarms': {
    'ar': 'حفظ وتحديث التنبيهات', 'en': 'Save & update alarms',
    'fa': 'ذخیره و به‌روزرسانی هشدارها', 'tr': 'Alarmları kaydet ve güncelle',
    'ckb': 'پاشەکەوت و نوێکردنەوەی ئاگادارکەرەوەکان',
  },
  // ---- Qibla ----
  'compass_read_error': {
    'ar': 'تعذّر قراءة البوصلة على هذا الجهاز', 'en': 'Cannot read the compass on this device',
    'fa': 'خواندن قطب‌نما روی این دستگاه ممکن نیست', 'tr': 'Bu cihazda pusula okunamıyor',
    'ckb': 'ناتوانرێت قیبلەنما لەم ئامێرە بخوێنرێتەوە',
  },
  'compass_unavailable': {
    'ar': 'البوصلة غير متوفرة على هذا الجهاز\nجهازك قد لا يحتوي على حساس مغناطيسي',
    'en': 'Compass not available on this device\nYour device may not have a magnetic sensor',
    'fa': 'قطب‌نما روی این دستگاه موجود نیست\nدستگاه شما ممکن است حسگر مغناطیسی نداشته باشد',
    'tr': 'Bu cihazda pusula yok\nCihazınızda manyetik sensör olmayabilir',
    'ckb': 'قیبلەنما لەم ئامێرەدا بەردەست نییە\nلەوانەیە ئامێرەکەت هەستەوەری moغناتیسی نەبێت',
  },
  'qibla_from_location': {
    'ar': 'اتجاه القبلة من موقعك', 'en': 'Qibla direction from your location',
    'fa': 'جهت قبله از موقعیت شما', 'tr': 'Konumunuzdan kıble yönü',
    'ckb': 'ئاراستەی قیبلە لە شوێنەکەتەوە',
  },
  'north_letter': {
    'ar': 'ش', 'en': 'N', 'fa': 'ش', 'tr': 'K', 'ckb': 'ب',
  },
  'facing_qibla': {
    'ar': '✓ أنت تواجه القبلة', 'en': '✓ You are facing the Qibla',
    'fa': '✓ شما رو به قبله هستید', 'tr': '✓ Kıbleye dönüksünüz',
    'ckb': '✓ تۆ ڕووت لە قیبلەیە',
  },
  'turn_phone_arrow': {
    'ar': 'أدر الهاتف حتى يشير السهم للأعلى', 'en': 'Turn the phone until the arrow points up',
    'fa': 'گوشی را بچرخانید تا فلش رو به بالا شود', 'tr': 'Ok yukarı bakana kadar telefonu çevirin',
    'ckb': 'مۆبایلەکە بسووڕێنە تا تیرەکە بەرەو سەرەوە بێت',
  },
  'current_heading': {
    'ar': 'اتجاهك الحالي: {d}°', 'en': 'Your heading: {d}°',
    'fa': 'جهت فعلی شما: {d}°', 'tr': 'Yönünüz: {d}°',
    'ckb': 'ئاراستەی ئێستات: {d}°',
  },
  'calibrate_hint': {
    'ar': 'لمعايرة البوصلة، حرّك الهاتف على شكل ∞', 'en': 'To calibrate, move the phone in a figure-8 (∞)',
    'fa': 'برای کالیبره کردن، گوشی را به شکل ∞ حرکت دهید', 'tr': 'Kalibre etmek için telefonu ∞ şeklinde hareket ettirin',
    'ckb': 'بۆ ڕێکخستن، مۆبایلەکە بە شێوەی ∞ بجوڵێنە',
  },
  // ---- City picker ----
  'city_selected': {
    'ar': 'تم اختيار {city}', 'en': 'Selected {city}', 'fa': '{city} انتخاب شد',
    'tr': '{city} seçildi', 'ckb': '{city} هەڵبژێردرا',
  },
  'select_city': {
    'ar': 'اختيار المدينة', 'en': 'Select City', 'fa': 'انتخاب شهر',
    'tr': 'Şehir Seç', 'ckb': 'شار هەڵبژێرە',
  },
  'country': {
    'ar': 'الدولة', 'en': 'Country', 'fa': 'کشور', 'tr': 'Ülke', 'ckb': 'وڵات',
  },
  'search_city': {
    'ar': 'ابحث عن مدينة...', 'en': 'Search for a city...',
    'fa': 'جستجوی شهر...', 'tr': 'Şehir ara...', 'ckb': 'بەدوای شاردا بگەڕێ...',
  },
  'no_results': {
    'ar': 'لا توجد نتائج', 'en': 'No results', 'fa': 'نتیجه‌ای نیست',
    'tr': 'Sonuç yok', 'ckb': 'هیچ ئەنجامێک نییە',
  },
  // ---- Iqama ----
  'iqama_after': {
    'ar': 'إقامة {name} بعد', 'en': 'Iqama for {name} in',
    'fa': 'اقامه {name} پس از', 'tr': '{name} kameti',
    'ckb': 'قامەتی {name} دوای',
  },
  // ---- Location service ----
  'loc_service_disabled': {
    'ar': 'خدمة الموقع غير مفعّلة على الهاتف', 'en': 'Location service is off on the phone',
    'fa': 'سرویس موقعیت روی گوشی خاموش است', 'tr': 'Telefonda konum servisi kapalı',
    'ckb': 'خزمەتگوزاری شوێن لەسەر مۆبایل کوژاوەتەوە',
  },
  'loc_denied': {
    'ar': 'تم رفض إذن الموقع', 'en': 'Location permission denied',
    'fa': 'مجوز موقعیت رد شد', 'tr': 'Konum izni reddedildi',
    'ckb': 'مۆڵەتی شوێن ڕەتکرایەوە',
  },
  'loc_denied_forever': {
    'ar': 'إذن الموقع مرفوض دائمًا، فعّله من إعدادات الهاتف',
    'en': 'Location permission permanently denied; enable it in phone settings',
    'fa': 'مجوز موقعیت برای همیشه رد شده؛ از تنظیمات گوشی فعال کنید',
    'tr': 'Konum izni kalıcı olarak reddedildi; telefon ayarlarından açın',
    'ckb': 'مۆڵەتی شوێن بۆ هەمیشە ڕەتکراوەتەوە؛ لە ڕێکخستنی مۆبایل چالاکی بکە',
  },
  'loc_updated': {
    'ar': 'تم تحديث الموقع: {city}', 'en': 'Location updated: {city}',
    'fa': 'موقعیت به‌روزرسانی شد: {city}', 'tr': 'Konum güncellendi: {city}',
    'ckb': 'شوێن نوێکرایەوە: {city}',
  },
  'loc_failed': {
    'ar': 'تعذّر الحصول على الموقع: ', 'en': 'Could not get location: ',
    'fa': 'دریافت موقعیت ممکن نشد: ', 'tr': 'Konum alınamadı: ',
    'ckb': 'نەتوانرا شوێن وەربگیرێت: ',
  },
  'my_location': {
    'ar': 'موقعي', 'en': 'My location', 'fa': 'موقعیت من', 'tr': 'Konumum',
    'ckb': 'شوێنەکەم',
  },
  // ---- Settings ----
  'settings_title': {
    'ar': 'الإعدادات', 'en': 'Settings', 'fa': 'تنظیمات', 'tr': 'Ayarlar',
    'ckb': 'ڕێکخستن',
  },
  'location': {
    'ar': 'الموقع', 'en': 'Location', 'fa': 'موقعیت', 'tr': 'Konum',
    'ckb': 'شوێن',
  },
  'city_label': {
    'ar': 'المدينة', 'en': 'City', 'fa': 'شهر', 'tr': 'Şehir', 'ckb': 'شار',
  },
  'latitude': {
    'ar': 'خط العرض', 'en': 'Latitude', 'fa': 'عرض جغرافیایی',
    'tr': 'Enlem', 'ckb': 'پانی',
  },
  'longitude': {
    'ar': 'خط الطول', 'en': 'Longitude', 'fa': 'طول جغرافیایی',
    'tr': 'Boylam', 'ckb': 'درێژی',
  },
  'gps_auto': {
    'ar': 'تحديد الموقع تلقائيًا (GPS)', 'en': 'Detect location automatically (GPS)',
    'fa': 'تشخیص خودکار موقعیت (GPS)', 'tr': 'Konumu otomatik algıla (GPS)',
    'ckb': 'دۆزینەوەی خۆکاری شوێن (GPS)',
  },
  'manual_city': {
    'ar': 'اختيار المدينة يدويًا', 'en': 'Choose city manually',
    'fa': 'انتخاب دستی شهر', 'tr': 'Şehri elle seç',
    'ckb': 'هەڵبژاردنی شار بە دەستی',
  },
  'calc_method': {
    'ar': 'طريقة الحساب', 'en': 'Calculation method', 'fa': 'روش محاسبه',
    'tr': 'Hesaplama yöntemi', 'ckb': 'شێوازی ژمێریاری',
  },
  'umm_alqura': {
    'ar': 'أم القرى', 'en': 'Umm al-Qura', 'fa': 'ام‌القری',
    'tr': 'Ummü’l-Kura', 'ckb': 'ئوم ئەلقورا',
  },
  'adjust_times': {
    'ar': 'تعديل الأوقات (بالدقائق)', 'en': 'Adjust times (minutes)',
    'fa': 'تنظیم اوقات (دقیقه)', 'tr': 'Vakitleri ayarla (dakika)',
    'ckb': 'ڕێکخستنی کاتەکان (خولەک)',
  },
  'iqama_time': {
    'ar': 'وقت الإقامة (دقائق بعد الأذان)', 'en': 'Iqama time (minutes after adhan)',
    'fa': 'زمان اقامه (دقیقه پس از اذان)', 'tr': 'Kamet süresi (ezandan sonra dakika)',
    'ckb': 'کاتی قامەت (خولەک دوای بانگ)',
  },
  'alarm_permissions': {
    'ar': 'أذونات التنبيه', 'en': 'Alarm permissions', 'fa': 'مجوزهای هشدار',
    'tr': 'Alarm izinleri', 'ckb': 'مۆڵەتەکانی ئاگادارکەرەوە',
  },
  'permissions_desc': {
    'ar': 'فعّل الأذونات وتجاهل تحسين البطارية لضمان عمل المنبه',
    'en': 'Enable permissions and ignore battery optimization to keep the alarm working',
    'fa': 'برای کارکرد هشدار، مجوزها را فعال و بهینه‌سازی باتری را نادیده بگیرید',
    'tr': 'Alarmın çalışması için izinleri etkinleştirin ve pil optimizasyonunu yok sayın',
    'ckb': 'بۆ کارکردنی ئاگادارکەرەوە، مۆڵەتەکان چالاک بکە و باشکردنی باتری پشتگوێ بخە',
  },
  'app_version': {
    'ar': 'تطبيق منبه الفجر • إصدار 1.0', 'en': 'Fajr Alarm app • version 1.0',
    'fa': 'برنامه بیدارباش فجر • نسخه 1.0', 'tr': 'Fajr Alarm uygulaması • sürüm 1.0',
    'ckb': 'بەرنامەی ئاگادارکەرەوەی بەیانی • وەشانی 1.0',
  },
  // ---- Calendar ----
  'calendar_title': {
    'ar': 'التقويم', 'en': 'Calendar', 'fa': 'تقویم', 'tr': 'Takvim', 'ckb': 'ساڵنامە',
  },
  'prayer_times': {
    'ar': 'أوقات الصلاة', 'en': 'Prayer Times', 'fa': 'اوقات نماز',
    'tr': 'Namaz Vakitleri', 'ckb': 'کاتەکانی نوێژ',
  },
  'events': {
    'ar': 'المناسبات', 'en': 'Events', 'fa': 'رویدادها', 'tr': 'Etkinlikler',
    'ckb': 'بۆنەکان',
  },
  'no_events': {
    'ar': 'لا توجد مناسبات في هذا اليوم', 'en': 'No events on this day',
    'fa': 'رویدادی در این روز نیست', 'tr': 'Bu günde etkinlik yok',
    'ckb': 'هیچ بۆنەیەک لەم ڕۆژەدا نییە',
  },
  'add_event': {
    'ar': 'إضافة مناسبة', 'en': 'Add event', 'fa': 'افزودن رویداد',
    'tr': 'Etkinlik ekle', 'ckb': 'زیادکردنی بۆنە',
  },
  'title_label': {
    'ar': 'العنوان', 'en': 'Title', 'fa': 'عنوان', 'tr': 'Başlık', 'ckb': 'ناونیشان',
  },
  'note_optional': {
    'ar': 'ملاحظة (اختياري)', 'en': 'Note (optional)', 'fa': 'یادداشت (اختیاری)',
    'tr': 'Not (isteğe bağlı)', 'ckb': 'تێبینی (ئارەزوومەندانە)',
  },
  'cancel': {
    'ar': 'إلغاء', 'en': 'Cancel', 'fa': 'لغو', 'tr': 'İptal', 'ckb': 'هەڵوەشاندنەوە',
  },
  'save': {
    'ar': 'حفظ', 'en': 'Save', 'fa': 'ذخیره', 'tr': 'Kaydet', 'ckb': 'پاشەکەوت',
  },
};

String tr(String key) {
  final lang = appLang.value;
  final entry = _t[key];
  if (entry == null) return key;
  return entry[lang] ?? entry['ar'] ?? entry['en'] ?? key;
}

/// Translation with placeholders, e.g. trp('city_selected', {'city': 'الدوحة'}).
String trp(String key, Map<String, String> params) {
  var s = tr(key);
  params.forEach((k, v) {
    s = s.replaceAll('{$k}', v);
  });
  return s;
}

/// Weekday names, indexed 0=Sunday .. 6=Saturday.
const Map<String, List<String>> _weekdays = {
  'ar': ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'],
  'en': ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
  'fa': ['یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه', 'شنبه'],
  'tr': ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'],
  'ckb': ['یەکشەممە', 'دووشەممە', 'سێشەممە', 'چوارشەممە', 'پێنجشەممە', 'هەینی', 'شەممە'],
};

/// Gregorian month names, indexed 0=January .. 11=December.
const Map<String, List<String>> _gregMonths = {
  'ar': ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'],
  'en': ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
  'fa': ['ژانویه', 'فوریه', 'مارس', 'آوریل', 'مه', 'ژوئن', 'ژوئیه', 'اوت', 'سپتامبر', 'اکتبر', 'نوامبر', 'دسامبر'],
  'tr': ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'],
  'ckb': ['کانوونی دووەم', 'شوبات', 'ئازار', 'نیسان', 'مایس', 'حوزەیران', 'تەمموز', 'ئاب', 'ئەیلوول', 'تشرینی یەکەم', 'تشرینی دووەم', 'کانوونی یەکەم'],
};

/// Hijri month names, indexed 0 .. 11 (Muharram .. Dhu al-Hijjah).
const Map<String, List<String>> _hijriMonths = {
  'ar': ['محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر', 'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'],
  'en': ['Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani', 'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', "Sha'ban", 'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah'],
  'fa': ['محرم', 'صفر', 'ربیع‌الاول', 'ربیع‌الثانی', 'جمادی‌الاول', 'جمادی‌الثانی', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذی‌القعده', 'ذی‌الحجه'],
  'tr': ['Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir', 'Cemaziyelevvel', 'Cemaziyelahir', 'Recep', 'Şaban', 'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce'],
  'ckb': ['موحەڕەم', 'سەفەر', 'ڕەبیعی یەکەم', 'ڕەبیعی دووەم', 'جومادای یەکەم', 'جومادای دووەم', 'ڕەجەب', 'شەعبان', 'ڕەمەزان', 'شەووال', 'زولقەعدە', 'زولحیججە'],
};

List<String> _pick(Map<String, List<String>> m) =>
    m[appLang.value] ?? m['ar']!;

/// Weekday name for a DateTime (Mon=1..Sun=7 -> 0=Sunday..6=Saturday).
String weekdayName(int weekday) => _pick(_weekdays)[weekday % 7];

String gregMonthName(int month) => _pick(_gregMonths)[(month - 1) % 12];

String hijriMonthName(int month) => _pick(_hijriMonths)[(month - 1) % 12];
