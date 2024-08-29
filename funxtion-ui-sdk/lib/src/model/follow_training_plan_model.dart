import 'package:hive/hive.dart';
part 'follow_training_plan_model.g.dart';

@HiveType(typeId: 0)
class FollowTrainingPlanModel extends HiveObject {
  @HiveField(0)
  String trainingPlanId;
  @HiveField(1)
  List<LocalWorkout> workoutData = [];
  @HiveField(2)
  int workoutCount;
  @HiveField(3)
  int totalWorkoutLength;
  @HiveField(4)
  bool outOfSequence;
  @HiveField(5)
  String trainingPlanTitle;
  @HiveField(6)
  String trainingPlanImg;

  FollowTrainingPlanModel({
    required this.trainingPlanId,
    required this.workoutData,
    required this.workoutCount,
    required this.totalWorkoutLength,
    required this.outOfSequence,
    required this.trainingPlanImg,
    required this.trainingPlanTitle,
  });
}

@HiveType(typeId: 1)
class LocalWorkout {
  @HiveField(0)
  final String workoutTitle;
  @HiveField(1)
  final String workoutSubtitle;
  @HiveField(2)
  final String workoutId;
  @HiveField(3)
  final String workoutImg;

  LocalWorkout(
      {required this.workoutTitle,
      required this.workoutSubtitle,
      required this.workoutId,
      required this.workoutImg});
}
