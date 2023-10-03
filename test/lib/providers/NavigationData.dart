import 'package:flutter/material.dart';

class NavigationData extends InheritedWidget { // 画面遷移用のcurrentIndexとpageKeysを下流ウィジェットに提供する
  final int currentIndex;
  final List<GlobalKey<NavigatorState>> pageKeys;
  final ValueChanged<int> onTabChange;

  NavigationData({
    required this.currentIndex,
    required this.pageKeys,
    required this.onTabChange,
    required Widget child,
  }) : super(child: child);

  static NavigationData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationData>();
  }

  @override
  bool updateShouldNotify(NavigationData oldWidget) {
    return currentIndex != oldWidget.currentIndex || pageKeys != oldWidget.pageKeys;
  }
}
