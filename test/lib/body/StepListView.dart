import 'package:flutter/material.dart';
import '../_dev/StepDetailPage.dart';
import '../_dev/data.dart';

class StepListView extends StatelessWidget {
  final MachineData machine;
  final String machineNumber;

  StepListView({required this.machine, required this.machineNumber});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
