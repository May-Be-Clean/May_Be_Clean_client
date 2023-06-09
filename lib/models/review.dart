import 'package:may_be_clean/models/model.dart';

class Review {
  final int id;
  final String storeName;
  final User user;
  final String contents;
  final int cloverCount;
  final List<String> storeCategory;
  final List<String> reviewCategory;
  final List<String> images;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.storeName,
    required this.user,
    required this.contents,
    required this.cloverCount,
    required this.storeCategory,
    required this.reviewCategory,
    required this.images,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      storeName: json['storeName'],
      user: User.fromJson(json['user']),
      contents: json['contents'],
      cloverCount: json['cloverCount'],
      storeCategory: List<String>.from(json['storeCategory']),
      reviewCategory: List<String>.from(json['reviewCategory']),
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
