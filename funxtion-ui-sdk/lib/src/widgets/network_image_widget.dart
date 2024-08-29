import 'package:flutter/material.dart';

import 'package:ui_tool_kit/ui_tool_kit.dart';

class NetworkImageWidget extends StatelessWidget {
  final String url;
  final int height;
  final int width;
  const NetworkImageWidget(
      {super.key,
      required this.url,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: BaseHelper.loadingWidget(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      !url.contains("vixyvideo")
          ? url
          : "$url/width/${width * 1}/height/${height * 1}/quality/1500",
    );
  }
}
