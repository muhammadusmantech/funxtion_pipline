import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:funxtion/funxtion_sdk.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class TrainingPlanListView extends StatefulWidget {
  final int initialIndex;
  const TrainingPlanListView({
    super.key,
    required this.initialIndex,
  });

  @override
  State<TrainingPlanListView> createState() => _TrainingPlanListViewState();
}

class _TrainingPlanListViewState extends State<TrainingPlanListView>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchControllerPage1;
  late TextEditingController _searchControllerPage2;
  late ScrollController _scrollControllerPage2;
  late ScrollController _scrollControllerPage1;

  late TabController _tabController;
  int pageNumber = 0;

  List<TrainingPlanModel> listTrainingPlanData = [];
  List<TrainingPlanModel> tempListTrainingPlanData = [];
  List<TrainingPlanModel> followTrainingData = [];
  Map<int, String> fitnessGoalData = {};

  bool nextPage = true;
  bool showCloseIcon = false;
  bool followedShowCloseIcon = false;
  bool isLoadMore = false;
  bool isNodData = false;
  bool isNodDataSecondTab = false;
  bool isLoadingSecondTab = false;
  bool shouldBreakLoop = false;
  bool isLoadingNotifier = false;

  ValueNotifier<List<SelectedFilterModel>> confirmedFilter = ValueNotifier([]);
  ValueNotifier<List<SelectedFilterModel>> followedConfirmedFilter =
      ValueNotifier([]);

  bool isFollowed = false;

  @override
  void initState() {
    if (EveentTriggered.screen_viewed != null) {
      EveentTriggered.screen_viewed!(
          "TrainingPlanListView", "MS 4 Training Plan");
    }

    _searchControllerPage1 = TextEditingController();
    _searchControllerPage2 = TextEditingController();
    _scrollControllerPage1 = ScrollController();
    _scrollControllerPage2 = ScrollController();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialIndex);
    if (widget.initialIndex == 0) {
      getData(isScroll: false);
    } else {
      getLocalTrainingData();
    }

    _tabController.addListener(() {
      if (Boxes.getTrainingPlanBox().isNotEmpty &&
          _tabController.index == 1 &&
          isLoadingSecondTab == false &&
          followTrainingData.isEmpty) {
        getLocalTrainingData();
      } else {
        if (tempListTrainingPlanData.isEmpty) {
            getData(isScroll: false);
        }

        bool isNew = false;
        for (var element in Boxes.getTrainingPlanBox().values) {
          for (var e in followTrainingData) {
            if (element.trainingPlanId != e.id) {
              isNew = true;
            } else {
              isNew = false;
            }
          }
        }
        if (isNew == true) {
          getLocalTrainingData();
        }
      }
    });
    _scrollControllerPage1.addListener(
      () {
        if (isLoadMore == false &&
            nextPage == true &&
            _scrollControllerPage1.position.extentAfter < 300.0 &&
            _scrollControllerPage1.position.extentAfter != 0.0) {
          isLoadMore = true;
          pageNumber += 10;
          getData(
            isScroll: true,
          );
        }
      },
    );

    super.initState();
  }

  checkIsFollowed() {
    isFollowed = Boxes.getTrainingPlanBox().isNotEmpty;

    if (isFollowed == false) {
      _tabController.animateTo(0);
    }
  }

  @override
  void dispose() {
    shouldBreakLoop = true;
    _scrollControllerPage1.dispose();
    _searchControllerPage1.dispose();
    _searchControllerPage2.dispose();
    _scrollControllerPage2.dispose();
    _tabController.dispose();
    ListController.filterListData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FollowTrainingPlanModel>>(
        valueListenable: Boxes.getTrainingPlanBox().listenable(),
        builder: (_, box, child) {
          checkIsFollowed();

          return Scaffold(
              backgroundColor: AppColor.surfaceBackgroundBaseColor,
              appBar: AppBar(
                  surfaceTintColor: AppColor.surfaceBackgroundColor,
                  titleSpacing: 0,
                  leadingWidth: 75,
                  toolbarHeight: 40,
                  leading: Navigator.of(context).canPop()
                      ? GestureDetector(
                          onTap: () {
                            context.maybePopPage();
                          },
                          child: SvgPicture.asset(
                            AppAssets.backArrowIcon,
                          ),
                        )
                      : const SizedBox.shrink(),
                  backgroundColor: AppColor.surfaceBackgroundColor,
                  elevation: 0.0,
                  centerTitle: true,
                  title: titleWidget(),
                  bottom: isFollowed == true
                      ? AppBar(
                          toolbarHeight: 45,
                          backgroundColor: AppColor.surfaceBackgroundColor,
                          surfaceTintColor: AppColor.surfaceBackgroundColor,
                          leading: const SizedBox.shrink(),
                          leadingWidth: 0,
                          titleSpacing: 0,
                          elevation: 0,
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppColor
                                          .surfaceBackgroundSecondaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TabBar(
                                      onTap: (value) {
                                        context.hideKeypad();
                                      },
                                      controller: _tabController,
                                      labelPadding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicator: BoxDecoration(
                                          color:
                                              AppColor.surfaceBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      tabs: [
                                        Text(
                                          context.loc.trainingAll,
                                          style: AppTypography.label14SM
                                              .copyWith(
                                                  color: AppColor
                                                      .textEmphasisColor),
                                        ),
                                        Text(
                                          context.loc.trainingFollow,
                                          style: AppTypography.label14SM
                                              .copyWith(
                                                  color: AppColor
                                                      .textEmphasisColor),
                                        )
                                      ])),
                            ],
                          ),
                        )
                      : null),
              body: Column(
                children: [
                  1.height(),
                  Expanded(
                    child: TabBarView(
                      physics: isFollowed == false
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      controller: _tabController,
                      children: [
                        FirstTabWidget(
                          followTrainingData: box.values.toList(),
                          key: const PageStorageKey("page1"),
                          searchControllerPage1: _searchControllerPage1,
                          confirmedFilter: confirmedFilter,
                          requestCall: () {
                            getData(
                              isScroll: false,
                            );
                          },
                          isLoadMore: isLoadMore,
                          isLoadingNotifier: isLoadingNotifier,
                          isNodData: isNodData,
                          listTrainingPlanData: listTrainingPlanData,
                          nextPage: nextPage,
                          scrollControllerPage1: _scrollControllerPage1,
                          showCloseIcon: showCloseIcon,
                          searchDelayFn: (value) {
                            ListController.deBouncerFn(fn: () {
                              getData(
                                isScroll: false,
                              );
                            });
                          },
                          fitnessGoalData: fitnessGoalData,
                        ),
                        isFollowed == false
                            ? Container()
                            : SecondTabWidget(
                                box: box,
                                scrollControllerPage2: _scrollControllerPage2,
                                searchControllerPage2: _searchControllerPage2,
                                followedConfirmedFilter:
                                    followedConfirmedFilter,
                                followTrainingData: followTrainingData,
                                requestCall: () {
                                  getLocalTrainingData();
                                },
                                searchDelayFn: (value) {
                                  ListController.deBouncerFn(fn: () {
                                    getLocalTrainingData();
                                  });
                                },
                                isLoadingSecondTab: isLoadingSecondTab,
                                isNodDataSecondTab: isLoadingSecondTab,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
          );
        });
  }

  Text titleWidget() {
    return Text(
      context.loc.titleText("training"),
      style:
          AppTypography.label18LG.copyWith(color: AppColor.textEmphasisColor),
    );
  }

  static List<TrainingPlanModel> sortTrainingDataById(
      List<TrainingPlanModel> trainingData, List<String> ids) {
    List<TrainingPlanModel> sortedTrainingData = [];
    for (var id in ids) {
      TrainingPlanModel? exercise =
          trainingData.firstWhere((element) => element.id == id);

      sortedTrainingData.add(exercise);
    }
    return sortedTrainingData;
  }

  void getLocalTrainingData() async {
    setState(() {
      followTrainingData.clear();
      isNodDataSecondTab = false;
      isLoadingSecondTab = true;
    });

    try {
      ListController.getLocalTrainingPlanDataFn(context,
              confirmedFilter: followedConfirmedFilter,
              ids: Boxes.getTrainingPlanBox()
                  .values
                  .map((e) => e.trainingPlanId)
                  .toList(),
              mainSearch: _searchControllerPage2.text.isNotEmpty
                  ? _searchControllerPage2.text
                  : null)
          .then((value) async {
        if (value != null && value.isNotEmpty) {
          List<TrainingPlanModel> data = [];
          if (followedConfirmedFilter.value.isEmpty &&
              _searchControllerPage2.text.isEmpty) {
            data = sortTrainingDataById(
                value,
                Boxes.getTrainingPlanBox()
                    .values
                    .map((e) => e.trainingPlanId)
                    .toList());
          } else {
            data = value;
          }

          followTrainingData.addAll(data);
          isLoadingSecondTab = false;
          setState(() {});
        } else {
          followTrainingData.clear();
          isLoadingSecondTab = false;
          setState(() {});
        }
      });
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      isNodData = true;
      setState(() {});
    }
  }

  void getData({
    required bool isScroll,
  }) async {
    setState(() {
      isNodData = false;

      if (isScroll == false) {
        listTrainingPlanData.clear();
        tempListTrainingPlanData.clear();
        fitnessGoalData.clear();
        pageNumber = 0;
      }

      isLoadingNotifier = isScroll == true ? false : true;
    });
    try {
      await ListController.getListTrainingPlanDataFn(
        context,
        confirmedFilter: confirmedFilter,
        mainSearch: _searchControllerPage1.text == ""
            ? null
            : _searchControllerPage1.text,
        pageNumber: pageNumber,
      ).then((value) async {
        if (value != null && value.isNotEmpty) {
          if (EveentTriggered.plan_searched != null &&
              _searchControllerPage1.text != "") {
            EveentTriggered.plan_searched!(
                _searchControllerPage1.text, value.length);
          }
          if (EveentTriggered.plan_filtered != null &&
              confirmedFilter.value.isNotEmpty) {
            EveentTriggered.plan_filtered!(
                confirmedFilter.value.length, confirmedFilter.value);
          }
          nextPage = true;
          isLoadMore = false;

          tempListTrainingPlanData.addAll(value);

          CommonController.getFilterFitnessGoalData(() {
            return;
          },

              trainingPlanData: tempListTrainingPlanData,
              filterFitnessGoalData: fitnessGoalData);
          listTrainingPlanData.addAll(value);
          isLoadingNotifier = isScroll == true ? false : false;
          setState(() {});
        } else if (value?.isEmpty ?? false) {
          nextPage = false;
          isLoadMore = false;
          isLoadingNotifier = isScroll == true ? false : false;
          setState(() {});
        } else if (value == null) {
          setState(() {
            isLoadMore = false;
            isNodData = true;
            nextPage = true;

            isLoadingNotifier = isScroll == true ? false : false;
          });
        }
      });
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
  }
}
