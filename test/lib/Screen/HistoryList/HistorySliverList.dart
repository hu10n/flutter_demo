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
    //print("load start");
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
            if (index < machine["project"].length) {
              Map<dynamic,dynamic> _machine = Map.of(machine);
              _machine["project"] = _machine["project"][index];
              return HistoryListCard(
                machine: _machine,
                onScrollDown: widget.onScrollDown,
                onScrollUp: widget.onScrollUp,
              );
            }
            return null;             
          },
          childCount: machine["project"].length, // Adjusted childCount
        ),
      );
    }
  }
}
