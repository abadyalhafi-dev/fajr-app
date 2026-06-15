import 'package:geolocator/geolocator.dart';
import 'storage_service.dart';

class LocationResult {
  final bool success;
  final String message;
  LocationResult(this.success, this.message);
}

class LocationService {
  final StorageService _storage = StorageService();

  Future<LocationResult> fetchAndSave() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult(false, 'فعّل خدمة الموقع (GPS) من إعدادات الهاتف');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult(false, 'تم رفض إذن الموقع');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return LocationResult(
            false, 'إذن الموقع مرفوض دائمًا، فعّله من إعدادات الهاتف');
      }

      Position? pos;
      // Try a fresh fix, but give up after 15s instead of hanging forever.
      try {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (_) {
        // Fall back to the last known location if the live fix times out.
        pos = await Geolocator.getLastKnownPosition();
      }

      if (pos == null) {
        return LocationResult(
            false, 'تعذّر تحديد الموقع، حاول في مكان مكشوف أو أعد المحاولة');
      }

      await _storage.saveLocation(
          pos.latitude, pos.longitude, _storage.cityName);
      return LocationResult(true, 'تم تحديث الموقع بنجاح');
    } catch (e) {
      return LocationResult(false, 'خطأ في تحديد الموقع: $e');
    }
  }
}
