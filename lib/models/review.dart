import 'package:may_be_clean/env/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:may_be_clean/utils/utils.dart';
import 'package:dio/dio.dart';

class Review {
  final int reviewId;
  final int userId;
  final String nickname;
  final int point;
  final int storeId;
  final String storeName;
  final List<String> storeCategories;
  final int clover;
  final String content;
  final List<String> imageUrls;
  final List<String> reviewCategories;
  final ReviewFilterCount reviewFilterCount;
  final DateTime createdAt;
  final DateTime updatedAt = DateTime.now();

  Review({
    required this.reviewId,
    required this.userId,
    required this.nickname,
    required this.point,
    required this.storeId,
    required this.storeName,
    required this.storeCategories,
    required this.clover,
    required this.content,
    required this.imageUrls,
    required this.reviewCategories,
    required this.createdAt,
    required this.reviewFilterCount,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      userId: json['userId'],
      nickname: json['nickname'],
      point: json['point'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeCategories: json['storeCategories'].cast<String>(),
      clover: json['clover'],
      content: json['content'],
      imageUrls: json['imageUrls'].cast<String>(),
      reviewCategories: json['reviewCategories'].cast<String>(),
      createdAt: DateTime.parse(json['createdAt']),
      reviewFilterCount: ReviewFilterCount.fromJson(json['reviewFilterCount']),
    );
  }

  String toKeyString() {
    return "REVIEW_$reviewId#${updatedAt.toIso8601String()}";
  }

  static Future<List<Review>> loadReviews(
      String token, int page, int size) async {
    final api = "${ENV.apiEndpoint}/review?page=$page&size=$size";

    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
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

  static Future<Review> postReview(String token, int storeId,
      List<String> categories, String content, List<String> images) async {
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      "storeId": storeId,
      "categories": categories,
      "content": content,
      "images": images.map((image) async {
        return await MultipartFile.fromFile(image, filename: "image.jpeg");
      }).toList(),
    });

    final response = await dio.post(
      '${ENV.apiEndpoint}/garbage',
      options: Options(
        headers: {
          "Content-Type": 'multipart/form-data',
          'Authorization': "Bearer $token"
        },
      ),
      data: formData,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.data);
      return Review.fromJson(result);
    } else {
      throw newHTTPException(response.statusCode ?? 500, response.data);
    }
  }
}

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
}

final emptyReviewData = Review(
  reviewId: 0,
  userId: 0,
  nickname: '',
  storeId: 0,
  point: 0,
  storeName: "덕분애",
  storeCategories: ['UPCYCLE', 'CAFE'],
  content: '',
  imageUrls: [
    'https://play-lh.googleusercontent.com/kgl_WvLEG-FjkVMJQmw8oWw8-PAKuy2BFHjCQ9pcGRL3S2Yk6usC-h5Cjn7Efkyq2-I',
    'https://play-lh.googleusercontent.com/kgl_WvLEG-FjkVMJQmw8oWw8-PAKuy2BFHjCQ9pcGRL3S2Yk6usC-h5Cjn7Efkyq2-I'
  ],
  clover: 4,
  reviewCategories: [
    'CLEAN',
    'LARGE',
    'PARKING',
    'MOOD',
    'VARIANT',
  ],
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
