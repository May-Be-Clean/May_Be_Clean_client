import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _globalStates = Get.find<GlobalState>();
  final _mapStates = Get.find<MapState>();
  final List<String> _selectedCategories = [];
  bool _isBottomsheetShow = false;

  final _categoryScrollController = ScrollController();

  void _bottomsheetDismiss() {
    setState(() {
      _isBottomsheetShow = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMarkers() async {
    await _globalStates.loadMarker(
        _mapStates.currentLocation!.latitude - 0.001,
        _mapStates.currentLocation!.longitude - 0.001,
        _mapStates.currentLocation!.latitude + 0.001,
        _mapStates.currentLocation!.longitude + 0.001,
        _selectedCategories);
  }

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
                text: TextSpan(
                  text: _globalStates.userData?.user.nickname ?? "익명",
                  style: FontSystem.subtitleSemiBold,
                  children: const [
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
      margin: (_selectedCategories.isNotEmpty || _globalStates.userData == null)
          ? EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
            )
          : null,
      height: 40,
      child: ListView.builder(
        itemCount: storeCategoryMapping.length,
        scrollDirection: Axis.horizontal,
        controller: _categoryScrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final category = storeCategoryMapping.values.toList()[index];
          final categoryName = storeCategoryMapping.keys.toList()[index];
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
                  _isBottomsheetShow = true;
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
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapStates.mapController = controller;
              loadMarkers();
            },
            initialCameraPosition: CameraPosition(
              target: _mapStates.currentLocation!,
              zoom: 16,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            mapType: MapType.terrain,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_selectedCategories.isEmpty && _globalStates.userData != null)
                _header(),
              _categoryListView(),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                if (_globalStates.userData == null) {
                  loginRequest(context);
                } else {
                  Get.dialog(const StoreAddDialog());
                }
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
          if (_selectedCategories.isNotEmpty && _isBottomsheetShow)
            StoreListBottomSheet(
              dismiss: _bottomsheetDismiss,
            ),
        ],
      ),
    );
  }
}
