import 'package:flutter/cupertino.dart';
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
  final _globalStates = Get.find<GlobalState>();
  final List<Review> _reviews = [];
  int _page = 0;
  final ScrollController _scrollController = ScrollController();

  void loadMore() {
    _page++;
    Review.getReviews(_globalStates.token, _page, _globalStates.pageSize)
        .then((value) {
      _reviews.addAll(value);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
    loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          if (_reviews.isEmpty)
            const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ))
          else
            Expanded(
              child: ListView.separated(
                itemCount: _reviews.length,
                padding: const EdgeInsets.all(10),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
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
  final bool isEdit;
  final Review review;
  final bool isTouchable;
  const ReviewCard(this.review,
      {this.isEdit = false, this.isTouchable = true, super.key});

  void onTapEdit(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                Get.dialog(EditReviewDialog(
                  storeId: review.store.id,
                  storeName: review.store.name,
                  clover: review.store.clover,
                  review: review,
                ));
              },
              child: const Text(
                "수정하기",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "닫기",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isTouchable) {
                        Get.bottomSheet(
                          StoreBottomSheet(
                            review.store.id,
                            dismiss: () {
                              Get.back();
                            },
                            isBottomSheet: true,
                          ),
                          isScrollControlled: true,
                        );
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      children: [
                        SvgPicture.asset(countToClover(review.store.clover)),
                        const SizedBox(width: 5),
                        Text(
                          review.store.name,
                          style: FontSystem.body1
                              .copyWith(color: ColorSystem.primary),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                    child: ListView.separated(
                      itemCount: review.storeCategories.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = review.storeCategories[index];
                        return Text(
                          "#${storeCategoryMapping[category]?[0] ?? '기타'}",
                          style: FontSystem.caption
                              .copyWith(color: ColorSystem.gray1),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 3),
                    ),
                  ),
                ],
              ),
              if (isEdit)
                GestureDetector(
                  onTap: () => onTapEdit(context),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: const Icon(Icons.more_vert),
                  ),
                )
            ],
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
          if (review.imageUrls.isNotEmpty)
            Container(
              height: 100,
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                  itemBuilder: (context, index) {
                    final image = review.imageUrls[index];
                    return RoundedImage(
                      imageUrl: image,
                      disableMargin: true,
                      onTap: () => Get.to(() => ExpandImageScreen(
                            review: review,
                            imageUrls: review.imageUrls,
                            initialIndex: index,
                          )),
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
