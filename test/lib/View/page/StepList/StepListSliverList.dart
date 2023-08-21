import 'package:flutter/material.dart';
import '../../../LocalData/data.dart';
import '../StepPreview/StepPreviewPage.dart';
import '../../../common/methods.dart';

class StepListSliverList extends StatefulWidget {
  final String machineNumber;

  const StepListSliverList({Key? key, required this.machineNumber})
      : super(key: key);

  @override
  State<StepListSliverList> createState() => _StepListSliverListState();
}

class _StepListSliverListState extends State<StepListSliverList> {
  // SliverListを返す ----------------------------------------------
  @override
  Widget build(BuildContext context) {
    final MachineData machine = machineData[widget.machineNumber]!;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return _buildMachineSummaryCard(machine);
          } else {
            final stepTitle = machine.childSteps.keys.elementAt(index - 1);
            final SmallStep step = machine.childSteps[stepTitle]!;
            return StepListCard(step, stepTitle, context, machine);
          }
        },
        childCount: machine.childSteps.length + 1,
      ),
    );
  }

  // Method, Widgetの定義 -----------------------------------------
  // Summary Card ----------
  Widget _buildMachineSummaryCard(MachineData machine) {
    final totalProgress = calcTotalProgress(machine);
    final stepNumber = calcStepNumber(machine);
    final progressPercentage =
        calcpProgressPercentage(totalProgress, stepNumber);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: CircularProgressIndicator(
                value: progressPercentage / 100,
                backgroundColor: Theme.of(context).disabledColor,
                strokeWidth: 10,
              ),
            ),
            SizedBox(
              height: 90,
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$progressPercentage %"),
                  Text("$totalProgress / $stepNumber"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card for Each Step ----------
  Material StepListCard(SmallStep step, String stepTitle, BuildContext context,
      MachineData machine) {
    return Material(
      // InkWellはMaterial Widgetを親に持つ必要がある。
      child: InkWell(
        child: _buildStepListCard(step, stepTitle),
        onTap: () {
          _handleStepCardTap(context, stepTitle, step, machine);
        },
      ),
    );
  }

  Widget _buildStepListCard(SmallStep step, String stepTitle) {
    return SizedBox(
      height: 70,
      child: Card(
        child: Row(
          children: [
            _buildStepStatusIcon(step.stepStatus),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepTitleLabel(stepTitle),
                _buildStepListSubtitle(step),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepStatusIcon(int status) {
    Color iconColor = status == 0
        ? Theme.of(context).disabledColor
        : Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        Icons.check_circle_rounded,
        color: iconColor,
        size: 25.0,
      ),
    );
  }

  Widget _buildStepTitleLabel(String stepTitle) {
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

  Widget _buildStepListSubtitle(SmallStep step) {
    return Row(
      children: [
        _buildSubtitleWithIcon(Icons.person, step.editorName, .3),
        _buildSubtitleWithIcon(Icons.trending_up, step.production, .25),
        _buildSubtitleWithIcon(Icons.update, step.editedDateTime, .3),
      ],
    );
  }

  Widget _buildSubtitleWithIcon(IconData icon, String text, double ratio) {
    // 画面サイズを取得
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * ratio,
      child: Row(
        children: [
          Icon(
            icon,
            size: 13,
            color: Colors.grey,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Card Tap Event ----------
  void _handleStepCardTap(BuildContext context, String stepTitle,
      SmallStep step, MachineData machine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepPreviewPage(
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
