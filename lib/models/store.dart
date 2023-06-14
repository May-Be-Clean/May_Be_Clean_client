import 'dart:developer';

import 'package:may_be_clean/env/env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/models/model.dart';

class Store {
  final int id;
  final String name;
  final String? newAddress;
  final String? oldAddress;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final List<String> storeCategories;
  final List<String> reviewCategories;
  final String? startAt;
  final String? endAt;
  final int clover;
  bool isLiked;
  final ReviewFilterCount? reviewFilterCount;
  final DateTime updatedAt = DateTime.now();
  final User? user;

  Store({
    required this.id,
    required this.name,
    this.newAddress,
    this.oldAddress,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    required this.storeCategories,
    required this.reviewCategories,
    this.startAt,
    this.endAt,
    required this.clover,
    required this.isLiked,
    this.reviewFilterCount,
    this.user,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'] ?? json['storeName'],
      newAddress: json['newAddress'],
      oldAddress: json['oldAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phoneNumber: json['phoneNumber'],
      storeCategories: List<String>.from(
          json['storeCategories'] ?? json['categories'] ?? []),
      reviewCategories: List<String>.from(json['reviewCategories'] ?? []),
      startAt: json['startAt'],
      endAt: json['endAt'],
      clover: json['clover'],
      isLiked: json['isLiked'] ?? false,
      reviewFilterCount: ReviewFilterCount.fromJson(
          json['reviewFilterCount'] ?? emptyReviewFilterCount.toJson()),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  static Future<Store> getStore(String token, int id) async {
    final api = "${ENV.apiEndpoint}/store/$id";

    final response = await http.get(Uri.parse(api), headers: {
      'Authorization': "Bearer $token",
    });

    log(response.body);

    if (response.statusCode == 200) {
      return Store.fromJson(json.decode(response.body)['store']);
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
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

    for (var i = 0; i < categories.length; i++) {
      api += '&category=${categories[i]}';
    }

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

  static Future<bool> verifyStore(String token, int storeId) async {
    final api = "${ENV.apiEndpoint}/store/$storeId/verify";

    final response = await http
        .post(Uri.parse(api), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return true;
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<List<Store>> getVerifiedStores(
      String token, int page, int size) async {
    final api = "${ENV.apiEndpoint}/store/myVerified?page=$page&size=$size";

    final response = await http
        .get(Uri.parse(api), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return json
          .decode(response.body)['stores']
          .map<Store>((json) => Store.fromJson(json))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<List<Store>> getRegistredStores(
      String token, int page, int size) async {
    final api = "${ENV.apiEndpoint}/store/myRegistered?page=$page&size=$size";

    final response = await http
        .get(Uri.parse(api), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return json
          .decode(response.body)['stores']
          .map<Store>((json) => Store.fromJson(json))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<List<Store>> getLikedStores(
      String token, int page, int size) async {
    final api = "${ENV.apiEndpoint}/store/liked?page=$page&size=$size";

    final response = await http
        .get(Uri.parse(api), headers: {"Authorization": "Bearer $token"});

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

  Future<Store> getStoreData(String token, int id) async {
    final api = "${ENV.apiEndpoint}/store/$id";

    final response = await http
        .get(Uri.parse(api), headers: {'Authorization': "Bearer $token"});

    if (response.statusCode == 200) {
      return Store.fromJson(json.decode(response.body)['store']);
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<Store> postNewStore(
      String token,
      String name,
      double latitude,
      double longitude,
      String newAddress,
      String oldAddress,
      String phone,
      List<String> category,
      String startAt,
      String endAt) async {
    const api = '${ENV.apiEndpoint}/store';

    final response = await http.post(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
      body: jsonEncode({
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'newAddress': newAddress,
        'oldAddress': oldAddress,
        'phoneNumber': phone,
        'category': category,
        'startAt': startAt,
        'endAt': endAt,
      }),
    );

    if (response.statusCode == 200) {
      return Store.fromJson(json.decode(response.body)['store']);
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<List<Store>> loadLikeStore(String token) async {
    const api = '${ENV.apiEndpoint}/store/like';

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)['stores']
          .map<Store>((json) => Store.fromJson(json))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
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
  storeCategories: ['REFILL'],
  reviewCategories: ['COFFEE', 'DESSERT', 'ATMOSPHERE', 'SERVICE'],
  clover: 4,
  startAt: '09:00:00',
  endAt: '21:30:00',
  isLiked: false,
);
