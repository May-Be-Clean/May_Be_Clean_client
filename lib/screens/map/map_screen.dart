import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
// import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/widgets/button.dart';
import 'package:may_be_clean/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // final _globalStates = Get.find<GlobalState>();
  // final _storeStates = Get.find<StoreState>();
  final List<String> _selectedCategories = [];

  Widget _header() {
    return SizedBox(
      width: Get.width,
      child: Column(
        children: [
          Container(
              width: Get.width,
              padding: const EdgeInsets.all(10),
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
                            text: "님 근처에 있는",
                            style: FontSystem.subtitleRegular),
                      ],
                    ),
                  ),
                  const Text(
                    "친환경 가게들을 찾아봤어요",
                    style: FontSystem.subtitleRegular,
                  ),
                ],
              )),
          SizedBox(
            height: 40,
            child: ListView.separated(
              itemCount: storeCategories.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(width: 5),
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.5665, 126.9780),
              zoom: 14.4746,
            ),
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 0,
            child: _header(),
          ),
        ],
      ),
    );
  }
}
