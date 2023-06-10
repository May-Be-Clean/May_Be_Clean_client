import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:developer';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/models/model.dart' as model;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<void> kakaoLogin(Function() loginStart, Function() loginEnd) async {
  final globalStates = Get.find<GlobalState>();
  try {
    OAuthToken oauth;

    final isInstalled = await isKakaoTalkInstalled();
    loginStart();
    if (isInstalled) {
      oauth = await UserApi.instance.loginWithKakaoTalk();
    } else {
      oauth = await UserApi.instance.loginWithKakaoAccount();
    }

    final model.User user = await model.User.authKakao(oauth.accessToken);
    globalStates.setAutoLogin(user.accessToken ?? "");
    final model.UserData userData =
        await model.UserData.getUserData(user.accessToken!);
    globalStates.innerLogin(userData);

    loginEnd();
  } catch (e, s) {
    loginEnd();

    if (e is KakaoAuthException && e.error.toString() == "access_denied") {
      return;
    }

    showToast("로그인 중 문제가 발생하였습니다");
    log(e.toString(), stackTrace: s);
  }
}

Future<void> appleLogin(Function() loginStart, Function() loginEnd) async {
  try {
    loginStart();
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: "plant.may-be-clean.com",
        redirectUri: Uri.parse(
          "https://develop.api.maybeclean.link/callbacks/sign_in_with_apple",
        ),
      ),
    );

    log(appleCredential.toString());
    log(appleCredential.authorizationCode.toString());
    loginEnd();
  } catch (e, s) {
    loginEnd();

    if (e is SignInWithAppleAuthorizationException) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return;
      }
    }

    showToast("로그인 중 문제가 발생하였습니다");
    log(e.toString(), stackTrace: s);
  }
}
