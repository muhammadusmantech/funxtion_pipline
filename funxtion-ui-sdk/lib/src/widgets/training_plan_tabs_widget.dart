import 'package:flutter/widgets.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../ui_tool_kit.dart';

class FirstTabWidget extends StatefulWidget {
  final List<FollowTrainingPlanModel>? followTrainingData;
  final TextEditingController searchControllerPage1;
  final void Function() requestCall;
  final void Function(String) searchDelayFn;
  final bool nextPage;
  final bool showCloseIcon;
  final bool isLoadingNotifier;
  final bool isLoadMore;
  final bool isNodData;
  final List<TrainingPlanModel> listTrainingPlanData;
  final ValueNotifier<List<SelectedFilterModel>> confirmedFilter;
  final ScrollController scrollControllerPage1;
  final Map<int, String> fitnessGoalData;

  FirstTabWidget({
    super.key,
    this.followTrainingData,
    required this.searchControllerPage1,
    required this.confirmedFilter,
    required this.requestCall,
    required this.isLoadMore,
    required this.isLoadingNotifier,
    required this.isNodData,
    required this.listTrainingPlanData,
    required this.nextPage,
    required this.scrollControllerPage1,
    required this.showCloseIcon,
    required this.searchDelayFn,
    required this.fitnessGoalData,
  });

  @override
  State<FirstTabWidget> createState() => _FirstTabWidgetState();
}

class _FirstTabWidgetState extends State<FirstTabWidget> {
  bool isShowFilter = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
            color: AppColor.surfaceBackgroundColor,
            child: BottomSearchWidget(
              searchController: widget.searchControllerPage1,
              searchDelayFn: widget.searchDelayFn,
              requestCall: widget.requestCall,
              confirmedFilter: widget.confirmedFilter,
              categoryName: CategoryName.trainingPlans,
              hideFilterFn: () {
                isShowFilter = false;
              },
            )),
        1.height(),
        Expanded(
          child: Stack(
            children: [
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: widget.confirmedFilter,
                      builder: (context, value, child) {
                        return FilterRowWidget(
                          confirmedFilter: widget.confirmedFilter,
                          deleteAFilterOnTap: (e) {
                            ListController.deleteAFilterFn(
                                context,
                                e.filterName.toString(),
                                widget.confirmedFilter);
                            widget.requestCall();
                          },
                          hideOnTap: () {
                            isShowFilter = false;
                            setState(() {});
                          },
                          showOnTap: () {
                            isShowFilter = true;
                            setState(() {});
                          },
                          clearOnTap: () {
                            ListController.clearAppliedFilterFn(
                              widget.confirmedFilter,
                            );
                            isShowFilter = false;
                            widget.requestCall();
                          },
                          isShowFilter: isShowFilter,
                        );
                      },
                    ),
                    if (widget.isLoadingNotifier == false)
                      widget.isNodData == true
                          ? const CustomErrorWidget()
                          : widget.listTrainingPlanData.isEmpty
                              ? const NoResultFoundWidget()
                              : Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.textInvertEmphasis,
                                    ),
                                    child: ListView.separated(
                                        key: widget.key,
                                        controller:
                                            widget.scrollControllerPage1,
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 20,
                                            right: 20,
                                            bottom: 20),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              CustomListTileWidget(
                                                  onTap: () {
                                                    context.hideKeypad();
                                                    context.navigateTo(
                                                        TrainingPlanDetailView(
                                                            id: widget
                                                                .listTrainingPlanData[
                                                                    index]
                                                                .id));
                                                  },
                                                  imageHeaderIcon:
                                                      AppAssets.calendarIcon,
                                                  imageUrl: widget.listTrainingPlanData[index].image
                                                      .toString(),
                                                  onSubtitleWidget: widget
                                                          .followTrainingData!
                                                          .any((element) =>
                                                              element.trainingPlanId ==
                                                              widget
                                                                  .listTrainingPlanData[

                                                                      index]
                                                                  .id)
                                                      ? FollowSubTitleWidget(
                                                          followTrainingData: widget
                                                              .followTrainingData!
                                                              .elementAt(widget
                                                                  .followTrainingData!
                                                                  .indexWhere((element) =>
                                                                      element.trainingPlanId ==
                                                                      widget
                                                                          .listTrainingPlanData[index]
                                                                          .id)))
                                                      : Text(
                                                          "${widget.listTrainingPlanData[index].daysTotal} workouts • ${widget.fitnessGoalData.entries.toList()[index].value} • ${widget.listTrainingPlanData[index].level}",
                                                          style: AppTypography
                                                              .paragraph14MD
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .textPrimaryColor),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                  title: widget.listTrainingPlanData[index].title.toString()),
                                              if (index ==
                                                      widget.listTrainingPlanData
                                                              .length -
                                                          1 &&
                                                  widget.nextPage == false)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0)
                                                          .copyWith(top: 12),
                                                  child: Text(
                                                    "Nothing to load",
                                                    style:
                                                        AppTypography.label14SM,
                                                  ),
                                                )
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Padding(
                                            padding: EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            child: CustomDividerWidget(
                                                indent: 102),
                                          );
                                        },
                                        itemCount:
                                            widget.listTrainingPlanData.length),
                                  ),
                                ),
                    if (widget.isLoadMore == true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: BaseHelper.loadingWidget(),
                        ),
                      ),
                  ]),
              if (widget.isLoadingNotifier) ...[
                ModalBarrier(
                    dismissible: false, color: AppColor.surfaceBackgroundColor),
                Center(child: BaseHelper.loadingWidget()),
              ]
            ],
          ),
        ),
      ],
    );
  }
}

