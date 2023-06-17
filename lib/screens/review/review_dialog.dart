import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditReviewDialog extends StatefulWidget {
  final int storeId;
  final String storeName;
  final int clover;
  final Review? review;

  const EditReviewDialog({
    required this.storeId,
    required this.storeName,
    required this.clover,
    this.review,
    super.key,
  });

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final List<String> _selectedCategories = [];
  final List<String> _currentImages = [""];
  final _textController = TextEditingController();
  final _globalStates = Get.find<GlobalState>();
  bool _isProcess = false;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _loadReviewData();
    }
  }

  void _loadReviewData() async {
    _textController.text = widget.review!.content;
    _selectedCategories.addAll(widget.review!.reviewCategories);
    for (final image in widget.review!.imageUrls) {
      final imageConverted = await getImage(image);
      _currentImages.add(imageConverted.path);
    }
    setState(() {});
  }

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
                  SvgPicture.asset(countToClover(widget.clover)),
                  Text(widget.storeName, style: FontSystem.subtitleSemiBold),
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
                controller: _textController,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("사진 첨부하기", style: FontSystem.body1),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${_currentImages.length - 1}",
                        style: FontSystem.caption
                            .copyWith(color: ColorSystem.primary),
                      ),
                      TextSpan(
                        text: " / 10",
                        style: FontSystem.caption
                            .copyWith(color: ColorSystem.gray1),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _currentImages
                    .map((e) => RoundedImage(
                          imageUrl: e,
                          onTap: () async {
                            final images =
                                await pickImage(_currentImages.length - 1);
                            setState(() {
                              _currentImages.addAll(images.map((e) => e.path));
                            });
                          },
                          dismissFunction: () {
                            _currentImages.remove(e);
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
        GestureDetector(
          onTap: () async {
            dismissKeyboard(context);

            if (_isProcess) return;
            setState(() {
              _isProcess = true;
            });
            if (_selectedCategories.isEmpty ||
                _textController.text.trim() == "") {
              showToast("후기 카테고리와 내용을 모두 작성해주세요.");
              return;
            }
            try {
              if (widget.review != null) {
                await Review.patchReview(
                    _globalStates.token,
                    widget.review!.id,
                    _selectedCategories,
                    _textController.text,
                    _currentImages.sublist(1));
                Get.back();
                Get.dialog(const ReviewCheckDialog());
                return;
              }
              await Review.postReview(
                  _globalStates.token,
                  widget.storeId,
                  _selectedCategories,
                  _textController.text,
                  _currentImages.sublist(1));
              setState(() {
                _isProcess = false;
              });
              Get.back();
              Get.dialog(const ReviewCheckDialog());
            } catch (e, s) {
              log(e.toString(), stackTrace: s);
              showToast("후기 작성에 실패했습니다.");
              setState(() {
                _isProcess = false;
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorSystem.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                (widget.review == null) ? '작성 완료' : '수정 완료',
                style: const TextStyle(
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
                while (Get.currentRoute != "/HomeScreen") {
                  Get.back();
                }
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
