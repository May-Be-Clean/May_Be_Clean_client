import 'dart:ui';
import 'package:flutter/services.dart';

Future<Uint8List> markerImageTransform(List<String> categories) async {
  String marker = "assets/icons/marker/";
  if (categories.isEmpty ||
      (!categories.contains("REFILL") &&
          !categories.contains("NO_DISPOSABLE") &&
          !categories.contains("UPCYCLE"))) {
    marker += "default";
  } else {
    if (categories.contains("REFILL")) {
      marker += "refill";
    } else if (categories.contains("NO_DISPOSABLE")) {
      marker += "nodisposable";
    } else if (categories.contains("UPCYCLE")) {
      marker += "upcycle";
    }
  }
  if (categories.contains("REFILL") &&
      categories.contains("NO_DISPOSABLE") &&
      categories.contains("UPCYCLE")) {
    if (categories.contains("RESTAURANT")) {
      marker += "_restaurant";
    } else if (categories.contains("CAFE")) {
      marker += "_cafe";
    } else if (categories.contains("ACCESSORY")) {
      marker += "_accessory";
    }
  }
  marker += ".png";

  ByteData data = await rootBundle.load(marker);

  Codec codec =
      await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 120);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
