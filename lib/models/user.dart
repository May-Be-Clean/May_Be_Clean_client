import 'package:http/http.dart' as http;
import 'package:may_be_clean/env/env.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'dart:convert';

class User {
  final String email;
  final String nickname;
  final String? accessToken;
  final String? role;
  final int point;
  final int? reviewCount;
  final int? registerCount;
  final int? verifiedCount;

  User({
    required this.email,
    required this.nickname,
    this.accessToken,
    required this.point,
    this.role,
    this.reviewCount,
    this.registerCount,
    this.verifiedCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'],
      email: json['email'],
      point: json['point'],
      accessToken: json['accessToken'],
      role: json['role'],
      reviewCount: json['reviewCount'],
      registerCount: json['registerCount'],
      verifiedCount: json['verifiedCount'],
    );
  }

  static Future<User> authKakao(String token) async {
    const api = '${ENV.apiEndpoint}/auth/kakao';

    final response = await http.post(
      Uri.parse(api),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(json.decode(response.body)['user']);
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<User> getUser(String token) async {
    const api = '${ENV.apiEndpoint}/user';

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  Future<User> getMypageData(String token) async {
    const api = '${ENV.apiEndpoint}/user/mypage';

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }
}
