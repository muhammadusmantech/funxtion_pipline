import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class FilterSheetWidget extends StatefulWidget {
  CategoryName categoryName;
  ValueNotifier<List<SelectedFilterModel>> confirmedFilter;
  void Function(List<SelectedFilterModel> selectedFilter) onDone;

  FilterSheetWidget(
      {super.key,
      required this.categoryName,
      required this.onDone,
      required this.confirmedFilter});

  @override
  State<FilterSheetWidget> createState() => _FilterSheetWidgetState();
}

class _FilterSheetWidgetState extends State<FilterSheetWidget> {
  List<SelectedFilterModel> selectedFilter = [];
  ValueNotifier<bool> filterLoader = ValueNotifier(false);
  @override
  void initState() {
    ListController.runComplexTask(context, widget.categoryName, filterLoader);
    selectedFilter.addAll(widget.confirmedFilter.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: selectedFilter.isNotEmpty
                    ? () {
                        ListController.resetFilterFn(
                            context, selectedFilter, widget.confirmedFilter);

                        setState(() {});
                      }
                    : null,
                child: Text(context.loc.resetText,
                    style: selectedFilter.isNotEmpty
                        ? AppTypography.label14SM
                            .copyWith(color: AppColor.linkPrimaryColor)
                        : AppTypography.label14SM
                            .copyWith(color: AppColor.linkDisableColor)),
              ),
              Text(
                context.loc.filterText,
                style: AppTypography.label18LG
                    .copyWith(color: AppColor.textEmphasisColor),
              ),
              InkWell(
                onTap: () {
                  context.popPage();
                  widget.onDone(selectedFilter);
                },
                child: Text(context.loc.doneText,
                    style: AppTypography.label14SM
                        .copyWith(color: AppColor.linkPrimaryColor)),
              ),
            ],
          ),
        ),
        const CustomDividerWidget(),
        ValueListenableBuilder<bool>(
            valueListenable: filterLoader,
            builder: (_, value, child) {
              return value == true
                  ? Center(
                      child: BaseHelper.loadingWidget(),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: ListController.filterListData
                                .map((data) => Padding(
                                      padding: EdgeInsets.only(
                                          top: ListController
                                                      .filterListData.first ==
                                                  data
                                              ? 20
                                              : 35,
                                          bottom: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              data.label.toString() == "Goal"
                                                  ? "Goals"
                                                  : data.label.toString(),
                                              style: AppTypography.title18LG
                                                  .copyWith(
                                                      color: AppColor
                                                          .textEmphasisColor)),
                                          12.height(),
                                          data.values != null
                                              ? Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: data.values!
                                                      .map((e) =>
                                                          GestureDetector(
                                                              onTap: () {
                                                                ListController.addFilterFn(
                                                                    SelectedFilterModel(
                                                                        filterId: e
                                                                            .id,
                                                                        filterType: data
                                                                            .key
                                                                            .toString(),
                                                                        filterName: e
                                                                            .label
                                                                            .toString()),
                                                                    selectedFilter,
                                                                    widget
                                                                        .confirmedFilter);
                                                                setState(() {});
                                                              },
                                                              child:
                                                                  levelContainer(
                                                                context,
                                                                e: IconTextModel(
                                                                    text: e
                                                                        .label
                                                                        .toString(),
                                                                    id: e.id),
                                                                selectedFilter:
                                                                    selectedFilter,
                                                                type: data.key
                                                                    .toString(),
                                                              )))
                                                      .toList(),
                                                )
                                              : Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: data.dynamicValues!
                                                      .map((e) =>
                                                          GestureDetector(
                                                              onTap: () {
                                                                ListController.addFilterFn(
                                                                    SelectedFilterModel(
                                                                        filterType: data
                                                                            .key
                                                                            .toString(),
                                                                        filterName: e
                                                                            .toString()),
                                                                    selectedFilter,
                                                                    widget
                                                                        .confirmedFilter);
                                                                setState(() {});
                                                              },
                                                              child:
                                                                  levelContainer(
                                                                context,
                                                                e: IconTextModel(
                                                                    text: e.toString(),
                                                                    imageName: e.toString().contains(RegExp('beginner', caseSensitive: false))
                                                                        ? AppAssets.chartLowIcon
                                                                        : e.toString().contains(RegExp("intermediate", caseSensitive: false))
                                                                            ? AppAssets.chatMidIcon
                                                                            : e.toString().contains(RegExp("advanced", caseSensitive: false))
                                                                                ? AppAssets.chartFullIcon
                                                                                : e.toString().contains(RegExp("club", caseSensitive: false))
                                                                                    ? AppAssets.gymIcon
                                                                                    : e.toString().contains(RegExp("home", caseSensitive: false))
                                                                                        ? AppAssets.homeIcon
                                                                                        : e.toString().contains(RegExp("outdoor", caseSensitive: false))
                                                                                            ? AppAssets.outdoorIcon
                                                                                            : null),
                                                                selectedFilter:
                                                                    selectedFilter,
                                                                type: data.key
                                                                    .toString(),
                                                              )))
                                                      .toList(),
                                                )
                                        ],
                                      ),
                                    ))
                                .toList()),
                      ),
                    );
            })
      ],
    );
  }
}

Widget levelContainer(BuildContext context,
    {required IconTextModel e,
    required List<SelectedFilterModel> selectedFilter,
    required String type}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        border: selectedFilter.any((element) {
          return element.filterName == e.text && element.filterType == type;
        })
            ? Border.all(color: AppColor.buttonPrimaryColor, width: 1)
            : Border.all(color: AppColor.borderOutlineColor, width: 1),
        color: AppColor.surfaceBackgroundColor,
        borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        e.imageName != null
            ? SvgPicture.asset(
                e.imageName.toString(),
                color: selectedFilter.any((element) {
                  return element.filterName == e.text &&
                      element.filterType == type;
                })
                    ? AppColor.buttonPrimaryColor
                    : AppColor.textEmphasisColor,
              )
            : const SizedBox.shrink(),
        4.height(),
        Text(
          e.text,
          style: AppTypography.label14SM.copyWith(
              color: selectedFilter.any((element) {
            return element.filterName == e.text && element.filterType == type;
          })
                  ? AppColor.buttonPrimaryColor
                  : AppColor.textEmphasisColor),
        )
      ],
    ),
  );
}
