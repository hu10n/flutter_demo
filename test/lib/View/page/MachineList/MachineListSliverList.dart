import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

//import '../../../DataClass.dart';
import '../../../LocalData/data.dart';
import '../StepList/StepListPage.dart';
import 'MachineListCard.dart';

class MachineListSliverList extends StatefulWidget {
  final Function onScrollDown;
  final Function onScrollUp;

  MachineListSliverList({required this.onScrollDown, required this.onScrollUp});

  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  int selectedStatus = -1; // マシンの絞り込み状態を管理する変数

  List<String> getFilteredMachines() {
    if (selectedStatus == -1) {
      return machineData.keys.toList();
    } else {
      return machineData.entries
          .where((entry) => entry.value.machineStatus == selectedStatus)
          .map((entry) => entry.key)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    //final dataNotifier = context.watch<DataNotifier>();

    Map<String, List<String>> categorizedMachines = {};

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
        (context, index) {
          final categories = categorizedMachines.keys.toList();

          if (index == 0) {
            return DropdownButton<int>(
              value: selectedStatus,
              onChanged: _handleStatusFilterChange,
              items: <int>[
                -1, // 全て表示
                0, // 未稼働
                1, // 停止中
                2, // 異常停止中
                3, // メンテナンス中
                4 // 稼働中
              ].map<DropdownMenuItem<int>>(
                (int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value == -1 ? "すべて表示" : _getStatusText(value)),
                  );
                },
              ).toList(),
            );
          } else if (index <= categories.length) {
            final category = categories[index - 1];
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
          } else {
            return SizedBox(
              height: safePadding,
            );
          }
        },
        childCount: categorizedMachines.length + 1,
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return '未稼働';
      case 1:
        return '停止中';
      case 2:
        return '異常停止中';
      case 3:
        return 'メンテナンス中';
      case 4:
        return '稼働中';
      default:
        return '';
    }
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

  void _handleStatusFilterChange(int? newStatus) {
    if (newStatus != null) {
      setState(() {
        selectedStatus = newStatus;
      });
    }
  }
}
