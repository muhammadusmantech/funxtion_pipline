
import 'package:ui_tool_kit/ui_tool_kit.dart';

class EveentTriggered {
  static Function()? app_open;

  static Function()? session_start;
  static Function(String, String)? screen_viewed;
  static Function(String, int)? video_class_searched;

  static Function(int, List<SelectedFilterModel>)? video_class_filtered;
  static Function(String, String, DateTime)? video_class_player_open;
  static Function(String, String, DateTime)? video_class_player_pause;
  static Function(String, String, DateTime, DateTime)? video_class_player_scrub;
  static Function(String, String, DateTime, DateTime)? video_class_player_skip;
  static Function(
    String,
    String,
    DateTime,
  )? video_class_player_close;
  static Function(String, String)? video_class_cta_pressed;
  static Function(String, int)? workouts_searched;
  static Function(int, List<SelectedFilterModel>)? workouts_filtered;
  static Function(String)? workout_preview_expanded;
  static Function(String)? workout_preview_exercise_info;
  static Function(String, DateTime, bool, String?)? workout_started;
  static Function(String, String, String)? workout_player_skip;
  static Function(String, String, String)? workout_player_previous;
  static Function(String, String, String)? workout_player_pause;
  static Function(String, String, String)? workout_player_type_info;
  static Function(String, String, String, String)? workout_player_exercise_info;
  static Function(String, String, String, String)? workout_player_trainer_notes;
  static Function(String, String)? workout_player_overview;
  static Function(String, String, String, String)?
      workout_player_overview_navigate;
  static Function(String, String, int, int, DateTime)? workout_cancelled;
  static Function(
    String,
    String,
    DateTime,
  )? workout_completed;
  static Function(String, int)? plan_searched;
  static Function(int, List<SelectedFilterModel>)? plan_filtered;
  static Function(String, String)? plan_followed;
  static Function(String, String, int, int)? plan_cancelled;
  static Function(String, String)? plan_completed;
  static Function(String, int)? audio_class_searched;
  static Function(int, List<SelectedFilterModel>)? audio_class_filtered;
  static Function(String, String, DateTime)? audio_class_player_open;
  static Function(String, String, DateTime)? audio_class_player_pause;
  static Function(String, String, DateTime, DateTime)? audio_class_player_scrub;
  static Function(String, String, DateTime, DateTime)? audio_class_player_skip;
  static Function(String, String, DateTime)? audio_class_player_close;
  static Function(String)? search_term;
  static Function(String, String, String)? search_result_clicked;
}
