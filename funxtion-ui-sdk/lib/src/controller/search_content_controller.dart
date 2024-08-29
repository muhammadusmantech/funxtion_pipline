import 'package:flutter/material.dart';
import 'package:funxtion/funxtion_sdk.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class SearchContentController {
  static Future<SearchContentModel?> fetchDataFn(
    BuildContext context, {
    required Map<String, dynamic> data,
    required SearchContentModel? searchContentData,
  }) async {
    SearchContentModel? dataFetched;
    try {
      await SearchContentRequest.searchContent(data: data).then((value) async {
        if (value != null) {
          dataFetched = SearchContentModel.fromJson(value);
        } else {
          dataFetched = null;
        }
      });
    } on RequestException catch (e) {
      if (context.mounted) {
        BaseHelper.showSnackBar(context, 'No internet connection');
// BaseHelper.showSnackBar(context, e.message);
      }

      dataFetched = null;
    }
    return dataFetched;
  }
}
