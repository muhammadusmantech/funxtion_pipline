import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

class DashBoardView extends StatefulWidget {
  final List<OnDemandModel> onDemandDataVideo;
  final List<WorkoutModel> workoutData;
  final List<OnDemandModel> onDemandDataAudio;
  final List<TrainingPlanModel> trainingPlanData;
  final Map<int, String> workoutDataType;
  final Map<int, String> videoDataType;
  final Map<int, String> audioDataType;
  final Map<int, String> fitnessGoalData;

  const DashBoardView(
      {super.key,
      required this.onDemandDataVideo,
      required this.workoutData,
      required this.onDemandDataAudio,
      required this.trainingPlanData,
      required this.workoutDataType,
      required this.videoDataType,
      required this.audioDataType,
      required this.fitnessGoalData});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  bool isNodData = false;

  @override
  void initState() {
    checkData();

    super.initState();
  }

  checkData() {
    if (widget.audioDataType.isEmpty &&
        widget.fitnessGoalData.isEmpty &&
        widget.onDemandDataAudio.isEmpty &&
        widget.onDemandDataVideo.isEmpty &&
        widget.trainingPlanData.isEmpty &&
        widget.videoDataType.isEmpty &&
        widget.workoutData.isEmpty &&
        widget.workoutDataType.isEmpty) {
      isNodData == true;
    } else {
      isNodData = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.textInvertPrimaryColor,
      appBar: AppBar(
          surfaceTintColor: AppColor.surfaceBackgroundColor,
          elevation: 0,
          backgroundColor: AppColor.surfaceBackgroundColor,
          leadingWidth: 0,
          titleSpacing: 0,
          leading: const SizedBox.shrink(),
          title: SearchTextFieldWidget(
            onFieldTap: () {
              context.navigateTo(const SearchContentView());
            },
            hintText: context.loc.hintSearchText,
            margin:
                const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 10),
          )),
      body: isNodData == true
          ? const CustomErrorWidget()
          : ListView(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              children: [
                  ValueListenableBuilder(
                      valueListenable: Boxes.getTrainingPlanBox().listenable(),
                      builder: (_, value, child) {
                        return value.isNotEmpty
                            ? Column(
                                children: [
                                  RowEndToEndTextWidget(
                                    columnText1: context.loc
                                        .yourTrainingPlan(value.length),
                                    rowText1: context.loc.seeAll,
                                    columnText2:
                                        context.loc.recentSubtitle("training"),
                                    seeOnTap: () {
                                      context.navigateTo(
                                          const TrainingPlanListView(
                                        initialIndex: 1,
                                      ));
                                    },
                                  ),
                                  20.height(),
                                  CarouselSlider(
                                    items: value.values
                                        .toList()
                                        .sublist(0,
                                            value.values.length > 4 ? 4 : null)
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColor
                                                        .surfaceBrandSecondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.navigateTo(
                                                            TrainingPlanDetailView(
                                                          id: e.trainingPlanId,
                                                        ));
                                                      },
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 190,
                                                            child: ClipRRect(
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          16)),
                                                              child: cacheNetworkWidget(
                                                                  height: 190,
                                                                  width: context
                                                                      .dynamicWidth
                                                                      .toInt(),
                                                                  context,
                                                                  imageUrl: e
                                                                      .trainingPlanImg),
                                                            ),
                                                          ),

                                                          /// Gradient overlay
                                                          Positioned.fill(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors
                                                                        .transparent,
                                                                    Colors
                                                                        .transparent,
                                                                    AppColor
                                                                        .surfaceBrandDarkColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                    AppColor
                                                                        .surfaceBrandDarkColor,
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    e.trainingPlanTitle.split(
                                                                        ":")[0],
                                                                    style: AppTypography
                                                                        .title18LG
                                                                        .copyWith(
                                                                            color:
                                                                                AppColor.textInvertEmphasis)),
                                                                10.height(),
                                                                FollowedBorderWidget(
                                                                    followTrainingData:
                                                                        e),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (e.workoutCount !=
                                                        e.totalWorkoutLength)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Next up',
                                                              style: AppTypography
                                                                  .label12XSM
                                                                  .copyWith(
                                                                      color: AppColor
                                                                          .textInvertSubtitle),
                                                            ),
                                                            4.height(),
                                                            CustomListTileWidget(
                                                              titleColor: AppColor
                                                                  .textInvertEmphasis,
                                                              subtitleColor:
                                                                  AppColor
                                                                      .textInvertPrimaryColor,
                                                              imageUrl: e
                                                                  .workoutData[e
                                                                              .workoutCount ==
                                                                          e.totalWorkoutLength
                                                                      ? e.workoutCount - 1
                                                                      : e.workoutCount]
                                                                  .workoutImg
                                                                  .trim(),
                                                              title: e
                                                                  .workoutData[e
                                                                              .workoutCount ==
                                                                          e.totalWorkoutLength
                                                                      ? e.workoutCount - 1
                                                                      : e.workoutCount]
                                                                  .workoutTitle,
                                                              subtitle:
                                                                  '${e.workoutData[e.workoutCount == e.totalWorkoutLength ? e.workoutCount - 1 : e.workoutCount].workoutSubtitle.split("•")[0].trim()} min',
                                                              onTap: () {
                                                                final workout = e
                                                                    .workoutData[e
                                                                            .workoutCount ==
                                                                        e.totalWorkoutLength
                                                                    ? e.workoutCount - 1
                                                                    : e.workoutCount];

                                                                context
                                                                    .navigateTo(
                                                                  WorkoutDetailView(
                                                                    id: workout
                                                                        .workoutId
                                                                        .toString(),
                                                                    followTrainingPlanModel:
                                                                        FollowTrainingPlanModel(
                                                                      trainingPlanId:
                                                                          e.trainingPlanId,
                                                                      workoutData:
                                                                          e.workoutData,
                                                                      workoutCount: e.workoutCount ==
                                                                              e.totalWorkoutLength
                                                                          ? e.workoutCount
                                                                          : e.workoutCount + 1,
                                                                      totalWorkoutLength:
                                                                          e.totalWorkoutLength,
                                                                      outOfSequence:
                                                                          false,
                                                                      trainingPlanImg:
                                                                          e.trainingPlanImg,
                                                                      trainingPlanTitle:
                                                                          e.trainingPlanTitle,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              imageHeaderIcon:
                                                                  AppAssets
                                                                      .workoutHeaderIcon,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    options: CarouselOptions(
                                      height: 310,
                                      autoPlay: false,
                                      viewportFraction: 0.9,
                                      enableInfiniteScroll: false,
                                    ),
                                  ),
                                  50.height(),
                                  const CustomDividerWidget(
                                    endIndent: 30,
                                    indent: 30,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink();
                      }),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: RowEndToEndTextWidget(
                        seeOnTap: () {
                          context.navigateTo(const VideoAudioWorkoutListView(
                              categoryName: CategoryName.videoClasses));
                        },
                        columnText1: context.loc.recentTitle("video"),
                        rowText1: context.loc.seeAll),
                  ),

                  /// 1
                  CarouselSlider(
                    items: widget.onDemandDataVideo.map((data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => context
                              .navigateTo(VideoAudioDetailView(id: data.id)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Background Image
                                Positioned.fill(
                                  child: cacheNetworkWidget(
                                    height: 220, // Matches the Carousel height
                                    width: double.maxFinite.toInt(),
                                    context,
                                    imageUrl: data.image,
                                  ),
                                ),

                                // Gradient Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          AppColor.surfaceBrandDarkColor
                                              .withOpacity(0.8),
                                          AppColor.surfaceBrandDarkColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Text Content
                                Positioned(
                                  left: 12,
                                  bottom: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.title18LG.copyWith(
                                          color: AppColor.textInvertEmphasis,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${data.duration} min • ${widget.videoDataType[widget.onDemandDataVideo.indexOf(data)]} • ${data.level}",
                                        style: AppTypography.paragraph14MD
                                            .copyWith(
                                          color:
                                              AppColor.textInvertPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: false,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 45,
                    ),
                    child: RowEndToEndTextWidget(
                        columnText1: context.loc.recentTitle("training"),
                        seeOnTap: () {
                          context.navigateTo(const TrainingPlanListView(
                            initialIndex: 0,
                          ));
                        },
                        columnText2: context.loc.recentSubtitle("training"),
                        rowText1: context.loc.seeAll),
                  ),

                  /// 2
                  CarouselSlider(
                    items: widget.trainingPlanData.asMap().entries.map((data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => context.navigateTo(
                              TrainingPlanDetailView(id: data.value.id)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Background Image
                                Positioned.fill(
                                  child: cacheNetworkWidget(
                                    height: 220, // Matches the Carousel height
                                    width: double.maxFinite.toInt(),
                                    context,
                                    imageUrl: data.value.image.toString(),
                                  ),
                                ),

                                // Gradient Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          AppColor.surfaceBrandDarkColor
                                              .withOpacity(0.8),
                                          AppColor.surfaceBrandDarkColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Text Content
                                Positioned(
                                  left: 10,
                                  bottom: 10,
                                  right: 10,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.value.title.split(":")[0],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.title18LG.copyWith(
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          color: AppColor.textInvertEmphasis,
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              4), // Small spacing between texts
                                      Text(
                                        "${data.value.daysTotal} ${context.loc.workoutPluraText(data.value.daysTotal!)} • "
                                        "${widget.fitnessGoalData.entries.toList()[data.key].value} •"
                                        " ${data.value.level}",
                                        style: AppTypography.paragraph12SM
                                            .copyWith(
                                          color:
                                              AppColor.textInvertPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: false,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: RowEndToEndTextWidget(
                        columnText1: context.loc.whatLookingFor, rowText1: ""),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            DashBoardButtonWidget(
                                index: 1, text: context.loc.titleText("video")),
                            16.width(),
                            DashBoardButtonWidget(
                                index: 2,
                                text: context.loc.titleText("workout"))
                          ],
                        ),
                        16.height(),
                        Row(
                          children: [
                            DashBoardButtonWidget(
                                index: 3,
                                text: context.loc.titleText("training")),
                            16.width(),
                            DashBoardButtonWidget(
                                index: 4, text: context.loc.titleText("audio"))
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: RowEndToEndTextWidget(
                      seeOnTap: () {
                        context.navigateTo(const VideoAudioWorkoutListView(
                            categoryName: CategoryName.workouts));
                      },
                      columnText1: context.loc.recentTitle('workout'),
                      rowText1: context.loc.seeAll,
                      columnText2: context.loc.recentSubtitle('workout'),
                    ),
                  ),
                  20.height(),

                  ///3
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.workoutData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: 180,
                          child: InkWell(
                            onTap: () {
                              context.navigateTo(WorkoutDetailView(
                                id: widget.workoutData[index].id.toString(),
                              ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  // Background image
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: cachedNetworkImageProvider(
                                            imageUrl: widget
                                                .workoutData[index].image
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay on the bottom half
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            AppColor.surfaceBrandDarkColor
                                                .withOpacity(0.8),
                                            AppColor.surfaceBrandDarkColor,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content on top of the gradient overlay
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    right: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.workoutData[index].title
                                              .toString(),
                                          maxLines: 3,
                                          style:
                                              AppTypography.title16XS.copyWith(
                                            color: AppColor.textInvertEmphasis,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          children: [
                                            Text(
                                              "${widget.workoutData[index].duration.toString()} min",
                                              style: AppTypography.paragraph14MD
                                                  .copyWith(
                                                color: AppColor
                                                    .textInvertPrimaryColor,
                                              ),
                                            ),
                                            Text(
                                              " • ${widget.workoutDataType[index].toString()}",
                                              style: AppTypography.paragraph14MD
                                                  .copyWith(
                                                color: AppColor
                                                    .textInvertPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: RowEndToEndTextWidget(
                      seeOnTap: () {
                        context.navigateTo(const VideoAudioWorkoutListView(
                            categoryName: CategoryName.audioClasses));
                      },
                      columnText1: context.loc.recentTitle("audio"),
                      rowText1: context.loc.seeAll,
                    ),
                  ),
                  20.height(),

                  ///4
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.onDemandDataAudio.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            width: 180,
                            child: InkWell(
                              onTap: () {
                                context.navigateTo(VideoAudioDetailView(
                                  id: widget.onDemandDataAudio[index].id
                                      .toString(),
                                ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  clipBehavior: Clip.antiAlias,
                                  children: [
                                    // Background image
                                    Positioned.fill(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: cachedNetworkImageProvider(
                                                  imageUrl: cacheNetworkWidget(
                                                          context,
                                                          height: 190,
                                                          width: context
                                                              .dynamicWidth
                                                              .toInt(),
                                                          imageUrl: widget
                                                              .onDemandDataAudio[
                                                                  index]
                                                              .image
                                                              .toString())
                                                      .imageUrl))),
                                    )),
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        alignment: Alignment.bottomLeft,
                                        child: Wrap(children: [
                                          Text(
                                            widget
                                                .onDemandDataAudio[index].title
                                                .toString(),
                                          ),
                                        ])),

                                    // Gradient overlay on the bottom half
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.transparent,
                                              Colors.transparent,
                                              AppColor.surfaceBrandDarkColor
                                                  .withOpacity(0.8),
                                              AppColor.surfaceBrandDarkColor,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Content on top of the gradient overlay
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      right: 12,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget
                                                .onDemandDataAudio[index].title
                                                .toString(),
                                            maxLines: 3,
                                            style: AppTypography.title16XS
                                                .copyWith(
                                              color:
                                                  AppColor.textInvertEmphasis,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Wrap(
                                            children: [
                                              Text(
                                                "${widget.onDemandDataAudio[index].duration.toString()} min",
                                                style: AppTypography
                                                    .paragraph14MD
                                                    .copyWith(
                                                  color: AppColor
                                                      .textInvertPrimaryColor,
                                                ),
                                              ),
                                              Text(
                                                " • ${widget.audioDataType[index].toString()}",
                                                style: AppTypography
                                                    .paragraph14MD
                                                    .copyWith(
                                                  color: AppColor
                                                      .textInvertPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Icon(
                                          Icons.headphones,
                                          color: AppColor.buttonLabelColor,
                                        ))
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                ]),
    );
  }
}
