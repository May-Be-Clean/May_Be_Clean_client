import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'states.dart';

class GlobalState extends GetxController {
  String token = "";
  late TabController tabController;
  UserData? userData;
  final _mapStates = Get.find<MapState>();
  final int pageSize = 20;

  RxMap<String, Marker> markers = RxMap<String, Marker>({});
  RxMap<String, Marker> filteredMarkers = RxMap<String, Marker>({});

  RxMap<int, Store> stores = RxMap<int, Store>({});

  Set<Marker> get markerSet => markers.values.toSet();

  List<Store> get storeList => stores.values.toList();

  bool isBottomsheetShow = false;
  List<String> selectedCategories = [];

  void setIsBottomsheetShow(check) {
    isBottomsheetShow = check;
  }

  // Future<void> loadLikeStores() async {
  //   final result = await Store.loadLikeStore(token);
  //   if (result.isEmpty) {
  //     return;
  //   }
  //   for (final store in result) {
  //     likeStores[store.id] = store;
  //   }
  // }

  Future loadMarker(double upperLat, double upperLon, double lowerLat,
      double lowerLon, List<String> categories) async {
    stores.clear();
    markers.clear();

    final result = await Store.getNearbyStore(
        token, upperLat, upperLon, lowerLat, lowerLon, categories);
    for (final store in result) {
      final marker = await _storeToMarker(store);
      markers[store.id.toString()] = marker;
    }
  }

  Future<Marker> _storeToMarker(Store store) async {
    final markerIcon = await markerImageTransform(store.storeCategories);

    return Marker(
        markerId: MarkerId(store.id.toString()),
        position: LatLng(store.latitude, store.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          final storeData = stores[store.id] ?? store;

          _mapStates.mapController!.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  target:
                      LatLng(storeData.latitude - 0.0001, storeData.longitude),
                  zoom: 16)));

          Get.bottomSheet(
            StoreBottomSheet(
              storeData.id,
              dismiss: Get.back,
              isBottomSheet: true,
            ),
            isScrollControlled: true,
            barrierColor: Colors.transparent,
          );
        });
  }

  void updateStore(Store store) async {
    final response = await store.getStoreData(token, store.id);

    stores[response.id] = store;
    final marker = await _storeToMarker(store);
    markers[store.id.toString()] = marker;
  }

  Future<void> init() async {
    try {
      Timer(const Duration(milliseconds: 500), () async {
        SharedPreferences.getInstance().then((prefs) async {
          final token = prefs.getString('accessToken');
          // 1회도 사용하지 않은 유저인 경우
          if (token == null) {
            Get.off(() => const LoginScreen());
            return;
          }
          // 1회 이상 사용한 유저인 경우
          if (token == "") {
            Get.off(() => const HomeScreen());
            return;
          }
          Timer(const Duration(milliseconds: 500), () async {
            Get.to(() => const HomeScreen());
          });
          // 자동 로그인
          await UserData.getUserData(token).then((autoLoginUser) async {
            innerLogin(autoLoginUser);
            this.token = token;
            if (Get.currentRoute != "/HomeScreen") {
              Get.to(() => const HomeScreen());
            }
          });
        });
      });
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      Get.to(() => const HomeScreen());
    }
  }

  void setAutoLogin(String token) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('accessToken', token);
    });
  }

  void innerLogin(UserData user) {
    userData = user;
  }

  Future<void> innerLogout() async {
    // 카카오 로그인은 로그아웃해야함
    try {
      await UserApi.instance.logout();
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
    }

    userData = null;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('accessToken');
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await init();
  }
}
