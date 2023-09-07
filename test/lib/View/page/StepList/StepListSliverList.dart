import 'package:flutter/material.dart';
import '../../../LocalData/data.dart';
import '../StepPreview/StepPreviewPage.dart';
import 'MachineSummaryCard.dart';
import 'StepListCard.dart';

class StepListSliverList extends StatefulWidget {
  final String machineNumber;
  final Function onScrollDown;
  final Function onScrollUp;

  const StepListSliverList(
      {required this.machineNumber,
      required this.onScrollDown,
      required this.onScrollUp});

  @override
  State<StepListSliverList> createState() => _StepListSliverListState();
}

class _StepListSliverListState extends State<StepListSliverList> {
  // SliverListを返す ----------------------------------------------
  @override
  Widget build(BuildContext context) {
    final machineNumber = widget.machineNumber;
    final MachineData machine = machineData[machineNumber]!;

    final safePadding = MediaQuery.of(context).padding.bottom;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return MachineSummaryCard(
              machine: machine,
              machineNumber: machineNumber,
              onPressAction: () => _handleIssueButton(context),
            );
          } else if (index <= machine.childSteps.length) {
            final stepTitle = machine.childSteps.keys.elementAt(index - 1);
            final SmallStep step = machine.childSteps[stepTitle]!;
            return StepListCard(
              step: step,
              stepTitle: stepTitle,
              context: context,
              tapAction: () =>
                  _handleStepCardTap(context, stepTitle, step, machineNumber),
            );
          } else {
            return SizedBox(height: safePadding + kToolbarHeight);
          }
        },
        childCount: machine.childSteps.length + 2,
      ),
    );
  }

  // カード発行ボタンのアクション
  Future<void> _handleIssueButton(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Button is Pressed !!!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

// Step Card Listをtapした時の動作
  void _handleStepCardTap(BuildContext context, String stepTitle,
      SmallStep step, String machineNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepPreviewPage(
          machineNumber: machineNumber,
          stepTitle: stepTitle,
        ),
      ),
    ).then((dataUpdated) {
      setState(() {}); // 常にtrueを渡して、再レンダリングさせる
    });
  }
}