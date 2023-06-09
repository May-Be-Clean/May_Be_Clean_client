import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'button.dart';

class CustomDialog extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final List<Widget> actions;
  const CustomDialog(
      {this.title, required this.body, required this.actions, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}

// //가게 인증 화면
// class StoreComfirmDialog extends StatefulWidget {
//   const StoreComfirmDialog({super.key});

//   @override
//   State<StoreComfirmDialog> createState() => _StoreComfirmDialogState();
// }

// int count = 1;
// String store = "덕분애 제로웨이스트샵";
// String name = "상원";
// String phoneNumber = "02-6959-4479";
// String location = "서울 서초구 서운로 26길 11 2층";
// String location1 = "서초동 1302-37";
// String openingHours = "13:00 - 20:00";

// // List<double> categorySize = [107, 86, 97, 67, 87, 65, 76];

// class _StoreComfirmDialogState extends State<StoreComfirmDialog> {
//   final List<String> _selectedCategories = [];
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxHeight: 200),
//       child: AlertDialog(
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(16), // You can change this value as you need.
//           ),
//         ),
//         insetPadding: const EdgeInsets.all(15),
//         contentPadding: const EdgeInsets.only(left: 20, right: 20),
//         titlePadding: const EdgeInsets.all(0),
//         title: SizedBox(
//           height: 30,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 alignment: Alignment.centerRight,
//               ),
//             ],
//           ),
//         ),
//         // buttonPadding: EdgeInsets.all(10),
//         content: SizedBox(
//           height: 350,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       "assets/images/CloverLeaves${count}.png",
//                     ),
//                     SizedBox(
//                       width: Get.width * 0.50,
//                       child: Text(
//                         store,
//                         softWrap: true,

//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20,
//                         ),
//                         // overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child: Text.rich(
//                     TextSpan(
//                         text: name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.green,
//                         ),
//                         children: const [
//                           TextSpan(
//                             text: "님이 등록한 가계예요.",
//                             style: TextStyle(color: Colors.grey),
//                           )
//                         ]),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   // width: Get.width,
//                   child: Wrap(
//                     direction: Axis.horizontal,
//                     spacing: -3, // horizontal spacing
//                     runSpacing: 2, // vertical spacing
//                     children: List<Widget>.generate(
//                       storeCategories.length,
//                       (index) {
//                         final category = storeCategories.values.toList()[index];
//                         bool isSelected = false;
//                         if (_selectedCategories.contains(category[0])) {
//                           isSelected = true;
//                         }
//                         return SizedBox(
//                           // width: categorySize[index],
//                           child: CategoryButton(
//                             title: category[0],
//                             unselectedSvg: category[1],
//                             selectedSvg: category[2],
//                             isSelected: isSelected,
//                             fontSize: 14,
//                             imageSize: 12,
//                             action: () {},
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/category/number.svg",
//                       width: 20,
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       phoneNumber,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/category/location.svg",
//                       width: 20,
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       location,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(width: 30),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "지번: ${location1}",
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/category/time.svg",
//                       width: 20,
//                       height: 20,
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       openingHours,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 const Text(
//                   "해당 가게가 정말 친환경 가게가 맞나요?",
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Color.fromRGBO(104, 158, 132, 1),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           Container(
//             alignment: Alignment.center,
//             child: Container(
//               width: 260,
//               padding: const EdgeInsets.all(15),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(104, 158, 132, 1),

//                 borderRadius:
//                     BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
//               ),
//               child: GestureDetector(
//                 child: const Text(
//                   '친환경 가게가 맞아요',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ),
//           // SizedBox(
//           //   height: 8,
//           // ),
//           // Container(
//           //   alignment: Alignment.center,
//           //   child: Container(
//           //     width: 260,
//           //     padding: EdgeInsets.all(15),
//           //     alignment: Alignment.center,
//           //     decoration: BoxDecoration(
//           //       color: Color.fromRGBO(176, 176, 176, 1),
//           //       borderRadius:
//           //           BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
//           //     ),
//           //     child: GestureDetector(
//           //       child: Text(
//           //         '친환경 가게가 아니예요',
//           //         style: TextStyle(
//           //             fontSize: 16,
//           //             color: Colors.white,
//           //             fontWeight: FontWeight.w600),
//           //       ),
//           //       onTap: () {
//           //         Navigator.of(context).pop();
//           //       },
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(
//             height: 10,
//           )
//         ],
//       ),
//     );
//   }
// }

class ReviewCheckDialog extends StatefulWidget {
  const ReviewCheckDialog({super.key});

  @override
  State<ReviewCheckDialog> createState() => _ReviewCheckDialogState();
}

class _ReviewCheckDialogState extends State<ReviewCheckDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16), // You can change this value as you need.
        ),
      ),
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      titlePadding: const EdgeInsets.only(bottom: 0),
      title: SizedBox(
        height: 50,
        child: Stack(
          children: [
            Center(
              child: Text(
                "후기 등록하기",
                style: FontSystem.body1.copyWith(
                  color: ColorSystem.primary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ],
        ),
      ),
      content: SizedBox(
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
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(104, 158, 132, 1),
              borderRadius: BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
            ),
            child: GestureDetector(
              child: const Text(
                '내가 작성한 후기 보러 가기',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
