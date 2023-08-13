import 'package:flutter/material.dart';
import '../wigets/custom_bottom_navigation_bar.dart';

class BottomNav extends StatelessWidget {
  final bool isScrollingDown;

  BottomNav({required this.isScrollingDown});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200), // アニメーションの持続時間
      curve: Curves.linear, // アニメーションのカーブ
      bottom: isScrollingDown ? -80 : 0, // ナビゲーションの高さに合わせて調整
      left: 0,
      right: 0,
      child: CustomBottomNavigationBar(),
    );
  }
}


