import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class StartWorkoutHeaderWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const StartWorkoutHeaderWidget({
    super.key,
    required this.workoutModel,
    required this.warmUpData,
    required this.trainingData,
    required this.coolDownData,
    required this.sliderWarmUp,
    required this.sliderTraining,
    required this.sliderCoolDown,
    required this.actionWidget,
    required this.durationNotifier,
    required this.closeButton,
    this.isCancel = false,
  });
  final bool isCancel;
  final void Function() closeButton;
  final WorkoutModel workoutModel;
  final Map<ExerciseDetailModel, ExerciseModel> warmUpData;
  final Map<ExerciseDetailModel, ExerciseModel> trainingData;
  final Map<ExerciseDetailModel, ExerciseModel> coolDownData;
  final ValueNotifier<double> sliderWarmUp;
  final ValueNotifier<double> sliderTraining;
  final ValueNotifier<double> sliderCoolDown;
  final ValueNotifier<int> durationNotifier;
  final Widget actionWidget;

  @override
  _StartWorkoutHeaderWidgetState createState() =>
      _StartWorkoutHeaderWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StartWorkoutHeaderWidgetState extends State<StartWorkoutHeaderWidget> {
  Widget _buildSlider(ValueNotifier<double> sliderValue, int division) {
    return Expanded(
      child: ValueListenableBuilder<double>(
        valueListenable: sliderValue,
        builder: (context, value, child) {
          return CustomSliderWidget(
            sliderValue: value,
            division: division,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColor.surfaceBackgroundColor,
      iconTheme: IconThemeData(color: AppColor.surfaceBrandDarkColor),
      elevation: 0,
      backgroundColor: AppColor.surfaceBackgroundColor,
      leading: Container(),
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: widget.durationNotifier,
              builder: (_, value, child) {
                return Text(
                  value.mordernDurationTextWidget,
                  style: AppTypography.label14SM
                      .copyWith(color: AppColor.textPrimaryColor),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.closeButton,
                    child: Icon(Icons.close,
                        color: AppColor.surfaceBrandDarkColor),
                  ),
                  15.width(),
                  if (widget.warmUpData.isNotEmpty) ...[
                    _buildSlider(widget.sliderWarmUp, widget.warmUpData.length),
                    4.width(),
                  ],
                  if (widget.trainingData.isNotEmpty) ...[
                    _buildSlider(
                        widget.sliderTraining, widget.trainingData.length),
                    4.width(),
                  ],
                  if (widget.coolDownData.isNotEmpty) ...[
                    _buildSlider(
                        widget.sliderCoolDown, widget.coolDownData.length),
                    15.width(),
                  ],
                  widget.actionWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
