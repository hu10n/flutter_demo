import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../LocalData/data.dart';

class StepListCard extends StatelessWidget {
  final SmallStep step;
  final String stepTitle;
  final BuildContext context;
  final VoidCallback tapAction;

  const StepListCard({
    required this.step,
    required this.stepTitle,
    required this.context,
    required this.tapAction,
  });

  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: _buildStepListCard(),
        onTap: tapAction, // Just use the function reference here
      ),
    );
  }

  Widget _buildStepListCard() {
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
        _buildSubtitleWithIcon(Icons.person, step.editorName, 0.32),
        _buildSubtitleWithIcon(Icons.trending_up, step.production, 0.21),
        _buildSubtitleWithIcon(Icons.update, step.editedDateTime, 0.32),
      ],
    );
  }

  Widget _buildSubtitleWithIcon(IconData icon, String text, double ratio) {
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
}
