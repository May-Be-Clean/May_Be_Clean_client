import 'package:may_be_clean/models/model.dart';

class StoreNetwork {
  static Future<Store> getStore() async {
    return Store(
      id: 4,
      name: '덕분애',
      address1: '서울 서초구 서운로26길 11 2층',
      address2: '서울 서초구 서초동 1337-1',
      latitude: 37.486,
      longitude: 127.019,
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
