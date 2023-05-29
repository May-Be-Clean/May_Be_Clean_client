import 'package:flutter/material.dart';

class WeecanProgressBar extends StatefulWidget {
  final double percentage;
  final Color color;
  final Color backgroundColor;
  final double fontSize;
  final double barHeight;
  final double barOpacity;
  final double barRadius;

  const WeecanProgressBar(
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
  State<WeecanProgressBar> createState() => _WeecanProgressBarState();
}

class _WeecanProgressBarState extends State<WeecanProgressBar> {
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
          // const SizedBox(width: 10),
          // Text(
          //   "${_percentage.toString()}%",
          //   style: TextStyle(
          //     fontSize: widget.fontSize,
          //     color: widget.color,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }
}
