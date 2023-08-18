import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../wigets/top_navigation_fadeable.dart';
import '../viewmodels/NavigationNotifier.dart';
import '../animations/bottom_bar_animation.dart';
import '../_dev/MachineListPage.dart';

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
                MachineList(),
              ],
            ),
            BottomNav(isScrollingDown: notifier.isScrollingDown),
          ],
        ),
      ),
    );
  }
}
