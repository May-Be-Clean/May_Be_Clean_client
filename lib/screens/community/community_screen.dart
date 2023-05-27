import 'package:flutter/material.dart';
import 'package:may_be_clean/utils/colors.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Community",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 30),
        backgroundColor: ColorSystem.primary,
      ),
      body: Column(children: [
        Row(
          children: [Text('모집'), Text('잡담')],
        ),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(10),
                  color: Colors.grey,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: 3),
        ),
      ]),
    );
  }
}
