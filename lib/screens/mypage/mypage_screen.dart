import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/models/model.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _globalState = Get.find<GlobalState>();
  bool _isProcess = false;

  @override
  void initState() {
    super.initState();
    UserData.getUserData(_globalState.token).then((value) {
      _globalState.userData = value;
      setState(() {});
    });
  }

  void loginStart() {
    setState(() {
      _isProcess = true;
    });
  }

  void loginEnd() {
    setState(() {
      _isProcess = false;
    });
  }

  Widget _requestLogin() {
    return Column(
      children: [
        const CustomTooltip(
          message: "깨끗해질지도의 그린 컨슈머가 되어주세요!",
        ),
        SvgPicture.asset(
          'assets/icons/badge/level0.svg',
          width: 100,
          height: 100,
        ),
        const Text("로그인이 필요한 서비스입니다.", style: FontSystem.subtitleSemiBold),
        const SizedBox(height: 30),
        if (_isProcess)
          Container(
              height: 80,
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  if (_isProcess) return;
                  setState(() {
                    kakaoLogin(loginStart, loginEnd);
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/login/kakao_small.svg'),
                    const Text("카카오 로그인", style: FontSystem.caption)
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isProcess) return;
                  setState(() {
                    appleLogin(loginStart, loginEnd);
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/login/apple_small.svg'),
                    const Text("애플 로그인", style: FontSystem.caption)
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _myPage() {
    return Column(
      children: [
        CustomTooltip(
          message: expToTooltip(_globalState.userData?.user.point ?? 0),
        ),
        SvgPicture.asset(
          expToBadge(_globalState.userData?.user.point ?? 20),
          width: 100,
          height: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          expToBadgeTitle(_globalState.userData?.user.point ?? 0),
          style: FontSystem.body1.copyWith(
            color: ColorSystem.primary,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _globalState.userData?.user.nickname ?? "익명의 유저",
          style: FontSystem.subtitleSemiBold.copyWith(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              expToBadgeTitle(_globalState.userData?.user.point ?? 0),
              style: FontSystem.caption.copyWith(
                color: ColorSystem.gray1,
              ),
            ),
            Text(
              expNextTitle(_globalState.userData?.user.point ?? 0),
              style: FontSystem.caption.copyWith(
                color: ColorSystem.gray1,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: ProgressBar(
            expPercent(_globalState.userData?.user.point ?? 0),
            barHeight: 10,
            color: ColorSystem.primary,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              expPrevious(_globalState.userData?.user.point ?? 0),
              style: FontSystem.caption.copyWith(
                color: ColorSystem.gray1,
              ),
            ),
            Text(
              expNext(_globalState.userData?.user.point ?? 0),
              style: FontSystem.caption.copyWith(
                color: ColorSystem.gray1,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyPageButton(
              title: "내가 작성한 후기",
              count: _globalState.userData?.reviewCount ?? 0,
              onTap: () {
                Get.to(() => const MyReviewScreen());
              },
            ),
            Container(
              color: ColorSystem.gray2,
              width: 1,
              height: 50,
            ),
            MyPageButton(
              title: "내가 찜한 가게",
              count: _globalState.userData?.likedCount ?? 0,
              onTap: () {
                Get.to(() => const LikeScreen());
              },
            ),
            Container(
              color: ColorSystem.gray2,
              width: 1,
              height: 50,
            ),
            MyPageButton(
              title: "내가 등록한 가게",
              count: _globalState.userData?.verifiedCount ?? 0,
              onTap: () {
                Get.to(() => const MyVerifyScreen());
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _myAccountSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(height: 30),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text("계정 관리", style: FontSystem.body1),
        ),
        MyPageInformationButton(
            title: "로그아웃",
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    content: const Text(
                      '로그아웃하시겠어요?',
                      style: FontSystem.body1,
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('취소',
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Get.back();
                          _globalState.innerLogout().then((value) {
                            setState(() {});
                          });
                        },
                        isDestructiveAction: true,
                        child: const Text(
                          '확인',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
        MyPageInformationButton(
            title: "회원 탈퇴",
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text(
                      '정말 탈퇴하시겠어요?',
                    ),
                    content: const Text(
                      '이 동작은 취소할 수 없어요',
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('취소',
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Get.back();
                          _globalState.innerLogout().then((value) {
                            Get.offAll(() => const LoginScreen());
                          });
                        },
                        isDestructiveAction: true,
                        child: const Text(
                          '탈퇴하기',
                          style: TextStyle(
                              color: ColorSystem.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
        child: Column(
          children: [
            if (_globalState.userData == null) _requestLogin() else _myPage(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Divider(height: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("앱 정보", style: FontSystem.body1),
                ),
                MyPageInformationButton(
                    title: "서비스 이용약관",
                    onTap: () {
                      urlLauncher(
                          "https://archive-halfmoon-mind.s3.ap-northeast-2.amazonaws.com/MayBeClean+Usage.html");
                    }),
                MyPageInformationButton(
                    title: "위치정보 이용약관",
                    onTap: () {
                      urlLauncher(
                          "https://archive-halfmoon-mind.s3.ap-northeast-2.amazonaws.com/MayBeClean+Location.html");
                    }),
                MyPageInformationButton(
                    title: "개인정보 처리 방침",
                    onTap: () {
                      urlLauncher(
                          "https://archive-halfmoon-mind.s3.ap-northeast-2.amazonaws.com/MayBeClean+Privacy.html");
                    }),
              ],
            ),
            if (_globalState.userData == null)
              const SizedBox()
            else
              _myAccountSetting(),
          ],
        ),
      ),
    );
  }
}

class CustomTooltip extends StatelessWidget {
  final String message;

  const CustomTooltip({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: ColorSystem.primary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            message,
            style: FontSystem.caption.copyWith(color: ColorSystem.white),
          ),
        ),
        CustomPaint(
          painter: TrianglePainter(),
          child: const SizedBox(width: 20, height: 10),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = ColorSystem.primary;

    var path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyPageButton extends StatelessWidget {
  final String title;
  final int count;
  final Function() onTap;

  const MyPageButton({
    required this.title,
    required this.count,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Text(title, style: FontSystem.caption),
          const SizedBox(
            height: 5,
          ),
          Text(
            count.toString(),
            style: FontSystem.subtitleSemiBold.copyWith(
              color: ColorSystem.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class MyPageInformationButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MyPageInformationButton({
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(title, style: FontSystem.body2),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
