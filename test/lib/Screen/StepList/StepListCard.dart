import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/GlobalMethod/CommonMethods.dart';

import '../../providers/DataProvider.dart';

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
    int productionVolume = 0;

    for (var project in (machine['project'] as List)) {
      for (var s in (project['step'] as List)) {
        if (s['step_id'] == stepId) {
          stepTitle = s['step_name'] ?? '';
          stepStatus = s['project_status'] as int?;
          // stepStatus = 1; //test
          worker = s['worker'] ?? '';
          updatedAt = formatTime(s['updated_at'] ?? '');
          productionVolume = s['production_volume'] ?? 0;
        }
      }
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: tapAction,
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
    switch (status) {
      case 0:
        iconColor = Theme.of(context).disabledColor;
        break;
      case -1:
        iconColor = Colors.yellow;
        break;
      case 1:
        iconColor = Colors.green;
        break;
      default:
        iconColor = Theme.of(context).disabledColor; // 0, -1, 1以外の場合もグレーに設定
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        Icons.check_circle_rounded,
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
      String worker, String updatedAt, int productionVolume) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createSubtitleWithIcon(Icons.person, worker),
        _createSubtitleWithIcon(Icons.inventory, productionVolume.toString()),
        _createSubtitleWithIcon(Icons.update, updatedAt),
      ],
    );
  }

  Widget _createSubtitleWithIcon(IconData icon, String text) {
    return SizedBox(
      width: 120,
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
