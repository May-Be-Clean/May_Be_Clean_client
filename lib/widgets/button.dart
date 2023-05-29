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
