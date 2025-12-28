import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  static Future<bool> checkGpsAndPermission() async {

    // 1️⃣ Check if GPS (location service) is ON
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Open GPS settings ONLY if OFF
      await Geolocator.openLocationSettings();
      return false;
    }

    // 2️⃣ Check app permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
