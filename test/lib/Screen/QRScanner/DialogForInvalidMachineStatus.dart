import 'package:flutter/material.dart';
import 'package:test/GlobalMethod/utils.dart';
import 'package:test/GlobalWidget/MachineStatusIndicator.dart';

class InvalidMachineStatusDialog extends StatefulWidget {
  final Function onScrollUp;
  final Map stepInfoMap;
  final Function onScrollDown;

  const InvalidMachineStatusDialog(
      {super.key,
      required this.stepInfoMap,
      required this.onScrollUp,
      required this.onScrollDown});

  @override
  State<InvalidMachineStatusDialog> createState() =>
      _InvalidMachineStatusDialogState();
}

class _InvalidMachineStatusDialogState
    extends State<InvalidMachineStatusDialog> {
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
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            // New Column wrapper
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '・機名: ${widget.stepInfoMap['machine_name']}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    '・状態: ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  MachineStatusIndicator(
                      context: context,
                      machineStatus: widget.stepInfoMap['step_status_to_edit'])
                ],
              ),
              SizedBox(height: 20),
              Text(
                "報告を作成できません",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         navigateToStepListPage(
          //             context,
          //             widget.stepInfoMap['machine_id'],
          //             widget.onScrollUp,
          //             widget.onScrollDown);
          //       },
          //       child: Text('確認'),
          //     ),
          //   ],
          // ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
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
