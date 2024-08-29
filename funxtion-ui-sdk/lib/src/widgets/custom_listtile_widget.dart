import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class CustomListTileWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Color? titleColor;
  final Color? subtitleColor;
  final Widget? onSubtitleWidget;
  final String? subtitle;
  final String imageHeaderIcon;
  final VoidCallback onTap;

  const CustomListTileWidget({
    super.key,
    required this.imageUrl,
    this.subtitleColor,
    this.titleColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.imageHeaderIcon,
    this.onSubtitleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: cacheNetworkWidget(
                    context,
                    height: 80,
                    width: 80,
                    imageUrl: imageUrl,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  imageHeaderIcon,
                  color: AppColor.textInvertEmphasis,
                ),
              ),
            ],
          ),
          16.width(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label16MD.copyWith(
                      color: titleColor ?? AppColor.textEmphasisColor,
                    )),
                5.height(),
                Container(
                  child: onSubtitleWidget ??
                      Text(
                        subtitle.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.paragraph14MD.copyWith(
                            color: subtitleColor ?? AppColor.textPrimaryColor),
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
