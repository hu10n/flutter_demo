import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:test/providers/DataProvider.dart';
import 'MachineSummaryCard.dart';
import 'StepListCard.dart';
import 'package:test/providers/NavigationData.dart';
import 'package:test/Screen/JobCard/PrintingJob.dart';

class StepListSliverList extends StatefulWidget {
  final String machineId;
  final Function onScrollDown;
  final Function onScrollUp;

  const StepListSliverList(
      {required this.machineId,
      required this.onScrollDown,
      required this.onScrollUp});

  @override
  State<StepListSliverList> createState() => _StepListSliverListState();
}

class _StepListSliverListState extends State<StepListSliverList> {
  final ScrollController _scrollController = ScrollController();
  // SliverListを返す ----------------------------------------------
  @override
  Widget build(BuildContext context) {
    final dataList = Provider.of<DataNotifier>(context).dataList;

    Map<String, dynamic> machine = dataList.firstWhere(
        (element) => element['machine_id'] == widget.machineId,
        orElse: () => {
              'machine_id': '',
              'machine_num': 'N/A',
              'machine_status': 0,
              'updated_at': 'N/A',
              'project': []
            });

    List<String> stepIds = _getAllStepIds(machine);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return MachineSummaryCard(
              machineId: widget.machineId,
              onPressAction: () => _handleIssueButton(context, machine),
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
              scrollController: _scrollController,
            );
          } else if (index <= stepIds.length) {
            String stepId = stepIds[index - 1];
            return StepListCard(
              machineId: widget.machineId,
              stepId: stepId,
              tapAction: () => _handleStepCardTap(context, stepId),
            );
          }
          return null;
        },
        childCount: stepIds.length + 1, // Adjusted childCount
      ),
    );
  }

  // カード発行ボタンのアクション
  Future<void> _handleIssueButton(
      BuildContext context, Map<String, dynamic> machine) async {
    // デバッグ用---------------------------------------------------------------
    final navigationData = NavigationData.of(context);
    //print(navigationData);
    //------------------------------------------------------------------------

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
                // 画面遷移管理のデバッグ用----------------------------------------
                if (navigationData != null) {
                  final navigatorState =
                      navigationData.pageKeys[0].currentState;

                  if (navigatorState != null && navigatorState.canPop()) {
                    navigatorState.popUntil((route) => route.isFirst);
                    navigationData.onTabChange(0);
                  }
                }

                //-------------------------------------------------------------
                final pdf = pw.Document();
                createAndPrintPdf(
                  pdf,
                  Provider.of<DataNotifier>(context, listen: false).japaneseFont,
                  machine,
                );
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

// Step Card Listをtapした時の動作
  void _handleStepCardTap(
    BuildContext context,
    String stepId,
  ) {
    //Navigator.push(
    //  context,
    //  MaterialPageRoute(builder: (context) => Placeholder()
    // StepPreviewPage(
    //   machineNumber: machineNumber,
    //   stepId: stepId,
    // ),
    //      ),
    //).then((dataUpdated) {
    //  setState(() {}); // 常にtrueを渡して、再レンダリングさせる
    //});
  }

  List<String> _getAllStepIds(Map<String, dynamic> machine) {
    List<String> stepIds = [];

    if (machine['project'] is List) {
      for (var project in machine['project']) {
        if (project['step'] is List) {
          List<dynamic> steps = project['step'];

          // Sort the steps following each step_num
          steps.sort(
              (a, b) => (a['step_num'] ?? 0).compareTo(b['step_num'] ?? 0));

          for (var step in steps) {
            if (step['step_id'] is String) {
              stepIds.add(step['step_id']);
            }
          }
        }
      }
    }

    return stepIds;
  }
}
