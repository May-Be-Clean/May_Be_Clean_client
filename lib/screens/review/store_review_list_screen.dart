import 'package:flutter/material.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:tuple/tuple.dart';

class StoreReviewListScreen extends StatefulWidget {
  final Store store;
  const StoreReviewListScreen({required this.store, super.key});

  @override
  State<StoreReviewListScreen> createState() => _StoreReviewListScreenState();
}

class _StoreReviewListScreenState extends State<StoreReviewListScreen> {
  final _globalStates = Get.find<GlobalState>();
  final List<Review> _reviews = [];
  late Store store;
  bool _isProcess = true;

  void loadMore() async {
    final reviews = await Review.getStoreReviews(
        _globalStates.token, store.id, _reviews.length, _globalStates.pageSize);
    _reviews.addAll(reviews);
    _isProcess = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    store = widget.store;

    loadMore();
  }

  void onTapLike() {
    try {
      if (_globalStates.userData == null) {
        loginRequest(context);
        return;
      }

      store.likeStore(_globalStates.token, store.id, !store.isLiked);
      store.isLiked = !store.isLiked;

      setState(() {});
    } catch (e) {
      showToast("좋아요 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "방문자 후기",
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(store.name, softWrap: true, style: FontSystem.title),
            SizedBox(
              width: Get.width - 40,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: (store.storeCategories)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          '#${storeCategoryMapping[item]?[0] ?? "알 수 없음"}',
                          style: FontSystem.body2
                              .copyWith(color: ColorSystem.gray1),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (store.clover < 4)
              GestureDetector(
                onTap: () async {
                  if (_globalStates.userData == null) {
                    loginRequest(context);
                    return;
                  }
                  Get.dialog(StoreComfirmDialog(store));
                  await Store.getStore(_globalStates.token, store.id)
                      .then((value) {
                    store = value;
                    setState(() {});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorSystem.primary),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  width: Get.width,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(countToClover(store.clover)),
                      Text(
                        "친환경 가게 인증하기",
                        style: FontSystem.subtitleSemiBold.copyWith(
                          color: ColorSystem.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "버튼을 눌러 친환경 가게 인증에 동참해주세요!",
                style: FontSystem.caption.copyWith(
                  color: ColorSystem.primary,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text.rich(
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  TextSpan(text: "방문자 후기 ", children: [
                    TextSpan(
                      text:
                          store.reviewCategoryCount?.countReviews.toString() ??
                              "0",
                      style: const TextStyle(color: Colors.green),
                    ),
                    const TextSpan(text: "건"), //후기 총 개수
                  ]),
                ),
                if (store.score != 0.0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "친환경 점수 ",
                          style: FontSystem.body2,
                          children: [
                            TextSpan(
                              text: store.score.toString(),
                              style: const TextStyle(color: Colors.green),
                            ),
                            const TextSpan(text: "점을 받은 가게에요."),
                          ],
                        ),
                      ),
                    ],
                  ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.dialog(EditReviewDialog(
                          storeId: store.id,
                          storeName: store.name,
                          clover: store.clover,
                        ));
                      },
                      child: const Text(
                        "후기 등록하기",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            () {
              final firstCategory =
                  store.reviewCategoryCount?.getSortedList[0] ??
                      const Tuple2("CLEAN", 0);
              final secondCategory =
                  store.reviewCategoryCount?.getSortedList[1] ??
                      const Tuple2("CLEAN", 0);
              final thirdCategory =
                  store.reviewCategoryCount?.getSortedList[2] ??
                      const Tuple2("CLEAN", 0);
              //TODO 전체 리뷰 개수 확인
              final totalCount = store.reviewCategoryCount?.countReviews ?? 1;

              Widget progressWidget(Tuple2 data) {
                return Column(
                  children: [
                    ReviewProgressBar(
                        percentage: data.item2 / totalCount * 100,
                        color: ColorSystem.primary,
                        category: data.item1,
                        count: data.item2,
                        barOpacity: 1.0),
                    const SizedBox(height: 10),
                  ],
                );
              }

              if (firstCategory.item2 == 0 &&
                  secondCategory.item2 == 0 &&
                  thirdCategory.item2 == 0) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "아직 후기가 없어요!",
                    style: FontSystem.body2.copyWith(
                      color: ColorSystem.gray1,
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () {
                  Get.to(() => StoreReviewListScreen(store: store));
                },
                child: Column(
                  children: [
                    (firstCategory.item2 == 0)
                        ? const SizedBox()
                        : progressWidget(firstCategory),
                    (secondCategory.item2 == 0)
                        ? const SizedBox()
                        : progressWidget(secondCategory),
                    (thirdCategory.item2 == 0)
                        ? const SizedBox()
                        : progressWidget(thirdCategory),
                  ],
                ),
              );
            }(),
            if (_isProcess)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              ListView.separated(
                  itemCount: _reviews.length,
                  shrinkWrap: true,
                  controller: PrimaryScrollController.of(context),
                  padding: const EdgeInsets.only(top: 20),
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return ReviewCard(review, isTouchable: false);
                  }),
          ],
        ),
      ),
    );
  }
}
