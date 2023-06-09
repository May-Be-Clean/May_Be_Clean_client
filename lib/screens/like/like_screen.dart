import 'package:flutter/material.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:get/get.dart';

class _StoreCard extends StatelessWidget {
  final Review review;

  const _StoreCard(this.review, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                StoreBottomSheet(
                  Get.find<StoreState>().stores[0],
                  isBottomSheet: true,
                  dismiss: () => Get.back(),
                ),
                isScrollControlled: true,
              );
            },
            child: Row(
              children: [
                SvgPicture.asset(countToClover(review.cloverCount)),
                Text(
                  review.storeName,
                  style: FontSystem.subtitleSemiBold
                      .copyWith(color: ColorSystem.primary),
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView.separated(
              itemCount: review.storeCategory.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final category = review.storeCategory[index];
                return Text(
                  "#${storeCategories[category]?[0] ?? '기타'}",
                  style: FontSystem.caption.copyWith(color: ColorSystem.gray1),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 3),
            ),
          ),
          Container(
            height: 24,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: review.reviewCategory.length,
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final reviewCategoryData =
                    reviewCategories[review.reviewCategory[index]];
                final String title = reviewCategoryData?[0] ?? "기타";
                final String image =
                    reviewCategoryData?[1] ?? "assets/icons/review/clean.png";
                return ReviewCategoryItem(title: title, image: image);
              },
            ),
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }
}

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final List<String> _selectedCategories = [];
  final _reviewStates = Get.find<ReviewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.all(10),
          child: const Text("찜한 가게", style: FontSystem.subtitleSemiBold),
        ),
        centerTitle: false,
      ),
      backgroundColor: ColorSystem.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 20,
            flexibleSpace: FlexibleSpaceBar(
              title: SizedBox(
                height: 40,
                child: ListView.separated(
                  itemCount: storeCategories.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                  itemBuilder: (context, index) {
                    final category = storeCategories.values.toList()[index];
                    final categoryName = storeCategories.keys.toList()[index];
                    bool isSelected = false;
                    if (_selectedCategories.contains(categoryName)) {
                      isSelected = true;
                    }
                    return CategoryButton(
                        title: category[0],
                        unselectedSvg: category[1],
                        selectedSvg: category[2],
                        isSelected: isSelected,
                        action: () {
                          if (isSelected) {
                            _selectedCategories.remove(categoryName);
                          } else {
                            _selectedCategories.add(categoryName);
                          }
                          isSelected = !isSelected;
                          setState(() {});
                        });
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final review = _reviewStates.myReviews[index];
              return _StoreCard(review);
            }, childCount: _reviewStates.myReviews.length),
          ),
        ],
      ),
    );
  }
}
