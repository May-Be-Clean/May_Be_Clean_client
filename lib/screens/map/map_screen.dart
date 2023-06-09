import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/networks/network.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapStates = Get.find<MapState>();
  final _storeStates = Get.find<StoreState>();
  final List<String> _selectedCategories = [];

  final _categoryScrollController = ScrollController();

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top,
      ),
      width: Get.width,
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: "심상현",
                  style: FontSystem.subtitleSemiBold,
                  children: [
                    TextSpan(
                        text: "님 근처에 있는", style: FontSystem.subtitleRegular),
                  ],
                ),
              ),
              const Text(
                "친환경 가게들을 찾아봤어요",
                style: FontSystem.subtitleRegular,
              ),
            ],
          )),
    );
  }

  Widget _categoryListView() {
    return Container(
      margin: (_selectedCategories.isNotEmpty)
          ? EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
            )
          : null,
      height: 40,
      child: ListView.builder(
        itemCount: storeCategories.length,
        scrollDirection: Axis.horizontal,
        controller: _categoryScrollController,
        shrinkWrap: true,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapStates.mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _mapStates.currentLocation,
              // target: LatLng(37.5665, 126.9780),
              zoom: 14.4746,
            ),
            myLocationButtonEnabled: false,
          ),
          Column(
            children: [
              if (_selectedCategories.isEmpty) _header(),
              _categoryListView(),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                // Get.dialog(StoreComfirmDialog(_storeStates.stores[0]));
                Get.dialog(const StoreAddDialog());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SvgPicture.asset('assets/icons/map/add_location.svg'),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: GestureDetector(
              onTap: () {
                _mapStates.moveToCurrentLocation();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child:
                    SvgPicture.asset('assets/icons/map/current_location.svg'),
              ),
            ),
          ),
          // if (_selectedCategories.isNotEmpty)
          //   Positioned(
          //     bottom: 20,
          //     child: StoreBottomSheet(_storeStates.stores[0]),
          //   ),
        ],
      ),
    );
  }
}

