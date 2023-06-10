import 'package:flutter/material.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';

class MyRegisterScreen extends StatefulWidget {
  const MyRegisterScreen({super.key});

  @override
  State<MyRegisterScreen> createState() => _MyRegisterScreenState();
}

class _MyRegisterScreenState extends State<MyRegisterScreen> {
  final _storeStates = Get.find<GlobalState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "내가 등록한 가게"),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: _storeStates.stores.length,
        itemBuilder: (context, index) {
          final store = _storeStates.stores.values.toList()[index];
          return StoreCard(store);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
