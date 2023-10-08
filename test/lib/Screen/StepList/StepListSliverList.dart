import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test/GlobalMethod/utils.dart';

import 'package:test/providers/DataProvider.dart';
import 'MachineSummaryCard.dart';
import 'StepListCard.dart';
import 'package:test/Screen/MachineList/MachineListSliverList.dart';
//import 'package:test/providers/NavigationData.dart';
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
              tapAction: () => _handleStepCardTap(context, widget.machineId),
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
    //final navigationData = NavigationData.of(context);
    //print(navigationData);
    //------------------------------------------------------------------------
    final pdf = pw.Document();
    createAndPrintPdf(
      pdf,
      Provider.of<DataNotifier>(context, listen: false).japaneseFont,
      machine,
    );
  }

// Step Card Listをtapした時の動作
  void _handleStepCardTap(
    BuildContext context,
    String machineId,
  ) {
    // -----------------------------テスト用----------------------
    // navigateToHome(context);
    // transToStepListPage(
    //     context, machineId, widget.onScrollUp, widget.onScrollDown);
    // -----------------------------------------------------------
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
