import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class WorkoutDetailView extends StatefulWidget {
  final String id;

  final FollowTrainingPlanModel? followTrainingPlanModel;

  const WorkoutDetailView({
    super.key,
    required this.id,
    this.followTrainingPlanModel,
  });

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  bool isLoadingNotifier = false;
  bool isNodData = false;
  late ScrollController scrollController;
  WorkoutModel? workoutData;
  Map<int, String> fitnessGoalData = {};
  Map<int, String> categoryFilterTypeData = {};
  List<BodyPartModel> listBodyPartData = [];
  List<Map<String, int>> equipmentIds = [];
  Map<ExerciseDetailModel, ExerciseModel> warmUpData = {};
  Map<ExerciseDetailModel, ExerciseModel> trainingData = {};
  Map<ExerciseDetailModel, ExerciseModel> coolDownData = {};

  ValueNotifier<bool> centerTitle = ValueNotifier(false);
  ValueNotifier<bool> warmUpLoader = ValueNotifier(true);
  ValueNotifier<bool> trainingLoader = ValueNotifier(true);
  ValueNotifier<bool> coolDownLoader = ValueNotifier(true);

  ValueNotifier<bool> warmUpExpand = ValueNotifier(true);

  ValueNotifier<bool> trainingExpand = ValueNotifier(false);
  ValueNotifier<bool> coolDownExpand = ValueNotifier(false);
  ValueNotifier<bool> btnLoader = ValueNotifier(false);

  List<Map<String, EquipmentModel>> equipmentData = [];
  List<Map<String, EquipmentModel>> filterEquipmentData = [];

  Timer? _timer;
  final ValueNotifier<bool> ctExpandWarmUp = ValueNotifier(true);

  final ValueNotifier<bool> crExpandWarmUp = ValueNotifier(true);

  final ValueNotifier<bool> seExpandWarmUp = ValueNotifier(true);

  final ValueNotifier<bool> rftExpandWarmUp = ValueNotifier(true);

  final ValueNotifier<bool> ssExpandWarmUp = ValueNotifier(true);

  final ValueNotifier<bool> amrapExpandWarmUp = ValueNotifier(true);

  final ValueNotifier<bool> emomExpandWarmUp = ValueNotifier(true);
  final ValueNotifier<bool> ctExpandTraining = ValueNotifier(true);

  final ValueNotifier<bool> crExpandTraining = ValueNotifier(true);

  final ValueNotifier<bool> seExpandTraining = ValueNotifier(true);

  final ValueNotifier<bool> rftExpandTraining = ValueNotifier(true);

  final ValueNotifier<bool> ssExpandTraining = ValueNotifier(true);

  final ValueNotifier<bool> amrapExpandTraining = ValueNotifier(true);

  final ValueNotifier<bool> emomExpandTraining = ValueNotifier(true);
  final ValueNotifier<bool> ctExpandCoolDown = ValueNotifier(true);

  final ValueNotifier<bool> crExpandCoolDown = ValueNotifier(true);

  final ValueNotifier<bool> seExpandCoolDown = ValueNotifier(true);

  final ValueNotifier<bool> rftExpandCoolDown = ValueNotifier(true);

  final ValueNotifier<bool> ssExpandCoolDown = ValueNotifier(true);

  final ValueNotifier<bool> amrapExpandCoolDown = ValueNotifier(true);

  final ValueNotifier<bool> emomExpandCoolDown = ValueNotifier(true);

  @override
  void initState() {
    fetchData();

    checkData();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset > 155) {
          centerTitle.value = true;
        } else if (scrollController.offset < 160) {
          centerTitle.value = false;
        }
      });

    super.initState();
  }

  checkData() {
    if (warmUpLoader.value || trainingLoader.value || coolDownLoader.value) {
      _timer = Timer.periodic(const Duration(milliseconds: 800), (_) async {
        if (warmUpLoader.value ||
            trainingLoader.value ||
            coolDownLoader.value) {
          btnLoader.value = true;
        } else {
          btnLoader.value = false;
          _timer?.cancel();
        }
      });
    }
  }

  checkDataWarmUpTraining() {
    if (workoutData?.phases?[0].items?.isEmpty ?? false) {
      warmUpLoader.value = false;
      trainingExpand.value = true;
    }
    if (workoutData?.phases?[1].items?.isEmpty ?? false) {
      trainingLoader.value = false;
      coolDownExpand.value = true;
    }
  }

  fetchData() async {
    isLoadingNotifier = true;
    isNodData = false;

    WorkoutDetailController.getworkoutDataFn(context, id: widget.id)
        .then((value) async {
      if (value != null && context.mounted) {
        isLoadingNotifier = false;
        workoutData = value;

        checkDataWarmUpTraining();
        setState(() {});

        CommonController.filterCategoryTypeData(
            workoutData: workoutData,
            categoryFilterTypeData: categoryFilterTypeData);
        if (workoutData?.phases?[0].items?.isNotEmpty == true) {
          await WorkoutDetailController.getWarmUpDataFn(context,
              warmUpLoader: warmUpLoader,
              warmupData: warmUpData,
              workoutData: workoutData,
              equipmentData: equipmentIds);
        }
        if (workoutData?.goals?.isNotEmpty == true) {
          if (context.mounted) {
            CommonController.getFilterFitnessGoalData(() {
              return;
            },
                filterFitnessGoalData: fitnessGoalData,
                workoutData: workoutData);
          }
        }
        if (workoutData?.bodyParts?.isNotEmpty == true) {
          CommonController.getBodyPartFilterData(
              bodyPartIds: workoutData!.bodyParts!.toSet(),
              filterData: listBodyPartData);
        }

        if (workoutData?.phases?[1].items?.isNotEmpty == true) {
          if (context.mounted) {
            await WorkoutDetailController.getTrainingDataFn(context,
                trainingLoader: trainingLoader,
                workoutData: workoutData,
                trainingData: trainingData,
                equipmentIds: equipmentIds);
          }
        }
        if (workoutData?.phases?[2].items?.isNotEmpty == true) {
          if (context.mounted) {
            await WorkoutDetailController.getCoolDownDataFn(context,
                coolDownLoader: coolDownLoader,
                workoutData: workoutData,
                coolDownData: coolDownData,
                equipmentIds: equipmentIds);
          }
        }
        CommonController.getEquipmentFilterData(
            equipmentIds: equipmentIds, filterEquipmentData: equipmentData);

        _filterEquipment();
        if (workoutData?.phases?[2].items?.isEmpty ?? false) {
          coolDownLoader.value = false;
        }

        if (context.mounted) {
          setState(() {});
        }
      } else {
        isLoadingNotifier = false;
        isNodData = true;
        if (context.mounted) {
          setState(() {});
        }
      }
    });
  }

  _filterEquipment() {
    for (var e in equipmentData) {
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
  void dispose() {
    scrollController.dispose();
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  appBarTitle: "${workoutData?.title}",
                                  backGroundImg:
                                      workoutData?.mapImage?.url.toString() ??
                                          "",
                                  flexibleTitle: "${workoutData?.title}",
                                  flexibleSubtitleWidget: RichText(
                                      text: TextSpan(
                                          style: AppTypography.label16MD
                                              .copyWith(
                                                  color: AppColor
                                                      .textInvertPrimaryColor),
                                          children: [
                                        TextSpan(
                                            text:
                                                "${workoutData?.duration} ${context.loc.minText}"),
                                        value == true
                                            ? WidgetSpan(
                                                child:
                                                    BaseHelper.loadingWidget())
                                            : TextSpan(
                                                text:
                                                    " • ${categoryFilterTypeData.entries.first.value}"),
                                      ])),
                                  onStackChild: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 120,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.9),
                                                Colors.black.withOpacity(0.9),
                                                // Colors.black
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: value,
                                ),
                                if (workoutData?.description?.isNotEmpty ??
                                    true)
                                  DescriptionBoxWidget(
                                    text: workoutData?.description.toString() ??
                                        "",
                                  ),
                                cardBoxWidget(context),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, bottom: 8),
                                    child: Text(
                                      context.loc.workoutOverviewText,
                                      style: AppTypography.title18LG.copyWith(
                                          color: AppColor.textEmphasisColor),
                                    ),
                                  ),
                                ),
                                if (workoutData
                                        ?.phases?.first.items?.isNotEmpty !=
                                    false) ...[
                                  phasesBodyWidget(
                                      title: context.loc.phaseTitle('warmUp'),
                                      expandNotifier: warmUpExpand,
                                      loaderNotifier: warmUpLoader,
                                      dataList: warmUpData,
                                      ctExpand: ctExpandWarmUp,
                                      crExpand: crExpandWarmUp,
                                      seExpand: seExpandWarmUp,
                                      rftExpand: rftExpandWarmUp,
                                      ssExpand: ssExpandWarmUp,
                                      amrapExpand: amrapExpandWarmUp,
                                      emomExpand: emomExpandWarmUp),
                                ],
                                if (workoutData?.phases?[1].items?.isNotEmpty !=
                                    false) ...[
                                  if (workoutData
                                          ?.phases?.first.items?.isNotEmpty !=
                                      false)
                                    const SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: 8,
                                      ),
                                    ),
                                  phasesBodyWidget(
                                      title: context.loc.phaseTitle("training"),
                                      expandNotifier: trainingExpand,
                                      loaderNotifier: trainingLoader,
                                      dataList: trainingData,
                                      ctExpand: ctExpandTraining,
                                      crExpand: crExpandTraining,
                                      seExpand: seExpandTraining,
                                      rftExpand: rftExpandTraining,
                                      ssExpand: ssExpandTraining,
                                      amrapExpand: amrapExpandTraining,
                                      emomExpand: emomExpandTraining),
                                ],
                                if (workoutData?.phases?[2].items?.isNotEmpty !=
                                    false) ...[
                                  if (workoutData
                                              ?.phases?[1].items?.isNotEmpty !=
                                          false ||
                                      workoutData?.phases?.first.items
                                              ?.isNotEmpty !=
                                          false)
                                    const SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: 8,
                                      ),
                                    ),
                                  phasesBodyWidget(
                                      title: context.loc.phaseTitle("coolDown"),
                                      expandNotifier: coolDownExpand,
                                      loaderNotifier: coolDownLoader,
                                      dataList: coolDownData,
                                      ctExpand: ctExpandCoolDown,
                                      crExpand: crExpandCoolDown,
                                      seExpand: seExpandCoolDown,
                                      rftExpand: rftExpandCoolDown,
                                      ssExpand: ssExpandCoolDown,
                                      amrapExpand: amrapExpandCoolDown,
                                      emomExpand: emomExpandCoolDown),
                                ],
                                const SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 8,
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
      bottomNavigationBar: isLoadingNotifier == false && isNodData == false
          ? bottomWidget()
          : null,
    );
  }

  Container bottomWidget() {
    return Container(
      color: AppColor.surfaceBackgroundColor,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 24),
      child: Row(
        children: [
          Expanded(
              child: widget.followTrainingPlanModel == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${workoutData?.title}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.title14XS
                              .copyWith(color: AppColor.textEmphasisColor),
                        ),
                        4.height(),
                        Text("${workoutData?.duration} ${context.loc.minText}",
                            style: AppTypography.paragraph12SM
                                .copyWith(color: AppColor.textPrimaryColor))
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.followTrainingPlanModel?.trainingPlanTitle}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.title14XS
                              .copyWith(color: AppColor.textEmphasisColor),
                        ),
                        4.height(),
                        Text(
                            "${context.loc.workoutText} ${widget.followTrainingPlanModel?.workoutCount}/${widget.followTrainingPlanModel?.totalWorkoutLength} ",
                            style: AppTypography.paragraph12SM
                                .copyWith(color: AppColor.textPrimaryColor))
                      ],
                    )),
          2.width(),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: btnLoader,
                builder: (_, value, child) {
                  return StartWorkoutButtonWidget(
                    onPressed: value == false
                        ? () async {
                            if (widget.followTrainingPlanModel?.outOfSequence ==
                                true) {
                              await showAdaptiveDialog(
                                context: context,
                                builder: (_) {
                                  return ShowAlertDialogWidget(
                                    title: context.loc.alertBoxTitle,
                                    body: context.loc.alertBoxBody,
                                    btnText1: context.loc.alertBoxButton1,
                                    btnText2: context.loc.alertBoxButton2,
                                    color: AppColor.linkPrimaryColor,
                                  );
                                },
                              ).then((value) async {
                                if (value == true) {
                                  await startWorkoutSheet(context);
                                }
                              });
                            } else {
                              await startWorkoutSheet(context);
                            }
                          }
                        : null,
                    btnChild: value == true
                        ? BaseHelper.loadingWidget()
                        : FittedBox(
                            child: Text(
                              context.loc.alertBoxButton2,
                              style: AppTypography.label16MD.copyWith(
                                  color: widget.followTrainingPlanModel
                                              ?.outOfSequence ==
                                          true
                                      ? AppColor.buttonSecondaryColor
                                      : AppColor.textInvertEmphasis),
                            ),
                          ),
                    btnColor:
                        widget.followTrainingPlanModel?.outOfSequence == true
                            ? null
                            : AppColor.buttonPrimaryColor,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<dynamic> startWorkoutSheet(BuildContext context) async {
    return await showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (context) => PopScope(
              canPop: false,
              child: GetReadySheetWidget(
                equipmentData: equipmentData,
                fitnessGoalModel: fitnessGoalData,
                warmUpData: warmUpData,
                trainingData: trainingData,
                workoutModel: workoutData as WorkoutModel,
                coolDownData: coolDownData,
                followTrainingPlanModel: widget.followTrainingPlanModel,
              ),
            ));
  }

  MultiSliver phasesBodyWidget({
    required String title,
    required ValueNotifier<bool> expandNotifier,
    required ValueNotifier<bool> loaderNotifier,
    required Map<ExerciseDetailModel, ExerciseModel> dataList,
    required ValueNotifier<bool> ctExpand,
    required ValueNotifier<bool> crExpand,
    required ValueNotifier<bool> seExpand,
    required ValueNotifier<bool> rftExpand,
    required ValueNotifier<bool> ssExpand,
    required ValueNotifier<bool> amrapExpand,
    required ValueNotifier<bool> emomExpand,
  }) {
    return MultiSliver(pushPinnedChildren: true, children: [
      SliverPinnedHeader(
        child: BuildHeader(
          loaderListenAble: loaderNotifier,
          dataList: dataList,
          title: title,
          expandHeaderValueListenable: expandNotifier,
          onTap: () {
            expandNotifier.value = !expandNotifier.value;
          },
        ),
      ),
      SliverToBoxAdapter(
        child: BuildExercisesBodyWidget(
          currentListData: dataList,
          expandHeaderValueListenable: expandNotifier,
          loaderValueListenable: loaderNotifier,
          ctExpandNew: ctExpand,
          crExpandNew: crExpand,
          seExpandNew: seExpand,
          rftExpandNew: rftExpand,
          amrapExpandNew: amrapExpand,
          ssExpandNew: ssExpand,
          emomExpandNew: emomExpand,
        ),
      ),
    ]);
  }

  SliverToBoxAdapter cardBoxWidget(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 0.2,
        margin: const EdgeInsets.only(left: 25, right: 20, bottom: 40, top: 20),
        color: AppColor.surfaceBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 16),
          child: Column(
            children: [
              if (workoutData?.level.toString() != null)
                CustomRowTextChartIcon(
                  level: workoutData?.level.toString(),
                  text1: context.loc.levelText,
                  text2: workoutData?.level.toString(),
                  isChartIcon: true,
                ),
              ValueListenableBuilder<bool>(
                  valueListenable: coolDownLoader,
                  builder: (context, value, child) {
                    return value == true
                        ? Center(child: BaseHelper.loadingWidget())
                        : equipmentData.isEmpty
                            ? Container()
                            : filterEquipmentData.isNotEmpty
                                ? Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 16, bottom: 16),
                                        child: CustomDividerWidget(),
                                      ),
                                      CustomRowTextChartIcon(
                                          text1: context.loc.equipmentText,
                                          secondWidget: SizedBox(
                                            height: 20,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              itemCount:
                                                  filterEquipmentData.length,
                                              itemBuilder: (context, index) {
                                                if (index == 2) {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                            "+${filterEquipmentData.length - 2}",
                                                            style: AppTypography
                                                                .label14SM
                                                                .copyWith(
                                                              color: AppColor
                                                                  .textPrimaryColor,
                                                            )),
                                                      ),
                                                      2.width(),
                                                      FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              backgroundColor:
                                                                  AppColor
                                                                      .surfaceBackgroundBaseColor,
                                                              useSafeArea: true,
                                                              isScrollControlled:
                                                                  true,
                                                              context: context,
                                                              builder: (context) => EquipmentExtendedSheet(
                                                                  title: workoutData
                                                                          ?.title
                                                                          .toString() ??
                                                                      "",
                                                                  equipmentData:
                                                                      filterEquipmentData),
                                                            );
                                                          },
                                                          child: Transform
                                                              .translate(
                                                            offset:
                                                                const Offset(
                                                                    0, -4),
                                                            child: const Icon(
                                                                Icons
                                                                    .more_horiz),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }
                                                if (index == 1) {
                                                  return SizedBox(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                          ",${filterEquipmentData[index].values.first.name}",
                                                          style: AppTypography
                                                              .label14SM
                                                              .copyWith(
                                                            color: AppColor
                                                                .textPrimaryColor,
                                                          )),
                                                    ),
                                                  );
                                                }
                                                if (index == 0) {
                                                  return SizedBox(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                          filterEquipmentData[
                                                                  index]
                                                              .values
                                                              .first
                                                              .name,
                                                          style: AppTypography
                                                              .label14SM
                                                              .copyWith(
                                                            color: AppColor
                                                                .textPrimaryColor,
                                                          )),
                                                    ),
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                          )),
                                    ],
                                  )
                                : const SizedBox.shrink();
                  }),
              if (fitnessGoalData.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: CustomDividerWidget(),
                ),
                CustomRowTextChartIcon(
                    text1: context.loc.goalText,
                    secondWidget: SizedBox(
                      height: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: fitnessGoalData.entries
                            .toList()[0]
                            .value
                            .split(",")
                            .length,
                        itemBuilder: (context, index) {
                          if (index == 2) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      "+${fitnessGoalData.entries.toList()[0].value.split(",").length - 2}",
                                      style: AppTypography.label14SM.copyWith(
                                        color: AppColor.textPrimaryColor,
                                      )),
                                ),
                                2.width(),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor:
                                            AppColor.surfaceBackgroundBaseColor,
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => GoalExtendedSheet(
                                            title:
                                                workoutData?.title.toString() ??
                                                    "",
                                            goalData: fitnessGoalData.entries
                                                .toList()[0]
                                                .value
                                                .split(",")),
                                      );
                                    },
                                    child: Transform.translate(
                                      offset: const Offset(0, -4),
                                      child: const Icon(Icons.more_horiz),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                          if (index == 1) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                  ",${fitnessGoalData.entries.toList()[0].value.split(",")[index]}",
                                  style: AppTypography.label14SM.copyWith(
                                    color: AppColor.textPrimaryColor,
                                  )),
                            );
                          }
                          if (index == 0) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                  fitnessGoalData.entries
                                      .toList()[0]
                                      .value
                                      .split(",")[index],
                                  style: AppTypography.label14SM.copyWith(
                                    color: AppColor.textPrimaryColor,
                                  )),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )),
              ],
              if (listBodyPartData.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: CustomDividerWidget(),
                ),
                CustomRowTextChartIcon(
                  text1: context.loc.bodyPartText,
                  secondWidget: SizedBox(
                    height: 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: listBodyPartData.length,
                      itemBuilder: (context, index) {
                        if (index == 2) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text("+${listBodyPartData.length - 2}",
                                    style: AppTypography.label14SM.copyWith(
                                      color: AppColor.textPrimaryColor,
                                    )),
                              ),
                              2.width(),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor:
                                          AppColor.surfaceBackgroundBaseColor,
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          BodyPartExtendedSheet(
                                              title: workoutData?.title
                                                      .toString() ??
                                                  "",
                                              bodyPartData: listBodyPartData),
                                    );
                                  },
                                  child: Transform.translate(
                                    offset: const Offset(0, -4),
                                    child: const Icon(Icons.more_horiz),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                        if (index == 1) {
                          return SizedBox(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(",${listBodyPartData[index].name}",
                                  style: AppTypography.label14SM.copyWith(
                                    color: AppColor.textPrimaryColor,
                                  )),
                            ),
                          );
                        }
                        if (index == 0) {
                          return SizedBox(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(listBodyPartData[index].name,
                                  style: AppTypography.label14SM.copyWith(
                                    color: AppColor.textPrimaryColor,
                                  )),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
