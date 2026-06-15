import 'package:geolocator/geolocator.dart';
import 'storage_service.dart';

class LocationResult {
  final bool success;
  final String message;
  LocationResult(this.success, this.message);
}

/// Hybrid location: fetch GPS once, then everything runs offline from the
/// saved coordinates. A manual refresh re-fetches when the user travels.
class LocationService {
  final StorageService _storage = StorageService();

  Future<LocationResult> fetchAndSave() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(false, 'خدمة الموقع غير مفعّلة على الهاتف');
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

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await _storage.saveLocation(
        pos.latitude,
        pos.longitude,
        _storage.cityName, // keep existing label; user can edit later
      );
      return LocationResult(true, 'تم تحديث الموقع بنجاح');
    } catch (e) {
      return LocationResult(false, 'تعذّر الحصول على الموقع: $e');
    }
  }
}
