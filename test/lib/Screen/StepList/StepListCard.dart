import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/GlobalMethod/utils.dart';

import 'package:test/providers/DataProvider.dart';

class StepListCard extends StatelessWidget {
  final String machineId; // 追加されたプロパティ
  final String stepId; // 追加されたプロパティ
  final VoidCallback tapAction;

  const StepListCard({
    required this.machineId, // コンストラクタでmachineIdを要求
    required this.stepId, // コンストラクタでstepIdを要求
    required this.tapAction,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final dataList = Provider.of<DataNotifier>(context).dataList;
    //print(dataList[2]);
    Map<String, dynamic> machine = dataList.firstWhere(
      (element) => element['machine_id'] == machineId,
    );

    String stepTitle = '';
    int? stepStatus;
    String worker = '';
    String updatedAt = '';
    String productionVolume = '';

    for (var project in (machine['project'] as List)) {
      for (var s in (project['step'] as List)) {
        if (s['step_id'] == stepId) {
          stepTitle = s['step_name'] ?? '';
          stepStatus = s['project_status'] as int?;
          // stepStatus = 1; //test
          worker = s['worker'] ?? '';
          updatedAt = formatTime(s['updated_at'] ?? '');
          productionVolume = formatNumber(s['production_volume']) ?? '';
        }
      }
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => tapAction(),
        child: SizedBox(
          width: screenWidth,
          height: 70,
          child: Row(
            children: [
              _createStepStatusIcon(context, stepStatus!),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _createStepTitleLabel(stepTitle),
                    _createStepListSubtitle(
                        worker, updatedAt, productionVolume),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createStepStatusIcon(BuildContext context, int status) {
    Color iconColor;
    IconData iconData;
    switch (status) {
      // Disabled
      case 0:
        iconColor = Theme.of(context).disabledColor;
        iconData = Icons.pending;
        break;
      // On Going
      case -1:
        iconColor = Theme.of(context).colorScheme.secondary;
        iconData = Icons.play_circle_fill;
        break;
      // Completed
      case 1:
        iconColor = Theme.of(context).colorScheme.primary;
        iconData = Icons.check_circle_rounded;
        break;
      default:
        iconColor = Theme.of(context).disabledColor;
        iconData = Icons.check_circle_rounded;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        iconData,
        color: iconColor,
        size: 25.0,
      ),
    );
  }

  Widget _createStepTitleLabel(String stepTitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(
        stepTitle,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _createStepListSubtitle(
      String worker, String updatedAt, String productionVolume) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: _createSubtitleWithIcon(Icons.person, worker),
        ),
        Flexible(
          flex: 4,
          child: _createSubtitleWithIcon(
              Icons.inventory, productionVolume.toString()),
        ),
        Flexible(
          flex: 5,
          child: _createSubtitleWithIcon(Icons.update, updatedAt),
        ),
      ],
    );
  }

  Widget _createSubtitleWithIcon(IconData icon, String text) {
    return Row(
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
    );
  }
}
