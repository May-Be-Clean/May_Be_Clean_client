import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'dart:async';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/states/states.dart';
import 'dart:developer';
import 'package:tuple/tuple.dart';

/*
 * StoreBottomSheet
 * storeID : 해당 가게 id값
 * dismiss : 해당 바텀시트를 닫고 싶을 때 사용하는 함수
 * isBottomSheet : 해당 바텀시트가 바텀시트인지 아닌지
 */
class StoreBottomSheet extends StatefulWidget {
  final Function() dismiss;
  final int storeId;
  final bool isBottomSheet;

  const StoreBottomSheet(
    this.storeId, {
    required this.dismiss,
    required this.isBottomSheet,
    super.key,
  });

  @override
  State<StoreBottomSheet> createState() => _StoreBottomSheetState();
}

class _StoreBottomSheetState extends State<StoreBottomSheet> {
  Timer _debounce = Timer(const Duration(milliseconds: 100), () {});
  final _controller = DraggableScrollableController();
  late ScrollController _innerController = ScrollController();
  bool _isFullscreen = false;
  final _globalStates = Get.find<GlobalState>();
  Store? store;
  bool _isProcess = true;

  @override
  void initState() {
    super.initState();
    Store.getStore(_globalStates.token, widget.storeId).then((value) {
      store = value;
      _isProcess = false;
      setState(() {});
    });
    if (_globalStates.isBottomsheetShow == true) {
      // print(_globalStates.selectedCategories);
      setState(() {
        _globalStates.setIsBottomsheetShow(false);
        _globalStates.selectedCategories = <String>[].obs;
      });
      // print(_globalStates.selectedCategories);
      // Get.offNamed('/HomeScreen');
    }
  }

