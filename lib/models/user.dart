import 'package:http/http.dart' as http;
import 'package:may_be_clean/env/env.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'dart:convert';

class User {
  final String email;
  final String nickname;
  final String? accessToken;
  final String? userRole;
  final int? point;

  User({
    required this.email,
    required this.nickname,
    this.accessToken,
    this.userRole,
    this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'],
      email: json['email'],
      point: json['point'],
      userRole: json['userRole'],
      accessToken: json['accessToken'],
    );
  }

  static Future<User> authKakao(String token) async {
    const api = '${ENV.apiEndpoint}/auth/kakao';

    final response = await http.post(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<User> authApple(String? nickname, String token) async {
    final api = (nickname == null)
        ? '${ENV.apiEndpoint}/auth/apple?token=$token'
        : '${ENV.apiEndpoint}/auth/apple?nickname=$nickname&token=$token';

    final response = await http.post(
      Uri.parse(api),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }
}

class UserData {
  final int reviewCount;
  final int registeredCount;
  final int verifiedCount;
  final int? likedCount;
  final User user;

  UserData({
    required this.reviewCount,
    required this.registeredCount,
    required this.verifiedCount,
    this.likedCount,
    required this.user,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: User.fromJson(json['user']),
      reviewCount: json['reviewCount'],
      registeredCount: json['registeredCount'],
      likedCount: json['likedCount'],
      verifiedCount: json['verifiedCount'],
    );
  }

  static Future<UserData> getUserData(String token) async {
    const api = '${ENV.apiEndpoint}/user/mypage';

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return UserData.fromJson(json.decode(response.body));
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }
}
