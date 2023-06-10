import 'package:flutter/material.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/screens.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  final _globalStates = Get.find<GlobalState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _globalStates.loadMyReviews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _globalStates.loadMyReviews();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '내가 작성한 후기'),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        controller: _scrollController,
        itemCount: _globalStates.myReviews.length,
        itemBuilder: (context, index) {
          final review = _globalStates.myReviews[index];
          return ReviewCard(review, key: Key(review.toKeyString()));
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