class SecondTabWidget extends StatefulWidget {
  final Box<FollowTrainingPlanModel> box;

  final ScrollController scrollControllerPage2;
  final TextEditingController searchControllerPage2;
  final ValueNotifier<List<SelectedFilterModel>> followedConfirmedFilter;
  final void Function() requestCall;
  final void Function(String) searchDelayFn;
  List<TrainingPlanModel> followTrainingData;
  final bool isLoadingSecondTab;
  final bool isNodDataSecondTab;

  SecondTabWidget({
    super.key,
    required this.box,
    required this.scrollControllerPage2,
    required this.searchControllerPage2,
    required this.followedConfirmedFilter,
    required this.followTrainingData,
    required this.requestCall,
    required this.searchDelayFn,
    required this.isLoadingSecondTab,
    required this.isNodDataSecondTab,
  });

  @override
  State<SecondTabWidget> createState() => _SecondTabWidgetState();
}

class _SecondTabWidgetState extends State<SecondTabWidget> {
  bool isShowFilter = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColoredBox(
            color: AppColor.surfaceBackgroundColor,
            child: BottomSearchWidget(
              searchController: widget.searchControllerPage2,
              searchDelayFn: widget.searchDelayFn,
              requestCall: widget.requestCall,
              confirmedFilter: widget.followedConfirmedFilter,
              categoryName: CategoryName.trainingPlans,
              hideFilterFn: () {
                isShowFilter = false;
              },
            )),
        4.height(),
        Expanded(
          child: widget.isLoadingSecondTab == true
              ? Center(
                  child: BaseHelper.loadingWidget(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      ValueListenableBuilder(
                        valueListenable: widget.followedConfirmedFilter,
                        builder: (context, value, child) {
                          return FilterRowWidget(
                            confirmedFilter: widget.followedConfirmedFilter,
                            deleteAFilterOnTap: (e) {
                              ListController.deleteAFilterFn(
                                  context,
                                  e.filterName.toString(),
                                  widget.followedConfirmedFilter);
                              widget.requestCall();
                            },
                            hideOnTap: () {
                              isShowFilter = false;
                              setState(() {});
                            },
                            showOnTap: () {
                              isShowFilter = true;
                              setState(() {});
                            },
                            clearOnTap: () {
                              ListController.clearAppliedFilterFn(
                                widget.followedConfirmedFilter,
                              );
                              isShowFilter = false;
                              widget.requestCall();
                            },
                            isShowFilter: isShowFilter,
                          );
                        },
                      ),
                      widget.isNodDataSecondTab == true
                          ? const CustomErrorWidget()
                          : widget.followTrainingData.isEmpty
                              ? const NoResultFoundWidget()
                              : Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.textInvertEmphasis,
                                    ),
                                    child: ListView.separated(
                                        key: const PageStorageKey("page2"),
                                        controller:
                                            widget.scrollControllerPage2,
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 20,
                                            right: 20,
                                            bottom: 20),
                                        itemBuilder: (context, index) {
                                          return CustomListTileWidget(
                                              onTap: () {
                                                context.hideKeypad();
                                                context.navigateTo(
                                                    TrainingPlanDetailView(
                                                  id: widget
                                                      .followTrainingData[index]
                                                      .id,
                                                ));
                                              },
                                              imageHeaderIcon:
                                                  AppAssets.calendarIcon,
                                              imageUrl: widget
                                                  .followTrainingData[index]
                                                  .image
                                                  .toString(),
                                              onSubtitleWidget: FollowSubTitleWidget(
                                                  followTrainingData: widget
                                                      .box.values
                                                      .toList()
                                                      .firstWhere((element) =>
                                                          element
                                                              .trainingPlanId ==
                                                          widget
                                                              .followTrainingData[
                                                                  index]
                                                              .id)),
                                              title: widget
                                                  .followTrainingData[index]
                                                  .title
                                                  .toString());
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Padding(
                                            padding: EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            child: CustomDividerWidget(
                                                indent: 102),
                                          );
                                        },
                                        itemCount:
                                            widget.followTrainingData.length),
                                  ),
                                ),
                    ]),
        ),
      ],
    );
  }
}
