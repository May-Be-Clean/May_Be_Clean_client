import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:may_be_clean/screens.dart';

class GlobalState extends GetxController {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RxMap<String, Marker> markers = RxMap<String, Marker>({});
  RxMap<String, Marker> throwableMarkers = RxMap<String, Marker>({});
  String token = "";
  String trashType1 = '';
  String trashType2 = '';
  late LatLng latlng;
  late TabController tabController;

  Set<Marker> get markerList =>
      markers.values.toSet()..addAll(throwableMarkers.values.toSet());

  late GoogleMapController mapController;

  Future<void> load() async {
    Timer(const Duration(milliseconds: 500), () async {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        await Geolocator.requestPermission();
      }

      await Geolocator.getCurrentPosition().then((location) {
        latlng = LatLng(location.latitude, location.longitude);

        Get.offAll(() => const HomeScreen());
      });
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await load();
  }
}
