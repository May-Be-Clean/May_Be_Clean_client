import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:may_be_clean/models/model.dart';

class GlobalState extends GetxController {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RxMap<String, Marker> markers = RxMap<String, Marker>({});
  String token = "";
  String trashType1 = '';
  String trashType2 = '';
  late TabController tabController;
  User? user;

  Future<void> load() async {
    Timer(const Duration(milliseconds: 500), () async {});
  }

  @override
  void onInit() async {
    super.onInit();
    user = User(
      id: 124,
      name: '유저 이름',
      exp: 14,
    );
    await load();
  }
}
