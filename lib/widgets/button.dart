import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/consts/consts.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String selectedSvg;
  final String unselectedSvg;
  final bool isSelected;
  final double fontSize;
  final double imageSize;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Function()? action;

  const CategoryButton({
    required this.title,
    required this.selectedSvg,
    required this.unselectedSvg,
    required this.isSelected,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(10, 7, 10, 7),
    this.margin = const EdgeInsets.all(5),
    this.fontSize = 15,
    this.imageSize = 15,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: (isSelected) ? ColorSystem.primary : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 1,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              (isSelected) ? selectedSvg : unselectedSvg,
              width: imageSize,
            ),
            const SizedBox(width: 2),
            Text(title,
                style: FontSystem.body2.copyWith(
                  fontSize: fontSize,
                  color: (isSelected) ? Colors.white : Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}

class ReviewCategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isImageBottomSheet;

  const ReviewCategoryItem({
    super.key,
    required this.title,
    required this.image,
    this.isImageBottomSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isImageBottomSheet
            ? const Color.fromRGBO(0, 0, 0, 0.4)
            : ColorSystem.chip,
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 16,
          ),
          const SizedBox(width: 2),
          Text(title,
              style: FontSystem.caption.copyWith(
                  color: isImageBottomSheet ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}

class ReviewButton extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final Function() action;

  const ReviewButton({
    super.key,
    required this.title,
    required this.image,
    required this.action,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
        margin: const EdgeInsets.all(3),
        decoration: (isSelected)
            ? BoxDecoration(
                color: ColorSystem.primary,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 0.5, color: ColorSystem.primary),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ColorSystem.gray3,
                border: Border.all(width: 0.5, color: ColorSystem.gray2),
              ),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 16,
            ),
            const SizedBox(width: 2),
            Text(title,
                style: FontSystem.body2.copyWith(
                    color: (isSelected) ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}
