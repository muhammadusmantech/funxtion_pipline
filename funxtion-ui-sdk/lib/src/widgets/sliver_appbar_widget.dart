import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class SliverAppBarWidget extends StatelessWidget {
  final bool value;
  bool isFollowingPlan;
  final Widget? bottomWidget;
  final String appBarTitle, flexibleTitle, backGroundImg;
  final Widget flexibleSubtitleWidget;
  Widget? onStackChild;
  SliverAppBarWidget(
      {super.key,
        required this.value,
        required this.appBarTitle,
        required this.flexibleTitle,
        required this.flexibleSubtitleWidget,
        required this.backGroundImg,
        this.isFollowingPlan = false,
        this.bottomWidget,
        this.onStackChild});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      stretch: true,
      backgroundColor: AppColor.surfaceBrandDarkColor,
      title: Visibility(
        visible: value == true ? true : false,
        child: Text(
          appBarTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.title24XL
              .copyWith(color: AppColor.textInvertEmphasis),
        ),
      ),

      leading: GestureDetector(
        onTap: () {
          context.maybePopPage();
        },
        child: Container(
            margin: const EdgeInsets.only(
              left: 19,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: AppColor.surfaceBrandDarkColor, shape: BoxShape.circle),
            child: Transform.scale(
              scale: 1.05,
              child: SvgPicture.asset(
                AppAssets.backArrowIcon,
                color: AppColor.textInvertEmphasis,
              ),
            )),
      ),
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          stretchModes: const [
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
          expandedTitleScale: 1,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
          title: Visibility(
            visible: value == false ? true : false,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFollowingPlan)
                    Container(
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 4, right: 16, left: 6),
                      decoration: BoxDecoration(
                          color: AppColor.buttonTertiaryColor,
                          borderRadius: BorderRadius.circular(26)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppColor.buttonPrimaryColor,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.check,
                              color: AppColor.surfaceBackgroundColor,
                              size: 16,
                            ),
                          ),
                          8.width(),
                          Text(
                            "Following",
                            style: AppTypography.label14SM
                                .copyWith(color: AppColor.buttonPrimaryColor),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    flexibleTitle,
                    style: AppTypography.title24XL
                        .copyWith(color: AppColor.textInvertEmphasis),
                  ),
                  isFollowingPlan == true
                      ? bottomWidget ?? const SizedBox.shrink()
                      : flexibleSubtitleWidget
                ],
              ),
            ),
          ),
          background: Stack(
            fit: StackFit.expand,
            children: [
              cacheNetworkWidget(context,
                height: 250,
                width: context.dynamicWidth.toInt(),
                imageUrl: backGroundImg,


              ),
              if (onStackChild != null) onStackChild!
            ],
          )),
    );
  }
}
