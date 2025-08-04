import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'app-assets.dart';

Future<void> preloadImages() async {
  final List<String> assetPaths = [
    AppAssets.appIcon,
    AppAssets.jobCardIcon,
    AppAssets.mobileIcon,
    AppAssets.companyIcon,
    AppAssets.seekerIcon,
    AppAssets.googleIcon,

  ];

  await Future.wait(assetPaths.map((path) => loadImage(path)));
}
Future<void> loadImage(String path) {
  final Completer<void> completer = Completer();
  final ImageStream stream = AssetImage(path).resolve(const ImageConfiguration());

  stream.addListener(
    ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
        completer.complete();
      },
      onError: (dynamic error, StackTrace? stackTrace) {
        completer.completeError(error);
      },
    ),
  );
  return completer.future;
}