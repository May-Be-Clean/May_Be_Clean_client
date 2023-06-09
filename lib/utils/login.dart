import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:developer';
import 'package:may_be_clean/utils/utils.dart';

Future<void> kakaoLogin(Function() loginStart, Function() loginEnd) async {
  try {
    OAuthToken oauth;

    final isInstalled = await isKakaoTalkInstalled();

    if (isInstalled) {
      oauth = await UserApi.instance.loginWithKakaoTalk();
    } else {
      oauth = await UserApi.instance.loginWithKakaoAccount();
    }

    loginStart();

    oauth.toJson().forEach((key, value) {
      log("$key: $value");
    });
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
