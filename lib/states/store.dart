import 'package:get/get.dart';
import 'dart:async';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/states/states.dart';

class StoreState extends GetxController {
  List<Store> stores = [];
  final _globalStates = Get.find<GlobalState>();

  Future loadMarker(double upperLat, double upperLon, double lowerLat,
      double lowerLon, List<String> categories) async {
    final result = await Store.getNearbyStore(_globalStates.token, upperLat,
        upperLon, lowerLat, lowerLon, categories);
    result.addAll(result);
  }

  @override
  void onInit() async {
    super.onInit();
    stores.add(emptyStoreData);
  }
}
