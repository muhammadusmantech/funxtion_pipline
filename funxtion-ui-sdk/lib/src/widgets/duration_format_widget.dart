import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class DurationFormatWidget extends StatelessWidget {
  const DurationFormatWidget({
    super.key,
    required this.formatTime, this.color,
  });
  final Color? color;
  final String formatTime;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: formatTime.split('').map((char) {
            return Container(
              width:
                  char == ":" ? 20 : 40, 
              alignment: Alignment.center,
              child: Text(char,
                  style: AppTypography.title60_6XL
                      .copyWith(color: color ?? AppColor.textEmphasisColor)),
            );
          }).toList()),
    );
  }
}