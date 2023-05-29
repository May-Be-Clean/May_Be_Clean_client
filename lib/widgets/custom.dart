import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet extends StatelessWidget {
  final double initialChildSize;
  final double maxChildSize;
  final double minChildSize;
  final EdgeInsets padding;
  final List<Widget> children;
  final Widget? header;
  final void Function()? onTapBackground;
  final double? barWidth;
  final DraggableScrollableController? controller;

  const CustomBottomSheet({
    Key? key,
    this.initialChildSize = 1.0,
    this.maxChildSize = 1.0,
    this.minChildSize = 0.1,
    this.onTapBackground,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 0),
    this.header,
    this.barWidth,
    this.controller,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapBackground ?? Get.back,
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          controller: controller,
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          builder: (_, controller2) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 0,
                  blurRadius: 5.0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (barWidth != null)
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: barWidth,
                        height: 6,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withOpacity(0.35),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                header ?? Container(),
                Expanded(
                  child: ListView(
                    controller: controller2,
                    padding: padding,
                    children: [
                      ...children,
                    ],
                  ),
                ),
                // SafeArea(
                //     child: TextButton(
                //         onPressed: () {
                //           print(controller.position.pixels);
                //           // print(controller.initialScrollOffset);
                //         },
                //         child: Text('오늘로가기'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
