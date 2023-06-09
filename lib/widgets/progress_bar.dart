import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressBar extends StatefulWidget {
  final double percentage;
  final Color color;
  final Color backgroundColor;
  final double fontSize;
  final double barHeight;
  final double barOpacity;
  final double barRadius;

  const ProgressBar(
    this.percentage, {
    this.barOpacity = -1,
    this.color = const Color.fromRGBO(164, 221, 137, 1),
    this.backgroundColor = const Color.fromRGBO(243, 243, 243, 1),
    this.fontSize = 18,
    this.barHeight = 16,
    this.barRadius = 10,
    super.key,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  int _percentage = 0;

  @override
  void initState() {
    _percentage = widget.percentage.floorToDouble().toInt();

    if (_percentage > 100) {
      _percentage = 100;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: widget.barHeight,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barRadius)),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: _percentage,
                    child: Container(
                      height: widget.barHeight,
                      decoration: BoxDecoration(
                        color: (widget.barOpacity == -1)
                            ? widget.color
                            : Color.fromRGBO(164, 221, 137, widget.barOpacity),
                        borderRadius:
                            BorderRadius.all(Radius.circular(widget.barRadius)),
                      ),
                    ),
                  ),
                  Flexible(flex: 100 - _percentage, child: Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewProgressBar extends StatelessWidget {
  final double percentage;
  final Color color;
  final String category;
  final double barOpacity;

  const ReviewProgressBar(
      {required this.percentage,
      required this.color,
      required this.category,
      required this.barOpacity,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProgressBar(
          percentage,
          barHeight: 28,
          barOpacity: barOpacity,
        ),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            SvgPicture.asset(
              "assets/icons/category/cafe.svg",
              width: 20,
              height: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              height: 28,
              alignment: Alignment.centerLeft,
              child: Text(
                "제품이 다양해요", //항목
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                height: 28,
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                child: const Text("26"), //항목 개수
              ),
            )
          ],
        ),
      ],
    );
  }
}
