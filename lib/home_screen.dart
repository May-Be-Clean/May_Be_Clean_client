import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/screens/story/story_screen.dart';
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
        length: 5, initialIndex: widget.initScreenIndex, vsync: this);
    _index = widget.initScreenIndex;

    _globalStates.tabController.addListener(() {
      if (_globalStates.tabController.indexIsChanging) {
        setState(() {
          _index = _globalStates.tabController.index;
        });
      }
    });
  }

  void _onTapNavigator(int index) async {
    HapticFeedback.lightImpact();

    if (index == _index) return;

    if (index == 2 && _globalStates.userData == null) {
      loginRequest(context);
      return;
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
            top: false,
            child: TabBarView(
              controller: _globalStates.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                MapScreen(),
                LikeScreen(),
                ReviewScreen(),
                StoryScreen(),
                MyPage(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: (Platform.isAndroid ||
                  View.of(context).physicalSize.width <= 1080)
              ? 56
              : 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 1,
                spreadRadius: 1,
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
                          'assets/icons/navigation/store_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/store_unselected.svg')),
              Tab(
                  height: 60,
                  child: (_index == 2)
                      ? SvgPicture.asset(
                          'assets/icons/navigation/review_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/review_unselected.svg')),
              Tab(
                  height: 60,
                  child: (_index == 3)
                      ? SvgPicture.asset(
                          'assets/icons/navigation/story_selected.svg')
                      : SvgPicture.asset(
                          'assets/icons/navigation/story_unselected.svg')),
              Tab(
                height: 60,
                child: (_index == 4)
                    ? SvgPicture.asset(
                        'assets/icons/navigation/mypage_selected.svg')
                    : SvgPicture.asset(
                        'assets/icons/navigation/mypage_unselected.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
