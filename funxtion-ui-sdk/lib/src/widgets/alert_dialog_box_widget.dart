import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ShowAlertDialogWidget extends StatelessWidget {
  final String title, body, btnText1, btnText2;
  final Color? color;

  const ShowAlertDialogWidget(
      {super.key,
      required this.title,
      required this.body,
      required this.btnText1,
      required this.btnText2,
      this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: AppColor.surfaceBackgroundColor,
      elevation: 10,
      titleTextStyle: AppTypography.label18LG
          .copyWith(fontSize: 17, color: AppColor.textEmphasisColor),
      title: Text(title),
      content: Text(
        body,
        style: AppTypography.paragraph12SM
            .copyWith(fontSize: 13)
            .copyWith(color: AppColor.textEmphasisColor),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 10),
      actions: [
        TextButton(
          child: FittedBox(
            child: Text(
              btnText1,
              style: AppTypography.paragraph18XL
                  .copyWith(fontSize: 17, color: AppColor.linkPrimaryColor),
            ),
          ),
          onPressed: () {
            context.popPage(result: false);
          },
        ),
        TextButton(
          child: FittedBox(
            child: Text(btnText2,
                style: AppTypography.label18LG
                    .copyWith(fontSize: 17, color: color ?? AppColor.redColor)),
          ),
          onPressed: () {
            context.popPage(result: true);
            WakelockPlus.disable();
          },
        ),
      ],
    );
  }
}
