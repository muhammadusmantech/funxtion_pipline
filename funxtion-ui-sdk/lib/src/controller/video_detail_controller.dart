import 'package:flutter/foundation.dart';
import 'package:funxtion/funxtion_sdk.dart';

import 'package:video_player/video_player.dart';

import '../../ui_tool_kit.dart';

class VideoDetailController {
  static Future<OnDemandModel?> getAOnDemandDataFn(context,
      {required String id}) async {
    try {
      final fetchedData = await OnDemandRequest.onDemandById(id: id);
      if (fetchedData != null) {
        OnDemandModel data = OnDemandModel.fromJson(fetchedData);
        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }

    return null;
  }

  static String getOnDemandCategoryDataFn(
    OnDemandModel data,
  ) {
    List<ContentProvidersCategoryOnDemandModel> onDemandCategoryData = [];
    for (var i = 0; i < data.categories!.length; i++) {
      for (var element in CommonController.onDemandCategoryData) {
        if (element.id.toString() == data.categories![i]) {
          onDemandCategoryData.add(element);
        }
      }
    }

    return onDemandCategoryData.map((e) => e.name).join(',');
  }

  static Future<InstructorModel?> getInstructorFn(context,
      {required String id}) async {
    try {
      final fetchData = await InstructorRequest.instructorsById(id: id);
      if (fetchData != null) {
        InstructorModel data = InstructorModel.fromJson(fetchData);
        return data;
      }
    } on RequestException catch (e) {
      BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
    }
    return null;
  }

  static ValueNotifier<bool> showControls = ValueNotifier(false);



  static String getPosition(VideoPlayerValue value) {
    final duration =
        Duration(milliseconds: value.position.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((x) => x.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  static String getFormatPosition(double value) {
    final duration = Duration(milliseconds: value.toInt());

    return duration.toString();
  }

  static String getVideoDuration(VideoPlayerValue value) {
    final duration =
        Duration(milliseconds: value.duration.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}
