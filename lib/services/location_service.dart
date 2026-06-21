import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'storage_service.dart';
import '../data/cities.dart';

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
      // Name the location by the nearest city in our offline list, so the
      // home screen shows where the user actually is (not the old label).
      final name = _nearestCityName(pos.latitude, pos.longitude);
      await _storage.saveLocation(pos.latitude, pos.longitude, name);
      return LocationResult(true, 'تم تحديث الموقع: $name');
    } catch (e) {
      return LocationResult(false, 'تعذّر الحصول على الموقع: $e');
    }
  }

  /// Nearest city (by name) from the offline dataset. Works without internet.
  String _nearestCityName(double lat, double lng) {
    String best = 'موقعي';
    double bestDist = double.infinity;
    for (final country in kCountries) {
      for (final city in country.cities) {
        final d = _distSq(lat, lng, city.lat, city.lng);
        if (d < bestDist) {
          bestDist = d;
          best = city.ar;
        }
      }
    }
    return best;
  }

  // Squared equirectangular distance — accurate enough for nearest-city.
  double _distSq(double lat1, double lng1, double lat2, double lng2) {
    final dLat = lat1 - lat2;
    final dLng = (lng1 - lng2) * math.cos(lat1 * math.pi / 180);
    return dLat * dLat + dLng * dLng;
  }
}
