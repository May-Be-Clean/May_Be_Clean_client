import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/utils/utils.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _reviewStates = Get.find<ReviewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leadingWidth: 0,
        centerTitle: false,
        title: Container(
          padding: const EdgeInsets.all(10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "후기 모아보기",
                style: FontSystem.subtitleSemiBold,
              ),
              Text(
                "지구를 깨끗하게 만드는 가게들의 후기를 모아봤어요!",
                style: FontSystem.body2,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _reviewStates.reviews.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final review = _reviewStates.reviews[index];
                return ReviewCard(review);
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final _storeStates = Get.find<StoreState>();
  final Review review;
  ReviewCard(this.review, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                StoreBottomSheet(
                  _storeStates.stores[0],
                  dismiss: () {
                    Get.back();
                  },
                  isBottomSheet: true,
                ),
                isScrollControlled: true,
              );
            },
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                SvgPicture.asset(countToClover(review.clover)),
                const SizedBox(width: 5),
                Text(
                  review.storeName,
                  style: FontSystem.body1.copyWith(color: ColorSystem.primary),
                )
              ],
            ),
          ),
          Container(
            height: 15,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView.separated(
              itemCount: review.storeCategories.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final category = review.storeCategories[index];
                return Text(
                  "#${storeCategoryMapping[category]?[0] ?? '기타'}",
                  style: FontSystem.caption.copyWith(color: ColorSystem.gray1),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 3),
            ),
          ),
          ReadMoreText(
            review.content,
            trimLength: 100,
            trimMode: TrimMode.Length,
            trimCollapsedText: ' 펼쳐보기',
            trimExpandedText: ' 접기',
            style: FontSystem.body2,
            moreStyle: FontSystem.body2.copyWith(color: ColorSystem.primary),
            lessStyle: FontSystem.body2.copyWith(color: ColorSystem.primary),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 5),
                itemBuilder: (context, index) {
                  final image = review.imageUrls[index];
                  return RoundedImage(
                    imageUrl: image,
                    onTap: () => Get.to(
                        () => ExpandImageScreen(imageUrls: review.imageUrls)),
                  );
                },
                itemCount: review.imageUrls.length),
          ),
          Container(
            height: 24,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: review.reviewCategories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final reviewCategoryData =
                    reviewCategoryMapping[review.reviewCategories[index]];
                final String title = reviewCategoryData?[0] ?? "기타";
                final String image =
                    reviewCategoryData?[1] ?? "assets/icons/review/clean.png";
                return ReviewCategoryItem(title: title, image: image);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // TODO 경험치 뱃지 연결
                  SvgPicture.asset(expToBadge(4), width: 16),
                  Text(
                    "${review.nickname}이 작성했어요",
                    style:
                        FontSystem.caption.copyWith(color: ColorSystem.gray1),
                  ),
                ],
              ),
              Text(
                convertTimeGapToString(review.createdAt),
                style: FontSystem.caption.copyWith(color: ColorSystem.gray1),
              ),
            ],
          )
        ],
      ),
    );
  }
}
