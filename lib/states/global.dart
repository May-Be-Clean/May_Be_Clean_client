import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class GlobalState extends GetxController {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RxMap<String, Marker> markers = RxMap<String, Marker>({});
  String token = "";
  late TabController tabController;
  UserData? userData;
  int _currentPage = 0;
  int _myCurrentPage = 0;
  RxMap<int, Store> stores = RxMap<int, Store>({});
  RxMap<int, Store> myStores = RxMap<int, Store>({});
  RxMap<int, Store> likeStores = RxMap<int, Store>({});
  int currentPage = 0;

  Future<void> loadStores() async {
    // final result = await Store.getStores(_globalStates.token);
    // if (result.isEmpty) {
    //   return;
    // }
    // stores.addAll(result);
  }

  Future<void> loadLikeStores() async {
    final result = await Store.loadLikeStore(token);
    if (result.isEmpty) {
      return;
    }
    for (final store in result) {
      likeStores[store.id] = store;
    }
  }

  Future loadMarker(double upperLat, double upperLon, double lowerLat,
      double lowerLon, List<String> categories) async {
    final result = await Store.getNearbyStore(
        token, upperLat, upperLon, lowerLat, lowerLon, categories);
    result.addAll(result);
  }

  List<Review> reviews = [];
  List<Review> myReviews = [];

  Future<void> loadReviews() async {
    final result = await Review.loadReviews(token, _currentPage, 10);

    if (result.isEmpty) {
      return;
    }
    reviews.addAll(result);
    _currentPage++;
  }

  Future<void> loadMyReviews() async {
    final result = await Review.loadMyReviews(token, _myCurrentPage, 10);

    if (result.isEmpty) {
      return;
    }
    myReviews.addAll(result);
    _myCurrentPage++;
  }

  Future<void> init() async {
    try {
      await SharedPreferences.getInstance().then((prefs) async {
        final token = prefs.getString('accessToken');
        // 1회도 사용하지 않은 유저인 경우
        if (token == null) {
          Get.to(() => const LoginScreen());
          return;
        }
        // 1회 이상 사용한 유저인 경우
        if (token == "") {
          Get.to(() => const HomeScreen());
          return;
        }
        // 자동 로그인
        await UserData.getUserData(token).then((autoLoginUser) async {
          innerLogin(autoLoginUser);
          loadLikeStores();
        });
        Get.to(() => const HomeScreen());
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
