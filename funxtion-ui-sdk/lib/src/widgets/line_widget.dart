import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class LineWidget extends StatelessWidget {
  final double height;
  final Color? color;
  const LineWidget({super.key, this.height = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 2,
          height: height,
          color: color ?? AppColor.borderSecondaryColor),
    );
  }
}
