import 'package:flutter/material.dart';
import 'package:test/common/MachineStatusText.dart';

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
    // Get Latest Edit Date Time
    String latestEditedDateTime = getLatestEditedDateTime(machineNumber);
    // Get Current Status
    final machineStatus = machine.machineStatus;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              _buildMachineNumberBox(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMachineRoleBox(),
                        _buildMachineStatusBox(
                            context, machineStatus, latestEditedDateTime),
                      ],
                    ),
                    _buildMachineProgressBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          ontapAction();
        },
      ),
    );
  }

  Widget _buildMachineNumberBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          child: Text(
        machineNumber,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      )),
    );
  }

  Widget _buildMachineRoleBox() {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              machine.productName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(
          height: 15,
          child: Text(
            machine.machineRole,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildMachineStatusBox(
      BuildContext context, int machineStatus, String latestEditedDateTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 30,
              child: MachineStatusText(
                  context: context, machineStatus: machineStatus)),
          Text(
            latestEditedDateTime,
            style:
                TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineProgressBox() {
    final totalProgress = calcTotalProgress(machine);
    final stepNumber = calcStepNumber(machine);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          for (int i = 0; i < stepNumber; i++)
            Row(
              children: [
                Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).disabledColor, width: 1),
                    borderRadius: BorderRadius.circular(2),
                    color: i < totalProgress
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.background,
                  ),
                ),
                SizedBox(
                  width: 1,
                )
              ],
            ),
        ],
      ),
    );
  }
}
