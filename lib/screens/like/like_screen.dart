import 'package:flutter/material.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:async';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final List<String> _selectedCategories = [];
  final List<Store> _filteredStores = [];
  final _globalStates = Get.find<GlobalState>();
  final _likeStores = <Store>[];
  int _page = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    final stores = await Store.getLikedStores(
        _globalStates.token, _page, _globalStates.pageSize);
    _likeStores.addAll(stores);
    _filteredStores.addAll(stores);
    _page++;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.all(10),
          child: const Text("찜한 가게", style: FontSystem.body1),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      backgroundColor: ColorSystem.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 20,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: SizedBox(
                height: 40,
                child: ListView.separated(
                  itemCount: storeCategoryMapping.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                  itemBuilder: (context, index) {
                    final category =
                        storeCategoryMapping.values.toList()[index];
                    final categoryName =
                        storeCategoryMapping.keys.toList()[index];
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
                          _filteredStores.clear();

                          Timer(const Duration(milliseconds: 100), () {
                            _filteredStores.addAll(_likeStores.where((store) {
                              if (_selectedCategories.isEmpty) {
                                return true;
                              }
                              for (final cateogry in store.storeCategories) {
                                if (_selectedCategories.contains(cateogry)) {
                                  return true;
                                }
                              }
                              return false;
                            }));
                            setState(() {});
                          });

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
              final store = _filteredStores[index];
              return StoreCard(store);
            }, childCount: _filteredStores.length),
          ),
        ],
      ),
    );
  }
}

class StoreCard extends StatefulWidget {
  final Store store;

  const StoreCard(this.store, {super.key});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  late Store store;
  final _globalStates = Get.find<GlobalState>();

  void onTapLike() {
    try {
      if (_globalStates.userData == null) {
        loginRequest(context);
        return;
      }

      store.likeStore(_globalStates.token, store.id, !store.isLiked);
      store.isLiked = !store.isLiked;

      setState(() {});
    } catch (e, s) {
      showToast("좋아요 실패");
      log(e.toString(), stackTrace: s);
    }
  }

  @override
  void initState() {
    super.initState();
    store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    StoreBottomSheet(
                      store.id,
                      isBottomSheet: true,
                      dismiss: () => Get.back(),
                    ),
                    isScrollControlled: true,
                  );
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      child: SvgPicture.asset(countToClover(store.clover)),
                    ),
                    SizedBox(
                      width: Get.width * 0.7,
                      child: Text(
                        store.name,
                        softWrap: true,
                        style: FontSystem.subtitleSemiBold
                            .copyWith(color: ColorSystem.primary),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTapLike,
                child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset(
                      (store.isLiked)
                          ? 'assets/icons/map/heart_selected.svg'
                          : 'assets/icons/map/heart_unselected.svg',
                    )),
              ),
            ],
          ),
          Container(
            height: 15,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView.separated(
              itemCount: store.storeCategories.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final category = store.storeCategories[index];
                return Text(
                  "#${storeCategoryMapping[category]?[0] ?? '기타'}",
                  style: FontSystem.caption.copyWith(color: ColorSystem.gray1),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 3),
            ),
          ),
          if (store.reviewCategories.isNotEmpty)
            Container(
              height: 24,
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: store.reviewCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 4),
                itemBuilder: (context, index) {
                  final reviewCategoryData =
                      reviewCategoryMapping[store.reviewCategories[index]];
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

class _StoreCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<String> tags;

  const _StoreCard(
      {required this.imagePath,
      required this.title,
      required this.description,
      required this.tags,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
          child: Image.network(imagePath),
        ),
        Column(
          children: [
            Text(title),
            Text(description),
            Row(
              children: [],
            )
          ],
        )
      ],
    );
  }
}
