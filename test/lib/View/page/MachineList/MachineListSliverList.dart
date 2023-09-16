import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DataClass.dart';
import '../../../LocalData/data.dart';
import '../StepList/StepListPage.dart';
import 'MachineListCard.dart';
//import '../../../api/TestAPI.dart';

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
  //int selectedStatus = -1; // マシンの絞り込み状態を管理する変数

  List<String> getFilteredMachines() {
    if (widget.selectedStatus == -1) {
      return machineData.keys.toList();
    } else {
      return machineData.entries
          .where((entry) => entry.value.machineStatus == widget.selectedStatus)
          .map((entry) => entry.key)
          .toList();
    }
  }

  late Map<String, List<String>> categorizedMachines;

  @override
  Widget build(BuildContext context) {
    final alphabetProvider = Provider.of<DataNotifier>(context);
    //final dataNotifier = context.watch<DataNotifier>();

    if (alphabetProvider.isSelectedAlphabet) {
      scrollToCategory(alphabetProvider.selectedAlphabet);
    }

    categorizedMachines = {};

    for (var machineNumber in getFilteredMachines()) {
      final machine = machineData[machineNumber]!;
      final category = machine.machineCategory;

      if (!categorizedMachines.containsKey(category)) {
        categorizedMachines[category] = [];
      }

      categorizedMachines[category]!.add(machineNumber);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index){
          final categories = categorizedMachines.keys.toList();

          if (index < categories.length) {
            final category = categories[index];
            final machinesInCategory = categorizedMachines[category]!;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        category,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: machinesInCategory.map((machineNumber) {
                    final machine = machineData[machineNumber]!;
                    return MachineListCard(
                      machineNumber: machineNumber,
                      machine: machine,
                      context: context,
                      ontapAction: () => _handleMachineCardTap(
                          context, machineNumber, machine),
                    );
                  }).toList(),
                ),
              ],
            );
          }
        },
        childCount: categorizedMachines.length + 1,
      ),
    );
  }

  void _handleMachineCardTap(
      BuildContext context, String machineNumber, MachineData machine) {
    widget.onScrollUp();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => StepListPage(
                  machineNumber: machineNumber,
                  onScrollDown: widget.onScrollDown,
                  onScrollUp: widget.onScrollUp,
                )))
        .then((dataUpdated) {
      setState(() {});
    });
  }

  void scrollToCategory(String categoryName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataNotifier>(context, listen: false).turnSelectedFlag(false);
    });
    
    var categories = categorizedMachines.keys.toList();
    var index = categories.indexOf(categoryName);
    
    // スクロール位置を計算する
    var offset = index * 60.0;  // 仮の計算
    widget.controller?.animateTo(
      offset, duration: Duration(milliseconds: 500,), curve: Curves.easeInOut
    );
  }
}