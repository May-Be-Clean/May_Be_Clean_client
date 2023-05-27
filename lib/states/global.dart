import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/utils/utils.dart';

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

  // void addThrowableMarker(models.Basket basket) async {
  //   final markerImage = await markerImageTransform(true);

  //   throwableMarkers.clear();
  //   throwableMarkers[basket.id.toString()] = Marker(
  //       markerId: MarkerId(basket.id.toString()),
  //       icon: BitmapDescriptor.fromBytes(markerImage),
  //       position: LatLng(basket.lat, basket.lng),
  //       onTap: () {
  //         Get.bottomSheet(MarkerBottomSheet(basket: basket, isThrowable: true));
  //       });
  // }

  // void login(models.User newUser) async {
  //   user.value = newUser;
  //   token = newUser.accessToken!;
  //   SharedPreferences.getInstance().then((pref) {
  //     pref.setString('accessToken', newUser.accessToken!);
  //   });
  // }

  // void setTargetCategory(String type1, String type2) {
  //   trashType1 = type1;
  //   trashType2 = type2.toUpperCase();
  // }

  // Future<bool> auth() async {
  //   SharedPreferences.getInstance().then((pref) async {
  //     try {
  //       final accessToken = pref.getString('accessToken');
  //       final user = await models.User.auth(accessToken ?? '');

  //       login(user);
  //     } catch (e, s) {
  //       if (e is! UnauthorisedException) {
  //         log(e.toString(), stackTrace: s);
  //       }
  //     }
  //   });
  //   if (user.value == null) {
  //     return false;
  //   }
  //   return true;
  // }

  // void changeLocation(LatLng nextPos) {
  //   latlng = nextPos;
  // }

  Future<void> load() async {
    Timer(const Duration(milliseconds: 500), () async {
      // await auth();

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
