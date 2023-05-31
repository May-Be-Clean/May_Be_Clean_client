import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:may_be_clean/consts/consts.dart';

class CategoryButton extends StatefulWidget {
  final String title;
  final String selectedSvg;
  final String unselectedSvg;
  final bool isSelected;
  final double fontSize;
  final double width;
  final Function() action;

  const CategoryButton({
    required this.title,
    required this.selectedSvg,
    required this.unselectedSvg,
    required this.isSelected,
    required this.action,
    this.fontSize = 15,
    this.width = 15,
    super.key,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: (widget.isSelected) ? ColorSystem.primary : Colors.white,
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
              (widget.isSelected) ? widget.selectedSvg : widget.unselectedSvg,
              width: widget.width,
            ),
            const SizedBox(width: 2),
            Text(widget.title,
                style: FontSystem.body2.copyWith(
                  fontSize: widget.fontSize,
                  color: (widget.isSelected) ? Colors.white : Colors.black,
                )),
          ],
        ),
      ),
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

class MyPageButton extends StatelessWidget {
  final String Title;
  final String Count;
  final VoidCallback onTap;

  const MyPageButton({
    required this.Title,
    required this.Count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            Title,
            style: FontSystem.caption.copyWith(),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            Count,
            style: FontSystem.subtitleSemiBold.copyWith(
              color: ColorSystem.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class MyPageInformationButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MyPageInformationButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: FontSystem.body2.copyWith(),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
