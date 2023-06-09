import 'package:get/get.dart';
import 'dart:async';
import 'package:may_be_clean/models/model.dart';

class ReviewState extends GetxController {
  List<Review> reviews = [];
  List<Review> myReviews = [];

  Future<void> load() async {
    for (int i = 0; i < 7; i++) {
      reviews.add(emptyReviewData);
      myReviews.add(emptyReviewData);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await load();
  }
}
