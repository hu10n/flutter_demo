import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DataClass.dart';
import '../../../common/MachineStatusText.dart';

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

    Map<String, dynamic> machine =
        dataList.firstWhere((element) => element['machine_id'] == machineId,
            orElse: () => {
                  'machine_id': '',
                  'machine_num': 'N/A',
                  'machine_status': 0,
                  'updated_at': 'N/A',
                  'project': []
                });

    String machineNum = machine['machine_num'].toString();
    String category = machine['machine_group'];
    String machineNumber = "$category-$machineNum";
    int machineStatus = machine['machine_status'] ?? 0;

    String latestEditedDateTime = machine['updated_at'];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              _buildMachineNumberBox(machineNumber),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMachineNameBox(
                            machine['machine_name'], "dummy-Product-Name"),
                        _buildMachineStatusBox(
                            context, machineStatus, latestEditedDateTime),
                      ],
                    ),
                    _buildMachineProgressBox(context, machine),
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

  Widget _buildMachineNumberBox(String machineNumber) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          child: Text(
        machineNumber,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      )),
    );
  }

  Widget _buildMachineNameBox(String machineName, String productName) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              machineName,
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

  Widget _buildMachineStatusBox(
      BuildContext context, int machineStatus, String latestEditedDateTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 30,
              child: MachineStatusText(
                  context: context, machineStatus: machineStatus)),
          Text(
            latestEditedDateTime,
            style:
                TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineProgressBox(
      BuildContext context, Map<String, dynamic> machine) {
    final List<dynamic> projects = machine['project'] ?? [];

    final int totalProgress = projects.fold(
        0, (sum, project) => sum + (project['project_status'] as int));

    final int stepNumber = projects.length;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          for (int i = 0; i < stepNumber; i++)
            Row(
              children: [
                Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).disabledColor, width: 1),
                    borderRadius: BorderRadius.circular(2),
                    color: i < totalProgress
                        ? Theme.of(context).colorScheme.primary
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
