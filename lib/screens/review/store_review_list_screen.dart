import 'package:flutter/material.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';

class StoreReviewListScreen extends StatefulWidget {
  final Store store;
  const StoreReviewListScreen({required this.store, super.key});

  @override
  State<StoreReviewListScreen> createState() => _StoreReviewListScreenState();
}

class _StoreReviewListScreenState extends State<StoreReviewListScreen> {
  final _globalStates = Get.find<GlobalState>();
  final List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    Review.getStoreReviews(_globalStates.token, widget.store.id, 0, 10)
        .then((value) {
      _reviews.addAll(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "방문자 후기",
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container();
          }),
    );
  }
}
