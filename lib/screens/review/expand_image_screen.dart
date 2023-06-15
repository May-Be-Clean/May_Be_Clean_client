import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:flutter/services.dart';
import 'package:may_be_clean/widgets/widgets.dart';

import '../../models/review.dart';
import '../../utils/converter.dart';

class ExpandImageScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final Review review;
  const ExpandImageScreen(
      {required this.imageUrls,
      required this.initialIndex,
      required this.review,
      super.key});

  @override
  State<ExpandImageScreen> createState() => _ExpandImageScreenState();
}

class _ExpandImageScreenState extends State<ExpandImageScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.black,
      body: SafeArea(
        child: Column(children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${_index + 1}",
                      style: FontSystem.subtitleSemiBold.copyWith(
                        color: ColorSystem.primary,
                      ),
                    ),
                    TextSpan(
                      text: " / ${widget.imageUrls.length}",
                      style: FontSystem.subtitleSemiBold.copyWith(
                        color: ColorSystem.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: ColorSystem.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
              child: Stack(
            children: [
              CarouselSlider(
                items: widget.imageUrls
                    .map((e) => Image.network(
                          e,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  height: double.infinity,
                  initialPage: widget.initialIndex,
                  enableInfiniteScroll: false,
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _index = index;
                    });
                  },
                ),
              ),
              // StoreImageBottomSheet(dismiss: _bottomsheetDismiss),
              Positioned(
                bottom: 0,
                height: 200,
                width: Get.width,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: StoreImageBottomSheet(
                      review: widget.review,
                      initialChildSize: 0.4,
                      maxChildSize: 1.0,
                      minChildSize: 0.4,
                    )),
              ),
            ],
          )),
        ]),
      ),
    );
  }
}

class StoreImageBottomSheet extends StatefulWidget {
  final Review review;
  final double initialChildSize;
  final double maxChildSize;
  final double minChildSize;
  final Widget? header;
  final void Function()? onTapBackground;
  final double? barWidth;
  final Color? color;

  // final bool isBoxShadow;

  const StoreImageBottomSheet({
    Key? key,
    this.initialChildSize = 1.0,
    this.maxChildSize = 1.0,
    this.minChildSize = 0.1,
    this.onTapBackground,
    this.header,
    this.barWidth,
    this.color = Colors.white,
    // this.isBoxShadow = false,
    required this.review,
  }) : super(key: key);

  @override
  _StoreImageBottomSheetState createState() => _StoreImageBottomSheetState();
}

class _StoreImageBottomSheetState extends State<StoreImageBottomSheet> {
  final DraggableScrollableController _scrollController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTapBackground ?? Get.back,
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          expand: false,
          controller: _scrollController,
          initialChildSize: widget.initialChildSize,
          maxChildSize: widget.maxChildSize,
          minChildSize: widget.minChildSize,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.barWidth != null)
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: widget.barWidth,
                        height: 6,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: ColorSystem.gray1,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                widget.header ?? const SizedBox.shrink(),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(expToBadge(4), width: 50),
                          SizedBox(
                            child: Text(
                              widget.review.nickname,
                              style: FontSystem.subtitleSemiBold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Text(
                          widget.review.content,
                          style: FontSystem.body1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 24,
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.review.reviewCategories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 4),
                          itemBuilder: (context, index) {
                            final reviewCategoryData = reviewCategoryMapping[
                                widget.review.reviewCategories[index]];
                            final String title = reviewCategoryData?[0] ?? "기타";
                            final String image = reviewCategoryData?[1] ??
                                "assets/icons/review/clean.png";
                            return ReviewCategoryItem(
                                isImageBottomSheet: true,
                                title: title,
                                image: image);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
