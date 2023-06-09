import 'package:may_be_clean/models/model.dart';

class StoreNetwork {
  static Future<Store> getStore() async {
    return Store(
      id: 4,
      name: '매장 이름',
      address: '매장 주소',
      phone: '매장 전화번호',
      cloverCount: 4,
      category: ['매장 카테고리'],
      openTime: '매장 오픈 시간',
      closeTime: '매장 마감 시간',
      updatedAt: DateTime.now(),
    );
  }

  static postNewStore(String name, String address, String phone,
      List<String> category, String openTime, String closeTime) async {
    return;
  }
}
