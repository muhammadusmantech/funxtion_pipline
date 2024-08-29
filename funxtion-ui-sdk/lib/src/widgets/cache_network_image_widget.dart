
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_tool_kit/ui_tool_kit.dart';

CachedNetworkImage cacheNetworkWidget(
  BuildContext context, {
  required String imageUrl,
  required int width,
  required int height,
}) {

  return CachedNetworkImage(


    imageUrl: !imageUrl.contains("vixyvideo")
        ? imageUrl
        : "$imageUrl/width/${width * 1.5}/height/${height * 1.5}/quality/1500",

    fit: BoxFit.cover,


    errorListener: (value) {

    },

    useOldImageOnUrlChange: false,
    progressIndicatorBuilder: (context, url, progress) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: BaseHelper.loadingWidget(value: progress.progress),
        ),
      );
    },

    errorWidget: (context, url, error) {
      return const Icon(Icons.error);
    },
  );
}

ImageProvider<CachedNetworkImageProvider> cachedNetworkImageProvider({
  required String imageUrl,
}) {
  return CachedNetworkImageProvider(
    imageUrl,
  );
}
