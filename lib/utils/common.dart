import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

import 'package:may_be_clean/utils/utils.dart';

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
