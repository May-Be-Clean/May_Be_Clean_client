import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/states/global.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/widgets/widgets.dart';

class CustomDialog extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final List<Widget> actions;
  final Function()? onTapBackground;

  const CustomDialog(
      {this.title,
      required this.body,
      required this.actions,
      this.onTapBackground,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBackground,
      behavior: (onTapBackground != null) ? HitTestBehavior.opaque : null,
      child: GestureDetector(
        onTap: () {},
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          insetPadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          titlePadding: const EdgeInsets.all(5),
          title: Stack(
            alignment: Alignment.centerRight,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
              Positioned.fill(
                child: Align(alignment: Alignment.center, child: title),
              ),
            ],
          ),
          content: body,
          actions: actions,
        ),
      ),
    );
  }
}

class ReviewUploadDialog extends StatefulWidget {
  final Store store;
  const ReviewUploadDialog({required this.store, super.key});

  @override
  State<ReviewUploadDialog> createState() => _ReviewUploadDialogState();
}

class _ReviewUploadDialogState extends State<ReviewUploadDialog> {
  final List<String> _selectedCategories = [];
  final List<String> currentImages = [""];

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      onTapBackground: () {
        showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: const Text("글 쓰기를 그만두시겠어요?", style: FontSystem.body1),
                  content: const Text(
                    "게시글 작성 화면을 나가면 현재 쓰고 있던 게시글은 저장되지 않아요.",
                    softWrap: true,
                    style: FontSystem.body2,
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        '나가기',
                        style: FontSystem.body1.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        '글쓰기',
                        style: FontSystem.body1.copyWith(
                            color: Colors.blue, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ));
      },
      title: Text(
        "후기 등록하기",
        style: FontSystem.body1.copyWith(color: ColorSystem.primary),
      ),
      body: GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  SvgPicture.asset(countToClover(widget.store.clover)),
                  Text(widget.store.name, style: FontSystem.subtitleSemiBold),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: const Text("이 점이 마음에 들어요", style: FontSystem.body1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                int innerIndex = index;
                final category =
                    reviewCategoryMapping.keys.toList()[innerIndex];
                bool isSelected = false;
                if (_selectedCategories.contains(category)) {
                  isSelected = true;
                }
                return ReviewButton(
                    title: reviewCategoryMapping.values.toList()[innerIndex][0],
                    image: reviewCategoryMapping.values.toList()[innerIndex][1],
                    isSelected: isSelected,
                    action: () {
                      if (isSelected) {
                        _selectedCategories.remove(category);
                      } else {
                        _selectedCategories.add(category);
                      }
                      isSelected = !isSelected;
                      setState(() {});
                    });
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                int innerIndex = index + 3;
                final category =
                    reviewCategoryMapping.keys.toList()[innerIndex];
                bool isSelected = false;
                if (_selectedCategories.contains(category)) {
                  isSelected = true;
                }
                return ReviewButton(
                    title: reviewCategoryMapping.values.toList()[innerIndex][0],
                    image: reviewCategoryMapping.values.toList()[innerIndex][1],
                    isSelected: isSelected,
                    action: () {
                      if (isSelected) {
                        _selectedCategories.remove(category);
                      } else {
                        _selectedCategories.add(category);
                      }
                      isSelected = !isSelected;
                      setState(() {});
                    });
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                int innerIndex = index + 6;
                final category =
                    reviewCategoryMapping.keys.toList()[innerIndex];
                bool isSelected = false;
                if (_selectedCategories.contains(category)) {
                  isSelected = true;
                }
                return ReviewButton(
                    title: reviewCategoryMapping.values.toList()[innerIndex][0],
                    image: reviewCategoryMapping.values.toList()[innerIndex][1],
                    isSelected: isSelected,
                    action: () {
                      if (isSelected) {
                        _selectedCategories.remove(category);
                      } else {
                        _selectedCategories.add(category);
                      }
                      isSelected = !isSelected;
                      setState(() {});
                    });
              }),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: const Text("글 작성하기 *", style: FontSystem.body1),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: ColorSystem.gray2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLength: 500,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterStyle:
                      FontSystem.caption.copyWith(color: ColorSystem.gray1),
                  hintText:
                      "가게에 대한 후기를 작성해주세요. (깨끗한 커뮤니티를 위해 단순 욕설 및 비하는 자제해주세요.)",
                  hintMaxLines: 3,
                  isDense: true,
                  contentPadding: const EdgeInsets.all(3),
                  hintStyle:
                      FontSystem.body2.copyWith(color: ColorSystem.gray2),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: currentImages
                    .map((e) => RoundedImage(
                          imageUrl: e,
                          onTap: () async {
                            final images =
                                await pickImage(currentImages.length - 1);
                            setState(() {
                              currentImages.addAll(images.map((e) => e.path));
                            });
                          },
                          dismissFunction: () {
                            currentImages.remove(e);
                            setState(() {});
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        )),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSystem.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () async {
                Get.back();
                // TODO 업로드 API 연결
              },
              child: const Text(
                '내가 작성한 후기 보러 가기',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewCheckDialog extends StatefulWidget {
  const ReviewCheckDialog({super.key});

  @override
  State<ReviewCheckDialog> createState() => _ReviewCheckDialogState();
}

class _ReviewCheckDialogState extends State<ReviewCheckDialog> {
  final _globalStates = Get.find<GlobalState>();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text(
        "후기 등록하기",
        style: FontSystem.body1.copyWith(color: ColorSystem.primary),
      ),
      body: SizedBox(
        width: Get.width,
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '후기가 성공적으로',
              style: FontSystem.subtitleSemiBold.copyWith(),
            ),
            const Text(
              '등록되었어요!',
              style: FontSystem.subtitleSemiBold,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/icons/review/map.png'),
            const SizedBox(
              height: 20,
            ),
            Text(
              "등록된 후기는 '후기'페이지 또는",
              style: FontSystem.body2.copyWith(),
            ),
            Text(
              "'MY'페이지에서 확인 가능해요.",
              style: FontSystem.body2.copyWith(),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSystem.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () async {
                Get.back();
                _globalStates.tabController.animateTo(3);
                Timer(const Duration(milliseconds: 100), () {
                  Get.to(() => const MyReviewScreen());
                });
              },
              child: const Text(
                '내가 작성한 후기 보러 가기',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
