import 'package:flutter/material.dart';
import 'package:test/GlobalWidget/MachineStatusIndicator.dart';

class InvalidMachineStatusDialog extends StatelessWidget {
  final int machineStatus;
  final String machineName;

  InvalidMachineStatusDialog(
      {required this.machineStatus, required this.machineName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('作業機の状態を確認'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('・機番: $machineName'),
          Row(
            children: [
              Text('・状態: '),
              MachineStatusIndicator(
                  context: context, machineStatus: machineStatus)
            ],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('閉じる'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
