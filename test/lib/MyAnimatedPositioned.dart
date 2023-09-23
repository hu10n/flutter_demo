import 'package:flutter/material.dart';

class MyAnimatedPositioned extends StatelessWidget {
  final bool showBottomBar;
  final int scrollValue;
  final Widget child;

  MyAnimatedPositioned({required this.showBottomBar,required this.scrollValue, required this.child});

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: showBottomBar ? 0.0 : -(kToolbarHeight + safePadding + scrollValue),
      left: 0.0,
      right: 0.0,
      child: child,
    );
  }
}
