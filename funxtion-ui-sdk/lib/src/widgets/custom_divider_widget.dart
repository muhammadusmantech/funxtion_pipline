import 'package:flutter/material.dart';
import 'package:ui_tool_kit/src/utils/utils.dart';

class CustomDividerWidget extends StatelessWidget {
  final double? endIndent, indent, thickness;
  final Color? dividerColor;

  const CustomDividerWidget(
      {super.key,
      this.endIndent,
      this.indent,
      this.thickness,
      this.dividerColor});

  @override
  Widget build(BuildContext context) {
    return Divider(
        color: dividerColor ?? AppColor.borderSecondaryColor,
        thickness: thickness ?? 1.5,
        endIndent: endIndent,
        height: 0,
        indent: indent);
  }
}
