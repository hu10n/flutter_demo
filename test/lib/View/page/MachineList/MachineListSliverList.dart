import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

//import '../../../DataClass.dart';
import '../../../LocalData/data.dart';
import '../StepList/StepListPage.dart';
import 'MachineListCard.dart';
//import '../../../api/TestAPI.dart';

class MachineListSliverList extends StatefulWidget {
  final int selectedStatus;
  final Function onScrollDown;
  final Function onScrollUp;

  MachineListSliverList({
    required this.selectedStatus,
    required this.onScrollDown,
    required this.onScrollUp,
  });

  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  List<String> getFilteredMachines() {
    if (widget.selectedStatus == -1) {
      return machineData.keys.toList();
    } else if (widget.selectedStatus == 0 || widget.selectedStatus == 1) {
      return machineData.entries
          .where((entry) => entry.value.machineStatus == widget.selectedStatus)
          .map((entry) => entry.key)
          .toList();
    } else {
      return machineData.entries
          .where((entry) =>
              entry.value.machineStatus != 0 && entry.value.machineStatus != 1)
          .map((entry) => entry.key)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
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

          if (index <= categories.length) {
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
        childCount: categorizedMachines.length,
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
}
