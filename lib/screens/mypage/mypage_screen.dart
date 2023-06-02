import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/widgets/widgets.dart';


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
      padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/review/kind.png",
                  scale: 1.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "환경수호자",
                  style: FontSystem.body1.copyWith(
                    color: ColorSystem.primary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      "새싹밭의 파수꾼",
                      style: FontSystem.subtitleSemiBold.copyWith(),
                    ),
                    GestureDetector(
                      onTap: () {}, //이름 바꾸기
                      child: SvgPicture.asset('assets/icons/category/edit.svg'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bronze",
                      style: FontSystem.caption.copyWith(
                        color: ColorSystem.gray2,
                      ),
                    ),
                    Text(
                      "silver",
                      style: FontSystem.caption.copyWith(
                        color: ColorSystem.gray2,
                      ),
                    ),
                  ],
                ),
                WeecanProgressBar(
                  60, // 남은 경험치 / 현재레벨 경험치
                  barHeight: 10,
                  color: ColorSystem.primary,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "0",
                      style: FontSystem.caption.copyWith(
                        color: ColorSystem.gray1,
                      ),
                    ),
                    Text(
                      "N",
                      style: FontSystem.caption.copyWith(
                        color: ColorSystem.gray1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyPageButton(
                      Title: "내가 작성한 후기",
                      Count: "8",
                      onTap: () {},
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      color: ColorSystem.gray2,
                      width: 1,
                      height: 50,
                    ),
                    MyPageButton(
                      Title: "내가 등록한 가게",
                      Count: "8",
                      onTap: () {},
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      color: ColorSystem.gray2,
                      width: 1,
                      height: 50,
                    ),
                    MyPageButton(
                      Title: "내가 인증한 가게",
                      Count: "8",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "앱 정보",
                    style: FontSystem.body1.copyWith(),
                  ),
                ),
                MyPageInformationButton(title: "서비스 이용약관", onTap: () {}),
                MyPageInformationButton(title: "이용규칙", onTap: () {}),
                MyPageInformationButton(title: "개인정보 처리 방침", onTap: () {}),
                MyPageInformationButton(title: "오픈소스 사용정보", onTap: () {}),
              ],
            ),

            // TextButton(
            //     onPressed: () async {
            //       try {
            //         OAuthToken oauth;

            //         final isInstalled = await isKakaoTalkInstalled();

            //         if (isInstalled) {
            //           oauth = await UserApi.instance.loginWithKakaoTalk();
            //         } else {
            //           oauth = await UserApi.instance.loginWithKakaoAccount();
            //         }

            //         log(oauth.accessToken);
            //         log(oauth.expiresAt.toString());
            //         log(oauth.refreshToken.toString());

            //         setState(() {
            //           _isSigning = true;
            //         });
            //       } catch (e, s) {
            //         setState(() {
            //           _isSigning = false;
            //         });

            //         if (e is KakaoAuthException &&
            //             e.error.toString() == "access_denied") {
            //           return;
            //         }

            //         showToast("로그인 중 문제가 발생하였습니다");
            //         log(e.toString(), stackTrace: s);
            //       }
            //     },
            //     child: Text("로그인")),
          ],
        ),

      ),
    );
  }
}
