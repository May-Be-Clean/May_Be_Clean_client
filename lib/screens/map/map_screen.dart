import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/consts/consts.dart';
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
  final _reviewStates = Get.find<ReviewState>();
  final List<String> _selectedCategories = [];
  bool _isBottomsheetShow = false;

  final _categoryScrollController = ScrollController();

  void bottomsheetDismiss() {
    setState(() {
      _isBottomsheetShow = false;
    });
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
            },
            initialCameraPosition: CameraPosition(
              target: _mapStates.currentLocation,
              // target: LatLng(37.5665, 126.9780),
              zoom: 14.4746,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
          if (_selectedCategories.isNotEmpty && _isBottomsheetShow)
            StoreBottomSheet(
              _storeStates.stores[0],
              dismiss: bottomsheetDismiss,
              isBottomSheet: false,
            ),
        ],
      ),
    );
  }
}