class StoreComfirmDialog extends StatelessWidget {
  final Store store;
  const StoreComfirmDialog(this.store, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text(
        "친환경 가게 인증하기",
        style: FontSystem.body1.copyWith(color: ColorSystem.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    countToClover(store.cloverCount),
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(store.name, style: FontSystem.subtitleSemiBold),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              Text.rich(
                TextSpan(
                    text: "유저",
                    style:
                        FontSystem.caption.copyWith(color: ColorSystem.primary),
                    children: const [
                      TextSpan(
                        text: "님이 등록한 가계예요.",
                        style: TextStyle(color: Colors.black),
                      )
                    ]),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) {
                  bool isSelected = false;
                  if (store.category
                      .contains(storeCategories.keys.toList()[index])) {
                    isSelected = true;
                  }
                  final title = storeCategories.values.toList()[index][0];
                  final unselectedSvg =
                      storeCategories.values.toList()[index][1];
                  final selectedSvg = storeCategories.values.toList()[index][2];

                  return SizedBox(
                    child: CategoryButton(
                      title: title,
                      unselectedSvg: unselectedSvg,
                      selectedSvg: selectedSvg,
                      isSelected: isSelected,
                      fontSize: 14,
                      imageSize: 12,
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) {
                  final innerIndex = index + 2;
                  bool isSelected = false;
                  if (store.category
                      .contains(storeCategories.keys.toList()[innerIndex])) {
                    isSelected = true;
                  }
                  final title = storeCategories.values.toList()[innerIndex][0];
                  final unselectedSvg =
                      storeCategories.values.toList()[innerIndex][1];
                  final selectedSvg =
                      storeCategories.values.toList()[innerIndex][2];

                  return SizedBox(
                    child: CategoryButton(
                      title: title,
                      unselectedSvg: unselectedSvg,
                      selectedSvg: selectedSvg,
                      isSelected: isSelected,
                      fontSize: 14,
                      imageSize: 12,
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  final innerIndex = index + 4;
                  bool isSelected = false;
                  if (store.category
                      .contains(storeCategories.keys.toList()[innerIndex])) {
                    isSelected = true;
                  }
                  final title = storeCategories.values.toList()[innerIndex][0];
                  final unselectedSvg =
                      storeCategories.values.toList()[innerIndex][1];
                  final selectedSvg =
                      storeCategories.values.toList()[innerIndex][2];

                  return SizedBox(
                    child: CategoryButton(
                      title: title,
                      unselectedSvg: unselectedSvg,
                      selectedSvg: selectedSvg,
                      isSelected: isSelected,
                      fontSize: 14,
                      imageSize: 12,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/icons/category/location.svg"),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(store.address, style: FontSystem.body2),
                    Text(store.address,
                        style: FontSystem.body2
                            .copyWith(color: ColorSystem.gray1)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/icons/category/number.svg"),
                const SizedBox(
                  width: 10,
                ),
                Text(store.phone, style: FontSystem.body2)
              ],
            ),
            Row(
              children: [
                SvgPicture.asset("assets/icons/category/time.svg"),
                const SizedBox(
                  width: 10,
                ),
                Text(store.openTime ?? "영업 시간 미지정", style: FontSystem.body2),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "해당 가게가 정말 친환경 가게가 맞나요?",
                style: FontSystem.caption.copyWith(color: ColorSystem.primary),
              ),
              Text(
                "맞다면 버튼을 클릭해주세요.",
                style: FontSystem.caption.copyWith(color: ColorSystem.primary),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSystem.primary,
              borderRadius: BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
            ),
            child: GestureDetector(
              child: const Text(
                '친환경 가게가 맞아요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                Get.back();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StoreAddDialog extends StatefulWidget {
  const StoreAddDialog({super.key});

  @override
  State<StoreAddDialog> createState() => _StoreAddDialogState();
}

class _StoreAddDialogState extends State<StoreAddDialog> {
  final _formkey = GlobalKey<FormState>();
  final List<String> _selectedCategories = [];

  String _name = "";
  String _location = "";
  String _phoneNumber = "";
  String _opentime = "";

  void dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text(
        "친환경 가게 등록하기",
        style: FontSystem.body1.copyWith(color: ColorSystem.primary),
      ),
      body: GestureDetector(
        onTap: dismissKeyboard,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      child:
                          Text("가게 이름 *", style: FontSystem.body1.copyWith()),
                    ),
                    TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "가게 이름을 입력해주세요",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      child:
                          Text("가게 분류 *", style: FontSystem.body1.copyWith()),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("(1개 이상의 친환경 카테고리를 선택해주세요.)",
                          style: FontSystem.caption
                              .copyWith(color: ColorSystem.primary)),
                    ),
                    Row(
                      children: List<Widget>.generate(
                        3,
                        (index) {
                          final category =
                              storeCategories.values.toList()[index];
                          bool isSelected = false;
                          if (_selectedCategories.contains(category[0])) {
                            isSelected = true;
                          }
                          return CategoryButton(
                            title: category[0],
                            unselectedSvg: category[1],
                            selectedSvg: category[2],
                            isSelected: isSelected,
                            padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
                            fontSize: 12,
                            imageSize: 12,
                            action: () {
                              if (isSelected) {
                                _selectedCategories.remove(category[0]);
                              } else {
                                _selectedCategories.add(category[0]);
                              }
                              isSelected = !isSelected;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      children: List<Widget>.generate(
                        storeCategories.length - 3,
                        (index) {
                          final category =
                              storeCategories.values.toList()[index + 3];
                          bool isSelected = false;
                          if (_selectedCategories.contains(category[0])) {
                            isSelected = true;
                          }
                          return CategoryButton(
                            title: category[0],
                            unselectedSvg: category[1],
                            selectedSvg: category[2],
                            isSelected: isSelected,
                            fontSize: 12,
                            imageSize: 12,
                            padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
                            action: () {
                              if (isSelected) {
                                _selectedCategories.remove(category[0]);
                              } else {
                                _selectedCategories.add(category[0]);
                              }
                              isSelected = !isSelected;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      child:
                          Text("가게 주소 *", style: FontSystem.body1.copyWith()),
                    ),
                    TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "가게 주소를 입력해주세요",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _location = value;
                        });
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      child: Text.rich(
                        TextSpan(
                            text: "가게 전화시간",
                            style: FontSystem.body1.copyWith(),
                            children: [
                              TextSpan(
                                text: " ex) 02-123-1234",
                                style: FontSystem.caption.copyWith(
                                  color: const Color.fromRGBO(104, 158, 132, 1),
                                ),
                              )
                            ]),
                      ),
                    ),
                    TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      autocorrect: false,
                      inputFormatters: [PhoneNumberInputFormatter()],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "가게 전화번호를 입력해주세요",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      child: Text.rich(
                        TextSpan(
                            text: "가게 영업시간",
                            style: FontSystem.body1.copyWith(),
                            children: [
                              TextSpan(
                                text: " ex) 9:00 - 17:00",
                                style: FontSystem.caption
                                    .copyWith(color: ColorSystem.primary),
                              )
                            ]),
                      ),
                    ),
                    TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      autocorrect: false,
                      inputFormatters: [TimeInputFormatter()],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "가게 영업시간을 입력해주세요",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _opentime = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
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
              borderRadius: BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
            ),
            child: GestureDetector(
              child: const Text(
                '가게 등록하기',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                if (_name == '' ||
                    _selectedCategories.isEmpty ||
                    _location == '') {
                  showToast('필수입력요소를 다 입력해주세요');
                } else {
                  StoreNetwork.postNewStore(_name, _location, _phoneNumber,
                      _selectedCategories, _opentime, _opentime);
                  //TODO 가게 등록 API 연결 및 마커 추가
                  Get.back();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
