import 'package:flutter/material.dart';

import 'package:funxtion/funxtion_sdk.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoAudioDetailView extends StatefulWidget {
  final String id;
  const VideoAudioDetailView({
    super.key,
    required this.id,
  });

  @override
  State<VideoAudioDetailView> createState() => _VideoAudioDetailViewState();
}

class _VideoAudioDetailViewState extends State<VideoAudioDetailView> {
  bool isLoadingNotifier = false;
  bool isNodData = false;
  OnDemandModel? onDemandModelData;
  InstructorModel? instructorModelData;
  late ScrollController scrollController;
  List<Map<String, EquipmentModel>> equipmentData = [];
  ValueNotifier<bool> centerTitle = ValueNotifier(false);
  String onDemandCategoryFilterData = "";
  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset > 155) {
          centerTitle.value = true;
        } else if (scrollController.offset < 160) {
          centerTitle.value = false;
        }
      });
    fetchData();

    super.initState();
  }

  fetchData() async {
    setState(() {
      isLoadingNotifier = true;
      isNodData = false;
    });
    try {
      await VideoDetailController.getAOnDemandDataFn(context, id: widget.id)
          .then((value) async {
        if (value != null) {
          isLoadingNotifier = false;
          onDemandModelData = value;
          onDemandCategoryFilterData =
              VideoDetailController.getOnDemandCategoryDataFn(value);

          if (onDemandModelData?.instructorId.toString() != "null") {
            instructorModelData = await VideoDetailController.getInstructorFn(
                context,
                id: onDemandModelData?.instructorId.toString() ?? "");
          }

          if (context.mounted) {
            for (var element in onDemandModelData!.equipment!) {
              List<Map<String, int>> id = [];
              id.add({"": element});
              CommonController.getEquipmentFilterData(
                  equipmentIds: id, filterEquipmentData: equipmentData);
            }
          }

          setState(() {});
        } else {
          isLoadingNotifier = false;
          isNodData = true;
          setState(() {});
        }
      });
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }
    }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  appBarTitle: "${onDemandModelData?.title.trim()}",
                                  backGroundImg: onDemandModelData?.mapImage?.url.toString() ?? "",
                                  flexibleTitle: "${onDemandModelData?.title.trim()}",
                                  flexibleSubtitleWidget: Text(
                                    "${onDemandModelData?.duration} ${context.loc.minText} • $onDemandCategoryFilterData",
                                    style: AppTypography.label16MD.copyWith(
                                      color: AppColor.textInvertPrimaryColor,
                                    ),
                                  ),

                                  onStackChild: Stack(
                                  children: [

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 100,
                                        width: double.maxFinite,

                                        decoration:  BoxDecoration(
                                          // color: Colors.blue,
                                          gradient: LinearGradient(

                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.9),Colors.black.withOpacity(0.9),
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

                                descriptionWidget(),
                                cardWidget(),
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

  void playOnTap(BuildContext context) {
    if (EveentTriggered.video_class_cta_pressed != null) {
      EveentTriggered.video_class_cta_pressed!(
          onDemandModelData?.title.toString() ?? "",
          onDemandModelData?.mapVideo?.url ?? "");
    }
    return context.navigateTo(VideoPlayerView(
        title: onDemandModelData?.title.toString() ?? "",
        videoURL: onDemandModelData?.mapVideo?.url ?? "",
        thumbNail: onDemandModelData?.mapImage?.url ?? ""));
  }

  descriptionWidget() {
    return SliverToBoxAdapter(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
          child: Text(onDemandModelData?.description.toString() ?? "",
              style: AppTypography.paragraph16LG
                  .copyWith(color: AppColor.textPrimaryColor))),
    );
  }

  cardWidget() {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 0.2,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
        color: AppColor.surfaceBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 16),
          child: Column(
            children: [
              if (onDemandModelData?.level.toString() != "")
                CustomRowTextChartIcon(
                  level: onDemandModelData?.level.toString(),
                  text1: context.loc.levelText,
                  text2: onDemandModelData?.level.toString(),
                  isChartIcon: true,
                ),
              if (instructorModelData?.name.toString() != "") ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: CustomDividerWidget(),
                ),
                CustomRowTextChartIcon(
                    text1: context.loc.instructorText,
                    text2: instructorModelData?.name.toString()),
              ],
              if (onDemandModelData?.type != 'audio-workout' &&
                  onDemandModelData!.equipment?.isNotEmpty == true) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: CustomDividerWidget(),
                ),
                CustomRowTextChartIcon(
                    text1: context.loc.equipmentText,
                    secondWidget: SizedBox(
                      height: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: equipmentData.length,
                        itemBuilder: (context, index) {
                          if (index == 2) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("+${equipmentData.length - 2}",
                                    style: AppTypography.label14SM.copyWith(
                                      color: AppColor.textPrimaryColor,
                                    )),
                                2.width(),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor:
                                          AppColor.surfaceBackgroundBaseColor,
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          EquipmentExtendedSheet(
                                              title: onDemandModelData?.title
                                                      .toString() ??
                                                  "",
                                              equipmentData: equipmentData),
                                    );
                                  },
                                  child: Transform.translate(
                                    offset: const Offset(0, -4),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: AppColor.textPrimaryColor,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                          if (index == 1) {
                            return Text(
                                ",${equipmentData[index].values.first.name}",
                                style: AppTypography.label14SM.copyWith(
                                  color: AppColor.textPrimaryColor,
                                ));
                          }
                          if (index == 0) {
                            return Text(equipmentData[index].values.first.name,
                                style: AppTypography.label14SM.copyWith(
                                  color: AppColor.textPrimaryColor,
                                ));
                          }
                          return Container();
                        },
                      ),
                    ))
              ]
            ],
          ),
        ),
      ),
    );
  }

  Container bottomWidget() {
    return Container(
      color: AppColor.surfaceBackgroundColor,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text("${onDemandModelData?.title}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.title14XS
                            .copyWith(color: AppColor.textEmphasisColor)),
                  ],
                ),
                4.height(),
                Text(
                  "${onDemandModelData?.duration} ${context.loc.minText}",
                  style: AppTypography.paragraph12SM
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
              ],
            ),
          ),
          2.width(),
          Expanded(
            child: PlayButtonWidget(onPressed: () {
              playOnTap(context);
            }),
          ),
        ],
      ),
    );
  }
}
