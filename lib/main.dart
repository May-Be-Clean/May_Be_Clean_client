import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:may_be_clean/env/env.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: ENV.kakaoNativeKey);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyBeClean());
}

class MyBeClean extends StatelessWidget {
  const MyBeClean({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: child!,
      ),
      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      initialBinding: BindingsBuilder(() {
        Get.put(GlobalState());
        Get.put(StoreState());
      }),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: ColorSystem.primary,
          primary: ColorSystem.primary,
        ),
        fontFamily: 'pretendard',
      ),
    );
  }
}
