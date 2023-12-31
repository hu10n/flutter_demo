import 'package:flutter/material.dart';

class BottNaviIndexStack extends StatelessWidget {
  final int currentIndex;
  final List<Widget> children;

  BottNaviIndexStack({required this.currentIndex, required this.children});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: children,
    );
  }
}
