import 'package:flutter/services.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:flutter/material.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'dart:developer';

// ignore: must_be_immutable
class StoreComfirmDialog extends StatelessWidget {
  final _globalStates = Get.find<GlobalState>();
  final Store store;
  StoreComfirmDialog(this.store, {super.key});
  bool _isPrcoess = false;

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
                    countToClover(store.clover),
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
                    text: store.user?.nickname ?? "유저",
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
                3,
                (index) {
                  bool isSelected = false;
                  if (store.storeCategories
                      .contains(storeCategoryMapping.keys.toList()[index])) {
                    isSelected = true;
                  }
                  final title = storeCategoryMapping.values.toList()[index][0];
                  final unselectedSvg =
                      storeCategoryMapping.values.toList()[index][1];
                  final selectedSvg =
                      storeCategoryMapping.values.toList()[index][2];

                  return SizedBox(
                    child: CategoryButton(
                      title: title,
                      unselectedSvg: unselectedSvg,
                      selectedSvg: selectedSvg,
                      isSelected: isSelected,
                      fontSize: 12,
                      imageSize: 10,
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
                  final innerIndex = index + 3;
                  bool isSelected = false;
                  if (store.storeCategories.contains(
                      storeCategoryMapping.keys.toList()[innerIndex])) {
                    isSelected = true;
                  }
                  final title =
                      storeCategoryMapping.values.toList()[innerIndex][0];
                  final unselectedSvg =
                      storeCategoryMapping.values.toList()[innerIndex][1];
                  final selectedSvg =
                      storeCategoryMapping.values.toList()[innerIndex][2];

                  return SizedBox(
                    child: CategoryButton(
                      title: title,
                      unselectedSvg: unselectedSvg,
                      selectedSvg: selectedSvg,
                      isSelected: isSelected,
                      fontSize: 12,
                      imageSize: 10,
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
                    Text(store.newAddress ?? "", style: FontSystem.body2),
                    Text(store.oldAddress ?? "",
                        style: FontSystem.body2
                            .copyWith(color: ColorSystem.gray1)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/icons/category/number.svg"),
                const SizedBox(
                  width: 10,
                ),
                if (store.phoneNumber == "" || store.phoneNumber == null)
                  const Text("번호 없음", style: FontSystem.body2)
                else
                  Text(store.phoneNumber!, style: FontSystem.body2)
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset("assets/icons/category/time.svg"),
                const SizedBox(
                  width: 10,
                ),
                if (store.startAt == null || store.endAt == null)
                  const Text("영업 시간 미지정", style: FontSystem.body2)
                else
                  Text("${store.startAt} - ${store.endAt}",
                      style: FontSystem.body2),
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
                try {
                  if (_isPrcoess) return;
                  _isPrcoess = true;
                  Store.verifyStore(_globalStates.token, store.id)
                      .then((value) => Get.back);
                } catch (e, s) {
                  log(e.toString(), stackTrace: s);
                  showToast("이미 친환경 가계 인증을 완료하였습니다.");
                }
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
  final _globalStates = Get.find<GlobalState>();
  final List<String> _selectedCategories = [];
  bool _isPrcoess = false;
  final _openTimeHourController = TextEditingController();
  final _openTimeMinuteController = TextEditingController();
  final _closeTimeHourController = TextEditingController();
  final _closeTimeMinuteController = TextEditingController();

  String _name = "";
  String _newAddress = "";
  String _oldAddress = "";
  String _phoneNumber = "";
  double _latitude = 0;
  double _longitude = 0;

  void _queryStore() async {
    final result =
        await Get.dialog(const SearchStoreDialog()) as KakaoStoreDTO?;
    if (result == null) return;

    _name = result.placeName;
    _newAddress = result.roadAddressName;
    _oldAddress = result.addressName;
    _phoneNumber = result.phone;
    _latitude = result.latitude;
    _longitude = result.longitude;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text(
        "친환경 가게 등록하기",
        style: FontSystem.body1.copyWith(color: ColorSystem.primary),
      ),
      body: GestureDetector(
        onTap: () => dismissKeyboard(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 20),
                child: Text("가게 이름 *", style: FontSystem.body1.copyWith()),
              ),
              GestureDetector(
                onTap: _queryStore,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: ColorSystem.gray2)),
                  ),
                  child: Text(
                    (_name == "") ? "가게 이름을 입력해주세요" : _name,
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 20),
                child: Text("가게 분류 *", style: FontSystem.body1.copyWith()),
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
                        storeCategoryMapping.values.toList()[index];
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
                  storeCategoryMapping.length - 3,
                  (index) {
                    final category =
                        storeCategoryMapping.values.toList()[index + 3];
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
                child: Text("가게 주소 *", style: FontSystem.body1.copyWith()),
              ),
              GestureDetector(
                onTap: _queryStore,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: ColorSystem.gray2)),
                  ),
                  child: Text(
                    (_newAddress == "") ? "가게 주소를 입력해주세요" : _newAddress,
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 20),
                child: Text.rich(
                  TextSpan(
                      text: "가게 전화번호",
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
              GestureDetector(
                onTap: _queryStore,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: ColorSystem.gray2)),
                  ),
                  child: Text(
                    (_phoneNumber == "") ? "가게 전화번호를 입력해주세요" : _phoneNumber,
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                ),
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
                          text: " ex) 09:00 - 17:00",
                          style: FontSystem.caption
                              .copyWith(color: ColorSystem.primary),
                        )
                      ]),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      controller: _openTimeHourController,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 0, max: 23)
                      ],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "00",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                    ),
                  ),
                  Text(
                    ":",
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                  SizedBox(
                    width: 30,
                    child: TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      controller: _openTimeMinuteController,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 0, max: 59)
                      ],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "00",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                    ),
                  ),
                  Text(
                    " - ",
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                  SizedBox(
                    width: 30,
                    child: TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      controller: _closeTimeHourController,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 0, max: 23)
                      ],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "00",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                    ),
                  ),
                  Text(
                    ":",
                    style: FontSystem.body2.copyWith(color: ColorSystem.gray1),
                  ),
                  SizedBox(
                    width: 30,
                    child: TextFormField(
                      style: FontSystem.body1
                          .copyWith(fontWeight: FontWeight.normal),
                      controller: _closeTimeMinuteController,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 0, max: 59)
                      ],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorSystem.gray2),
                        ),
                        hintText: "00",
                        hintStyle:
                            FontSystem.body2.copyWith(color: ColorSystem.gray1),
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            if (_name == '' || _selectedCategories.isEmpty) {
              showToast('필수입력요소를 다 입력해주세요');
            } else {
              if (_isPrcoess) return;
              setState(() {
                _isPrcoess = true;
              });
              String? openTime;
              String? closeTime;
              if (_openTimeHourController.text.isNotEmpty &&
                  _openTimeMinuteController.text.isNotEmpty) {
                openTime =
                    "${_openTimeHourController.text.padLeft(2, '0')}:${_openTimeMinuteController.text.padLeft(2, '0')}:00";
                closeTime =
                    "${_closeTimeHourController.text.padLeft(2, '0')}:${_closeTimeMinuteController.text.padLeft(2, '0')}:00";
              }
              Store.postNewStore(
                  _globalStates.token,
                  _name,
                  _latitude,
                  _longitude,
                  _newAddress,
                  _oldAddress,
                  _phoneNumber,
                  _selectedCategories,
                  openTime,
                  closeTime);
              Get.back();
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
                borderRadius:
                    BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
              ),
              child: const Text(
                '가게 등록하기',
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

class SearchStoreDialog extends StatefulWidget {
  const SearchStoreDialog({super.key});

  @override
  State<SearchStoreDialog> createState() => _SearchStoreDialogState();
}

class _SearchStoreDialogState extends State<SearchStoreDialog> {
  final _textController = TextEditingController();
  final _mapStates = Get.find<MapState>();
  final List<KakaoStoreDTO> _storeDatas = [];
  int _index = -1;

  Future<void> searchStores(String keyword) async {
    final result = await KakaoStoreDTO.queryLocation(
        keyword,
        _mapStates.currentLocation!.latitude,
        _mapStates.currentLocation!.longitude);

    _storeDatas.addAll(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text(
        "가게 검색",
        style: FontSystem.body1.copyWith(color: ColorSystem.primary),
      ),
      body: SizedBox(
        width: Get.width * 0.75,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: FontSystem.body1.copyWith(fontWeight: FontWeight.normal),
                autocorrect: false,
                controller: _textController,
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
                  suffixIcon: GestureDetector(
                    onTap: () => searchStores(_textController.text),
                    child: const Icon(Icons.search),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                onFieldSubmitted: (value) {
                  searchStores(value);
                },
              ),
              if (_storeDatas.isEmpty)
                SizedBox(
                  height: Get.height * 0.4,
                )
              else
                ...List.generate(_storeDatas.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (_index == index) {
                        _index = -1;
                      } else {
                        _index = index;
                      }
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: Get.width * 0.75,
                      decoration: BoxDecoration(
                        color: _index == index
                            ? ColorSystem.gray2
                            : Colors.transparent,
                        border: const Border(
                            bottom: BorderSide(color: ColorSystem.gray2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _storeDatas[index].placeName,
                            style: FontSystem.body1
                                .copyWith(color: ColorSystem.primary),
                          ),
                          Text(
                            _storeDatas[index].roadAddressName,
                            style: FontSystem.body2
                                .copyWith(color: ColorSystem.gray1),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            if (_index == -1) {
              Get.back();
            }
            Get.back(result: _storeDatas[_index]);
          },
          child: Container(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorSystem.primary,
                borderRadius:
                    BorderRadius.circular(10), // 원하는 BorderRadius 값 설정
              ),
              child: const Text(
                '가게 선택',
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
