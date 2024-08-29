import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class FilterRowWidget extends StatelessWidget {
  final ValueNotifier<List<SelectedFilterModel>> confirmedFilter;
  final Function(SelectedFilterModel value) deleteAFilterOnTap;
  final VoidCallback hideOnTap;
  final VoidCallback showOnTap;
  final VoidCallback clearOnTap;
  final bool isShowFilter;
  const FilterRowWidget(
      {super.key,
      required this.confirmedFilter,
      required this.deleteAFilterOnTap,
      required this.hideOnTap,
      required this.showOnTap,
      required this.clearOnTap,
      required this.isShowFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: confirmedFilter.value.isEmpty
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: confirmedFilter.value.isEmpty
            ? []
            : [
                Expanded(
                  child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: confirmedFilter.value.length >= 2
                          ? [
                              Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: isShowFilter == false
                                      ? confirmedFilter.value
                                          .sublist(0, 2)
                                          .map((e) => CancelIconContainerWidget(
                                                e: e.filterName.toString(),
                                                onIconTap: () {
                                                  deleteAFilterOnTap(e);
                                                },
                                                isActive: true,
                                              ))
                                          .toList()
                                      : [
                                          for (int i = 0;
                                              i < confirmedFilter.value.length;
                                              i++)
                                            CancelIconContainerWidget(
                                              e: confirmedFilter
                                                  .value[i].filterName,
                                              onIconTap: () {
                                                deleteAFilterOnTap(
                                                    confirmedFilter.value[i]);
                                                if (confirmedFilter
                                                        .value.length <
                                                    3) {
                                                  hideOnTap();
                                                }
                                              },
                                              isActive: true,
                                            ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 9),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColor.linkTeritaryCOlor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: InkWell(
                                                  onTap: hideOnTap,
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 18,
                                                    color: AppColor
                                                        .textInvertEmphasis,
                                                  )))
                                        ]),
                              confirmedFilter.value.length > 2 &&
                                      isShowFilter == false
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 9),
                                      decoration: BoxDecoration(
                                        color: AppColor.linkTeritaryCOlor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: InkWell(
                                        onTap: showOnTap,
                                        child: Text(
                                            "+${confirmedFilter.value.length - 2}",
                                            style: AppTypography.label14SM
                                                .copyWith(
                                                    color: AppColor
                                                        .textInvertEmphasis)),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ]
                          : confirmedFilter.value
                              .map((e) => CancelIconContainerWidget(
                                    e: e.filterName.toString(),
                                    onIconTap: () {
                                      deleteAFilterOnTap(e);
                                    },
                                    isActive: true,
                                  ))
                              .toList()),
                ),
                InkWell(
                  onTap: clearOnTap,
                  child: Text(
                    'Clear',
                    style: AppTypography.label14SM.copyWith(
                        color: AppColor.linkTeritaryCOlor,
                        decorationStyle: TextDecorationStyle.solid,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
      ),
    );
  }
}
