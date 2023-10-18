import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/utils/utils.dart';

class UserPropfile extends StatefulWidget {
  final int point;
  final int userId;
  final String nickname;
  const UserPropfile(
      {required this.point,
      required this.userId,
      required this.nickname,
      super.key});

  @override
  State<UserPropfile> createState() => _UserPropfileState();
}

class _UserPropfileState extends State<UserPropfile> {
  final _reivews = <Review>[];
  int _page = 0;
  final _stores = <Store>[];
  int _section = 0;
  final _scrollController = ScrollController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    try {
      Review.getUserReviews(widget.userId, _page, 15).then((value) {
        _reivews.addAll(value);
        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
    _scrollController.addListener(() {
      if (_isProcessing) return;
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _isProcessing = true;
        _page++;
        if (_section == 0) {
          Review.getUserReviews(widget.userId, _page, 15).then((value) {
            setState(() {
              _reivews.addAll(value);
              _isProcessing = false;
            });
          });
        } else {
          Store.getUserStores(widget.userId, _page, 15).then((value) {
            setState(() {
              _stores.addAll(value);
              _isProcessing = false;
            });
          });
        }
      }
    });
  }

  void onTapReviewSection() {
    setState(() {
      _section = 0;
      _page = 0;
      _reivews.clear();

      Review.getUserReviews(widget.userId, _page, 15).then((value) {
        _reivews.addAll(value);
        setState(() {});
      });
    });
  }

  void onTapStoreSection() {
    setState(() {
      _section = 1;
      _page = 0;
      _stores.clear();

      Store.getUserStores(widget.userId, _page, 15).then((value) {
        _stores.addAll(value);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방문자 후기', style: FontSystem.body1),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(expToBadge(widget.point), width: 100),
                const SizedBox(height: 12),
                Text(
                  expToBadgeTitle(widget.point),
                  style: FontSystem.body1.copyWith(color: ColorSystem.green),
                ),
                Text(
                  widget.nickname,
                  style: FontSystem.subtitleSemiBold.copyWith(
                    color: ColorSystem.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: onTapReviewSection,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        width: Get.width / 2,
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: (_section == 0)
                            ? const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: ColorSystem.green,
                                    width: 2,
                                  ),
                                ),
                              )
                            : null,
                        child: const Text(
                          "작성한 후기",
                          style: FontSystem.body2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTapStoreSection,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                          alignment: Alignment.center,
                          width: Get.width / 2,
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: (_section == 1)
                              ? const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorSystem.green,
                                      width: 2,
                                    ),
                                  ),
                                )
                              : null,
                          child: const Text(
                            "등록한 가게",
                            style: FontSystem.body2,
                          )),
                    ),
                  ],
                )
              ],
            ),
            ListView.separated(
              itemCount: (_section == 0) ? _reivews.length : _stores.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (_section == 0) {
                  final review = _reivews[index];
                  return ReviewCard(review);
                } else {
                  final store = _stores[index];
                  return StoreCard(store);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
