import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/global.dart';
import 'package:flutter/services.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/screens.dart';

class HomeScreen extends StatefulWidget {
  final int initScreenIndex;
  const HomeScreen({this.initScreenIndex = 2, super.key});
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _globalStates = Get.find<GlobalState>();

  int _index = 2;
  bool _isPoping = false;

  @override
  void initState() {
    super.initState();
    _globalStates.tabController = TabController(
        length: 5, initialIndex: widget.initScreenIndex, vsync: this);
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
      length: 5,
      initialIndex: widget.initScreenIndex,
      child: Scaffold(
        key: _scaffoldKey,
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
                CommunityScreen(),
                CommunityScreen(),
                CommunityScreen(),
                CommunityScreen(),
                CommunityScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: (Platform.isAndroid || window.physicalSize.width <= 1080)
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
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      color: (_index == 0) ? ColorSystem.primary : Colors.grey,
                      size: 36,
                    ),
                    const Text(
                      "아이템",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Tab(
                height: 60,
                child: Column(
                  children: [
                    Icon(
                      Icons.star_outline_rounded,
                      color: (_index == 1) ? ColorSystem.primary : Colors.grey,
                      size: 36,
                    ),
                    const Text(
                      "랭킹",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Tab(
                height: 60,
                child: Column(
                  children: [
                    Icon(
                      Icons.home,
                      color: (_index == 2) ? ColorSystem.primary : Colors.grey,
                      size: 36,
                    ),
                    const Text(
                      "홈",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Tab(
                height: 60,
                child: Column(
                  children: [
                    Icon(
                      Icons.panorama_photosphere_outlined,
                      color: (_index == 3) ? ColorSystem.primary : Colors.grey,
                      size: 36,
                    ),
                    const Text(
                      "커뮤니티",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Tab(
                height: 60,
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: (_index == 4) ? ColorSystem.primary : Colors.grey,
                      size: 36,
                    ),
                    const Text(
                      "마이",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
