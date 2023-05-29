export 'dialog.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../consts/category.dart';
import '../consts/font.dart';
import 'button.dart';

//가게 인증 화면
class StoreComfirmDialog extends StatefulWidget {
  const StoreComfirmDialog({super.key});

  @override
  State<StoreComfirmDialog> createState() => _StoreComfirmDialogState();
}

int count = 1;
String store = "덕분애 제로웨이스트샵";
String name = "상원";
String phoneNumber = "02-6959-4479";
String location = "서울 서초구 서운로 26길 11 2층";
String location1 = "서초동 1302-37";
String openingHours = "13:00 - 20:00";

// List<double> categorySize = [107, 86, 97, 67, 87, 65, 76];

class _StoreComfirmDialogState extends State<StoreComfirmDialog> {
  final List<String> _selectedCategories = [];
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16), // You can change this value as you need.
          ),
        ),
        insetPadding: EdgeInsets.all(15),
        contentPadding: EdgeInsets.only(left: 20, right: 20),
        titlePadding: EdgeInsets.all(0),
        title: Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
        // buttonPadding: EdgeInsets.all(10),
        content: Container(
          height: 350,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/CloverLeaves${count}.png",
                    ),
                    Container(
                      width: Get.width * 0.50,
                      child: Text(
                        store,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                        text: "${name}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                        children: [
                          TextSpan(
                            text: "님이 등록한 가계예요.",
                            style: TextStyle(color: Colors.grey),
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // width: Get.width,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: -3, // horizontal spacing
                    runSpacing: 2, // vertical spacing
                    children: List<Widget>.generate(
                      storeCategories.length,
                      (index) {
                        final category = storeCategories.values.toList()[index];
                        bool isSelected = false;
                        if (_selectedCategories.contains(category[0])) {
                          isSelected = true;
                        }
                        return SizedBox(
                          // width: categorySize[index],
                          child: CategoryButton(
                            title: category[0],
                            unselectedSvg: category[1],
                            selectedSvg: category[2],
                            isSelected: isSelected,
                            fontSize: 14,
                            width: 12,
                            action: () {},
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/category/number.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${phoneNumber}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/category/location.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${location}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "지번: ${location1}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/category/time.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${openingHours}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "해당 가게가 정말 친환경 가게가 맞나요?",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(104, 158, 132, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 260,
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(104, 158, 132, 1),
                borderRadius:
                    BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
              ),
              child: GestureDetector(
                child: Text(
                  '친환경 가게가 맞아요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          // SizedBox(
          //   height: 8,
          // ),
          // Container(
          //   alignment: Alignment.center,
          //   child: Container(
          //     width: 260,
          //     padding: EdgeInsets.all(15),
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //       color: Color.fromRGBO(176, 176, 176, 1),
          //       borderRadius:
          //           BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
          //     ),
          //     child: GestureDetector(
          //       child: Text(
          //         '친환경 가게가 아니예요',
          //         style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600),
          //       ),
          //       onTap: () {
          //         Navigator.of(context).pop();
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

//가게 등록 화면
class StoreAddDialog extends StatefulWidget {
  const StoreAddDialog({super.key});

  @override
  State<StoreAddDialog> createState() => _StoreAddDialogState();
}

String store_name = "";
String store_filter = "";
String store_location = "";
String phone_number = "";
String store_time = "";

class _StoreAddDialogState extends State<StoreAddDialog> {
  final _formkey = GlobalKey<FormState>();
  final List<String> _selectedCategories = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16), // You can change this value as you need.
        ),
      ),
      insetPadding: EdgeInsets.all(15),
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      titlePadding: EdgeInsets.all(0),
      title: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
      // buttonPadding: EdgeInsets.all(10),
      content:
          // ConstrainedBox(
          // constraints: BoxConstraints(maxHeight: 350),
          // child:
          Container(
        height: 350,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20),
                      child:
                          Text("가게 이름 *", style: FontSystem.body1.copyWith()),
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      child: TextFormField(
                        style: FontSystem.body1.copyWith(),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(229, 229, 229, 1),
                            ),
                          ),
                          hintText: "가게 이름을 입력해주세요",
                          contentPadding: EdgeInsets.only(bottom: 5),
                          hintStyle: FontSystem.body2.copyWith(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            store_name = value as String;
                          });
                        },
                        // onSaved: (value) {
                        //   setState(() {
                        //     store_name = value as String;
                        //   });
                        // },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20),
                      child:
                          Text("가게 분류 *", style: FontSystem.body1.copyWith()),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("(1개 이상의 친환경 카테고리를 선택해주세요.)",
                          style: FontSystem.caption.copyWith(
                            color: Color.fromRGBO(104, 158, 132, 1),
                          )),
                    ),
                    SizedBox(
                      // width: Get.width,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: -3, // horizontal spacing
                        runSpacing: 2, // vertical spacing
                        children: List<Widget>.generate(
                          storeCategories.length,
                          (index) {
                            final category =
                                storeCategories.values.toList()[index];
                            bool isSelected = false;
                            if (_selectedCategories.contains(category[0])) {
                              isSelected = true;
                            }
                            return SizedBox(
                              // width: categorySize[index],
                              child: CategoryButton(
                                title: category[0],
                                unselectedSvg: category[1],
                                selectedSvg: category[2],
                                isSelected: isSelected,
                                fontSize: 12,
                                width: 12,
                                action: () {
                                  if (isSelected) {
                                    _selectedCategories.remove(category[0]);
                                  } else {
                                    _selectedCategories.add(category[0]);
                                  }
                                  isSelected = !isSelected;
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20),
                      child:
                          Text("가게 주소 *", style: FontSystem.body1.copyWith()),
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      child: TextFormField(
                        style: FontSystem.body1.copyWith(),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "가게 주소를 입력해주세요",
                          contentPadding: EdgeInsets.only(bottom: 0),
                          hintStyle: FontSystem.body2.copyWith(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            store_location = value;
                          });
                        },
                        // onSaved: (value) {
                        //   setState(() {
                        //     store_location = value as String;
                        //   });
                        // },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20),
                      child: Text.rich(
                        TextSpan(
                            text: "가게 전화시간",
                            style: FontSystem.body1.copyWith(),
                            children: [
                              TextSpan(
                                text: " ex) 02-123-1234",
                                style: FontSystem.caption.copyWith(
                                  color: Color.fromRGBO(104, 158, 132, 1),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      child: TextFormField(
                        style: FontSystem.body1.copyWith(),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromRGBO(229, 229, 229, 1),
                          )),
                          hintText: "가게 전화번호를 입력해주세요",
                          contentPadding: EdgeInsets.only(bottom: 5),
                          hintStyle: FontSystem.body2.copyWith(),
                        ),
                        onSaved: (value) {
                          setState(() {
                            store_location = value as String;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20),
                      child: Text.rich(
                        TextSpan(
                            text: "가게 영업시간",
                            style: FontSystem.body1.copyWith(),
                            children: [
                              TextSpan(
                                text: " ex) 9:00 - 17:00",
                                style: FontSystem.caption.copyWith(
                                  color: Color.fromRGBO(104, 158, 132, 1),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      child: TextFormField(
                        style: FontSystem.body1.copyWith(),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "가게 영업시간을 입력해주세요",
                          contentPadding: EdgeInsets.only(bottom: 5),
                          hintStyle: FontSystem.body2.copyWith(),
                        ),
                        onSaved: (value) {
                          setState(() {
                            store_time = value as String;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      // ),
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 260,
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(104, 158, 132, 1),
              borderRadius: BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
            ),
            child: GestureDetector(
              child: Text(
                '가게 등록하기',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                if (store_name == '' ||
                    store_filter == '' ||
                    store_location == '') {
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: ListBody(
                            //List Body를 기준으로 Text 설정
                            children: <Widget>[
                              Text('필수입력요소를 다 입력해주세요'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  //todo
                  Navigator.of(context).pop();
                }
                // Navigator.of(context).pop();
              },
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
