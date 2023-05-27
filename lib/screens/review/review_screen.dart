import 'package:flutter/material.dart';
import 'package:may_be_clean/consts/color.dart';
import 'package:may_be_clean/widgets/button.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

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
        backgroundColor: ColorSystem.primary,
        child: const Icon(Icons.add, size: 30),
      ),
      body: Column(children: [
        Row(
          children: [
            const Text('모집'),
            const Text('잡담'),
            CategoryButton(
                title: "무야호",
                selectedSvg: "assets/icons/category/accessory.svg",
                unselectedSvg: "assets/icons/category/accessory.svg",
                isSelected: true,
                action: () {})
          ],
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
