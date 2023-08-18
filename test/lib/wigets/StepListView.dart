import 'package:flutter/material.dart';

import '../_dev/data.dart';
import '../_dev/StepDetailPage.dart';

class StepSliverList extends StatelessWidget {
  final Map<String, SmallStep> childSteps;
  final String machineNumber;

  StepSliverList({required this.childSteps, required this.machineNumber});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final stepTitle = childSteps.keys.elementAt(index);
          final SmallStep step = childSteps[stepTitle]!;

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
                      // step: step,
                    ),
                  ),
                );
              },
            ),
          );
        },
        childCount: childSteps.length,
      ),
    );
  }
}
