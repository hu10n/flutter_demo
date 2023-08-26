import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../LocalData/data.dart';
import '../../../common/methods.dart';
import 'MachineStatusText.dart';

class MachineSummaryCard extends StatelessWidget {
  const MachineSummaryCard(
      {required this.machine,
      required this.machineNumber,
      required this.onPressAction});

  final MachineData machine;
  final String machineNumber;
  final VoidCallback onPressAction;

  @override
  Widget build(BuildContext context) {
    final totalProgress = calcTotalProgress(machine);
    final stepNumber = calcStepNumber(machine);
    final progressPercentage =
        calcpProgressPercentage(totalProgress, stepNumber);

    final machineStatus = machine.machineStatus;

    final productName = machine.productName;
    final material = machine.material;
    final lotNumber = machine.lotNumber;
    final updateDate = getLatestEditedDateTime(machineNumber);

    return Card(
      child: Column(
        children: [
          _buildTitleBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMachineStatusBox(context, machineStatus, progressPercentage,
                  totalProgress, stepNumber),
              _buildProductSpecBox(productName, material, lotNumber, updateDate)
            ],
          ),
          _buildBottomButtonBox(context, onPressAction)
        ],
      ),
    );
  }

  Widget _buildBottomButtonBox(
      BuildContext context, VoidCallback onPressAction) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          child: ElevatedButton(
              onPressed: () {
                onPressAction();
              },
              child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "カード発行",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )))),
    );
  }

  SizedBox _buildProductSpecBox(String productName, String material,
      String lotNumber, String updateDate) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("品名:$productName"),
          SizedBox(
            height: 10,
          ),
          Text("材質:$material"),
          SizedBox(
            height: 10,
          ),
          Text("Lot番号:$lotNumber"),
          SizedBox(
            height: 10,
          ),
          Text("前回更新:$updateDate")
        ],
      ),
    );
  }

  Widget _buildMachineStatusBox(BuildContext context, int machineStatus,
      int progressPercentage, int totalProgress, int stepNumber) {
    return SizedBox(
      width: 170,
      child: Column(
        children: [
          MachineStatusText(context: context, machineStatus: machineStatus),
          SizedBox(
            height: 10,
          ),
          _buildProgressCircle(
              context, progressPercentage, totalProgress, stepNumber, 100),
        ],
      ),
    );
  }

  Widget _buildTitleBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(child: Text(machineNumber)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text(
                machine.machineRole,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context, int progressPercentage,
      int totalProgress, int stepNumber, double circleRadius) {
    return Stack(
      children: [
        SizedBox(
          height: circleRadius,
          width: circleRadius,
          child: CircularProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Theme.of(context).disabledColor,
            strokeWidth: 10,
          ),
        ),
        SizedBox(
          height: circleRadius,
          width: circleRadius,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$progressPercentage %"),
              Text("$totalProgress / $stepNumber"),
            ],
          ),
        ),
      ],
    );
  }
}
