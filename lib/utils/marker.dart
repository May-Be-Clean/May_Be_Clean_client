import 'dart:ui';
import 'package:flutter/services.dart';

Future<Uint8List> markerImageTransform(String type1, String type2) async {
  String marker = 'assets/icons/marker/${type1.toLowerCase()}';
  if (type2 != '') {
    marker += '_${type2.toLowerCase()}';
  }
  marker += '.png';

  ByteData data = await rootBundle.load(marker);

  Codec codec =
      await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 120);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
