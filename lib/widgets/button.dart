import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/consts/consts.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String selectedSvg;
  final String unselectedSvg;
  final bool isSelected;
  final double fontSize;
  final Function() action;

  const CategoryButton({
    required this.title,
    required this.selectedSvg,
    required this.unselectedSvg,
    required this.isSelected,
    required this.action,
    this.fontSize = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
          margin: const EdgeInsets.all(5),
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
                width: 16,
              ),
              const SizedBox(width: 2),
              Text(title,
                  style: FontSystem.caption.copyWith(
                    color: (isSelected) ? Colors.white : Colors.black,
                    fontSize: fontSize,
                  )),
            ],
          )),
    );
  }
}

class ReviewButton extends StatelessWidget {
  final String title;
  final String image;
  final Function() action;

  const ReviewButton({
    super.key,
    required this.title,
    required this.image,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
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
                style: FontSystem.caption.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
