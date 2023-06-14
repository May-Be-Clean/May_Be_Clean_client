import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';
import 'package:may_be_clean/utils/utils.dart';

Future<void> urlLauncher(String url) async {
  try {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  } catch (e, s) {
    showToast('링크를 여는데 실패했습니다.');
    log(e.toString(), stackTrace: s);
  }
}
