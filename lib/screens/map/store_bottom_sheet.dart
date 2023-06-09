import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/models/model.dart';

import '../../widgets/widgets.dart';

List<String> hashtag = ["리필스테이션", "업사이클링"];
int reviewLength = 120;

class StoreBottomSheet extends StatefulWidget {
  final Store store;
  const StoreBottomSheet(this.store, {super.key});

  @override
  State<StoreBottomSheet> createState() => _StoreBottomSheetState();
}

class _StoreBottomSheetState extends State<StoreBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      barWidth: 48,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.store.name, softWrap: true, style: FontSystem.title),
            Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 15),
                child: SvgPicture.asset('assets/icons/map/heart_selected.svg')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.store.category
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    '#${storeCategories[item]?[0] ?? "알 수 없음"}',
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
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
              Text(
                "친환경 가게 인증하기",
                style: FontSystem.subtitleSemiBold.copyWith(
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
            SizedBox(
              child: Text.rich(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                TextSpan(text: "방문자 후기 ", children: [
                  TextSpan(
                    text: "${reviewLength}",
                    style: const TextStyle(color: Colors.green),
                  ),
                  const TextSpan(text: "건 >"), //후기 총 개수
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
                    padding: const EdgeInsets.only(right: 10),
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
                    padding: const EdgeInsets.only(right: 10),
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
              "location",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 30),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "지번: ",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
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
              "phoneNumber",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            )
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
              "openingHours",
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
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(16, 17, 18, 0.15),
              ),
              bottom: BorderSide(
                color: Color.fromRGBO(16, 17, 18, 0.15),
              ),
            ),
          ),
          child: GestureDetector(
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
    );
  }
}
