import 'package:flutter/material.dart';
import 'package:funxtion/funxtion_sdk.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class DetailWorkoutBottomSheet extends StatefulWidget {
  final ItemType itemType;
  final String id;
  final ExerciseDetailModel exerciseDetailModel;
  const DetailWorkoutBottomSheet(
      {super.key,
      required this.id,
      required this.itemType,
      required this.exerciseDetailModel});

  @override
  State<DetailWorkoutBottomSheet> createState() =>
      _DetailWorkoutBottomSheetState();
}

class _DetailWorkoutBottomSheetState extends State<DetailWorkoutBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSingleItemType = false;
  ExerciseModel? exerciseData;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  @override
  void initState() {
    getExercisedata();
    checkItemType();
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  getExercisedata() async {
    isLoading.value = true;
    try {
      await ExerciseRequest.exerciseById(id: widget.id).then((value) async {
        if (value != null) {
          exerciseData = ExerciseModel.fromJson(value);
        }
      });
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
    isLoading.value = false;
  }

  checkItemType() {
    if (widget.exerciseDetailModel.exerciseCategoryName ==
        ItemType.singleExercise) {
      isSingleItemType = true;
    }
  }

  ValueNotifier<int> index = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (_, value, child) {
          return value == true && exerciseData == null
              ? Center(
                  child: BaseHelper.loadingWidget(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 12, bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            width: context.dynamicWidth * 0.7,
                            alignment: Alignment.center,
                            child: Text(
                              exerciseData?.name ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.title18LG
                                  .copyWith(color: AppColor.textEmphasisColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.textInvertSubtitle,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const CustomDividerWidget(),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 40),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: NetworkImageWidget(
                                height: 100,
                                width:
                                    MediaQuery.of(context).size.width.toInt(),
                                url: exerciseData?.mapGif?.url ?? "",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor.surfaceBackgroundColor,
                            ),
                            child: Column(
                              children: [
                                isSingleItemType
                                    ? Container(
                                        padding: const EdgeInsets.all(2),
                                        margin: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        decoration: BoxDecoration(
                                          color: AppColor
                                              .surfaceBackgroundSecondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TabBar(
                                          onTap: (value) {
                                            index.value = value;
                                          },
                                          controller: _tabController,
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8),
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          indicator: BoxDecoration(
                                            color:
                                                AppColor.surfaceBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          tabs: [
                                            Text(
                                              "Instructions",
                                              style: AppTypography.label14SM
                                                  .copyWith(
                                                      color: AppColor
                                                          .textEmphasisColor),
                                            ),
                                            Text(
                                              "Sets",
                                              style: AppTypography.label14SM
                                                  .copyWith(
                                                      color: AppColor
                                                          .textEmphasisColor),
                                            ),
                                          ],
                                        ))
                                    : Container(),
                                ValueListenableBuilder(
                                  valueListenable: index,
                                  builder: (_, value, child) {
                                    return value == 0
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: isSingleItemType ? 0 : 8),
                                            child: InstructionTabView(
                                                exerciseModel: exerciseData
                                                    as ExerciseModel),
                                          )
                                        : SetsTabView(
                                            exerciseDetailModel:
                                                widget.exerciseDetailModel);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
        });
  }
}

class InstructionTabView extends StatelessWidget {
  final ExerciseModel exerciseModel;
  const InstructionTabView({super.key, required this.exerciseModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exerciseModel.steps?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
            leading: Container(
              alignment: Alignment.center,
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  color: AppColor.surfaceBackgroundBaseColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "${index + 1}",
                style: AppTypography.label18LG
                    .copyWith(color: AppColor.textEmphasisColor),
              ),
            ),
            title: Text(exerciseModel.steps?[index],
                style: AppTypography.paragraph14MD.copyWith(
                  color: AppColor.textPrimaryColor,
                )));
      },
      separatorBuilder: (context, index) {
        return const CustomDividerWidget(
          indent: 70,
          endIndent: 30,
        );
      },
    );
  }
}

class SetsTabView extends StatelessWidget {
  final ExerciseDetailModel exerciseDetailModel;
  const SetsTabView({super.key, required this.exerciseDetailModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exerciseDetailModel.setsCount?.toInt() ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
            leading: Container(
              alignment: Alignment.center,
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  color: AppColor.surfaceBackgroundBaseColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "${index + 1}",
                style: AppTypography.label18LG
                    .copyWith(color: AppColor.textEmphasisColor),
              ),
            ),
            title: Text(exerciseDetailModel.goalTargets![index].getTargets,
                style: AppTypography.paragraph14MD.copyWith(
                  color: AppColor.textPrimaryColor,
                )));
      },
      separatorBuilder: (context, index) {
        return const CustomDividerWidget(
          indent: 70,
          endIndent: 30,
        );
      },
    );
  }
}
