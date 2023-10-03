import 'package:flutter/material.dart';

class MyIndexedStack extends StatelessWidget {
  final int currentIndex;
  final List<Widget> children;

  MyIndexedStack({required this.currentIndex, required this.children});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: children,
    );
  }
}
