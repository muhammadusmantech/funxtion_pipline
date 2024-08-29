import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:funxtion/funxtion_sdk.dart';
import 'package:ui_tool_kit/l10n/app_localizations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../ui_tool_kit.dart';
import 'package:dio/dio.dart';

class UiToolKitSDK extends StatefulWidget {
  final Locale? locale;
  final String? contentPackageId;
  final Function(List<FollowTrainingPlanModel>, Dio)? readWriteTrainingPlan;
  final String token;
  final CategoryName categoryName;
  const UiToolKitSDK(
      {super.key,
      this.locale,
      required this.token,
      this.contentPackageId,
      required this.categoryName,
      this.readWriteTrainingPlan});

  @override
  State<UiToolKitSDK> createState() => _UiToolKitSDKState();
}

class _UiToolKitSDKState extends State<UiToolKitSDK>
    with WidgetsBindingObserver {
  @override
  void initState() {
    if (EveentTriggered.app_open != null) {
      EveentTriggered.app_open!();
    }
    setLocale();
    setToken();
    setPackageIdFn();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _disableWakelockIfEnabled();
    }
  }

  Future<void> _disableWakelockIfEnabled() async {
    bool isWakelockEnabled = await WakelockPlus.enabled;
    if (isWakelockEnabled) {
      WakelockPlus.disable();
    }
  }

  setLocale() {
    if (widget.locale != null) {
      AppLanguage.setLanguageCode = widget.locale?.languageCode;
    } else {
      AppLanguage.setLanguageCode =
          PlatformDispatcher.instance.locale.languageCode;
    }
  }

  setToken() {
    BearerToken.setToken = widget.token;
  }

  setPackageIdFn() {
    ContentPackage.setContentPackageId = widget.contentPackageId;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: widget.locale,
        debugShowCheckedModeBanner: false,
        home: HomePage(
          categoryName: widget.categoryName,
          readWriteTrainingPlanFn: widget.readWriteTrainingPlan,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('it'),
          Locale('pl'),
          Locale('nl')
        ]);
  }
}

class HomePage extends StatefulWidget {
  final CategoryName categoryName;
  final Function(List<FollowTrainingPlanModel>, Dio)? readWriteTrainingPlanFn;
  const HomePage(
      {super.key, required this.categoryName, this.readWriteTrainingPlanFn});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<OnDemandModel> onDemandDataVideo = [];

  List<WorkoutModel> workoutData = [];
  List<OnDemandModel> onDemandDataAudio = [];
  List<TrainingPlanModel> trainingPlanData = [];

  Map<int, String> workoutDataType = {};
  Map<int, String> videoDataType = {};
  Map<int, String> audioDataType = {};
  Map<int, String> fitnessGoalData = {};
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isInitlize = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    fetchData();
    getPath();
  }

  @override
  void dispose() {
    HiveLocalController.closeHive();

    super.dispose();
  }

  Future getPath() async {
    if (widget.categoryName == CategoryName.trainingPlans ||
        widget.categoryName == CategoryName.dashBoard) {
      await HiveLocalController.openTrainingBox();
      readWriteTrainingPlanFn();
    }
  }

  fetchData() async {
    if (widget.categoryName == CategoryName.dashBoard) {
      await DashBoardController.getData(context,
          audioDataType: audioDataType,
          videoDataType: videoDataType,
          workoutDataType: workoutDataType,
          isLoading: isLoading,
          onDemandDataVideo: onDemandDataVideo,
          audioData: onDemandDataAudio,
          workoutData: workoutData,
          trainingPlanData: trainingPlanData,
          filterFitnessGoalData: fitnessGoalData);
    }
  }

  readWriteTrainingPlanFn() async {
    if (widget.readWriteTrainingPlanFn != null) {
      NetworkHelper networkHelper = NetworkHelper();
      try {
        await widget.readWriteTrainingPlanFn!(
            Boxes.getTrainingPlanBox().values.toList(), networkHelper.dio);
      } on RequestException catch (e) {
        if (context.mounted) {
           BaseHelper.showSnackBar(context, 'No internet connection');
          // BaseHelper.showSnackBar(context, e.message);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, value, child) {
          if (value == true) {
            return Scaffold(
              backgroundColor: AppColor.surfaceBrandDarkColor,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                AppAssets.logo,
                              ))),
                    ),
                    20.height(),
                    const Center(child: ThreeDotLoader()),
                  ]),
            );
          }

          if (value == false) {
            if (widget.categoryName == CategoryName.dashBoard) {
              if (EveentTriggered.session_start != null) {
                EveentTriggered.session_start!();
              }
              return DashBoardView(
                  onDemandDataVideo: onDemandDataVideo,
                  workoutData: workoutData,
                  onDemandDataAudio: onDemandDataAudio,
                  trainingPlanData: trainingPlanData,
                  workoutDataType: workoutDataType,
                  videoDataType: videoDataType,
                  audioDataType: audioDataType,
                  fitnessGoalData: fitnessGoalData);
            } else if (widget.categoryName == CategoryName.contentDiscovery) {
              return const SearchContentView();
            } else if (widget.categoryName == CategoryName.audioClasses) {
              return VideoAudioWorkoutListView(
                  categoryName: widget.categoryName);
            } else if (widget.categoryName == CategoryName.videoClasses) {
              return VideoAudioWorkoutListView(
                  categoryName: widget.categoryName);
            } else if (widget.categoryName == CategoryName.workouts) {
              return VideoAudioWorkoutListView(
                  categoryName: widget.categoryName);
            } else if (widget.categoryName == CategoryName.trainingPlans) {
              return const TrainingPlanListView(initialIndex: 0);
            }
          }

          return Container();
        });
  }
}

class ThreeDotLoader extends StatefulWidget {
  const ThreeDotLoader({super.key});

  @override
  State<ThreeDotLoader> createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _animation1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.0, curve: Curves.easeInOut),
      ),
    );
    _animation4 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );
    _animation5 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation1.value,
                child: child,
              );
            },
            child: const Dot(),
          ),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation2.value,
                child: child,
              );
            },
            child: const Dot(),
          ),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: _animation3,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation3.value,
                child: child,
              );
            },
            child: const Dot(),
          ),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: _animation4,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation4.value,
                child: child,
              );
            },
            child: const Dot(),
          ),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: _animation5,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation5.value,
                child: child,
              );
            },
            child: const Dot(),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.textInvertEmphasis,
      ),
    );
  }
}
