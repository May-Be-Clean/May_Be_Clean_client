import 'package:http/http.dart' as http;
import 'package:may_be_clean/env/env.dart';
import 'dart:convert';
import 'package:may_be_clean/utils/utils.dart';

import 'dart:developer';

class KakaoStoreDTO {
  final String id;
  final String placeName;
  final String phone;
  final String addressName;
  final String roadAddressName;
  final double longitude;
  final double latitude;

  KakaoStoreDTO({
    required this.id,
    required this.placeName,
    required this.phone,
    required this.addressName,
    required this.roadAddressName,
    required this.longitude,
    required this.latitude,
  });

  factory KakaoStoreDTO.fromJson(Map<String, dynamic> json) {
    return KakaoStoreDTO(
      id: json['id'],
      placeName: json['place_name'],
      phone: json['phone'],
      addressName: json['address_name'],
      roadAddressName: json['road_address_name'],
      longitude: double.parse(json['x']),
      latitude: double.parse(json['y']),
    );
  }

  static Future<List<KakaoStoreDTO>> queryLocation(
      String keyword, double y, double x) async {
    final api = "${ENV.kakaoRestEndpoint}?query=$keyword&y=$y&x=$x";

    log(api);
    final response = await http.get(Uri.parse(api),
        headers: {"Authorization": "KakaoAK ${ENV.kakaoRestApiKey}"});

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final documents = json['documents'] as List<dynamic>;

      return documents
          .map((e) => KakaoStoreDTO.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }
}
