import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/providers/DataProvider.dart';
import 'package:test/Screen/StepList/StepListPage.dart';
import 'MachineListCard.dart';

class MachineListSliverList extends StatefulWidget {
  final int selectedStatus;
  final Function onScrollDown;
  final Function onScrollUp;

  final ScrollController? controller;

  MachineListSliverList({
    required this.selectedStatus,
    required this.onScrollDown,
    required this.onScrollUp,
    this.controller,
  });

  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  Map<String, Map<String, dynamic>> getMachineCardCount(
      List<Map<String, dynamic>> dataList, int selectedStatus) {
    final Map<String, List<String>> categorizedMachines = {};
    final Map<String, Map<String, dynamic>> machineCardCount = {};

    // Filtering step
    List<Map<String, dynamic>> filteredMachines = dataList;
    if (selectedStatus != -1) {
      if (selectedStatus == 0 || selectedStatus == 1) {
        filteredMachines = dataList
            .where((machine) => machine['machine_status'] == selectedStatus)
            .toList();
      } else {
        filteredMachines = dataList
            .where((machine) =>
                machine['machine_status'] != 0 &&
                machine['machine_status'] != 1)
            .toList();
      }
    }

    for (var machine in filteredMachines) {
      final machineId = machine['machine_id']; // machine_idを取得
      final category = machine['machine_group'];

      if (!categorizedMachines.containsKey(category)) {
        categorizedMachines[category] = [];
      }

      categorizedMachines[category]!.add(machineId); // machine_idをリストに追加
    }

    int accumulatedHeight = 0;
    for (var category in categorizedMachines.keys) {
      final machineIds = categorizedMachines[category]!;
      final count = machineIds.length;
      final height = 78 * count + 25;

      accumulatedHeight += height;
      machineCardCount[category] = {
        'machines': machineIds, // machineIdsを格納
        'count': count,
        'height': accumulatedHeight,
      };
    }

    return machineCardCount;
  }

// 最初期build時に計算しProviderをアップデート
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataNotifier = Provider.of<DataNotifier>(context, listen: false);
      //dataNotifier.getAllData();
      print("initState Timing");
      final dataList = dataNotifier.dataList;
      final machineCardCount =
          getMachineCardCount(dataList, widget.selectedStatus);
      dataNotifier.updateMachineCardCount(machineCardCount);
      //print("#initState/cardcount: ${machineCardCount['A']}"); // []が返ってくる
    });
  }

// selectedStatusが更新された際に計算しProviderをアップデート
  @override
  void didUpdateWidget(covariant MachineListSliverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedStatus != oldWidget.selectedStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final dataNotifier = Provider.of<DataNotifier>(context, listen: false);
        final dataList = dataNotifier.dataList;
        final machineCardCount =
            getMachineCardCount(dataList, widget.selectedStatus);
        dataNotifier.updateMachineCardCount(machineCardCount);
        // print("#didupdate/cardcount: ${machineCardCount['A']}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataNotifier = Provider.of<DataNotifier>(context, listen: true);
    final dataList = dataNotifier.dataList;
    final machineCardCount =
        getMachineCardCount(dataList, widget.selectedStatus);
    // print("#build/cardcount: ${machineCardCount['A']}");
    if (dataNotifier.isSelectedAlphabet) {
      scrollToCategory(dataNotifier.selectedAlphabet);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final categories = machineCardCount.keys.toList();

          if (index < categories.length && categories[index] != null) {
            final category = categories[index];
            final machineIdsInCategory =
                machineCardCount[category]?["machines"];
            if (machineIdsInCategory != null) {
              return Column(
                children: [
                  CategoryTitle(category: category),
                  Column(
                    children: machineIdsInCategory.map<Widget>((machineId) {
                      return MachineListCard(
                        machineId: machineId,
                        ontapAction: () =>
                            handleMachineCardTap(context, machineId),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          }

          return null;
        },
        childCount: machineCardCount.length,
      ),
    );
  }

  void handleMachineCardTap(BuildContext context, String machineId) {
    widget.onScrollUp(0);
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => StepListPage(
                  machineId: machineId,
                  onScrollDown: widget.onScrollDown,
                  onScrollUp: widget.onScrollUp,
                )))
        // .push(MaterialPageRoute(builder: (context) => Placeholder()))
        .then((dataUpdated) {
      setState(() {});
    });
  }

  void scrollToCategory(int categoryIndex) {
    var offset = 0.0;
    if (Provider.of<DataNotifier>(context, listen: false).selectedAlphabet !=
        0) {
      offset = Provider.of<DataNotifier>(context, listen: false)
              .machineCardCount
              .entries
              .toList()[categoryIndex - 1]
              .value["height"] +
          5.0;
    }

    widget.controller?.animateTo(offset,
        duration: Duration(
          milliseconds: 10,
        ),
        curve: Curves.easeOut);
  }
}

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
          width: 25,
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).disabledColor),
            ),
          ),
        ),
      ],
    );
  }
}
