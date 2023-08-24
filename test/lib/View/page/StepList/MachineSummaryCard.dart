import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../LocalData/data.dart';
import '../../../common/methods.dart';

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

    return Card(
      child: Column(
        children: [
          _buildTitleBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMachineStatusBox(context, machineStatus, progressPercentage,
                  totalProgress, stepNumber),
              _buildProductSpecBox(productName, material, lotNumber)
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

  SizedBox _buildProductSpecBox(
      String productName, String material, String lotNumber) {
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
          Text("Lot番号:$lotNumber")
        ],
      ),
    );
  }

  Widget _buildMachineStatusBox(BuildContext context, int machineStatus,
      int progressPercentage, int totalProgress, int stepNumber) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          _buildMachineStatusText(context, machineStatus),
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

  Widget _buildMachineStatusText(BuildContext context, int machineStatus) {
    Color circleColor;
    String statusText;

    switch (machineStatus) {
      case 0:
        circleColor = Colors.grey;
        statusText = "未稼働";
        break;
      case 1:
        circleColor = Colors.pinkAccent;
        statusText = "停止中";
        break;
      case 2:
        circleColor = Colors.red;
        statusText = "異常停止中";
        break;
      case 3:
        circleColor = Colors.yellow;
        statusText = "メンテナンス中";
        break;
      case 4:
        circleColor = Colors.green;
        statusText = "稼働中";
        break;
      default:
        circleColor = Colors.black12;
        statusText = "Error";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
        ),
        SizedBox(width: 5),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
