import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui_tool_kit.dart';

class ItemTypeTitleRowWidget extends StatelessWidget {
  final String itemTypeTitle;
  final ValueNotifier<bool> isPlaying;
  final WorkoutModel workoutModel;
  const ItemTypeTitleRowWidget(
      {super.key, required this.itemTypeTitle, required this.isPlaying, required this.workoutModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(itemTypeTitle,
            style: AppTypography.title14XS.copyWith(
              color: AppColor.textPrimaryColor,
            )),
        4.width(),
        InkWell(
            onTap: () async {
              isPlaying.value = false;
              if (EveentTriggered.workout_player_type_info != null) {
                EveentTriggered.workout_player_type_info!(
                    itemTypeTitle,
                    workoutModel.title.toString(),
                    workoutModel.id.toString());
              }
              await showModalBottomSheet(
                backgroundColor: AppColor.surfaceBackgroundColor,
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => PopScope(
                  onPopInvoked: (didPop) {
                    isPlaying.value = true;
                  },
                  child: HeaderExerciseInfoSheet(
                    title: itemTypeTitle,
                  ),
                ),
              );
            },
            child: SvgPicture.asset(
              AppAssets.infoIcon,
              color: AppColor.textPrimaryColor,
            ))
      ],
    );
  }
}
