import 'package:flutter/material.dart';
import 'package:may_be_clean/widgets/widgets.dart';

class MyVerifyScreen extends StatefulWidget {
  const MyVerifyScreen({super.key});

  @override
  State<MyVerifyScreen> createState() => _MyVerifyScreenState();
}

class _MyVerifyScreenState extends State<MyVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "내가 인증한 가게"),
    );
  }
}
