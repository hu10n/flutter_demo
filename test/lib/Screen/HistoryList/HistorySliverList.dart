import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test/GlobalMethod/utils.dart';
import 'package:provider/provider.dart';

import 'package:test/providers/DataProvider.dart';
import 'package:test/providers/DataProvider.dart';
import 'HistoryListCard.dart';
import 'package:test/Screen/MachineList/MachineListSliverList.dart';
//import 'package:test/providers/NavigationData.dart';
import 'package:test/Screen/JobCard/PrintingJob.dart';
import 'package:test/GlobalWidget/LoadingModal.dart';

import 'package:test/api/api.dart';

class HistoryListSliverList extends StatefulWidget {
  final String machineId;
  final Function onScrollDown;
  final Function onScrollUp;

  const HistoryListSliverList(
      {required this.machineId,
      required this.onScrollDown,
      required this.onScrollUp});

  @override
  State<HistoryListSliverList> createState() => _HistoryListSliverListState();
}

class _HistoryListSliverListState extends State<HistoryListSliverList> {
  //final ScrollController _scrollController = ScrollController();
  bool _isLoading = true; //ローディング画面用
  Map<dynamic,dynamic> machine = {};
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }
  Future<void> _loadDataAndNavigate() async {
    // ローディング中の処理--------------------------------
    print("load start");
    await Future.delayed(Duration(milliseconds: 500));
    final data = await getHistoryData(widget.machineId);
    
    final dataNotifier = Provider.of<DataNotifier>(context, listen: false);
    final _machine = dataNotifier.structuredData2(data["machine"],data["project"],data["step"]);
    
    setState(() {
      machine = _machine[0];
      _isLoading = false;
    });
  }
  // SliverListを返す ----------------------------------------------
  @override
  Widget build(BuildContext context) {
    final dataNotifier = Provider.of<DataNotifier>(context, listen: false);
    final dataList = dataNotifier.dataList;

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

    print(stepIds);

    if(_isLoading){ //データを読むまではローディング
      return SliverFillRemaining(
        child: Container(
          child: LoadingModal(),
        ),
      );
    }else{
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {       
            if (index < stepIds.length) {
              String stepId = stepIds[index];
              return HistoryListCard(
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
  }

// Step Card Listをtapした時の動作
  void _handleStepCardTap(
    BuildContext context,
    String machineId,
  ) async{
    // -----------------------------テスト用----------------------
    // navigateToHome(context);
    // navigateToStepListPage(context, "4d789eb5-00bc-4404-8b1f-36e93387598c",
    //     widget.onScrollUp, widget.onScrollDown);
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
