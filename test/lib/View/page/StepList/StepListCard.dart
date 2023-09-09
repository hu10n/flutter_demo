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
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: tapAction,
        child: SizedBox(
          width: screenWidth,
          height: 60,
          child: Row(
            children: [
              _buildStepStatusIcon(step.stepStatus),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepTitleLabel(stepTitle),
                    _buildStepListSubtitle(step),
                  ],
                ),
              ),
            ],
          ),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSubtitleWithIcon(Icons.person, step.editorName),
        _buildSubtitleWithIcon(Icons.trending_up, step.production),
        _buildSubtitleWithIcon(Icons.update, step.editedDateTime),
      ],
    );
  }

  Widget _buildSubtitleWithIcon(IconData icon, String text) {
    return SizedBox(
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
