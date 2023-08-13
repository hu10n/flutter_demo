import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../wigets/top_navigation_fadeable.dart';
import '../wigets/scroll_body_content_in_dummydata.dart';
import '../viewmodels/NavigationNotifier.dart';
import '../animations/bottom_bar_animation.dart';


class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationNotifier(),
      child: Consumer<NavigationNotifier>(
        builder: (context, notifier, _) => Stack(
          children: [
            CustomScrollView(
              controller: notifier.scrollController,
              slivers: <Widget>[
                TopNavigation(),
                BodyContent(),
              ],
            ),
            BottomNav(isScrollingDown: notifier.isScrollingDown),
          ],
        ),
      ),
    );
  }
}