  void onTapLike() {
    try {
      if (_globalStates.userData == null) {
        loginRequest(context);
        return;
      }

      store!.likeStore(_globalStates.token, store!.id, !store!.isLiked);
      store!.isLiked = !store!.isLiked;

      setState(() {});
    } catch (e, s) {
      showToast("좋아요 실패");
      log(e.toString(), stackTrace: s);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDrag(double extent) {
    if (_debounce.isActive) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 60), () async {
      if (extent < 0.4) {
        // await _controller
        //     .animateTo(0,
        //         duration: const Duration(milliseconds: 150),
        //         curve: Curves.linear)
        //     .then((value) {
        //   if (_isDisabled) return;
        //   widget.disable();
        //   _isDisabled = true;
        // });
        return;
      }

      if ((extent > 0.4 && extent < 0.51)) {
        await _controller.animateTo(0.5,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = false;
        return;
      }

      if (extent > 0.78) {
        _controller.animateTo(0.8,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = true;
        _innerController.animateTo(0,
            duration: const Duration(milliseconds: 150), curve: Curves.linear);
        return;
      }

      if (_isFullscreen && extent < 0.78) {
        await _controller.animateTo(0.5,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = false;
        return;
      }

      if (!_isFullscreen && extent > 0.51) {
        _controller.animateTo(0.8,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = true;
        _innerController.animateTo(0,
            duration: const Duration(milliseconds: 150), curve: Curves.linear);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcess) {
      return GestureDetector(
          onTap: widget.dismiss,
          child: const Center(child: CircularProgressIndicator()));
    }
    return GestureDetector(
      behavior: (widget.isBottomSheet) ? HitTestBehavior.opaque : null,
      onTap: (widget.isBottomSheet) ? widget.dismiss : null,
      child: GestureDetector(
        onTap: () {},
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            _onDrag(notification.extent);
            return true;
          },
          child: DraggableScrollableSheet(
            minChildSize: 0.3,
            maxChildSize: _globalStates.userData == null ? 0.8 : 0.7,
            initialChildSize: 0.3,
            controller: _controller,
            builder: (context, scrollController) {
              _innerController = scrollController;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 0,
                      blurRadius: 5.0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorSystem.gray1,
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(store?.name ?? "",
                                    softWrap: true, style: FontSystem.title),
                                GestureDetector(
                                  onTap: onTapLike,
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      margin: const EdgeInsets.only(right: 15),
                                      child: SvgPicture.asset(
                                        (store?.isLiked ?? false)
                                            ? 'assets/icons/map/heart_selected.svg'
                                            : 'assets/icons/map/heart_unselected.svg',
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: Get.width - 40,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: (store?.storeCategories ?? [])
                                    .map(
                                      (item) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          '#${storeCategoryMapping[item]?[0] ?? "알 수 없음"}',
                                          style: FontSystem.body2.copyWith(
                                              color: ColorSystem.gray1),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if ((store?.clover ?? 0) < 4)
                              GestureDetector(
                                onTap: () {
                                  Get.dialog(StoreComfirmDialog(store!));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: ColorSystem.primary),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: Get.width,
                                  height: 56,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          countToClover(store?.clover ?? 0)),
                                      Text(
                                        "친환경 가게 인증하기",
                                        style: FontSystem.subtitleSemiBold
                                            .copyWith(
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
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        StoreReviewListScreen(store: store!));
                                  },
                                  child: Text.rich(
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    TextSpan(text: "방문자 후기 ", children: [
                                      TextSpan(
                                        text: store?.reviewCategoryCount
                                                ?.countReviews
                                                .toString() ??
                                            "0",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                      const TextSpan(text: "건"), //후기 총 개수
                                    ]),
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.dialog(EditReviewDialog(
                                          storeId: store!.id,
                                          storeName: store!.name,
                                          clover: store!.clover,
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
                              final firstCategory = store
                                      ?.reviewCategoryCount?.getSortedList[0] ??
                                  const Tuple2("CLEAN", 0);
                              final secondCategory = store
                                      ?.reviewCategoryCount?.getSortedList[1] ??
                                  const Tuple2("CLEAN", 0);
                              final thirdCategory = store
                                      ?.reviewCategoryCount?.getSortedList[2] ??
                                  const Tuple2("CLEAN", 0);
                              //TODO 전체 리뷰 개수 확인
                              final totalCount =
                                  store?.reviewCategoryCount?.countReviews ?? 1;

                              Widget progressWidget(Tuple2 data) {
                                return Column(
                                  children: [
                                    ReviewProgressBar(
                                        percentage:
                                            data.item2 / totalCount * 100,
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
                                  Get.to(() =>
                                      StoreReviewListScreen(store: store!));
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/category/location.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  store?.newAddress ?? "",
                                  style: FontSystem.body2,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 30),
                                Text(
                                  "지번: ",
                                  style: FontSystem.body2
                                      .copyWith(color: ColorSystem.gray1),
                                ),
                                Text(
                                  store?.oldAddress ?? "",
                                  style: FontSystem.body2
                                      .copyWith(color: ColorSystem.gray1),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/category/number.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    ((store?.phoneNumber ?? "") == "")
                                        ? "전화번호 정보 없음"
                                        : store!.phoneNumber!,
                                    style: FontSystem.body2)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/category/time.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(() {
                                  if (store?.startAt == null ||
                                      store?.endAt == null) {
                                    return "영업시간 정보 없음";
                                  }

                                  return "${store?.startAt ?? "00:00"} - ${store?.endAt ?? "00:00"}";
                                }(), style: FontSystem.body2),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: ColorSystem.gray2, width: 0.5),
                                  bottom: BorderSide(
                                      color: ColorSystem.gray2, width: 0.5),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  urlLauncher(
                                      "http://pf.kakao.com/_Pxgxnxoxj/chat");
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/category/edit.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      "정보수정 제안하기",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/*
 * StoreBottomSheet
 * store : 해당 가게 정보
 * dismiss : 해당 바텀시트를 닫고 싶을 때 사용하는 함수
 */
class StoreListBottomSheet extends StatefulWidget {
  /// 해당 바텀시트를 닫고 싶을 때 사용하는 함수
  final Function() dismiss;

  const StoreListBottomSheet({required this.dismiss, super.key});

  @override
  State<StoreListBottomSheet> createState() => _StoreListBottomSheetState();
}

class _StoreListBottomSheetState extends State<StoreListBottomSheet> {
  Timer _debounce = Timer(const Duration(milliseconds: 100), () {});
  final _controller = DraggableScrollableController();
  late ScrollController _innerController = ScrollController();
  bool _isFullscreen = false;
  // bool _isDisabled = false;
  final List<String> _selectedCategories = [];
  final _globalStates = Get.find<GlobalState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDrag(double extent) {
    if (_debounce.isActive) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 60), () async {
      if (extent < 0.4) {
        return;
      }

      if ((extent > 0.4 && extent < 0.51)) {
        await _controller.animateTo(0.5,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = false;
        return;
      }

      if (extent > 0.78) {
        _controller.animateTo(0.8,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = true;
        _innerController.animateTo(0,
            duration: const Duration(milliseconds: 150), curve: Curves.linear);
        return;
      }

      if (_isFullscreen && extent < 0.78) {
        await _controller.animateTo(0.5,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = false;
        return;
      }

      if (!_isFullscreen && extent > 0.51) {
        _controller.animateTo(0.8,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
        _isFullscreen = true;
        _innerController.animateTo(0,
            duration: const Duration(milliseconds: 150), curve: Curves.linear);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        _onDrag(notification.extent);
        return true;
      },
      child: DraggableScrollableSheet(
        minChildSize: 0.3,
        maxChildSize: 0.8,
        initialChildSize: 0.3,
        controller: _controller,
        builder: (context, scrollController) {
          _innerController = scrollController;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 0,
                  blurRadius: 5.0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorSystem.gray1,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListView.separated(
                                itemCount: reviewCategoryMapping.length,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 5),
                                itemBuilder: (context, index) {
                                  final category = reviewCategoryMapping.values
                                      .toList()[index];
                                  final categoryName = reviewCategoryMapping
                                      .keys
                                      .toList()[index];
                                  bool isSelected = false;
                                  if (_selectedCategories
                                      .contains(categoryName)) {
                                    isSelected = true;
                                  }
                                  return ReviewButton(
                                      title: category[0],
                                      isSelected: isSelected,
                                      image: category[1],
                                      action: () {
                                        if (isSelected) {
                                          _selectedCategories
                                              .remove(categoryName);
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
                          SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              final store = _globalStates.storeList[index];
                              return StoreCard(store);
                            }, childCount: _globalStates.stores.length),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: widget.dismiss,
                          child:
                              SvgPicture.asset('assets/icons/map/hide_map.svg'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
