import 'package:flutter/material.dart';
import '../_dev/StepDetailPage.dart';
import '../_dev/data.dart';

class StepListSliverList extends StatefulWidget {
  final String machineNumber;

  const StepListSliverList({Key? key, required this.machineNumber})
      : super(key: key);

  @override
  State<StepListSliverList> createState() => _StepListSliverListState();
}

class _StepListSliverListState extends State<StepListSliverList> {
  @override
  Widget build(BuildContext context) {
    final MachineData machine = machineData[widget.machineNumber]!;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // Summary Card 一番上に挿入する
            return Card(
                child: MachineSummaryCard(
              machine: machine,
            ));
          } else {
            // StepごとのCard
            final stepTitle = machine.childSteps.keys.elementAt(index - 1);
            final SmallStep step = machine.childSteps[stepTitle]!;
            return InkWell(
              child: StepListCard(step: step, stepTitle: stepTitle),
              onTap: () {
                _handleStepTap(context, stepTitle, step, machine);
              },
            );
          }
        },
        childCount: machine.childSteps.length + 1, // 追加した分だけ増やす
      ),
    );
  }

  void _handleStepTap(BuildContext context, String stepTitle, SmallStep step,
      MachineData machine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepDetailPage(
          machineNumber: widget.machineNumber,
          stepTitle: stepTitle,
        ),
      ),
    ).then((dataUpdated) {
      if (dataUpdated == true) {
        setState(() {
          machine.childSteps[stepTitle] = step;
        });
      }
    });
  }
}

class StepListCard extends StatelessWidget {
  const StepListCard({
    super.key,
    required this.step,
    required this.stepTitle,
  });

  final SmallStep step;
  final String stepTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Card(
        child: Row(
          children: [
            StepStatusIcon(status: step.stepStatus),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepTitleLabel(stepTitle: stepTitle),
                StepListSubtitle(step: step),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StepListSubtitle extends StatelessWidget {
  const StepListSubtitle({
    super.key,
    required this.step,
  });

  final SmallStep step;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SubtitleWithIcon(icon: Icons.person, text: step.editorName, width: 120),
      SubtitleWithIcon(
          icon: Icons.trending_up, text: step.production, width: 80),
      SubtitleWithIcon(
          icon: Icons.update, text: step.editedDateTime, width: 120),
    ]);
  }
}

class SubtitleWithIcon extends StatelessWidget {
  const SubtitleWithIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.width,
  });

  final IconData icon;
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Icon(
            icon,
            size: 13,
            color: Color.fromARGB(255, 80, 80, 80),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 80, 80, 80),
            ),
          ),
        ],
      ),
    );
  }
}

class StepTitleLabel extends StatelessWidget {
  const StepTitleLabel({
    super.key,
    required this.stepTitle,
  });

  final String stepTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(
        stepTitle,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class StepStatusIcon extends StatelessWidget {
  final int status;

  const StepStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color iconColor = status == 0 ? Colors.grey : Colors.green;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        Icons.check_circle_rounded,
        color: iconColor,
        size: 25.0,
      ),
    );
  }
}

class MachineSummaryCard extends StatelessWidget {
  const MachineSummaryCard({super.key, required this.machine});
  final MachineData machine;

  @override
  Widget build(BuildContext context) {
    // Calculate total progress (Number)
    int totalProgress = 0;
    for (var step in machine.childSteps.values) {
      totalProgress += step.stepStatus;
    }
    // Calculate Percentage (%) *Convert to Int*
    final stepNumber = machine.childSteps.length;
    final progressPercentage = ((totalProgress / stepNumber) * 100).toInt();

    return Card(
      child: Column(
        children: [
          CircularProgressIndicator(
            value: progressPercentage / 100, // 0~1の範囲で入力する必要がある
            backgroundColor: Colors.grey[300],
          ),
          Text("$totalProgress / $stepNumber"),
          Text("$progressPercentage %")
        ],
      ),
    );
  }
}
