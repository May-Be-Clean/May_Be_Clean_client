import 'package:get/get.dart';
import 'dart:async';
import 'package:may_be_clean/models/model.dart';

class StoreState extends GetxController {
  List<Store> stores = [];

  Future<void> load() async {
    for (int i = 0; i < 7; i++) {
      stores.add(Store(
        id: 4,
        name: '매장 이름',
        address: '매장 주소',
        phone: '매장 전화번호',
        category: ['vegan', 'cafe'],
        openTime: '매장 오픈 시간',
        cloverCount: 2,
        closeTime: '매장 마감 시간',
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
