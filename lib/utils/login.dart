import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:developer';
import 'package:may_be_clean/utils/utils.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/models/model.dart' as model;

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
    globalStates.login(user);
    log('KAKAO SUCESS : ${user.email}');

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
  // try {
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     webAuthenticationOptions: WebAuthenticationOptions(
  //       clientId: "app.weecan.com",
  //       redirectUri:
  //           Uri.parse("${ENV.apiEndpoint}/callbacks/sign_in_with_apple"),
  //     ),
  //   );

  //   setState(() {
  //     _isSigning = true;
  //   });

  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     accessToken: appleCredential.authorizationCode,
  //   );

  //   FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // } catch (e, s) {
  //   setState(() {
  //     _isSigning = false;
  //   });

  //   if (e is SignInWithAppleAuthorizationException) {
  //     if (e.code == AuthorizationErrorCode.canceled) {
  //       return;
  //     }
  //   }

  //   showToast("로그인 중 문제가 발생하였습니다");
  //   log(e.toString(), stackTrace: s);
  // }
}
