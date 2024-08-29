import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class TrainingPlanDetailView extends StatefulWidget {
  final String id;

  const TrainingPlanDetailView({
    super.key,
    required this.id,
  });

  @override
  State<TrainingPlanDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<TrainingPlanDetailView> {
  bool isLoadingNotifier = false;
  bool isNodData = false;

  late ScrollController scrollController;

  TrainingPlanModel? trainingPlanData;
  Map<int, String> fitnessGoalData = {};
  FitnessActivityTypeModel? fitnessActivityTypeData;
  ExerciseModel? exerciseData;
  ExerciseModel? exerciseWorkoutData;

  ValueNotifier<int> weekIndex = ValueNotifier(0);
  ValueNotifier<bool> centerTitle = ValueNotifier(false);
  FitnessActivityTypeModel? workoutType;
  List<WorkoutModel> listScheduleWorkoutData = [];
  ValueNotifier<bool> schedulePlanLoader = ValueNotifier(false);
  ValueNotifier<bool> fitnessTypeLoader = ValueNotifier(true);

  FollowTrainingPlanModel? followTrainingData;

  ValueNotifier<bool> typeLoader = ValueNotifier(false);
  Map<int, String> categoryFilterTypeData = {};
  List<LocalWorkout> workoutLocalData = [];

  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset > 90) {
          centerTitle.value = true;
        } else if (scrollController.offset < 105) {
          centerTitle.value = false;
        }
      });

    fetchData();

    super.initState();
  }

  fetchData() async {
    isLoadingNotifier = true;
    isNodData = false;

    TrainingPlanDetailController.getATrainingPlanDataFn(context, id: widget.id)
        .then((data) async {
      if (data != null && context.mounted) {
        isLoadingNotifier = false;
        trainingPlanData = data;

        CommonController.getFilterFitnessGoalData(() {
          return;
        }, trainingData: data, filterFitnessGoalData: fitnessGoalData);
        setState(() {});
        if (trainingPlanData!.weeks!.isNotEmpty) {
          TrainingPlanDetailController.schedulePlanFn(context,
              listScheduleWorkoutData: listScheduleWorkoutData,
              schedulePlanLoader: schedulePlanLoader,
              trainingPlanData: trainingPlanData,
              categoryFilterTypeData: categoryFilterTypeData,
              weekIndex: weekIndex);
        }
      } else if (context.mounted) {
        setState(() {
          isLoadingNotifier = false;
          isNodData = true;
        });
      }
    });
  }

  void addWorkoutData(List<WorkoutModel> workoutListData) {
    for (var i = 0; i < workoutListData.length; i++) {
      workoutLocalData.add(LocalWorkout(
          workoutTitle: workoutListData[i].title.toString(),
          workoutSubtitle:
              "${workoutListData[i].duration} • ${workoutListData[i]} • ${workoutListData[i].level.toString()}",
          workoutId: workoutListData[i].id.toString(),
          workoutImg: workoutListData[i].mapImage?.url ?? ""));
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  checkIsFollowed(Box<FollowTrainingPlanModel> box) {
    if (box.isNotEmpty) {
      for (var element in box.values.toList()) {
        if (element.trainingPlanId == trainingPlanData?.id) {
          followTrainingData = element;
        }
      }
    } else {
      followTrainingData = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FollowTrainingPlanModel>>(
        valueListenable: Boxes.getTrainingPlanBox().listenable(),
        builder: (_, box, child) {
          checkIsFollowed(box);

          return Scaffold(
            backgroundColor: AppColor.surfaceBackgroundBaseColor,
            body: isLoadingNotifier == true
                ? const LoaderStackWidget()
                : isNodData == true
                    ? const Center(child: CustomErrorWidget())
                    : Column(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: centerTitle,
                                builder: (_, value, child) {
                                  return CustomScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    controller: scrollController,
                                    slivers: [
                                      SliverAppBarWidget(
                                        value: value,
                                        appBarTitle:
                                            "${trainingPlanData?.title}",
                                        flexibleTitle:
                                            "${trainingPlanData?.title}",
                                        onStackChild:Stack(
                                      children: [

                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 100,
                                          width: double.maxFinite,

                                          decoration:  BoxDecoration(
                                            // color: Colors.blue,
                                            gradient: LinearGradient(

                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.9),Colors.black.withOpacity(0.9),
                                                // Colors.black
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                        flexibleSubtitleWidget: Row(
                                          children: [
                                            ValueListenableBuilder(
                                                valueListenable:
                                                    schedulePlanLoader,
                                                builder: (_, value, child) {
                                                  return value == true
                                                      ? SizedBox(
                                                          height: 12,
                                                          width: 12,
                                                          child: BaseHelper
                                                              .loadingWidget(),
                                                        )
                                                      : Text(
                                                          '${listScheduleWorkoutData.length} ${context.loc.workoutPluraText(listScheduleWorkoutData.length)}',
                                                          style: AppTypography
                                                              .label16MD
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .textInvertPrimaryColor),
                                                        );
                                                }),
                                            Text(
                                              " • ${fitnessGoalData.entries.first.value}",
                                              style: AppTypography.label16MD
                                                  .copyWith(
                                                      color: AppColor
                                                          .textInvertPrimaryColor),
                                            ),
                                            Text(
                                              " • ${trainingPlanData?.level.toString()}",
                                              style: AppTypography.label16MD
                                                  .copyWith(
                                                      color: AppColor
                                                          .textInvertPrimaryColor),
                                            )
                                          ],
                                        ),
                                        backGroundImg: trainingPlanData
                                                ?.mapImage?.url
                                                .toString() ??
                                            "",
                                        isFollowingPlan:
                                            followTrainingData == null
                                                ? false
                                                : true,
                                        bottomWidget: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${followTrainingData?.workoutCount}/${followTrainingData?.totalWorkoutLength}",
                                              style: AppTypography.label16MD
                                                  .copyWith(
                                                      color: AppColor
                                                          .textInvertPrimaryColor),
                                            ),
                                            4.height(),
                                            if (followTrainingData
                                                    ?.workoutCount !=
                                                followTrainingData
                                                    ?.totalWorkoutLength)
                                              FollowedBorderWidget(
                                                  followTrainingData:
                                                      followTrainingData),
                                          ],
                                        ),
                                      ),
                                      DescriptionBoxWidget(
                                          text: trainingPlanData?.description
                                                  .toString() ??
                                              ""),
                                      cardBoxWidget(),
                                      SliverToBoxAdapter(
                                          child: ValueListenableBuilder(
                                        valueListenable: schedulePlanLoader,
                                        builder: (_, value, child) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              schedulHeadingWidget(),
                                              scheduleCardBoxWidget(
                                                  context, box, value),
                                            ],
                                          );
                                        },
                                      )),
                                      if (followTrainingData != null)
                                        SliverPadding(
                                          padding: const EdgeInsets.all(20),
                                          sliver: SliverToBoxAdapter(
                                            child: Card(
                                              elevation: 0.2,
                                              color: AppColor
                                                  .surfaceBackgroundColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              child: InkWell(
                                                onTap: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return ShowAlertDialogWidget(
                                                        body: context
                                                            .loc.alertBoxBody3,
                                                        btnText1: context.loc
                                                            .alertBoxButton1,
                                                        btnText2: context.loc
                                                            .alertBox3Button2,
                                                        title: context
                                                            .loc.alertBoxTitle3,
                                                      );
                                                    },
                                                  ).then((value) {
                                                    if (value == true) {
                                                      if (EveentTriggered
                                                              .plan_cancelled !=
                                                          null) {
                                                        EveentTriggered
                                                                .plan_cancelled!(
                                                            followTrainingData!
                                                                .trainingPlanTitle,
                                                            followTrainingData!
                                                                .trainingPlanId,
                                                            followTrainingData!
                                                                .workoutCount,
                                                            followTrainingData!
                                                                .totalWorkoutLength);
                                                      }

                                                      followTrainingData
                                                          ?.delete();
                                                      followTrainingData = null;
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        context.loc
                                                            .unFollowTrainingPlanText,
                                                        style: AppTypography
                                                            .label16MD
                                                            .copyWith(
                                                                color: AppColor
                                                                    .textEmphasisColor),
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
                                                        size: 30,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
            bottomNavigationBar:
                isLoadingNotifier == false && isNodData == false
                    ? bottomWidget(box)
                    : null,
          );
        });
  }

  schedulHeadingWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 35, left: 20),
      child: Text(
        context.loc.scheduleText,
        style:
            AppTypography.title18LG.copyWith(color: AppColor.textEmphasisColor),
      ),
    );
  }

  Container bottomWidget(Box<FollowTrainingPlanModel> box) {
    return Container(
      color: AppColor.surfaceBackgroundColor,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: box.values.any((element) =>
                      element.trainingPlanId == trainingPlanData?.id)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (followTrainingData?.workoutCount !=
                            followTrainingData?.totalWorkoutLength) ...[
                          Text(
                            context.loc.nextUp,
                            style: AppTypography.paragraph12SM
                                .copyWith(color: AppColor.textPrimaryColor),
                          ),
                          2.height(),
                          Text(
                              "${followTrainingData?.workoutData[followTrainingData!.workoutCount].workoutTitle.toString()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.title14XS
                                  .copyWith(color: AppColor.textEmphasisColor))
                        ]
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${trainingPlanData?.title}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.title14XS
                              .copyWith(color: AppColor.textEmphasisColor),
                        ),
                        2.height(),
                        ValueListenableBuilder(
                            valueListenable: schedulePlanLoader,
                            builder: (_, value, child) {
                              return value == true
                                  ? SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: BaseHelper.loadingWidget(),
                                    )
                                  : Text(
                                      '${listScheduleWorkoutData.length} ${listScheduleWorkoutData.length > 1 ? "workouts" : "workout"}',
                                      style: AppTypography.paragraph12SM
                                          .copyWith(
                                              color:
                                                  AppColor.textPrimaryColor));
                            }),
                      ],
                    )),
          2.width(),
          Expanded(
              child: ValueListenableBuilder<bool>(
                  valueListenable: schedulePlanLoader,
                  builder: (_, value, child) {
                    return box.values.any((element) =>
                            element.trainingPlanId == trainingPlanData?.id)
                        ? ScheduletButtonWidget(
                            text: followTrainingData?.workoutCount ==
                                    followTrainingData?.totalWorkoutLength
                                ? context.loc.doneText
                                : context.loc.buttonText('nextWorkout'),
                            onPressed: value == true
                                ? null
                                : () {
                                    if (followTrainingData?.workoutCount ==
                                        followTrainingData
                                            ?.totalWorkoutLength) {
                                      for (var i = 0;
                                          i < Boxes.getTrainingPlanBox().length;
                                          i++) {
                                        if (Boxes.getTrainingPlanBox()
                                                .values
                                                .toList()[i]
                                                .trainingPlanId ==
                                            followTrainingData!
                                                .trainingPlanId) {
                                          Boxes.getTrainingPlanBox()
                                              .deleteAt(i);
                                          context.popPage();
                                        }
                                      }
                                    } else {
                                      if (workoutLocalData.isEmpty) {
                                        addWorkoutData(listScheduleWorkoutData);
                                      }
                                      int nextIndex =
                                          followTrainingData!.workoutCount + 1;

                                      context.navigateTo(WorkoutDetailView(
                                          id: followTrainingData
                                                  ?.workoutData[
                                                      followTrainingData!
                                                          .workoutCount]
                                                  .workoutId ??
                                              '',
                                          followTrainingPlanModel:
                                              FollowTrainingPlanModel(
                                            trainingPlanId: followTrainingData!
                                                .trainingPlanId,
                                            workoutData: workoutLocalData,
                                            workoutCount: nextIndex,
                                            totalWorkoutLength:
                                                followTrainingData!
                                                    .totalWorkoutLength,
                                            outOfSequence: false,
                                            trainingPlanImg: followTrainingData!
                                                .trainingPlanImg,
                                            trainingPlanTitle:
                                                followTrainingData!
                                                    .trainingPlanTitle,
                                          )));
                                    }
                                  },
                            child: value == true
                                ? BaseHelper.loadingWidget()
                                : null)
                        : ScheduletButtonWidget(
                            text: context.loc.buttonText("startFollow"),
                            onPressed: value == true
                                ? null
                                : () async {
                                    if (EveentTriggered.plan_followed != null) {
                                      EveentTriggered.plan_followed!(
                                          trainingPlanData!.title,
                                          trainingPlanData!.id);
                                    }
                                    if (workoutLocalData.isEmpty) {
                                      addWorkoutData(listScheduleWorkoutData);
                                    }
                                    final data = FollowTrainingPlanModel(
                                        outOfSequence: false,
                                        trainingPlanImg:
                                            trainingPlanData?.mapImage?.url ??
                                                "",
                                        trainingPlanTitle:
                                            trainingPlanData!.title,
                                        trainingPlanId: trainingPlanData!.id,
                                        workoutData: workoutLocalData,
                                        totalWorkoutLength:
                                            listScheduleWorkoutData.length,
                                        workoutCount: 0);
                                    box.add(data);
                                  },
                            child: value == true
                                ? BaseHelper.loadingWidget()
                                : null);
                  }))
        ],
      ),
    );
  }

  scheduleCardBoxWidget(BuildContext context, Box<FollowTrainingPlanModel> box,
      bool schedulePlanLoader) {
    return Card(
        elevation: 0.2,
        color: AppColor.surfaceBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: schedulePlanLoader == true
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: BaseHelper.loadingWidget(),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    box.values.any((element) =>
                                element.trainingPlanId ==
                                trainingPlanData?.id) ==
                            false
                        ? Container()
                        : SizedBox(
                            width: 25,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 46),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listScheduleWorkoutData.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    StepWidget(
                                        isCompleted: box.values.any((element) =>
                                                    element.trainingPlanId ==
                                                        trainingPlanData?.id &&
                                                    index <=
                                                        element.workoutCount -
                                                            1.toInt()) ==
                                                true
                                            ? true
                                            : false,
                                        isActive: box.values.any((element) =>
                                                    element.trainingPlanId ==
                                                        trainingPlanData?.id &&
                                                    index ==
                                                        element.workoutCount
                                                            .toInt()) ==
                                                true
                                            ? true
                                            : false),
                                    if (index !=
                                        listScheduleWorkoutData.length - 1)
                                      LineWidget(
                                        height: 78,
                                        color: box.values.any((element) =>
                                                element.trainingPlanId ==
                                                    trainingPlanData?.id &&
                                                index <=
                                                    element.workoutCount -
                                                        1.toInt())
                                            ? AppColor.surfaceBrandDarkColor
                                            : null,
                                      )
                                  ],
                                );
                              },
                            ),
                          ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(left: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listScheduleWorkoutData.length,
                          itemBuilder: (context, index) {
                            WorkoutModel? data = listScheduleWorkoutData[index];

                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: CustomListTileWidget(
                                  imageHeaderIcon: AppAssets.workoutHeaderIcon,
                                  imageUrl: data.mapImage?.url.toString() ?? data.image ?? "",
                                  title: data.title ?? "",
                                  subtitle:
                                      " ${data.duration} • ${categoryFilterTypeData[index]} • ${data.level.toString()}",
                                  onTap: () {
                                    if (followTrainingData != null) {
                                      if (workoutLocalData.isEmpty) {
                                        addWorkoutData(listScheduleWorkoutData);
                                      }
                                      if (followTrainingData!.workoutCount ==
                                          index) {
                                        context.navigateTo(WorkoutDetailView(
                                            id: listScheduleWorkoutData[index]
                                                .id
                                                .toString(),
                                            followTrainingPlanModel:
                                                FollowTrainingPlanModel(
                                              workoutData: workoutLocalData,
                                              trainingPlanId:
                                                  followTrainingData!
                                                      .trainingPlanId,
                                              workoutCount: followTrainingData!
                                                      .workoutCount +
                                                  1,
                                              totalWorkoutLength:
                                                  followTrainingData!
                                                      .totalWorkoutLength,
                                              outOfSequence: false,
                                              trainingPlanImg:
                                                  followTrainingData!
                                                      .trainingPlanImg,
                                              trainingPlanTitle:
                                                  followTrainingData!
                                                      .trainingPlanTitle,
                                            )));
                                      } else if (followTrainingData!
                                              .workoutCount
                                              .toInt() >=
                                          index) {
                                        context.navigateTo(WorkoutDetailView(
                                            id: listScheduleWorkoutData[index]
                                                .id
                                                .toString(),
                                            followTrainingPlanModel:
                                                FollowTrainingPlanModel(
                                              trainingPlanId:
                                                  followTrainingData!
                                                      .trainingPlanId,
                                              workoutData: workoutLocalData,
                                              workoutCount: index + 1,
                                              totalWorkoutLength:
                                                  followTrainingData!
                                                      .totalWorkoutLength,
                                              outOfSequence: false,
                                              trainingPlanImg:
                                                  followTrainingData!
                                                      .trainingPlanImg,
                                              trainingPlanTitle:
                                                  followTrainingData!
                                                      .trainingPlanTitle,
                                            )));
                                      } else {
                                        context.navigateTo(WorkoutDetailView(
                                            id: listScheduleWorkoutData[index]
                                                .id
                                                .toString(),
                                            followTrainingPlanModel:
                                                FollowTrainingPlanModel(
                                              workoutData: workoutLocalData,
                                              trainingPlanId:
                                                  followTrainingData!
                                                      .trainingPlanId,
                                              workoutCount: index + 1,
                                              totalWorkoutLength:
                                                  followTrainingData!
                                                      .totalWorkoutLength,
                                              outOfSequence: true,
                                              trainingPlanImg:
                                                  followTrainingData!
                                                      .trainingPlanImg,
                                              trainingPlanTitle:
                                                  followTrainingData!
                                                      .trainingPlanTitle,
                                            )));
                                      }
                                    } else {
                                      context.navigateTo(WorkoutDetailView(
                                        id: listScheduleWorkoutData[index]
                                            .id
                                            .toString(),
                                      ));
                                    }
                                  }),
                            );
                          }),
                    ),
                  ],
                ),
        ));
  }

  SliverToBoxAdapter cardBoxWidget() {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        color: AppColor.surfaceBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 16),
          child: Column(
            children: [
              if (fitnessGoalData.isNotEmpty)
                CustomRowTextChartIcon(
                    text1: context.loc.goalText,
                    text2: fitnessGoalData.entries.first.value),
              if (trainingPlanData != null) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: CustomDividerWidget(),
                ),
                CustomRowTextChartIcon(
                  level: trainingPlanData?.level.toString() ?? "",
                  text1: context.loc.levelText,
                  text2: trainingPlanData?.level.toString() ?? "",
                  isChartIcon: true,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class FollowedBorderWidget extends StatelessWidget {
  const FollowedBorderWidget(
      {super.key, required this.followTrainingData, this.color, this.color2});

  final FollowTrainingPlanModel? followTrainingData;
  final Color? color, color2;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
      followTrainingData?.totalWorkoutLength ?? 0,
      (index) => Flexible(
        child: Container(
          height: 6,
          margin: const EdgeInsets.only(left: 2, right: 2),
          decoration: BoxDecoration(
              color: index + 1 <= followTrainingData!.workoutCount.toInt()
                  ? color ?? AppColor.textInvertEmphasis
                  : color2 ?? AppColor.surfaceBrandSecondaryColor,
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ));
  }
}
