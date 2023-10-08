import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalWidget/MachineStatusIndicator.dart';
import 'package:test/GlobalMethod/utils.dart';

class MachineListCard extends StatelessWidget {
  const MachineListCard({
    Key? key,
    required this.machineId,
    required this.ontapAction,
  }) : super(key: key);

  final String machineId;
  final VoidCallback ontapAction;

  @override
  Widget build(BuildContext context) {
    final dataList = Provider.of<DataNotifier>(context).dataList;

    Map<String, dynamic> machine = dataList.firstWhere(
      (element) => element['machine_id'] == machineId,
    );

    String machineNumber =
        "${machine['machine_group']}-${machine['machine_num'].toString()}";
    int machineStatus = machine['machine_status'] ?? 0;
    String latestEditedDateTime = formatTime(getLatestUpdatedAt(machine));
    String machineName = machine['machine_name'];
    String productNumber = getProductNumber(machine);
    String productName = getProductName(machine);

    //int totalSteps = calculateTotalSteps(machine);
    //int totalProgress = calculateTotalProgress(machine);
    // print("$sumOfProjectStatus/$totalSteps");

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              _createMachineNumberBox(machineNumber, machineName),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _createProductInfoBox(productNumber!, productName!),
                        _createMachineStatusBox(
                            context, machineStatus, latestEditedDateTime),
                      ],
                    ),
                    _createMachineProgressBox(context, machine),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          ontapAction();
        },
      ),
    );
  }

  Widget _createMachineNumberBox(String machineNumber, String machineName) {
    return Container(
      width: 60,
      // alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            machineNumber,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          Text(
            machineName,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _createProductInfoBox(String productNumber, String productName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              productNumber,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(
          height: 15,
          child: Text(
            productName,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }

  Widget _createMachineStatusBox(
      BuildContext context, int machineStatus, String latestEditedDateTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 30,
              child: MachineStatusIndicator(
                  context: context, machineStatus: machineStatus)),
          Container(
            width: 110,
            child: Text(
              latestEditedDateTime,
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).disabledColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMachineProgressBox(
      BuildContext context, Map<String, dynamic> machine) {
    List<int> stepStatusList = [];

    if (machine['project'] != null && machine['project'].isNotEmpty) {
      stepStatusList = (machine['project'][0]['step'] as List)
          .map<int>((dynamic stepMap) =>
              (stepMap as Map<String, dynamic>)['project_status'] as int)
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          for (int status in stepStatusList)
            Row(
              children: [
                Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).disabledColor, width: 1),
                    borderRadius: BorderRadius.circular(2),
                    color: status == 1
                        ? Theme.of(context).colorScheme.primary
                        : status == -1
                            ? Color(0xff88F7E2)
                            : Theme.of(context).colorScheme.background,
                  ),
                ),
                SizedBox(
                  width: 1,
                )
              ],
            ),
        ],
      ),
    );
  }
}
