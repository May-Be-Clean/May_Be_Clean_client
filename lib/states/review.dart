import 'package:get/get.dart';
import 'dart:async';
import 'package:may_be_clean/models/model.dart';

class ReviewState extends GetxController {
  List<Review> reviews = [];
  List<Review> myReviews = [];

  Future<void> load() async {
    for (int i = 0; i < 7; i++) {
      reviews.add(Review(
        id: 1,
        storeName: '매장 이름',
        user: User(
          id: 124,
          name: '유저 이름',
          exp: 14,
        ),
        cloverCount: 3,
        contents: '리뷰 내용',
        storeCategory: ['nodisposable'],
        reviewCategory: ['clean'],
        images: [
          'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9',
          'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9'
        ],
        createdAt: DateTime.now(),
      ));
      myReviews.add(Review(
        id: 1,
        storeName: '덕문애 제로웨이스트 샵',
        user: User(
          id: 124,
          name: '유저 이름',
          exp: 14,
        ),
        cloverCount: 3,
        contents: '리뷰 내용',
        storeCategory: ['nodisposable', 'cafe'],
        reviewCategory: ['clean', 'large', 'mood'],
        images: [
          'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9',
          'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9'
        ],
        createdAt: DateTime.now(),
      ));
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await load();
  }
}
