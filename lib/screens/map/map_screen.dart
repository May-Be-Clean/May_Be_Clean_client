import 'dart:async';
import 'dart:developer';

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

  void _bottomsheetDismiss() {
    setState(() {
      _isBottomsheetShow = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMarkers(GoogleMapController controller) async {
    await controller.getVisibleRegion().then((bounds) async {
      log("upperLat: ${bounds.northeast.latitude}, upperLon: ${bounds.northeast.longitude}, lowerLat: ${bounds.southwest.latitude}, lowerLon: ${bounds.southwest.longitude}");

      await _globalStates.loadMarker(
        bounds.northeast.latitude - 0.001,
        bounds.southwest.longitude - 0.001,
        bounds.southwest.latitude + 0.001,
        bounds.northeast.longitude + 0.001,
        _selectedCategories,
      );

      setState(() {});
    });
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
              // 설정 변경
              changeMapMode(_mapStates.mapController!);
              Timer(const Duration(milliseconds: 100), () async {
                await loadMarkers(controller);
              });
            },
            initialCameraPosition: CameraPosition(
              target: _mapStates.currentLocation!,
              zoom: 16,
            ),
            myLocationButtonEnabled: false,
            compassEnabled: false,
            myLocationEnabled: true,
            markers: _globalStates.filteredMarkerSet,
            zoomControlsEnabled: false,
            tiltGesturesEnabled: false,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_selectedCategories.isEmpty && _globalStates.userData != null)
                _header(),
              _categoryListView(),
              _refreshButton(),
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
          GetBuilder<GlobalState>(builder: (globalStates) {
            if (_selectedCategories.isNotEmpty && _isBottomsheetShow) {
              return StoreListBottomSheet(
                dismiss: _bottomsheetDismiss,
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }

  void loadFilteredMarkers() async {
    loadMarkers(_mapStates.mapController!).then((value) async {
      _globalStates.filteredStores.clear();
      _globalStates.filteredMarkers.clear();

      for (var store in _globalStates.storeList) {
        final storeCategories = store.storeCategories;
        if (_selectedCategories.isEmpty) {
          _globalStates.filteredMarkers[store.id.toString()] =
              await _globalStates.storeToMarker(store);
          _globalStates.filteredStores[store.id] = store;
          continue;
        }

        for (var category in storeCategories) {
          if (_selectedCategories.contains(category)) {
            _globalStates.filteredMarkers[store.id.toString()] =
                await _globalStates.storeToMarker(store);
            _globalStates.filteredStores[store.id] = store;
            break;
          }
        }
      }

      setState(() {});
    });
  }

  Widget _refreshButton() {
    return GestureDetector(
      onTap: loadFilteredMarkers,
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        child: SvgPicture.asset('assets/icons/map/refresh.svg'),
      ),
    );
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
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                loadFilteredMarkers();
                isSelected = !isSelected;
                setState(() {});
              });
        },
      ),
    );
  }
}
