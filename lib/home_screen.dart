import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/global.dart';
import 'package:flutter/services.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final int initScreenIndex;
  const HomeScreen({this.initScreenIndex = 0, super.key});
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _globalStates = Get.find<GlobalState>();

  int _index = 0;
  bool _isPoping = false;

  @override
  void initState() {
    super.initState();
    _globalStates.tabController = TabController(
        length: 4, initialIndex: widget.initScreenIndex, vsync: this);
    _index = widget.initScreenIndex;
  }

  void _onTapNavigator(int index) async {
    HapticFeedback.lightImpact();

    if (index == _index) return;

    if (_index == 1) {
      // final bounds = await _globalStates.mapController.getVisibleRegion();
      // _globalStates.changeLocation(LatLng(
      //     (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      //     (bounds.northeast.longitude + bounds.southwest.longitude) / 2));
    }

    setState(() {
      _globalStates.tabController.animateTo(index);
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: widget.initScreenIndex,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: (() async {
            if (!_isPoping) {
              _isPoping = true;
              Timer(const Duration(milliseconds: 200), () {
                _isPoping = false;
              });
              showToast('한번 더 뒤로가기를 하면 종료됩니다.');
              return false;
            }

            return true;
          }),
          child: SafeArea(
            child: TabBarView(
              controller: _globalStates.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                MapScreen(),
                ReviewScreen(),
                ReviewScreen(),
                ReviewScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: (Platform.isAndroid ||
                  View.of(context).physicalSize.width <= 1080)
              ? 56
              : 90,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 2,
              ),
            ],
          ),
          child: TabBar(
            indicator: const BoxDecoration(),
            indicatorColor: null,
            onTap: _onTapNavigator,
            tabs: [
              Tab(
                  height: 60,
                  child: (_index == 0)
                      ? SvgPicture.asset(
                          'assets/icons/navigation/map_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/map_unselected.svg')),
              Tab(
                  height: 60,
                  child: (_index == 1)
                      ? SvgPicture.asset(
                          'assets/icons/navigation/review_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/review_unselected.svg')),
              Tab(
                  height: 60,
                  child: (_index == 2)
                      ? SvgPicture.asset(
                          'assets/icons/navigation/like_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/like_unselected.svg')),
              Tab(
                  height: 60,
                  child: (_index == 3)
                      ? SvgPicture.asset(
                          'assets/icons/navigation/mypage_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/mypage_unselected.svg')),
            ],
          ),
        ),
      ),
    );
  }
}
