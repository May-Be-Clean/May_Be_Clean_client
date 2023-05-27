import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:may_be_clean/utils/utils.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _isSigning = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                try {
                  OAuthToken oauth;

                  final isInstalled = await isKakaoTalkInstalled();

                  if (isInstalled) {
                    oauth = await UserApi.instance.loginWithKakaoTalk();
                  } else {
                    oauth = await UserApi.instance.loginWithKakaoAccount();
                  }

                  log(oauth.accessToken);
                  log(oauth.expiresAt.toString());
                  log(oauth.refreshToken.toString());

                  setState(() {
                    _isSigning = true;
                  });
                } catch (e, s) {
                  setState(() {
                    _isSigning = false;
                  });

                  if (e is KakaoAuthException &&
                      e.error.toString() == "access_denied") {
                    return;
                  }

                  showToast("로그인 중 문제가 발생하였습니다");
                  log(e.toString(), stackTrace: s);
                }
              },
              child: Text("로그인")),
        ],
      ),
    );
  }
}
