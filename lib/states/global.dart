import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState extends GetxController {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RxMap<String, Marker> markers = RxMap<String, Marker>({});
  String token = "test";
  late TabController tabController;
  UserData? userData;

  Future<void> load() async {
    Timer(const Duration(milliseconds: 1000), () async {
      Get.to(() => const HomeScreen());
    });
    // try {
    //   final prefs = await SharedPreferences.getInstance();
    //   Timer(const Duration(milliseconds: 1000), () async {
    //     final token = prefs.getString('accessToken');
    //     // if (token == null) {
    //     //   Get.to(() => const LoginScreen());
    //     //   return;
    //     // }
    //     // if (token == "") {
    //     //   Get.to(() => const HomeScreen());
    //     //   return;
    //     // }
    //     final autoLoginUser = await User.getUser(this.token);
    //     login(autoLoginUser);
    //     Get.to(() => const HomeScreen());
    //   });
    // } catch (e, s) {
    //   log(e.toString(), stackTrace: s);
    //   Get.to(() => const HomeScreen());
    // }
  }

  void login(UserData user) {
    userData = user;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('accessToken', userData?.user.accessToken ?? '');
    });
  }

  void logout() {
    userData = null;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('accessToken');
    });
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await load();
  }
}
