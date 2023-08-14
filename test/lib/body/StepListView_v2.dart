import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/NavigationNotifier.dart';
import '../animations/bottom_bar_animation.dart';
import '../wigets/StepListView.dart';
import '../_dev/data.dart';


class StepListView extends StatelessWidget {
  final MachineData machine;
  final String machineNumber;

  StepListView({required this.machine, required this.machineNumber});

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
                StepSliverList(
                  childSteps: machine.childSteps,
                  machineNumber: machineNumber,
                ),
              ],
            ),
            BottomNav(isScrollingDown: notifier.isScrollingDown),
          ],
        ),
      ),
    );
  }
}
