import 'package:may_be_clean/env/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:may_be_clean/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:may_be_clean/models/model.dart';
import 'dart:developer';
import 'package:http_parser/http_parser.dart';

class Review {
  final int id;
  final int userId;
  final String nickname;
  final int point;
  final Store store;
  final List<String> reviewCategories;
  final List<String> storeCategories;
  final String content;
  final List<String> imageUrls;
  final ReviewFilterCount reviewFilterCount;
  final DateTime createdAt;
  final DateTime updatedAt = DateTime.now();

  Review({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.point,
    required this.store,
    required this.reviewCategories,
    required this.storeCategories,
    required this.content,
    required this.imageUrls,
    required this.reviewFilterCount,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      nickname: json['nickname'],
      point: json['point'],
      store: Store.fromJson(json['store']),
      reviewCategories: List<String>.from(json['reviewCategories'] ?? []),
      storeCategories: List<String>.from(json['storeCategories'] ?? []),
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls']),
      reviewFilterCount: ReviewFilterCount.fromJson(
          json['reviewFilterCount'] ?? emptyReviewFilterCount.toJson()),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static Future<List<Review>> getReviews(
      String token, int page, int size) async {
    final api = "${ENV.apiEndpoint}/review?page=$page&size=$size";

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    log(response.body);

    if (response.statusCode == 200) {
      final result = json.decode(response.body)['reviews'];
      return result
          .map<Review>((data) => Review.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<List<Review>> getStoreReviews(
      String token, int storeId, int page, int size) async {
    final api = "${ENV.apiEndpoint}/review/$storeId?page=$page&size=$size";

    final response = await http
        .get(Uri.parse(api), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final result = json.decode(response.body)["reviews"];
      return result
          .map((data) => Review.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<List<Review>> loadMyReviews(
      String token, int page, int size) async {
    final api = "${ENV.apiEndpoint}/review/myReview?page=$page&size=$size";

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = json.decode(response.body)["reviews"];

      return result
          .map((data) => Review.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      throw newHTTPException(response.statusCode, response.body);
    }
  }

  static Future<bool> postReview(String token, int storeId,
      List<String> categories, String content, List<String> imagesPath) async {
    Dio dio = Dio();
    FormData formData = FormData();

    formData = FormData.fromMap({
      "storeId": storeId,
      "categories": categories,
      "content": content,
    });

    if (imagesPath.isNotEmpty) {
      for (final imagePath in imagesPath) {
        final subPath = imagePath.split('/').last;
        String subString = "";
        if (subPath.length <= 15) {
          subString = subPath;
        } else {
          subString = subPath.substring(subPath.length - 15);
        }

        final file =
            await MultipartFile.fromFile(imagePath, filename: subString);
        formData.files.add(MapEntry("images", file));
      }
    }

    final response = await dio.post(
      '${ENV.apiEndpoint}/review',
      options: Options(
        headers: {
          "Content-Type": 'multipart/form-data',
          'Authorization': "Bearer $token",
        },
      ),
      data: formData,
    );

    log('Response data: ${response.data}');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw newHTTPException(response.statusCode ?? 500, response.data);
    }
  }

  Future<bool> deleteReview(String token) async {
    return true;
  }
}

final emptyReviewFilterCount = ReviewFilterCount(
  clean: 0,
  large: 0,
  parking: 0,
  mood: 0,
  variant: 0,
  valuable: 0,
  quality: 0,
  effective: 0,
  kind: 0,
);

class ReviewFilterCount {
  final int clean;
  final int large;
  final int parking;
  final int mood;
  final int variant;
  final int valuable;
  final int quality;
  final int effective;
  final int kind;

  ReviewFilterCount({
    required this.clean,
    required this.large,
    required this.parking,
    required this.mood,
    required this.variant,
    required this.valuable,
    required this.quality,
    required this.effective,
    required this.kind,
  });

  factory ReviewFilterCount.fromJson(Map<String, dynamic> json) {
    return ReviewFilterCount(
      clean: json['countOfCleanStore'],
      large: json['countOfLargeStore'],
      parking: json['countOfParking'],
      mood: json['countOfMood'],
      variant: json['countOfVariant'],
      valuable: json['countOfValuable'],
      quality: json['countOfQuality'],
      effective: json['countOfPrice'],
      kind: json['countOfKindness'],
    );
  }

  //toJson
  Map<String, dynamic> toJson() => {
        'countOfCleanStore': clean,
        'countOfLargeStore': large,
        'countOfParking': parking,
        'countOfMood': mood,
        'countOfVariant': variant,
        'countOfValuable': valuable,
        'countOfQuality': quality,
        'countOfPrice': effective,
        'countOfKindness': kind,
      };

  int countReviews() {
    return clean +
        large +
        parking +
        mood +
        variant +
        valuable +
        quality +
        effective +
        kind;
  }
}

final emptyReviewData = Review(
  id: 0,
  userId: 0,
  nickname: '',
  point: 0,
  store: emptyStoreData,
  reviewCategories: [],
  storeCategories: [],
  content: '',
  imageUrls: [],
  reviewFilterCount: ReviewFilterCount(
    clean: 0,
    large: 0,
    parking: 0,
    mood: 0,
    variant: 0,
    valuable: 0,
    quality: 0,
    effective: 0,
    kind: 0,
  ),
  createdAt: DateTime.now(),
);
