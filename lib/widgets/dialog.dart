import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final List<Widget> actions;
  final Function()? onTapBackground;

  const CustomDialog(
      {this.title,
      required this.body,
      required this.actions,
      this.onTapBackground,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBackground,
      behavior: (onTapBackground != null) ? HitTestBehavior.opaque : null,
      child: GestureDetector(
        onTap: () {},
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          insetPadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          titlePadding: const EdgeInsets.all(5),
          title: Stack(
            alignment: Alignment.centerRight,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
              Positioned.fill(
                child: Align(alignment: Alignment.center, child: title),
              ),
            ],
          ),
          content: body,
          actions: actions,
        ),
      ),
    );
  }
}
