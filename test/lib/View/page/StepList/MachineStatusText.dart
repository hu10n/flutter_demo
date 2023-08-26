import 'package:flutter/material.dart';

class MachineStatusText extends StatelessWidget {
  const MachineStatusText({
    super.key,
    required this.context,
    required this.machineStatus,
  });

  final BuildContext context;
  final int machineStatus;

  @override
  Widget build(BuildContext context) {
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
