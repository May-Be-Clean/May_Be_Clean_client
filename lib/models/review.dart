import 'package:may_be_clean/env/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:may_be_clean/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:may_be_clean/models/model.dart';
import 'dart:developer';

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
      List<String> categories, String content, List<String> images) async {
    FormData formData;

    if (images.isEmpty) {
      formData = FormData.fromMap({
        "storeId": storeId,
        "categories": categories,
        "content": content,
      });
    } else {
      formData = FormData.fromMap({
        "storeId": storeId,
        "categories": categories,
        "content": content,
        "images": images.map((image) async {
          return await MultipartFile.fromFile(image, filename: "image.jpeg");
        }).toList(),
      });
    }

    final len = formData.length;

    log('Form data: ${formData.fields}');

    final response = await Dio().post(
      '${ENV.apiEndpoint}/review',
      options: Options(
        headers: {
          "Content-Type": 'multipart/form-data',
          'Authorization': "Bearer $token",
          "Content-Length": len,
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
}

class ReviewDTO {
  final int userId;
  final String nickname;
  final int point;
  final Store store;
  final List<String> storeCategories;
  final int id;
  final String content;
  final List<String> imageUrls;
  final List<String> reviewCategories;
  final DateTime createdAt;

  ReviewDTO({
    required this.userId,
    required this.nickname,
    required this.point,
    required this.store,
    required this.storeCategories,
    required this.id,
    required this.content,
    required this.imageUrls,
    required this.reviewCategories,
    required this.createdAt,
  });

  factory ReviewDTO.fromJson(Map<String, dynamic> json) {
    return ReviewDTO(
      userId: json['userId'],
      nickname: json['nickname'],
      point: json['point'],
      store: Store.fromJson(json['store']),
      storeCategories: json['storeCategories'].cast<String>(),
      id: json['id'],
      content: json['content'],
      imageUrls: json['imageUrls'].cast<String>(),
      reviewCategories: json['reviewCategories'].cast<String>(),
      createdAt: DateTime.parse(json['createdAt']),
    );
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
