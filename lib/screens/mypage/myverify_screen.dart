import 'package:flutter/material.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/states/global.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:get/get.dart';

class MyVerifyScreen extends StatefulWidget {
  const MyVerifyScreen({super.key});

  @override
  State<MyVerifyScreen> createState() => _MyVerifyScreenState();
}

class _MyVerifyScreenState extends State<MyVerifyScreen> {
  final List<Store> _myVerifyStores = <Store>[];
  int _page = 0;
  final _globalStates = Get.find<GlobalState>();
  final _controller = ScrollController();

  void loadMore() async {
    final stores = await Store.getVerifiedStores(
        _globalStates.token, _page, _globalStates.pageSize);
    _myVerifyStores.addAll(stores);
    _page++;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        loadMore();
      }
    });
    loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "내가 인증한 가게"),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: _myVerifyStores.length,
        shrinkWrap: true,
        controller: _controller,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final store = _myVerifyStores[index];
          return StoreCard(store);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
