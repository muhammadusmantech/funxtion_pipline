import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui_tool_kit.dart';

class BottomSearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) searchDelayFn;
  final void Function() requestCall;
  final void Function() hideFilterFn;
  final ValueNotifier<List<SelectedFilterModel>> confirmedFilter;
  final CategoryName categoryName;
  const BottomSearchWidget({
    super.key,
    required this.searchController,
    required this.searchDelayFn,
    required this.confirmedFilter,
    required this.categoryName,
    required this.requestCall,
    required this.hideFilterFn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SearchTextFieldWidget(
                hintText: context.loc.hintSearchText2,
                showCloseIcon: searchController.text.isNotEmpty,
                onChange: (value) {
                  searchDelayFn(value);
                },
                onIconTap: () {
                  context.hideKeypad();
                  searchController.clear();

                  requestCall();
                },
                searchController: searchController)),
        searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  searchController.clear();

                  ListController.clearAppliedFilterFn(
                    confirmedFilter,
                  );
                  hideFilterFn();
                  requestCall();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 20),
                  child: Text('Cancel',
                      style: AppTypography.label14SM.copyWith(
                        color: AppColor.textEmphasisColor,
                      )),
                ),
              )
            : iconFilterWidget(context)
      ],
    );
  }

  iconFilterWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      decoration: BoxDecoration(
          color:
              confirmedFilter.value.isEmpty ? null : AppColor.textEmphasisColor,
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          context.hideKeypad();
          await showModalBottomSheet(
            useSafeArea: true,
            enableDrag: false,
            isDismissible: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            backgroundColor: AppColor.surfaceBackgroundBaseColor,
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return PopScope(
                canPop: false,
                child: FilterSheetWidget(
                  confirmedFilter: confirmedFilter,
                  onDone: (value) {
                    if (value.isNotEmpty ||
                        ListController.restConfirmFilterAlso == true) {
                      ListController.restConfirmFilterAlso = false;
                      ListController.confirmFilterFn(
                          confirmedFilter: confirmedFilter,
                          selectedFilter: value);
                      requestCall();
                    }
                  },
                  categoryName: categoryName,
                ),
              );
            },
          );
        },
        child: SvgPicture.asset(AppAssets.iconFilter,
            color: confirmedFilter.value.isEmpty
                ? AppColor.textEmphasisColor
                : AppColor.textInvertEmphasis),
      ),
    );
  }
}
