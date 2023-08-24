import 'package:flutter/material.dart';
import '../../../LocalData/data.dart';
import '../../../common/methods.dart';
import '../StepList/StepListPage.dart';

class MachineListSliverList extends StatefulWidget {
  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index != machineData.length) {
            final machineNumber = machineData.keys.elementAt(index);
            final MachineData machine = machineData[machineNumber]!;
            return _MachineListCard(machineNumber, machine, context);
          } else {
            return SizedBox(
              height: safePadding, // 一番下のウィジェットがノッチに食い込むのを防ぐ
            );
          }
        },
        childCount: machineData.length + 1,
      ),
    );
  }

  Card _MachineListCard(
      String machineNumber, MachineData machine, BuildContext context) {
    // Get Latest Edit Date Time
    String latestEditedDateTime = getLatestEditedDateTime(machineNumber);
    return Card(
      child: Material(
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(machineNumber),
              Text('Product Name: ${machine.productName}'),
              Text('Material: ${machine.material}'),
              Text('Lot Number: ${machine.lotNumber}'),
              Text('Edited Date & Time: $latestEditedDateTime'),
              Text(
                  'Progress: ${calcTotalProgress(machine)} / ${calcStepNumber(machine)}'),
            ],
          ),
          onTap: () {
            _handleMachineCardTap(context, machineNumber, machine);
          },
        ),
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
