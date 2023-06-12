import 'package:flutter/material.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/models/model.dart';

class MyRegisterScreen extends StatefulWidget {
  const MyRegisterScreen({super.key});

  @override
  State<MyRegisterScreen> createState() => _MyRegisterScreenState();
}

class _MyRegisterScreenState extends State<MyRegisterScreen> {
  final _globalStates = Get.find<GlobalState>();
  final _myRegisterStores = <Store>[];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  Future<void> loadMore() async {
    final stores =
        await Store.getRegistredStores(_globalStates.token, _page, 10);
    _myRegisterStores.addAll(stores);
    _page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "내가 등록한 가게"),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: _myRegisterStores.length,
        itemBuilder: (context, index) {
          final store = _myRegisterStores[index];
          return StoreCard(store);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
