import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class NavigationNotifier with ChangeNotifier {
  bool _isScrollingDown = false;
  late ScrollController scrollController;

  NavigationNotifier() {
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  bool get isScrollingDown => _isScrollingDown;

  void _onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        _isScrollingDown = true;
        notifyListeners();
      }
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) {
        _isScrollingDown = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
