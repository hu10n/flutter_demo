import 'package:flutter/material.dart';
//import 'dart:math';

import 'ToggleButtons.dart';

class YourHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(int) onToggleSelected;

  YourHeaderDelegate({required this.onToggleSelected});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    //double topPadding = max(30.0 - shrinkOffset, 0);
    //double bottomPadding = max(10.0 - shrinkOffset, 0);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Spacer(),
          ToggleButtonsWidget(onToggleSelected: onToggleSelected),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.menu), // ハンバーガーメニュー
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}