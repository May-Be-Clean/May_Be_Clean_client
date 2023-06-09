import 'package:flutter/material.dart';
import 'package:may_be_clean/widgets/widgets.dart';
import 'package:may_be_clean/models/model.dart';

class StoreReviewListScreen extends StatefulWidget {
  final Store store;
  const StoreReviewListScreen({required this.store, super.key});

  @override
  State<StoreReviewListScreen> createState() => _StoreReviewListScreenState();
}

class _StoreReviewListScreenState extends State<StoreReviewListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "방문자 후기",
      ),
    );
  }
}
