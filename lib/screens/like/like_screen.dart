import 'package:flutter/material.dart';
import 'package:may_be_clean/consts/consts.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _StoreCard extends StatelessWidget {
  final String title;
  final int cloverCount;

  const _StoreCard({required this.title, required this.cloverCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/icons/clover/clover_$cloverCount.svg"),
            Text(
              title,
              style: FontSystem.subtitleSemiBold
                  .copyWith(color: ColorSystem.primary),
            ),
          ],
        ),
        SizedBox(
          height: 20,
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Text("#해시태그",
                  style: FontSystem.caption.copyWith(color: ColorSystem.gray1));
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              final reviewCategory = reviewCategories.values.toList()[index];
              return ReviewButton(
                  title: reviewCategory[0],
                  image: reviewCategory[1],
                  action: () {});
            },
          ),
        ),
      ],
    );
  }
}

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final List<String> _selectedCategories = [];

  Widget _storeCard(String title, int cloverCount) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icons/clover/clover_$cloverCount.svg"),
              Text(
                title,
                style: FontSystem.subtitleSemiBold
                    .copyWith(color: ColorSystem.primary),
              ),
            ],
          ),
          SizedBox(
            height: 20,
            child: ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Text("#해시태그",
                    style:
                        FontSystem.caption.copyWith(color: ColorSystem.gray1));
              },
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                final reviewCategory = reviewCategories.values.toList()[index];
                return ReviewButton(
                    title: reviewCategory[0],
                    image: reviewCategory[1],
                    action: () {});
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.all(10),
          child: const Text("찜한 가게", style: FontSystem.subtitleSemiBold),
        ),
        centerTitle: false,
      ),
      backgroundColor: ColorSystem.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 20,
            flexibleSpace: FlexibleSpaceBar(
              title: SizedBox(
                height: 40,
                child: ListView.separated(
                  itemCount: storeCategories.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                  itemBuilder: (context, index) {
                    final category = storeCategories.values.toList()[index];
                    final categoryName = storeCategories.keys.toList()[index];
                    bool isSelected = false;
                    if (_selectedCategories.contains(categoryName)) {
                      isSelected = true;
                    }
                    return CategoryButton(
                        title: category[0],
                        unselectedSvg: category[1],
                        selectedSvg: category[2],
                        isSelected: isSelected,
                        action: () {
                          if (isSelected) {
                            _selectedCategories.remove(categoryName);
                          } else {
                            _selectedCategories.add(categoryName);
                          }
                          isSelected = !isSelected;
                          setState(() {});
                        });
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _storeCard("두둥탁", 3);
            }, childCount: 20),
          ),
          // SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //   (context, index) {
          //     return _storeCard("두둥학", 2);
          //   },
          //   childCount: 20,
          // )),
        ],
      ),
    );
  }
}
