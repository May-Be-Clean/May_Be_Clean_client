import 'dart:io';
import 'dart:developer';

import 'package:may_be_clean/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/screens.dart';
import 'package:image_picker/image_picker.dart';

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Future<List<File>> pickImage(int count) async {
  try {
    final List<XFile?> images = await ImagePicker().pickMultiImage(
      maxWidth: 512,
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
