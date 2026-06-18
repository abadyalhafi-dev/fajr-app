/// A city with coordinates for offline prayer-time calculation.
class CityEntry {
  final String ar; // Arabic name
  final String en; // English name
  final double lat;
  final double lng;
  const CityEntry(this.ar, this.en, this.lat, this.lng);

  String get label => '$ar  $en';
}

class CountryEntry {
  final String ar;
  final String en;
  final List<CityEntry> cities;
  const CountryEntry(this.ar, this.en, this.cities);

  String get label => '$ar  $en';
}

/// Curated list: thorough across the Middle East & North Africa, plus major
/// cities/capitals worldwide. Coordinates are standard known values, accurate
/// enough for prayer-time calculation.
const List<CountryEntry> kCountries = [
  // ---------------- GULF ----------------
  CountryEntry('قطر', 'Qatar', [
    CityEntry('الدوحة', 'Doha', 25.2854, 51.5310),
    CityEntry('الوكرة', 'Al Wakrah', 25.1715, 51.6034),
    CityEntry('الخور', 'Al Khor', 25.6840, 51.4980),
    CityEntry('الريان', 'Al Rayyan', 25.2919, 51.4244),
    CityEntry('أم صلال', 'Umm Salal', 25.4052, 51.4030),
    CityEntry('دخان', 'Dukhan', 25.4259, 50.7833),
    CityEntry('مسيعيد', 'Mesaieed', 24.9904, 51.5494),
  ]),
  CountryEntry('السعودية', 'Saudi Arabia', [
    CityEntry('مكة المكرمة', 'Mecca', 21.3891, 39.8579),
    CityEntry('المدينة المنورة', 'Medina', 24.5247, 39.5692),
    CityEntry('الرياض', 'Riyadh', 24.7136, 46.6753),
    CityEntry('جدة', 'Jeddah', 21.4858, 39.1925),
    CityEntry('الدمام', 'Dammam', 26.4207, 50.0888),
    CityEntry('الخبر', 'Khobar', 26.2794, 50.2083),
    CityEntry('الطائف', 'Taif', 21.2854, 40.4244),
    CityEntry('تبوك', 'Tabuk', 28.3838, 36.5550),
    CityEntry('بريدة', 'Buraidah', 26.3260, 43.9750),
    CityEntry('أبها', 'Abha', 18.2164, 42.5053),
    CityEntry('حائل', 'Hail', 27.5114, 41.7208),
    CityEntry('نجران', 'Najran', 17.4933, 44.1277),
    CityEntry('جازان', 'Jazan', 16.8892, 42.5611),
    CityEntry('ينبع', 'Yanbu', 24.0896, 38.0618),
  ]),
  CountryEntry('الإمارات', 'United Arab Emirates', [
    CityEntry('دبي', 'Dubai', 25.2048, 55.2708),
    CityEntry('أبوظبي', 'Abu Dhabi', 24.4539, 54.3773),
    CityEntry('الشارقة', 'Sharjah', 25.3463, 55.4209),
    CityEntry('العين', 'Al Ain', 24.1302, 55.8023),
    CityEntry('عجمان', 'Ajman', 25.4052, 55.5136),
    CityEntry('رأس الخيمة', 'Ras Al Khaimah', 25.7895, 55.9432),
    CityEntry('الفجيرة', 'Fujairah', 25.1288, 56.3265),
  ]),
  CountryEntry('الكويت', 'Kuwait', [
    CityEntry('مدينة الكويت', 'Kuwait City', 29.3759, 47.9774),
    CityEntry('الأحمدي', 'Al Ahmadi', 29.0769, 48.0838),
    CityEntry('حولي', 'Hawalli', 29.3328, 48.0286),
    CityEntry('الجهراء', 'Al Jahra', 29.3375, 47.6581),
  ]),
  CountryEntry('البحرين', 'Bahrain', [
    CityEntry('المنامة', 'Manama', 26.2285, 50.5860),
    CityEntry('المحرق', 'Muharraq', 26.2572, 50.6119),
    CityEntry('الرفاع', 'Riffa', 26.1300, 50.5550),
  ]),
  CountryEntry('عُمان', 'Oman', [
    CityEntry('مسقط', 'Muscat', 23.5880, 58.3829),
    CityEntry('صلالة', 'Salalah', 17.0151, 54.0924),
    CityEntry('صحار', 'Sohar', 24.3470, 56.7090),
    CityEntry('نزوى', 'Nizwa', 22.9333, 57.5333),
    CityEntry('صور', 'Sur', 22.5667, 59.5289),
  ]),
  CountryEntry('اليمن', 'Yemen', [
    CityEntry('صنعاء', 'Sanaa', 15.3694, 44.1910),
    CityEntry('عدن', 'Aden', 12.7855, 45.0187),
    CityEntry('تعز', 'Taiz', 13.5795, 44.0209),
    CityEntry('الحديدة', 'Hodeidah', 14.7978, 42.9545),
    CityEntry('المكلا', 'Mukalla', 14.5425, 49.1242),
  ]),

  // ---------------- LEVANT & IRAQ ----------------
  CountryEntry('العراق', 'Iraq', [
    CityEntry('بغداد', 'Baghdad', 33.3152, 44.3661),
    CityEntry('البصرة', 'Basra', 30.5085, 47.7835),
    CityEntry('الموصل', 'Mosul', 36.3450, 43.1450),
    CityEntry('أربيل', 'Erbil', 36.1911, 44.0092),
    CityEntry('النجف', 'Najaf', 31.9960, 44.3148),
    CityEntry('كربلاء', 'Karbala', 32.6160, 44.0249),
    CityEntry('كركوك', 'Kirkuk', 35.4681, 44.3922),
    CityEntry('السليمانية', 'Sulaymaniyah', 35.5650, 45.4329),
  ]),
  CountryEntry('سوريا', 'Syria', [
    CityEntry('دمشق', 'Damascus', 33.5138, 36.2765),
    CityEntry('حلب', 'Aleppo', 36.2021, 37.1343),
    CityEntry('حمص', 'Homs', 34.7308, 36.7090),
    CityEntry('حماة', 'Hama', 35.1318, 36.7578),
    CityEntry('اللاذقية', 'Latakia', 35.5317, 35.7915),
    CityEntry('دير الزور', 'Deir ez-Zor', 35.3359, 40.1408),
  ]),
  CountryEntry('الأردن', 'Jordan', [
    CityEntry('عمّان', 'Amman', 31.9454, 35.9284),
    CityEntry('الزرقاء', 'Zarqa', 32.0728, 36.0880),
    CityEntry('إربد', 'Irbid', 32.5556, 35.8500),
    CityEntry('العقبة', 'Aqaba', 29.5320, 35.0063),
  ]),
  CountryEntry('لبنان', 'Lebanon', [
    CityEntry('بيروت', 'Beirut', 33.8938, 35.5018),
    CityEntry('طرابلس', 'Tripoli', 34.4367, 35.8497),
    CityEntry('صيدا', 'Sidon', 33.5571, 35.3729),
    CityEntry('صور', 'Tyre', 33.2705, 35.2038),
  ]),
  CountryEntry('فلسطين', 'Palestine', [
    CityEntry('القدس', 'Jerusalem', 31.7683, 35.2137),
    CityEntry('غزة', 'Gaza', 31.5017, 34.4668),
    CityEntry('رام الله', 'Ramallah', 31.9038, 35.2034),
    CityEntry('الخليل', 'Hebron', 31.5326, 35.0998),
    CityEntry('نابلس', 'Nablus', 32.2211, 35.2544),
    CityEntry('بيت لحم', 'Bethlehem', 31.7054, 35.2024),
  ]),

  // ---------------- NORTH AFRICA ----------------
  CountryEntry('مصر', 'Egypt', [
    CityEntry('القاهرة', 'Cairo', 30.0444, 31.2357),
    CityEntry('الإسكندرية', 'Alexandria', 31.2001, 29.9187),
    CityEntry('الجيزة', 'Giza', 30.0131, 31.2089),
    CityEntry('شبرا الخيمة', 'Shubra El Kheima', 30.1286, 31.2422),
    CityEntry('بورسعيد', 'Port Said', 31.2653, 32.3019),
    CityEntry('السويس', 'Suez', 29.9668, 32.5498),
    CityEntry('الأقصر', 'Luxor', 25.6872, 32.6396),
    CityEntry('أسوان', 'Aswan', 24.0889, 32.8998),
    CityEntry('المنصورة', 'Mansoura', 31.0409, 31.3785),
    CityEntry('طنطا', 'Tanta', 30.7865, 31.0004),
    CityEntry('أسيوط', 'Asyut', 27.1809, 31.1837),
  ]),
  CountryEntry('ليبيا', 'Libya', [
    CityEntry('طرابلس', 'Tripoli', 32.8872, 13.1913),
    CityEntry('بنغازي', 'Benghazi', 32.1167, 20.0686),
    CityEntry('مصراتة', 'Misrata', 32.3754, 15.0925),
    CityEntry('البيضاء', 'Bayda', 32.7627, 21.7551),
    CityEntry('سبها', 'Sabha', 27.0377, 14.4283),
  ]),
  CountryEntry('تونس', 'Tunisia', [
    CityEntry('تونس', 'Tunis', 36.8065, 10.1815),
    CityEntry('صفاقس', 'Sfax', 34.7406, 10.7603),
    CityEntry('سوسة', 'Sousse', 35.8256, 10.6360),
    CityEntry('القيروان', 'Kairouan', 35.6781, 10.0963),
    CityEntry('قابس', 'Gabes', 33.8814, 10.0982),
  ]),
  CountryEntry('الجزائر', 'Algeria', [
    CityEntry('الجزائر', 'Algiers', 36.7538, 3.0588),
    CityEntry('وهران', 'Oran', 35.6969, -0.6331),
    CityEntry('قسنطينة', 'Constantine', 36.3650, 6.6147),
    CityEntry('عنابة', 'Annaba', 36.9000, 7.7667),
    CityEntry('البليدة', 'Blida', 36.4703, 2.8277),
    CityEntry('سطيف', 'Setif', 36.1898, 5.4108),
  ]),
  CountryEntry('المغرب', 'Morocco', [
    CityEntry('الدار البيضاء', 'Casablanca', 33.5731, -7.5898),
    CityEntry('الرباط', 'Rabat', 34.0209, -6.8416),
    CityEntry('فاس', 'Fez', 34.0181, -5.0078),
    CityEntry('مراكش', 'Marrakesh', 31.6295, -7.9811),
    CityEntry('طنجة', 'Tangier', 35.7595, -5.8340),
    CityEntry('أكادير', 'Agadir', 30.4278, -9.5981),
    CityEntry('مكناس', 'Meknes', 33.8935, -5.5473),
    CityEntry('وجدة', 'Oujda', 34.6814, -1.9086),
  ]),
  CountryEntry('السودان', 'Sudan', [
    CityEntry('الخرطوم', 'Khartoum', 15.5007, 32.5599),
    CityEntry('أم درمان', 'Omdurman', 15.6445, 32.4777),
    CityEntry('بورتسودان', 'Port Sudan', 19.6175, 37.2164),
    CityEntry('كسلا', 'Kassala', 15.4510, 36.4000),
  ]),
  CountryEntry('موريتانيا', 'Mauritania', [
    CityEntry('نواكشوط', 'Nouakchott', 18.0735, -15.9582),
  ]),

  // ---------------- TURKEY & IRAN ----------------
  CountryEntry('تركيا', 'Turkey', [
    CityEntry('إسطنبول', 'Istanbul', 41.0082, 28.9784),
    CityEntry('أنقرة', 'Ankara', 39.9334, 32.8597),
    CityEntry('إزمير', 'Izmir', 38.4237, 27.1428),
    CityEntry('بورصة', 'Bursa', 40.1885, 29.0610),
    CityEntry('أنطاليا', 'Antalya', 36.8969, 30.7133),
    CityEntry('أضنة', 'Adana', 37.0000, 35.3213),
    CityEntry('قونية', 'Konya', 37.8746, 32.4932),
    CityEntry('غازي عنتاب', 'Gaziantep', 37.0662, 37.3833),
  ]),
  CountryEntry('إيران', 'Iran', [
    CityEntry('طهران', 'Tehran', 35.6892, 51.3890),
    CityEntry('مشهد', 'Mashhad', 36.2605, 59.6168),
    CityEntry('أصفهان', 'Isfahan', 32.6539, 51.6660),
    CityEntry('تبريز', 'Tabriz', 38.0800, 46.2919),
    CityEntry('شيراز', 'Shiraz', 29.5918, 52.5837),
    CityEntry('قم', 'Qom', 34.6416, 50.8746),
  ]),

  // ---------------- SOUTH & CENTRAL ASIA ----------------
  CountryEntry('باكستان', 'Pakistan', [
    CityEntry('كراتشي', 'Karachi', 24.8607, 67.0011),
    CityEntry('لاهور', 'Lahore', 31.5204, 74.3587),
    CityEntry('إسلام آباد', 'Islamabad', 33.6844, 73.0479),
    CityEntry('روالبندي', 'Rawalpindi', 33.5651, 73.0169),
    CityEntry('فيصل آباد', 'Faisalabad', 31.4504, 73.1350),
    CityEntry('بيشاور', 'Peshawar', 34.0151, 71.5249),
    CityEntry('ملتان', 'Multan', 30.1575, 71.5249),
    CityEntry('كويتا', 'Quetta', 30.1798, 66.9750),
  ]),
  CountryEntry('الهند', 'India', [
    CityEntry('نيودلهي', 'New Delhi', 28.6139, 77.2090),
    CityEntry('مومباي', 'Mumbai', 19.0760, 72.8777),
    CityEntry('حيدر آباد', 'Hyderabad', 17.3850, 78.4867),
    CityEntry('بنغالور', 'Bangalore', 12.9716, 77.5946),
    CityEntry('كولكاتا', 'Kolkata', 22.5726, 88.3639),
    CityEntry('تشيناي', 'Chennai', 13.0827, 80.2707),
    CityEntry('لكناو', 'Lucknow', 26.8467, 80.9462),
  ]),
  CountryEntry('بنغلاديش', 'Bangladesh', [
    CityEntry('دكا', 'Dhaka', 23.8103, 90.4125),
    CityEntry('شيتاغونغ', 'Chittagong', 22.3569, 91.7832),
    CityEntry('خولنا', 'Khulna', 22.8456, 89.5403),
    CityEntry('سيلهيت', 'Sylhet', 24.8949, 91.8687),
  ]),
  CountryEntry('أفغانستان', 'Afghanistan', [
    CityEntry('كابول', 'Kabul', 34.5553, 69.2075),
    CityEntry('قندهار', 'Kandahar', 31.6289, 65.7372),
    CityEntry('هرات', 'Herat', 34.3529, 62.2040),
    CityEntry('مزار شريف', 'Mazar-i-Sharif', 36.7090, 67.1109),
  ]),
  CountryEntry('كازاخستان', 'Kazakhstan', [
    CityEntry('ألماتي', 'Almaty', 43.2220, 76.8512),
    CityEntry('أستانا', 'Astana', 51.1605, 71.4704),
  ]),
  CountryEntry('أوزبكستان', 'Uzbekistan', [
    CityEntry('طشقند', 'Tashkent', 41.2995, 69.2401),
    CityEntry('سمرقند', 'Samarkand', 39.6270, 66.9750),
  ]),

  // ---------------- SOUTHEAST ASIA ----------------
  CountryEntry('إندونيسيا', 'Indonesia', [
    CityEntry('جاكرتا', 'Jakarta', -6.2088, 106.8456),
    CityEntry('سورابايا', 'Surabaya', -7.2575, 112.7521),
    CityEntry('باندونغ', 'Bandung', -6.9175, 107.6191),
    CityEntry('ميدان', 'Medan', 3.5952, 98.6722),
    CityEntry('مكاسر', 'Makassar', -5.1477, 119.4327),
  ]),
  CountryEntry('ماليزيا', 'Malaysia', [
    CityEntry('كوالالمبور', 'Kuala Lumpur', 3.1390, 101.6869),
    CityEntry('جورج تاون', 'George Town', 5.4141, 100.3288),
    CityEntry('جوهور باهرو', 'Johor Bahru', 1.4927, 103.7414),
    CityEntry('كوتشينغ', 'Kuching', 1.5533, 110.3592),
  ]),
  CountryEntry('سنغافورة', 'Singapore', [
    CityEntry('سنغافورة', 'Singapore', 1.3521, 103.8198),
  ]),
  CountryEntry('بروناي', 'Brunei', [
    CityEntry('بندر سري بكاوان', 'Bandar Seri Begawan', 4.9031, 114.9398),
  ]),

  // ---------------- SUB-SAHARAN AFRICA ----------------
  CountryEntry('نيجيريا', 'Nigeria', [
    CityEntry('لاغوس', 'Lagos', 6.5244, 3.3792),
    CityEntry('أبوجا', 'Abuja', 9.0765, 7.3986),
    CityEntry('كانو', 'Kano', 12.0022, 8.5920),
  ]),
  CountryEntry('الصومال', 'Somalia', [
    CityEntry('مقديشو', 'Mogadishu', 2.0469, 45.3182),
    CityEntry('هرجيسا', 'Hargeisa', 9.5600, 44.0650),
  ]),
  CountryEntry('جيبوتي', 'Djibouti', [
    CityEntry('جيبوتي', 'Djibouti', 11.5721, 43.1456),
  ]),
  CountryEntry('السنغال', 'Senegal', [
    CityEntry('داكار', 'Dakar', 14.7167, -17.4677),
  ]),
  CountryEntry('كينيا', 'Kenya', [
    CityEntry('نيروبي', 'Nairobi', -1.2921, 36.8219),
    CityEntry('مومباسا', 'Mombasa', -4.0435, 39.6682),
  ]),
  CountryEntry('جنوب أفريقيا', 'South Africa', [
    CityEntry('جوهانسبرغ', 'Johannesburg', -26.2041, 28.0473),
    CityEntry('كيب تاون', 'Cape Town', -33.9249, 18.4241),
    CityEntry('ديربان', 'Durban', -29.8587, 31.0218),
  ]),

  // ---------------- EUROPE ----------------
  CountryEntry('المملكة المتحدة', 'United Kingdom', [
    CityEntry('لندن', 'London', 51.5074, -0.1278),
    CityEntry('برمنغهام', 'Birmingham', 52.4862, -1.8904),
    CityEntry('مانشستر', 'Manchester', 53.4808, -2.2426),
    CityEntry('غلاسكو', 'Glasgow', 55.8642, -4.2518),
    CityEntry('ليدز', 'Leeds', 53.8008, -1.5491),
  ]),
  CountryEntry('فرنسا', 'France', [
    CityEntry('باريس', 'Paris', 48.8566, 2.3522),
    CityEntry('مرسيليا', 'Marseille', 43.2965, 5.3698),
    CityEntry('ليون', 'Lyon', 45.7640, 4.8357),
    CityEntry('تولوز', 'Toulouse', 43.6047, 1.4442),
  ]),
  CountryEntry('ألمانيا', 'Germany', [
    CityEntry('برلين', 'Berlin', 52.5200, 13.4050),
    CityEntry('ميونخ', 'Munich', 48.1351, 11.5820),
    CityEntry('فرانكفورت', 'Frankfurt', 50.1109, 8.6821),
    CityEntry('هامبورغ', 'Hamburg', 53.5511, 9.9937),
    CityEntry('كولونيا', 'Cologne', 50.9375, 6.9603),
  ]),
  CountryEntry('إيطاليا', 'Italy', [
    CityEntry('روما', 'Rome', 41.9028, 12.4964),
    CityEntry('ميلانو', 'Milan', 45.4642, 9.1900),
    CityEntry('نابولي', 'Naples', 40.8518, 14.2681),
  ]),
  CountryEntry('إسبانيا', 'Spain', [
    CityEntry('مدريد', 'Madrid', 40.4168, -3.7038),
    CityEntry('برشلونة', 'Barcelona', 41.3851, 2.1734),
    CityEntry('فالنسيا', 'Valencia', 39.4699, -0.3763),
  ]),
  CountryEntry('هولندا', 'Netherlands', [
    CityEntry('أمستردام', 'Amsterdam', 52.3676, 4.9041),
    CityEntry('روتردام', 'Rotterdam', 51.9244, 4.4777),
  ]),
  CountryEntry('السويد', 'Sweden', [
    CityEntry('ستوكهولم', 'Stockholm', 59.3293, 18.0686),
    CityEntry('غوتنبرغ', 'Gothenburg', 57.7089, 11.9746),
  ]),
  CountryEntry('روسيا', 'Russia', [
    CityEntry('موسكو', 'Moscow', 55.7558, 37.6173),
    CityEntry('سان بطرسبرغ', 'Saint Petersburg', 59.9311, 30.3609),
    CityEntry('قازان', 'Kazan', 55.8304, 49.0661),
  ]),

  // ---------------- NORTH AMERICA ----------------
  CountryEntry('الولايات المتحدة', 'United States', [
    CityEntry('نيويورك', 'New York', 40.7128, -74.0060),
    CityEntry('لوس أنجلوس', 'Los Angeles', 34.0522, -118.2437),
    CityEntry('شيكاغو', 'Chicago', 41.8781, -87.6298),
    CityEntry('هيوستن', 'Houston', 29.7604, -95.3698),
    CityEntry('ديترويت', 'Detroit', 42.3314, -83.0458),
    CityEntry('واشنطن', 'Washington DC', 38.9072, -77.0369),
    CityEntry('دالاس', 'Dallas', 32.7767, -96.7970),
  ]),
  CountryEntry('كندا', 'Canada', [
    CityEntry('تورنتو', 'Toronto', 43.6532, -79.3832),
    CityEntry('مونتريال', 'Montreal', 45.5017, -73.5673),
    CityEntry('فانكوفر', 'Vancouver', 49.2827, -123.1207),
    CityEntry('كالغاري', 'Calgary', 51.0447, -114.0719),
    CityEntry('أوتاوا', 'Ottawa', 45.4215, -75.6972),
  ]),

  // ---------------- OCEANIA ----------------
  CountryEntry('أستراليا', 'Australia', [
    CityEntry('سيدني', 'Sydney', -33.8688, 151.2093),
    CityEntry('ملبورن', 'Melbourne', -37.8136, 144.9631),
    CityEntry('بريسبان', 'Brisbane', -27.4698, 153.0251),
    CityEntry('بيرث', 'Perth', -31.9505, 115.8605),
  ]),

  // ---------------- EAST ASIA ----------------
  CountryEntry('الصين', 'China', [
    CityEntry('بكين', 'Beijing', 39.9042, 116.4074),
    CityEntry('شنغهاي', 'Shanghai', 31.2304, 121.4737),
    CityEntry('غوانزو', 'Guangzhou', 23.1291, 113.2644),
    CityEntry('أورومتشي', 'Urumqi', 43.8256, 87.6168),
  ]),
  CountryEntry('اليابان', 'Japan', [
    CityEntry('طوكيو', 'Tokyo', 35.6762, 139.6503),
    CityEntry('أوساكا', 'Osaka', 34.6937, 135.5023),
  ]),
];
