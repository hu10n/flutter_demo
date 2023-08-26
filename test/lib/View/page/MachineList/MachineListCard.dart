import 'package:flutter/material.dart';
import 'package:test/View/page/StepList/MachineStatusText.dart';

import '../../../LocalData/data.dart';
import '../../../common/methods.dart';

class MachineListCard extends StatelessWidget {
  const MachineListCard(
      {super.key,
      required this.machineNumber,
      required this.machine,
      required this.context,
      required this.ontapAction});

  final String machineNumber;
  final MachineData machine;
  final BuildContext context;
  final VoidCallback ontapAction;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Get Latest Edit Date Time
    String latestEditedDateTime = getLatestEditedDateTime(machineNumber);
    // Get Current Status
    final machineStatus = machine.machineStatus;
    return SizedBox(
      width: screenWidth,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(machineNumber),
              Text('${machine.productName}'),
              Text('${machine.machineRole}'),
              MachineStatusText(context: context, machineStatus: machineStatus),
              Text('前回更新: $latestEditedDateTime'),
              Text(
                  'Progress: ${calcTotalProgress(machine)} / ${calcStepNumber(machine)}'),
            ],
          ),
          onTap: () {
            ontapAction();
          },
        ),
      ),
    );
  }
}
