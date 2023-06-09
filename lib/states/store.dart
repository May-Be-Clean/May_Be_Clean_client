import 'package:get/get.dart';
import 'dart:async';
import 'package:may_be_clean/models/model.dart';

class StoreState extends GetxController {
  List<Store> stores = [];

  Future<void> load() async {
    for (int i = 0; i < 7; i++) {
      stores.add(Store(
        id: 4,
        name: '덕분애 제로웨이스트샵',
        address1: '서울 서초구 서운로26길 11 2층',
        address2: '서울 서초구 서초동 1337-1',
        latitude: 37.486,
        longitude: 127.019,
        phone: '02-6959-4479',
        category: ['vegan', 'cafe'],
        openTime: '1200',
        cloverCount: 2,
        closeTime: '2000',
        updatedAt: DateTime.now(),
      ));
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await load();
  }
}
