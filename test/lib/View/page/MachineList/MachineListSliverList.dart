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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final machineNumber = machineData.keys.elementAt(index);
          final MachineData machine = machineData[machineNumber]!;
          return _MachineListCard(machineNumber, machine, context);
        },
        childCount: machineData.length,
      ),
    );
  }

  Card _MachineListCard(
      String machineNumber, MachineData machine, BuildContext context) {
    // Get Latest Edit Date Time
    String latestEditedDateTime = getLatestEditedDateTime(machineNumber);
    return Card(
      child: ListTile(
        title: Text(machineNumber),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      setState(() {
        machineData[machineNumber] = machine;
      });
    });
  }
}
