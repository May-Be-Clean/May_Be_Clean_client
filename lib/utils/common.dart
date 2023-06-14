import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:may_be_clean/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:may_be_clean/screens.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Future<List<File>> pickImage(int count) async {
  try {
    final List<XFile?> images = await ImagePicker().pickMultiImage(
      maxHeight: 1024,
      requestFullMetadata: false,
    );

    if (count + images.length > 10) {
      showToast('사진은 최대 10장까지 업로드 가능합니다.');
      images.removeRange(10 - count, images.length);
    }

    return images.map((image) => File(image!.path)).toList();
  } catch (e, s) {
    log(e.toString(), stackTrace: s);
    return [];
  }
}

Future<File> getImage(String url) async {
  final Response res = await Dio().get<List<int>>(
    url,
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );

  final Directory appDir = await getApplicationDocumentsDirectory();

  final String imageName = url.split('/').last;

  final File file = File(join(appDir.path, imageName));

  file.writeAsBytesSync(res.data as List<int>);

  return file;
}

void loginRequest(BuildContext context) async {
  final result = await showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('로그인이 필요한 서비스에요.'),
        content: const Text('로그인 페이지로 이동할까요?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('취소'),
            onPressed: () {
              Get.back(result: "cancel");
            },
          ),
          CupertinoDialogAction(
            child: const Text('확인'),
            onPressed: () {
              Get.back(result: "ok");
            },
          ),
        ],
      );
    },
  );
  if (result == null || result == "cancel") {
    return;
  }
  if (result == "ok") {
    Get.to(() => const LoginScreen());
    return;
  }
}

void changeMapMode(GoogleMapController mapController) {
  getJsonFile("assets/map_style.json")
      .then((value) => setMapStyle(value, mapController));
}

//helper function
void setMapStyle(String mapStyle, GoogleMapController mapController) {
  mapController.setMapStyle(mapStyle);
}

//helper function
Future<String> getJsonFile(String path) async {
  ByteData byte = await rootBundle.load(path);
  var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
  return utf8.decode(list);
}
