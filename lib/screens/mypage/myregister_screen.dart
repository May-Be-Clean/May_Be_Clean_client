import 'package:flutter/material.dart';
import 'package:may_be_clean/screens.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/states/states.dart';
import 'package:may_be_clean/models/model.dart';
import 'package:may_be_clean/consts/consts.dart';

class MyRegisterScreen extends StatefulWidget {
  const MyRegisterScreen({super.key});

  @override
  State<MyRegisterScreen> createState() => _MyRegisterScreenState();
}

class _MyRegisterScreenState extends State<MyRegisterScreen> {
  final _globalStates = Get.find<GlobalState>();
  final _myRegisterStores = <Store>[];
  int _page = 0;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMore();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    final stores = await Store.getRegistredStores(
        _globalStates.token, _page, _globalStates.pageSize);
    _myRegisterStores.addAll(stores);
    _page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "내가 등록한 가게"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _globalStates.userData!.user.nickname,
                          style: FontSystem.subtitleSemiBold,
                        ),
                        const TextSpan(
                          text: '님이 등록한',
                          style: FontSystem.subtitleRegular,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "친환경 가게들을 모아봤어요.",
                    style: FontSystem.subtitleRegular,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _myRegisterStores.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  final store = _myRegisterStores[index];
                  return StoreCard(store);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
