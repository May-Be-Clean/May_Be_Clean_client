import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/models/story.dart';
import 'package:may_be_clean/utils/utils.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final _stores = <Story>[];
  @override
  void initState() {
    super.initState();
    try {
      Story.getStories().then((value) {
        _stores.addAll(value);
        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leadingWidth: 0,
          centerTitle: false,
          title: Container(
            padding: const EdgeInsets.all(10),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "깨끗해질 이야기",
                  style: FontSystem.subtitleSemiBold,
                ),
                Text(
                  "지구를 깨끗하게 만드는 가게들의 후기를 모아봤어요!",
                  style: FontSystem.body2,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView.separated(
          itemCount: _stores.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final story = _stores[index];
            return StoryCard(story: story);
          },
        ));
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  const StoryCard({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        urlLauncher(story.url);
      },
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/badge/level5.svg',
                      width: 24,
                    ),
                    const SizedBox(width: 4),
                    const Text("새싹밭의 파수꾼", style: FontSystem.body2)
                  ],
                ),
                const Spacer(),
                Text(convertTimeGapToString(story.updatedAt),
                    style:
                        FontSystem.caption.copyWith(color: ColorSystem.gray1))
              ],
            ),
            const SizedBox(height: 8),
            Text(story.title, style: FontSystem.body1),
            const SizedBox(height: 8),
            Text(story.content, style: FontSystem.body2),
            if (story.picture != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  story.picture!,
                  width: Get.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
