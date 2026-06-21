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
};

String tr(String key) {
  final lang = appLang.value;
  final entry = _t[key];
  if (entry == null) return key;
  return entry[lang] ?? entry['ar'] ?? entry['en'] ?? key;
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
