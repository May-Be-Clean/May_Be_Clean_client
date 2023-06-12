import 'package:flutter/material.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/models/model.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  final _globalStates = Get.find<GlobalState>();
  final _scrollController = ScrollController();
  final _myReviews = <Review>[];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  Future<void> loadMore() async {
    final reviews = await Review.loadMyReviews(_globalStates.token, _page, 10);
    _myReviews.addAll(reviews);
    _page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '내가 작성한 후기'),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _globalStates.userData!.user.nickname,
                        style: FontSystem.subtitleSemiBold,
                      ),
                      const TextSpan(
                        text: '님이 작성해주신',
                        style: FontSystem.subtitleRegular,
                      ),
                    ],
                  ),
                ),
                const Text(
                  "소중한 후기들을 모아봤어요.",
                  style: FontSystem.subtitleRegular,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              controller: _scrollController,
              itemCount: _myReviews.length,
              itemBuilder: (context, index) {
                final review = _myReviews[index];
                return ReviewCard(review,
                    isEdit: true, key: Key(review.toKeyString()));
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
