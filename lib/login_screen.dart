import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/font.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/utils/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final bool isBackbuttonAllow;
  const LoginScreen({this.isBackbuttonAllow = false, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isProcess = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/splash/login_background.png',
          fit: BoxFit.cover,
        ),
        Positioned(
          left: 20,
          top: MediaQuery.of(context).viewPadding.top,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset('assets/icons/navigation/left.svg'),
          ),
        ),
        SizedBox(
          width: Get.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_isProcess) return;
                  kakaoLogin(() {
                    setState(() {
                      _isProcess = true;
                    });
                  }, () {
                    setState(() {
                      _isProcess = false;
                    });
                  });
                },
                child: Image.asset('assets/icons/login/kakao_login.png'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (_isProcess) return;
                  appleLogin(() {
                    setState(() {
                      _isProcess = true;
                    });
                  }, () {
                    setState(() {
                      _isProcess = false;
                    });
                  });
                },
                child: Image.asset('assets/icons/login/apple_login.png'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setString('accessToken', '');
                  });
                  Get.to(() => const HomeScreen());
                },
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1))),
                  child: Text(
                    "게스트로 로그인",
                    style: FontSystem.body2.copyWith(
                        color: Colors.white, decoration: TextDecoration.none),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
