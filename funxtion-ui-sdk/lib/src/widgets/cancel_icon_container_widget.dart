import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class CancelIconContainerWidget extends StatelessWidget {
  final String e;
  final VoidCallback onIconTap;
  bool isActive;

  CancelIconContainerWidget(
      {super.key,
      required this.onIconTap,
      required this.e,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive == true
            ? AppColor.linkTeritaryCOlor
            : AppColor.surfaceBackgroundSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              e.toString(),
              style: AppTypography.label14SM.copyWith(
                  color: isActive == true
                      ? AppColor.textInvertEmphasis
                      : AppColor.textEmphasisColor),
            ),
            InkWell(
                onTap: onIconTap,
                child: isActive == true
                    ? Icon(
                        Icons.close,
                        color: AppColor.textInvertEmphasis,
                      )
                    : const SizedBox.shrink())
          ]),
    );
  }
}