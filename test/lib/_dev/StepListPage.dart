import 'package:flutter/material.dart';

import 'StepDetailPage.dart';
import 'data.dart';

// Detail画面での編集内容の反映にStateを使うのでStatfulWidgetにした。
class StepListPage extends StatefulWidget {
  final String machineNumber;

  const StepListPage({super.key, required this.machineNumber});

  @override
  State<StepListPage> createState() => _StepListPageState();
}

class _StepListPageState extends State<StepListPage> {
  @override
  Widget build(BuildContext context) {
    final MachineData machine = machineData[widget.machineNumber]!; // マシンデータを取得

    return Scaffold(
      appBar: AppBar(title: Text("Machine ${widget.machineNumber} Steps")),
      body: ListView.builder(
        itemCount: machine.childSteps.length,
        itemBuilder: (context, index) {
          final stepTitle = machine.childSteps.keys.elementAt(index);
          final SmallStep step = machine.childSteps[stepTitle]!;
          // Stepごとに以下のCardを作成(Tapイベントを使用するためにInkWellを使用)
          return InkWell(
            child: StepList_Card(step: step, stepTitle: stepTitle),
            onTap: () {
              StepList_PressAction(context, stepTitle, step, machine);
            },
          );
        },
      ),
    );
  }

  // Tapした時のイベント。
  void StepList_PressAction(BuildContext context, String stepTitle,
      SmallStep step, MachineData machine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepDetailPage(
          machineNumber: widget.machineNumber,
          stepTitle: stepTitle,
        ),
      ),
    ).then((dataUpdated) {
      // Detail画面でdata更新があり、戻ってきた際に表示項目をアップデートする
      if (dataUpdated == true) {
        // Data was updated, reload and rebuild the widget
        setState(() {
          // Reload data from the source
          machine.childSteps[stepTitle] = step;
        });
      }
    });
  }
}

class StepList_Card extends StatelessWidget {
  const StepList_Card({
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
                StepList_Subtitle(step: step),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StepList_Subtitle extends StatelessWidget {
  const StepList_Subtitle({
    super.key,
    required this.step,
  });

  final SmallStep step;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      StepList_Subtitle_with_Icon(
          icon: Icons.person, text: step.editorName, w: 120),
      StepList_Subtitle_with_Icon(
          icon: Icons.trending_up, text: step.production, w: 80),
      StepList_Subtitle_with_Icon(
          icon: Icons.update, text: step.editedDateTime, w: 120),
    ]);
  }
}

class StepList_Subtitle_with_Icon extends StatelessWidget {
  const StepList_Subtitle_with_Icon({
    super.key,
    required this.icon,
    required this.text,
    required this.w,
  });

  final IconData icon;
  final String text;
  final double w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
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
