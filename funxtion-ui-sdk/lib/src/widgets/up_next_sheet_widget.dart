import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class UpNextSheetWidget extends StatefulWidget {
  const UpNextSheetWidget({
    super.key,
    required this.workoutModel,
    required this.warmUpData,
    required this.trainingData,
    required this.coolDownData,
    required this.fitnessGoalModel,
    this.isFromNext,
    required this.equipmentData,
    required this.durationNotifier,
    required this.title,
    required this.currentListData,
    required this.sliderWarmUp,
    required this.sliderTraining,
    required this.sliderCoolDown,
    required this.coolDownBody,
    required this.trainingBody,
    required this.warmupBody,
    required this.followTrainingPlanModel,
  });
  final WorkoutModel workoutModel;

  final Map<ExerciseDetailModel, ExerciseModel> warmUpData;
  final Map<ExerciseDetailModel, ExerciseModel> trainingData;
  final Map<ExerciseDetailModel, ExerciseModel> coolDownData;
  final Map<int, String> fitnessGoalModel;
  final List<Map<String, EquipmentModel>> equipmentData;
  final ValueNotifier<int> durationNotifier;
  final ValueNotifier<double> sliderWarmUp;
  final ValueNotifier<double> sliderTraining;
  final ValueNotifier<double> sliderCoolDown;
  final int coolDownBody;
  final int trainingBody;
  final int warmupBody;
  final bool? isFromNext;

  final String title;
  final Map<ExerciseDetailModel, ExerciseModel> currentListData;
  final FollowTrainingPlanModel? followTrainingPlanModel;

  @override
  State<UpNextSheetWidget> createState() => _UpNextSheetWidgetState();
}

class _UpNextSheetWidgetState extends State<UpNextSheetWidget> {
  List<Map<String, EquipmentModel>> filterEquipmentData = [];
  ValueNotifier<bool> expand = ValueNotifier(true);

  final ValueNotifier<bool> ctExpand = ValueNotifier(true);

  final ValueNotifier<bool> crExpand = ValueNotifier(true);

  final ValueNotifier<bool> seExpand = ValueNotifier(true);

  final ValueNotifier<bool> rftExpand = ValueNotifier(true);

  final ValueNotifier<bool> ssExpand = ValueNotifier(true);

  final ValueNotifier<bool> amrapExpand = ValueNotifier(true);

  final ValueNotifier<bool> emomExpand = ValueNotifier(true);

  Timer? newTimer;
  @override
  void initState() {
    _startTimer();
    _filterEquipmentFn();

    super.initState();
  }

  _filterEquipmentFn() {
    for (var element in widget.equipmentData) {
      String formatElement = element.keys.first.toLowerCase().trim();
      String formatTitle = widget.title.toLowerCase().replaceAll(" ", '');
      if (formatElement.contains(formatTitle) && element.values.first.id != 1) {
        filterEquipmentData.add({"": element.values.first});
      }
    }
  }

  void _startTimer() {
    if (newTimer == null && widget.durationNotifier.value == 0) {
      newTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        widget.durationNotifier.value += 1;
      });
    }
  }

  void _cancelTimer() {
    newTimer?.cancel();
    newTimer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundBaseColor,
      appBar: StartWorkoutHeaderWidget(
        warmUpData: widget.warmUpData,
        coolDownData: widget.coolDownData,
        trainingData: widget.trainingData,
        workoutModel: widget.workoutModel,
        durationNotifier: widget.durationNotifier,
        sliderWarmUp: widget.sliderWarmUp,
        sliderTraining: widget.sliderTraining,
        sliderCoolDown: widget.sliderCoolDown,
        actionWidget: InkWell(
            onTap: () async {
              await showModalBottomSheet(
                backgroundColor: AppColor.surfaceBackgroundBaseColor,
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => OverviewBottomSheet(
                  warmUpData: widget.warmUpData,
                  coolDownData: widget.coolDownData,
                  trainingData: widget.trainingData,
                  workoutModel: widget.workoutModel,
                  coolDownBody: widget.coolDownBody,
                  trainingBody: widget.trainingBody,
                  warmupBody: widget.warmupBody,
                  currentRound: 0,
                ),
              );
            },
            child: SvgPicture.asset(AppAssets.exploreIcon)),
        closeButton: () {
          context.popPage();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 40),
              child: Text(context.loc.upNext,
                  style: AppTypography.label14SM
                      .copyWith(color: AppColor.textSubTitleColor)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                widget.title.toString(),
                style: AppTypography.title28_2XL,
              ),
            ),
            if (filterEquipmentData.isNotEmpty)
              Card(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 0),
                color: AppColor.surfaceBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                      child: Text(context.loc.equipmentText,
                          style: AppTypography.label14SM
                              .copyWith(color: AppColor.textPrimaryColor)),
                    ),
                    const CustomDividerWidget(),
                    ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  filterEquipmentData[index].values.first.name,
                                  style: AppTypography.label16MD.copyWith(
                                      color: AppColor.textEmphasisColor),
                                ),
                                12.width(),
                                Text(
                                  '',
                                  style: AppTypography.paragraph14MD.copyWith(
                                      color: AppColor.textPrimaryColor),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const CustomDividerWidget();
                        },
                        itemCount: filterEquipmentData.length)
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  BuildExercisesBodyWidget(
                    currentListData: widget.currentListData,
                    expandHeaderValueListenable: expand,
                    loaderValueListenable: ValueNotifier(false),
                    ctExpandNew: ctExpand,
                    crExpandNew: crExpand,
                    seExpandNew: seExpand,
                    rftExpandNew: rftExpand,
                    ssExpandNew: ssExpand,
                    emomExpandNew: emomExpand,
                    amrapExpandNew: amrapExpand,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
        child: Row(
          children: [
            Expanded(
                child: SizedBox(
              height: 50,
              child: CustomElevatedButtonWidget(
                  btnColor: AppColor.surfaceBackgroundSecondaryColor,
                  onPressed: () {
                    if (widget.isFromNext == true) {
                      context.popPage(result: false);
                    }
                  },
                  child: Text(context.loc.buttonText("previous"),
                      style: AppTypography.label16MD
                          .copyWith(color: AppColor.textSubTitleColor))),
            )),
            16.width(),
            Expanded(
                child: SizedBox(
              height: 50,
              child: CustomElevatedButtonWidget(
                  onPressed: () {
                    widget.isFromNext == true
                        ? context.popPage(result: true)
                        : context.navigateTo(StartWorkoutView(
                            equipmentData: widget.equipmentData,
                            durationNotifier: widget.durationNotifier,
                            workoutModel: widget.workoutModel,
                            warmUpData: widget.warmUpData,
                            trainingData: widget.trainingData,
                            coolDownData: widget.coolDownData,
                            fitnessGoalModel: widget.fitnessGoalModel,
                            followTrainingPlanModel:
                                widget.followTrainingPlanModel,
                            cancelTimer: true,
                          ));
                  },
                  child: Text(context.loc.buttonText('letsGo'),
                      style: AppTypography.label16MD
                          .copyWith(color: AppColor.textInvertEmphasis))),
            ))
          ],
        ),
      ),
    );
  }
}
