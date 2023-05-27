import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:flutter/services.dart';

class ExpandImageScreen extends StatefulWidget {
  final List<String> imageUrls;
  const ExpandImageScreen({required this.imageUrls, super.key});

  @override
  State<ExpandImageScreen> createState() => _ExpandImageScreenState();
}

class _ExpandImageScreenState extends State<ExpandImageScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
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
            child: CarouselSlider(
              items: widget.imageUrls.map((e) => Image.network(e)).toList(),
              options: CarouselOptions(
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: 0,
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
          ),
        ]),
      ),
    );
  }
}
