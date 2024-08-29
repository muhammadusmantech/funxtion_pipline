import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../ui_tool_kit.dart';

class SearchContentView extends StatefulWidget {
  const SearchContentView({super.key});

  @override
  State<SearchContentView> createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  SearchContentModel? searchContentData;
  List<Result> resultData = [];
  List<Result> filterResultData = [];

  int pageNumber = 0;

  bool nextPage = true;

  bool isLoadMore = false;
  bool isNodData = false;

  bool isLoadingNotifier = false;
  bool resultPage = false;
  bool isHive = false;
  Box<RecentSearchLocalModel>? recentSearchLocalList;
  Box<RecentlyVisitedLocalModel>? recentlyVisitedLocalList;
  List<Map<CategoryName, bool>> filterList = [];
  @override
  void initState() {
    openBoxes();
    if (EveentTriggered.screen_viewed != null) {
      EveentTriggered.screen_viewed!(
          "SearchContentView", "MS 5 Search & Content View");
    }

    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    _scrollController.addListener(
      () {
        if (isLoadMore == false &&
            nextPage == true &&
            _scrollController.position.extentAfter < 300 &&
            _scrollController.position.extentAfter != 0.0) {
          isLoadMore = true;

          pageNumber += 10;
          getdata(isScroll: true, text: _searchController.text);
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    recentSearchLocalList?.close();
    recentlyVisitedLocalList?.close();

    super.dispose();
  }

  openBoxes() async {
    await HiveLocalController.openSearchBox();
    getLocalInstance();
  }

  getLocalInstance() {
    recentSearchLocalList = Boxes.getRecentSearchBox();
    recentlyVisitedLocalList = Boxes.getRecentlyVisitedBox();

    setState(() {});
  }

  List<String> topMatches = [];
  String removeMarkTags(String input) {
    RegExp exp = RegExp(r'<\/?mark>');

    return input.replaceAll(exp, '');
  }

  void updateSuggestions(
    String input,
  ) {
    if (searchContentData != null) {
      List<String> filteredSuggestions = searchContentData!.suggestions!
          .map((e) => removeMarkTags(e.q.toString()))
          .toList();

      topMatches = filteredSuggestions.length > 4
          ? filteredSuggestions.sublist(0, 4)
          : filteredSuggestions;

      setState(() {});
    }
  }

  getdata({required bool isScroll, required text}) async {
    isLoadingNotifier = isScroll == true ? false : true;
    isNodData = false;
    if (isScroll == false) {
      resultData.clear();
      filterResultData.clear();
      filterList.clear();
      pageNumber = 0;
    }

    setState(() {});

    await SearchContentController.fetchDataFn(
      context,
      data: {
        "q": text,
        "cursors": [
          {"collection": "workouts", "offset": pageNumber, "limit": 10},
          {"collection": "video", "offset": pageNumber, "limit": 10},
          {"collection": "audio", "offset": pageNumber, "limit": 10},
          {"collection": "training-plans", "offset": pageNumber, "limit": 10}
        ],
      },
      searchContentData: searchContentData,
    ).then((data) {
      if (data != null) {
        nextPage = true;

        isLoadMore = false;
        searchContentData = data;

        if (data.results?.isNotEmpty ?? false) {
          resultData.addAll(data.results as List<Result>);
          filterResultData.addAll(data.results as List<Result>);
          addCategoryFn(data.results?.toList() as List<Result>);
          if (filterList
              .any((element) => element.entries.first.value == true)) {
            filterResultData.clear();
            onFiltertapFn();
          }
        } else if (data.results?.isEmpty ?? false) {
          nextPage = false;
        }
      } else if (data == null) {
        isLoadMore = false;
        isNodData = true;
        nextPage = true;
        isLoadingNotifier = isScroll == true ? false : false;
        setState(() {});
      }
    });
    setState(() {
      isLoadingNotifier = false;
    });
  }

  addCategoryFn(List<Result> listResultData) {
    for (var i = 0; i < listResultData.length; i++) {
      if (filterList.any((element) =>
          element.entries.first.key == listResultData[i].collection)) {
      } else {
        filterList.add({listResultData[i].collection!: false});
      }
    }
  }

  recentSearchSortAddDataFn() async {
    if (recentSearchLocalList!.values.isNotEmpty) {
      if (recentSearchLocalList!.values.any((element) =>
          element.recentSearch.containsValue(_searchController.text))) {
        for (var i = 0; i < recentSearchLocalList!.values.length; i++) {
          if (recentSearchLocalList!.values
              .toList()[i]
              .recentSearch
              .entries
              .first
              .value
              .contains(_searchController.text)) {
            await recentSearchLocalList!.put(
                i,
                RecentSearchLocalModel(
                    recentSearch: {DateTime.now(): _searchController.text}));
          }
        }
      } else {
        await recentSearchLocalList!.add(RecentSearchLocalModel(
            recentSearch: {DateTime.now(): _searchController.text}));
      }
      if (recentSearchLocalList!.length >= 1) {
        sortRecentSearchList(recentSearchLocalList!.values.toList());
      }
    } else {
      await recentSearchLocalList!.add(RecentSearchLocalModel(
          recentSearch: {DateTime.now(): _searchController.text}));
    }

    setState(() {});
  }

  sortRecentSearchList(List<RecentSearchLocalModel> recentSearchList) async {
    recentSearchList.sort((a, b) => b.recentSearch.entries.first.key
        .compareTo(a.recentSearch.entries.first.key));

    await recentSearchLocalList!.clear();

    for (var i = 0;
        i < (recentSearchList.length > 4 ? 4 : recentSearchList.length);
        i++) {
      await recentSearchLocalList!.put(i, recentSearchList[i]);
    }
  }

  sortRecentlyVisitedList(
      List<RecentlyVisitedLocalModel> recentlyVisitedList) async {
    recentlyVisitedList.sort((a, b) => b.recentlyVisited.entries.first.key
        .compareTo(a.recentlyVisited.entries.first.key));

    await recentlyVisitedLocalList!.clear();

    for (var i = 0;
        i < (recentlyVisitedList.length > 8 ? 8 : recentlyVisitedList.length);
        i++) {
      await recentlyVisitedLocalList!.put(i, recentlyVisitedList[i]);
    }
  }

  recnetlyVisiteSortAddDataFn(LocalResult localResultData) async {
    if (recentlyVisitedLocalList!.values.isNotEmpty) {
      if (recentlyVisitedLocalList!.values.any((element) =>
          element.recentlyVisited.containsValue(localResultData))) {
        for (var i = 0; i < recentlyVisitedLocalList!.values.length; i++) {
          if (recentlyVisitedLocalList!.values
                  .toList()[i]
                  .recentlyVisited
                  .entries
                  .first
                  .value ==
              localResultData) {
            await recentlyVisitedLocalList!.put(
                i,
                RecentlyVisitedLocalModel(
                    recentlyVisited: {DateTime.now(): localResultData}));
          }
        }
      } else {
        await recentlyVisitedLocalList!.add(RecentlyVisitedLocalModel(
            recentlyVisited: {DateTime.now(): localResultData}));
      }
      if (recentlyVisitedLocalList!.length >= 1) {
        sortRecentlyVisitedList(recentlyVisitedLocalList!.values.toList());
      }
    } else {
      await Boxes.getRecentlyVisitedBox().add(RecentlyVisitedLocalModel(
          recentlyVisited: {DateTime.now(): localResultData}));
    }

    setState(() {});
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
          onSubmitted: (p0) async {
            resultPage = true;
            if (_searchController.text.isNotEmpty) {
              await recentSearchSortAddDataFn();
            }
            if (EveentTriggered.search_term != null) {
              EveentTriggered.search_term!(_searchController.text.trim());
            }
            setState(() {});
          },
          onChange: (p0) {
            resultPage = false;
            if (p0 == "") {
              topMatches.clear();
              resultData.clear();
              filterResultData.clear();
              setState(() {});
            } else {
              topMatches.clear();
              ListController.deBouncerFn(fn: () async {
                if (p0 != "") {
                  await getdata(isScroll: false, text: _searchController.text);
                  updateSuggestions(p0);
                }
                if (EveentTriggered.search_term != null) {
                  EveentTriggered.search_term!(_searchController.text.trim());
                }
              });
            }
          },
          onIconTap: () {
            _searchController.clear();
            filterList.clear();
            filterResultData.clear();
            resultPage = false;
            topMatches.clear();
            resultData.clear();
            setState(() {});
          },
          showCloseIcon: _searchController.text.isNotEmpty,
          focusNode: _focusNode,
          searchController: _searchController,
          hintText: context.loc.hintSearchText,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.popPage();
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 20),
              child: Text(context.loc.cancelText,
                  style: AppTypography.label14SM.copyWith(
                    color: AppColor.textEmphasisColor,
                  )),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          1.height(),
          resultPage == false
              ? buildSuggestions()
              : filterList.isNotEmpty
                  ? Container(
                      padding:
                          const EdgeInsets.only(top: 16, bottom: 16, left: 24),
                      width: double.infinity,
                      height: 75,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: filterList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SearchConatinerWIdget(
                              isActive: filterList[index].entries.first.value,
                              onFilterTap: (e) {
                                if (filterList[index].entries.first.value ==
                                    false) {
                                  var tappedItem = filterList.removeAt(index);
                                  Map<CategoryName, bool> updatedValue = {
                                    tappedItem.entries.first.key: true
                                  };
                                  filterList.insert(0, updatedValue);
                                  filterResultData.clear();
                                  nextPage = true;
                                  onFiltertapFn();
                                  setState(() {});
                                }
                              },
                              onIconTap: (e) {
                                var tappedItem = filterList.removeAt(index);
                                Map<CategoryName, bool> updatedValue = {
                                  tappedItem.entries.first.key: false
                                };
                                filterList.insert(
                                    filterList.length, updatedValue);
                                filterResultData.clear();
                                nextPage = true;
                                if (filterList.any((element) =>
                                    element.entries.first.value == true)) {
                                  onFiltertapFn();
                                } else {
                                  filterResultData.addAll(resultData);
                                }

                                setState(() {});
                              },
                              title: filterTitleWidget(
                                context,
                                filterList[index].entries.first.key,
                              )),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
          _searchController.text.isEmpty
              ? Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: recentSearchLocalList?.length != 0 ||
                            recentlyVisitedLocalList?.length != 0
                        ? recentSearchRecentlyVisitWidget()
                        : const SizedBox.shrink(),
                  ),
                )
              : Expanded(
                  child: Stack(
                    children: [
                      if (isLoadingNotifier == false &&
                          _searchController.text.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: topMatches.isNotEmpty
                                  ? BorderRadius.circular(20)
                                  : null,
                              color: AppColor.textInvertEmphasis),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              isNodData == true
                                  ? const CustomErrorWidget()
                                  : resultData.isEmpty &&
                                          _searchController.text.isNotEmpty
                                      ? const NoResultFoundWidget()
                                      : Expanded(
                                          child: ListView.separated(
                                              controller: _scrollController,
                                              keyboardDismissBehavior:
                                                  ScrollViewKeyboardDismissBehavior
                                                      .onDrag,
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    CustomListTileWidget(
                                                        onTap: () {
                                                          recnetlyVisiteSortAddDataFn(
                                                              LocalResult(
                                                            collection:
                                                                filterResultData[
                                                                        index]
                                                                    .collection
                                                                    .getLocalCategoryName(),
                                                            duration:
                                                                filterResultData[
                                                                        index]
                                                                    .duration!,
                                                            entityId:
                                                                filterResultData[
                                                                        index]
                                                                    .entityId!,
                                                            image:
                                                                filterResultData[
                                                                        index]
                                                                    .image!,
                                                            level:
                                                                filterResultData[
                                                                        index]
                                                                    .level!,
                                                            matchScore:
                                                                filterResultData[
                                                                        index]
                                                                    .matchScore!,
                                                            title:
                                                                filterResultData[
                                                                        index]
                                                                    .title!,
                                                            categories:
                                                                List.from(
                                                              filterResultData[
                                                                      index]
                                                                  .categories!
                                                                  .map((e) =>
                                                                      e.label)
                                                                  .toList(),
                                                            ),
                                                            goals: List.from(
                                                              filterResultData[
                                                                      index]
                                                                  .goals!
                                                                  .map((e) =>
                                                                      e.label)
                                                                  .toList(),
                                                            ),
                                                          ));
                                                          context.hideKeypad();
                                                          checkCollectionAndNavigate(
                                                              filterResultData[
                                                                      index]
                                                                  .collection!,
                                                              filterResultData[
                                                                      index]
                                                                  .entityId
                                                                  .toString(),
                                                              context);
                                                          if (EveentTriggered
                                                                  .search_result_clicked !=
                                                              null) {
                                                            EveentTriggered
                                                                    .search_result_clicked!(
                                                                _searchController
                                                                    .text
                                                                    .trim(),
                                                                filterResultData[
                                                                        index]
                                                                    .entityId
                                                                    .toString(),
                                                                filterResultData[
                                                                        index]
                                                                    .title
                                                                    .toString());
                                                          }
                                                        },
                                                        imageHeaderIcon:
                                                            checkCollectionShowImage(
                                                                filterResultData[
                                                                        index]
                                                                    .collection!,
                                                                index,
                                                                context),
                                                        imageUrl:
                                                            filterResultData[
                                                                    index]
                                                                .image
                                                                .toString(),
                                                        subtitle:
                                                            '${filterResultData[index].duration} min • ${filterResultData[index].categories?.map((e) => e.label).join(',')} • ${filterResultData[index].level}',
                                                        title: filterResultData[
                                                                index]
                                                            .title
                                                            .toString()),
                                                    if (index ==
                                                            filterResultData
                                                                    .length -
                                                                1 &&
                                                        nextPage == false)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(8.0)
                                                                .copyWith(
                                                                    top: 12),
                                                        child: Text(
                                                          context.loc
                                                              .nothingToLoadText,
                                                          style: AppTypography
                                                              .label14SM,
                                                        ),
                                                      )
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 12, bottom: 12),
                                                  child: CustomDividerWidget(
                                                      indent: 102),
                                                );
                                              },
                                              itemCount:
                                                  filterResultData.length),
                                        ),
                              if (isLoadMore == true)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: BaseHelper.loadingWidget(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (isLoadingNotifier) ...[
                        ModalBarrier(
                            dismissible: false,
                            color: AppColor.surfaceBackgroundColor),
                        Center(child: BaseHelper.loadingWidget()),
                      ]
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Column recentSearchRecentlyVisitWidget() {
    return Column(
      children: [
        if (recentSearchLocalList?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RowEndToEndTextWidget(
                    seeOnTap: () async {
                      await recentSearchLocalList!.clear();
                      setState(() {});
                    },
                    columnText1: context.loc.recentTitle("search"),
                    rowText1: context.loc.clearText),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      alignment: WrapAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: recentSearchLocalList!.values.toList().map((e) {
                        return Container(
                          constraints: BoxConstraints(
                            minWidth: 0,
                            maxWidth: context.dynamicWidth * 0.41,
                          ),
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  context.hideKeypad();

                                  _searchController.text =
                                      e.recentSearch.values.first;
                                  await recentSearchSortAddDataFn();
                                  resultPage = true;
                                  await getdata(
                                      isScroll: false,
                                      text: e.recentSearch.values.first);
                                  resultPage = true;
                                  if (EveentTriggered.search_term != null) {
                                    EveentTriggered.search_term!(
                                        _searchController.text.trim());
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                        AppAssets.recentSearchIcon),
                                    8.width(),
                                    Expanded(
                                      child: Text(
                                        e.recentSearch.values.first,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.label16MD.copyWith(
                                            color: AppColor.linkPrimaryColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              8.height(),
                              const CustomDividerWidget(
                                thickness: 1,
                              )
                            ],
                          ),
                        );
                      }).toList()),
                )
              ],
            ),
          ),
        if (recentlyVisitedLocalList?.isNotEmpty ?? false)
          Expanded(
            child: Column(
              children: [
                RowEndToEndTextWidget(
                    seeOnTap: () {
                      recentlyVisitedLocalList?.clear();
                      setState(() {});
                    },
                    columnText1: context.loc.recentTitle("visit"),
                    rowText1: context.loc.clearText),
                12.height(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.textInvertEmphasis),
                    child: ListView.separated(
                      itemCount: recentlyVisitedLocalList!.length,
                      controller: _scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 20),
                      itemBuilder: (context, index) {
                        return CustomListTileWidget(
                          imageUrl: recentlyVisitedLocalList!.values
                              .toList()[index]
                              .recentlyVisited
                              .values
                              .first
                              .image
                              .toString(),
                          title: recentlyVisitedLocalList!.values
                              .toList()[index]
                              .recentlyVisited
                              .values
                              .first
                              .title
                              .toString(),
                          onTap: () {
                            checkCollectionAndNavigate(
                                recentlyVisitedLocalList!.values
                                    .toList()[index]
                                    .recentlyVisited
                                    .values
                                    .first
                                    .collection
                                    .getCategoryName(),
                                recentlyVisitedLocalList!.values
                                    .toList()[index]
                                    .recentlyVisited
                                    .values
                                    .first
                                    .entityId!,
                                context);
                          },
                          imageHeaderIcon: checkCollectionShowImage(
                              recentlyVisitedLocalList!.values
                                  .toList()[index]
                                  .recentlyVisited
                                  .values
                                  .first
                                  .collection
                                  .getCategoryName(),
                              index,
                              context),
                          subtitle:
                              '${recentlyVisitedLocalList!.values.toList()[index].recentlyVisited.values.first.duration} ${context.loc.minText} • ${recentlyVisitedLocalList!.values.toList()[index].recentlyVisited.values.first.categories?.map((e) => e).join(',')} • ${recentlyVisitedLocalList!.values.toList()[index].recentlyVisited.values.first.level}',
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: CustomDividerWidget(indent: 102),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  void checkCollectionAndNavigate(
      CategoryName categoryName, String id, BuildContext context) {
    if (categoryName == CategoryName.workouts) {
      context.navigateTo(WorkoutDetailView(id: id));
    } else if (categoryName == CategoryName.videoClasses) {
      context.navigateTo(VideoAudioDetailView(id: id));
    } else if (categoryName == CategoryName.audioClasses) {
      context.navigateTo(VideoAudioDetailView(id: id));
    } else if (categoryName == CategoryName.trainingPlans) {
      context.navigateTo(TrainingPlanDetailView(id: id));
    }
  }

  String checkCollectionShowImage(
      CategoryName categoryName, int index, BuildContext context) {
    if (categoryName == CategoryName.workouts) {
      return AppAssets.workoutHeaderIcon.toString();
    } else if (categoryName == CategoryName.videoClasses) {
      return AppAssets.videoPlayIcon.toString();
    } else if (categoryName == CategoryName.audioClasses) {
      return AppAssets.headPhoneIcon.toString();
    } else if (categoryName == CategoryName.trainingPlans) {
      return AppAssets.calendarIcon.toString();
    }
    return "";
  }

  void onFiltertapFn() {
    for (var element in filterList) {
      if (element.entries.first.value == true) {
        if (searchContentData!.cursors!
            .any((e) => e.collection == element.entries.first.key)) {
          filterResultData.addAll(resultData
              .where((a) => a.collection == element.entries.first.key));
        } else {
          nextPage = false;
          filterResultData.addAll(resultData
              .where((a) => a.collection == element.entries.first.key));
        }
      }
    }
  }

  Widget buildSuggestions() {
    if (topMatches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: StringComparator(
        string1: topMatches,
        string2: _searchController,
        onTap: (p0) async {
          context.hideKeypad();
          _searchController.text = p0;
          await recentSearchSortAddDataFn();
          resultPage = true;

          await getdata(isScroll: false, text: _searchController.text);
          if (EveentTriggered.search_term != null) {
            EveentTriggered.search_term!(_searchController.text.trim());
          }
        },
      ),
    );
  }
}

class SearchConatinerWIdget extends StatefulWidget {
  final bool isActive;
  final String title;
  final Function(String) onIconTap, onFilterTap;
  const SearchConatinerWIdget(
      {super.key,
      required this.onFilterTap,
      required this.onIconTap,
      required this.title,
      required this.isActive});

  @override
  State<SearchConatinerWIdget> createState() => _SearchConatinerWIdgetState();
}

class _SearchConatinerWIdgetState extends State<SearchConatinerWIdget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onFilterTap(widget.title);
      },
      child: CancelIconContainerWidget(
        onIconTap: () {
          setState(() {});
          widget.onIconTap(widget.title);
        },
        e: widget.title,
        isActive: widget.isActive,
      ),
    );
  }
}

class StringComparator extends StatefulWidget {
  const StringComparator(
      {super.key,
      required this.string1,
      required this.string2,
      required this.onTap});
  final List<String> string1;
  final TextEditingController string2;
  final Function(String) onTap;

  @override
  State<StringComparator> createState() => _StringComparatorState();
}

class _StringComparatorState extends State<StringComparator> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.string1.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColor.linkPrimaryColor,
                size: 20,
              ),
              8.width(),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.label16MD,
                    children: _compareWords(widget.string1[index],
                        widget.string2.text, widget.onTap),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<TextSpan> _compareWords(
      String text1, String text2, void Function(String) onTap) {
    List<TextSpan> spans = [];

    for (int j = 0; j < text1.length; j++) {
      bool isMatched = j < text2.length &&
          text1[j].toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]+'), '') ==
              text2[j].toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]+'), '');

      spans.add(
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onTap(text1);
              },
            text: text1[j],
            style: AppTypography.label16MD.copyWith(
              color: isMatched
                  ? AppColor.linkPrimaryColor
                  : AppColor.linkSecondaryColor,
            )),
      );
    }

    return spans;
  }
}
