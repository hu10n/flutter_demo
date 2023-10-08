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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        '作業機の状態を確認',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '・機名: $machineName',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 15), // スペースを追加
          Row(
            children: [
              Text(
                '・状態: ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              MachineStatusIndicator(
                  context: context, machineStatus: machineStatus)
            ],
          ),
          SizedBox(height: 20), // スペースを追加
          Text(
            "報告を作成できません",
            style: TextStyle(
              fontSize: 18,
              color: Colors.red, // 警告メッセージの色を赤にする
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            '閉じる',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
