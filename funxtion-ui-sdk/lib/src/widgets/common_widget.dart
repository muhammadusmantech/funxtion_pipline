import 'package:flutter/material.dart';

import '../../ui_tool_kit.dart';

class LoaderStackWidget extends StatelessWidget {
  const LoaderStackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
            dismissible: false, color: AppColor.surfaceBackgroundColor),
        Center(
          child: BaseHelper.loadingWidget(),
        )
      ],
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final EdgeInsetsGeometry? customPadding;
  const CustomErrorWidget({
    super.key,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customPadding ?? const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error',
            style: AppTypography.title18LG,
          ),
          5.height(),
          Text(
            "Something went wrong",
            style: AppTypography.paragraph14MD
                .copyWith(color: AppColor.textPrimaryColor),
          )
        ],
      ),
    );
  }
}

class NoResultFoundWidget extends StatelessWidget {
  final EdgeInsetsGeometry? customPadding;
  const NoResultFoundWidget({
    super.key,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customPadding ?? const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Results',
            style: AppTypography.title18LG,
          ),
          5.height(),
          Text(
            "We couldn’t find anything",
            style: AppTypography.paragraph14MD
                .copyWith(color: AppColor.textPrimaryColor),
          )
        ],
      ),
    );
  }
}

class DescriptionBoxWidget extends StatelessWidget {
  final String text;
  const DescriptionBoxWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          child: Text(text,
              style: AppTypography.paragraph16LG
                  .copyWith(color: AppColor.textPrimaryColor))),
    );
  }
}

class HeaderTitleWidget extends StatelessWidget {
  final CategoryName categoryName;
  const HeaderTitleWidget({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      categoryName == CategoryName.videoClasses
          ? context.loc.titleText("video")
          : categoryName == CategoryName.workouts
              ? context.loc.titleText("workout")
              : categoryName == CategoryName.audioClasses
                  ? context.loc.titleText("audio")
                  : '',
      style:
          AppTypography.label18LG.copyWith(color: AppColor.textEmphasisColor),
    );
  }
}

String filterTitleWidget(BuildContext context, CategoryName categoryName) {
  return categoryName == CategoryName.videoClasses
      ? context.loc.titleText("videos")
      : categoryName == CategoryName.workouts
          ? context.loc.titleText("workout")
          : categoryName == CategoryName.audioClasses
              ? context.loc.titleText("audios")
              : categoryName == CategoryName.trainingPlans
                  ? context.loc.titleText("training")
                  : "";
}
