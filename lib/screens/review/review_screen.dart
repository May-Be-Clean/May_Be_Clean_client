import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/utils/time.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget reviewCard() {
      return Container(
        width: Get.width,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/clover/clover_4.svg'),
                Text(
                  "마료마료",
                  style: FontSystem.body1.copyWith(color: ColorSystem.primary),
                )
              ],
            ),
            SizedBox(
              height: 15,
              child: ListView.separated(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text(
                    "#노플라스틱",
                    style:
                        FontSystem.caption.copyWith(color: ColorSystem.gray1),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 3),
              ),
            ),
            ReadMoreText(
              'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
              trimLength: 100,
              trimMode: TrimMode.Length,
              trimCollapsedText: ' 펼쳐보기',
              trimExpandedText: ' 접기',
              style: FontSystem.caption,
              moreStyle:
                  FontSystem.caption.copyWith(color: ColorSystem.primary),
              lessStyle:
                  FontSystem.caption.copyWith(color: ColorSystem.primary),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final reviewCategory =
                      reviewCategories.values.toList()[index];
                  return ReviewButton(
                      title: reviewCategory[0],
                      image: reviewCategory[1],
                      action: () {});
                },
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const ExpandImageScreen(imageUrls: [
                              'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9',
                              'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9'
                            ]));
                      },
                      child: RoundedImage(
                          imageUrl:
                              'https://play-lh.googleusercontent.com/jYtnK__ibJh9emODIgTyjZdbKym1iAj4RfoVhQZcfbG-DuTSHR5moHVx9CQnqg1yoco9'),
                    );
                  },
                  itemCount: 4),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "(뱃지) ",
                      style:
                          FontSystem.caption.copyWith(color: ColorSystem.gray1),
                    ),
                    Text(
                      "새싹밭의 파수꾼이 되어주셔서 감사합니다!",
                      style:
                          FontSystem.caption.copyWith(color: ColorSystem.gray1),
                    ),
                  ],
                ),
                Text(
                  convertTimeGapToString(
                      DateTime.now().subtract(const Duration(days: 1))),
                  style: FontSystem.caption.copyWith(color: ColorSystem.gray1),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
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
        Expanded(
          child: ListView.separated(
            itemCount: 3,
            itemBuilder: (context, index) {
              return reviewCard();
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ]),
    );
  }
}
