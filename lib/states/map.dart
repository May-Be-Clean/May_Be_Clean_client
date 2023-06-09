import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapState extends GetxController {
  late LatLng currentLocation;

  late GoogleMapController mapController;

  Future<void> moveToCurrentLocation() async {
    final location = await getCurrentLocation();
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 16)));
  }

  Future<LatLng> getCurrentLocation() async {
    final location = await Geolocator.getCurrentPosition();
    return LatLng(location.latitude, location.longitude);
  }

  Future<void> init() async {
    currentLocation = const LatLng(37.49599990284907, 126.95783113055364);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission();
    }

    await Geolocator.getCurrentPosition().then((location) {
      currentLocation = LatLng(location.latitude, location.longitude);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await init();
  }
}
