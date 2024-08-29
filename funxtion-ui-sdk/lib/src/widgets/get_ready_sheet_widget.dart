import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class GetReadySheetWidget extends StatefulWidget {
  const GetReadySheetWidget({
    super.key,
    required this.workoutModel,
    required this.warmUpData,
    required this.trainingData,
    required this.coolDownData,
    required this.fitnessGoalModel,
    required this.equipmentData,
    required this.followTrainingPlanModel,
  });
  final WorkoutModel workoutModel;

  final Map<ExerciseDetailModel, ExerciseModel> warmUpData;
  final Map<ExerciseDetailModel, ExerciseModel> trainingData;
  final Map<ExerciseDetailModel, ExerciseModel> coolDownData;
  final Map<int, String> fitnessGoalModel;
  final List<Map<String, EquipmentModel>> equipmentData;
  final FollowTrainingPlanModel? followTrainingPlanModel;

  @override
  State<GetReadySheetWidget> createState() => _GetReadySheetWidgetState();
}

class _GetReadySheetWidgetState extends State<GetReadySheetWidget> {
  final ValueNotifier<int> durationNotifier = ValueNotifier(0);

  String? getReadytitle;

  Map<ExerciseDetailModel, ExerciseModel> currentListData = {};
  List<Map<String, EquipmentModel>> filterEquipmentData = [];
  initFn(BuildContext context) {
    if (widget.warmUpData.isNotEmpty) {
      getReadytitle = context.loc.phaseTitle("warmUp");

      currentListData = widget.warmUpData;
    } else if (widget.trainingData.isNotEmpty) {
      getReadytitle = context.loc.phaseTitle("training");

      currentListData = widget.trainingData;
    } else {
      getReadytitle = context.loc.phaseTitle("coolDown");

      currentListData = widget.coolDownData;
    }
  }

  @override
  void initState() {
    _filterEquipment();

    super.initState();
  }

  _filterEquipment() {
    for (var e in widget.equipmentData) {
      var exist = filterEquipmentData.firstWhere(
        (element) => element.values.first.id == e.values.first.id,
        orElse: () => {},
      );
      if (exist.isEmpty && e.values.first.id != 1) {
        filterEquipmentData.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundBaseColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 19, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      context.popPage();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 30,
                    )),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      context.loc.workoutText,
                      style: AppTypography.label18LG
                          .copyWith(color: AppColor.textEmphasisColor),
                    )),
                const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, bottom: 20, right: 24, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.getReadyForText,
                          style: AppTypography.label14SM
                              .copyWith(color: AppColor.textSubTitleColor),
                        ),
                        Text(
                          widget.workoutModel.title.toString(),
                          style: AppTypography.title28_2XL
                              .copyWith(color: AppColor.textEmphasisColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 31),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: BuildCardWidget(
                              subtitle: widget.workoutModel.duration.toString(),
                              title: context.loc.durationText),
                        ),
                        20.width(),
                        Expanded(
                            child: BuildCardWidget(
                                title: context.loc.typeText,
                                subtitle: widget
                                    .fitnessGoalModel.entries.first.value))
                      ],
                    ),
                  ),
                  if (filterEquipmentData.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 40),
                      color: AppColor.surfaceBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 12, bottom: 12, right: 16),
                            child: Text(context.loc.whatYouNeedText,
                                style: AppTypography.label14SM.copyWith(
                                    color: AppColor.textPrimaryColor)),
                          ),
                          CustomDividerWidget(
                              dividerColor: AppColor.borderOutlineColor),
                          SizedBox(
                            width: double.infinity,
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, top: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          filterEquipmentData[index]
                                              .values
                                              .first
                                              .name,
                                          style: AppTypography.label16MD
                                              .copyWith(
                                                  color: AppColor
                                                      .textEmphasisColor),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const CustomDividerWidget();
                                },
                                itemCount: filterEquipmentData.length),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: buttonWidget(context),
    );
  }

  Container buttonWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: CustomElevatedButtonWidget(
          radius: 16,
          btnColor: AppColor.buttonPrimaryColor,
          onPressed: () {
            if (widget.warmUpData.isEmpty &&
                widget.trainingData.isNotEmpty &&
                widget.coolDownData.isEmpty) {
              context.navigateTo(StartWorkoutView(
                equipmentData: widget.equipmentData,
                durationNotifier: durationNotifier,
                workoutModel: widget.workoutModel,
                warmUpData: widget.warmUpData,
                trainingData: widget.trainingData,
                coolDownData: widget.coolDownData,
                fitnessGoalModel: widget.fitnessGoalModel,
                followTrainingPlanModel: widget.followTrainingPlanModel,
                cancelTimer: false,
              ));
            } else if (widget.warmUpData.isNotEmpty &&
                widget.trainingData.isEmpty &&
                widget.coolDownData.isEmpty) {
              context.navigateTo(StartWorkoutView(
                equipmentData: widget.equipmentData,
                durationNotifier: durationNotifier,
                workoutModel: widget.workoutModel,
                warmUpData: widget.warmUpData,
                trainingData: widget.trainingData,
                coolDownData: widget.coolDownData,
                fitnessGoalModel: widget.fitnessGoalModel,
                followTrainingPlanModel: widget.followTrainingPlanModel,
                cancelTimer: false,
              ));
            } else if (widget.warmUpData.isEmpty &&
                widget.trainingData.isEmpty &&
                widget.coolDownData.isNotEmpty) {
              context.navigateTo(StartWorkoutView(
                equipmentData: widget.equipmentData,
                durationNotifier: durationNotifier,
                workoutModel: widget.workoutModel,
                warmUpData: widget.warmUpData,
                trainingData: widget.trainingData,
                coolDownData: widget.coolDownData,
                fitnessGoalModel: widget.fitnessGoalModel,
                followTrainingPlanModel: widget.followTrainingPlanModel,
                cancelTimer: false,
              ));
            } else {
              initFn(context);
              durationNotifier.value = 0;
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                backgroundColor: AppColor.surfaceBackgroundColor,
                context: context,
                builder: (context) {
                  return PopScope(
                    canPop: false,
                    child: UpNextSheetWidget(
                      durationNotifier: durationNotifier,
                      equipmentData: widget.equipmentData,
                      fitnessGoalModel: widget.fitnessGoalModel,
                      workoutModel: widget.workoutModel,
                      warmUpData: widget.warmUpData,
                      trainingData: widget.trainingData,
                      coolDownData: widget.coolDownData,
                      title: getReadytitle.toString(),
                      currentListData: currentListData,
                      sliderWarmUp: ValueNotifier(0),
                      sliderTraining: ValueNotifier(0),
                      sliderCoolDown: ValueNotifier(0),
                      coolDownBody: -1,
                      trainingBody: -1,
                      warmupBody: -1,
                      followTrainingPlanModel: widget.followTrainingPlanModel,
                    ),
                  );
                },
              );
            }
          },
          child: Text(
            context.loc.buttonText("letsGo"),
            style: AppTypography.label18LG
                .copyWith(color: AppColor.textInvertEmphasis),
          )),
    );
  }
}
