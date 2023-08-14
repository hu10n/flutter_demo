import 'package:flutter/material.dart';

import 'StepDetailPage.dart';
import 'data.dart';

class StepListPage extends StatelessWidget {
  final String machineNumber;

  StepListPage({required this.machineNumber});

  @override
  Widget build(BuildContext context) {
    final MachineData machine = machineData[machineNumber]!; // マシンデータを取得

    return Scaffold(
      appBar: AppBar(title: Text("Machine $machineNumber Steps")),
      body: ListView.builder(
        itemCount: machine.childSteps.length,
        itemBuilder: (context, index) {
          final stepTitle = machine.childSteps.keys.elementAt(index);
          final SmallStep step = machine.childSteps[stepTitle]!;

          return Card(
            child: ListTile(
              title: Text(stepTitle),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Editor Name: ${step.editorName}'),
                  Text('Produced Number: ${step.production}'),
                  Text('Edited Date & Time: ${step.editedDateTime}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StepDetailPage(
                      machineNumber: machineNumber,
                      stepTitle: stepTitle,
                      step: step,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ... 他のウィジェットやコード ...