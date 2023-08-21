import 'package:flutter/material.dart';

class MyAnimatedPositioned extends StatelessWidget {
  final bool showBottomBar;
  final Widget child;

  MyAnimatedPositioned({required this.showBottomBar, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom:
          showBottomBar ? 0.0 : -(kToolbarHeight + kBottomNavigationBarOffset),
      left: 0.0,
      right: 0.0,
      child: child,
    );
  }
}
