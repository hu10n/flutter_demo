import 'package:flutter/material.dart';
import '../../../LocalData/data.dart';
import '../StepList/StepListPage.dart';
import 'MachineListCard.dart';

class MachineListSliverList extends StatefulWidget {
  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;

    // Categorize machines
    Map<String, List<String>> categorizedMachines = {};

    for (var machineNumber in machineData.keys) {
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

          if (index < categories.length) {
            final category = categories[index];
            final machinesInCategory = categorizedMachines[category]!;
            // マシンカテゴリごとにまとめる
            return Column(
              children: [
                // カテゴリーラベル ex. A
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                  ],
                ),
                // カテゴリーに該当するマシンのカードリスト
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

  void _handleMachineCardTap(
      BuildContext context, String machineNumber, MachineData machine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepListPage(machineNumber: machineNumber),
      ),
    ).then((dataUpdated) {
      // 遷移先から戻った際に毎回setStateにtrueを渡す
      setState(() {});
    });
  }
}
