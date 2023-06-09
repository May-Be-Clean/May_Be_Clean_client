import 'dart:developer';

import 'package:may_be_clean/env/env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:may_be_clean/utils/utils.dart';

class Store {
  final int id;
  final String name;
  final String newAddress;
  final String oldAddress;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final List<String> category;
  final String? startAt;
  final String? endAt;
  final int clover;
  final bool isLiked;

  Store({
    required this.id,
    required this.name,
    required this.newAddress,
    required this.oldAddress,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    required this.category,
    this.startAt,
    this.endAt,
    required this.clover,
    required this.isLiked,
  });

  // String toKeyString() {
  //   return "STORE_$id#${updatedAt.toIso8601String()}";
  // }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      newAddress: json['newAddress'],
      oldAddress: json['oldAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phoneNumber: json['phoneNumber'],
      category: json['category'].cast<String>(),
      startAt: json['startAt'],
      endAt: json['endAt'],
      clover: json['clover'],
      isLiked: json['isLiked'],
    );
  }

  static Future<List<Store>> getNearbyStore(
      String token,
      double upperLatitude,
      double upperLongitude,
      double lowerLatitude,
      double lowerLongitude,
      List<String> categories) async {
    final parameters = {
      'upperLatitude': upperLatitude.toString(),
      'upperLongitude': upperLongitude.toString(),
      'lowerLatitude': lowerLatitude.toString(),
      'lowerLongitude': lowerLongitude.toString(),
    };

    String api =
        '${ENV.apiEndpoint}/store/nearby?${Uri(queryParameters: parameters).query}';
    // make catgories list to each query parameter
    for (var i = 0; i < categories.length; i++) {
      api += '&category=${categories[i]}';
    }

    log("API : $api");
    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    log(response.body);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)['stores']
          .map<Store>((json) => Store.fromJson(json))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static postNewStore(String name, String address, String phone,
      List<String> category, String openTime, String closeTime) async {
    return;
  }
}

final emptyStoreData = Store(
  id: 4,
  name: '덕분애',
  newAddress: '서울 서초구 서운로26길 11 2층',
  oldAddress: '서울 서초구 서초동 1337-1',
  latitude: 37.486,
  longitude: 127.019,
  phoneNumber: '02-234-5231',
  clover: 4,
  category: ['REFILL'],
  startAt: '09:00:00',
  endAt: '21:30:00',
  isLiked: false,
);
