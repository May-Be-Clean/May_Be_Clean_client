import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'dart:async';
import 'package:may_be_clean/screens.dart';

import '../../widgets/widgets.dart';

class StoreBottomSheet extends StatefulWidget {
  final Function() dismiss;
  final Store store;
  final bool isBottomSheet;
  const StoreBottomSheet(this.store,
      {required this.dismiss, required this.isBottomSheet, super.key});

  @override
  State<StoreBottomSheet> createState() => _StoreBottomSheetState();
}

class _StoreBottomSheetState extends State<StoreBottomSheet> {
  Timer _debounce = Timer(const Duration(milliseconds: 100), () {});
  final _controller = DraggableScrollableController();
  late ScrollController _innerController = ScrollController();
  bool _isFullscreen = false;
  // bool _isDisabled = false;

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
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.store.name,
                                    softWrap: true, style: FontSystem.title),
                                Container(
                                    alignment: Alignment.centerRight,
                                    margin: const EdgeInsets.only(right: 15),
                                    child: SvgPicture.asset(
                                        'assets/icons/map/heart_selected.svg')),
                              ],
                            ),
                            SizedBox(
                              width: Get.width - 40,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: widget.store.category
                                    .map(
                                      (item) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          '#${storeCategories[item]?[0] ?? "알 수 없음"}',
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
                            if (widget.store.cloverCount < 4)
                              Container(
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
                                    SvgPicture.asset(countToClover(
                                        widget.store.cloverCount)),
                                    Text(
                                      "친환경 가게 인증하기",
                                      style:
                                          FontSystem.subtitleSemiBold.copyWith(
                                        color: ColorSystem.primary,
                                      ),
                                    ),
                                  ],
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
                                    Get.to(() => StoreReviewListScreen(
                                        store: widget.store));
                                  },
                                  child: const Text.rich(
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    TextSpan(text: "방문자 후기 ", children: [
                                      TextSpan(
                                        text: "120",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      TextSpan(text: "건 >"), //후기 총 개수
                                    ]),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      child: const Text(
                                        "후기 등록하기", //후기 등록하기 스크린으로 연결
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
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                ProgressBar(
                                  67, // 현재 항목 후기 개수 / 전체 후기 개수
                                  barHeight: 28,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SvgPicture.asset(
                                      "assets/icons/category/cafe.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 28,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "제품이 다양해요", //항목
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Container(
                                        height: 28,
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        alignment: Alignment.centerRight,
                                        child: const Text("26"), //항목 개수
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                ProgressBar(
                                  50, // 현재 항목 후기 개수 / 전체 후기 개수
                                  barHeight: 28,
                                  barOpacity: 0.7,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SvgPicture.asset(
                                      "assets/icons/category/cafe.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 28,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "제품이 다양해요", //항목
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Container(
                                        height: 28,
                                        padding: EdgeInsets.only(right: 10),
                                        alignment: Alignment.centerRight,
                                        child: Text("26"), //항목 개수
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                ProgressBar(
                                  27, // 현재 항목 후기 개수 / 전체 후기 개수
                                  barHeight: 28,
                                  barOpacity: 0.5,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SvgPicture.asset(
                                      "assets/icons/category/cafe.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 28,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "제품이 다양해요", //항목
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Container(
                                        height: 28,
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        alignment: Alignment.centerRight,
                                        child: const Text("26"), //항목 개수
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
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
                                  widget.store.address1,
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
                                  widget.store.address2,
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
                                Text(widget.store.phone,
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
                                Text(
                                  "${widget.store.openTime} - ${widget.store.closeTime}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
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
                                  //TODO 정보 수정 API 연결
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
