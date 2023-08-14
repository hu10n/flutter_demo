import 'package:flutter/material.dart';

import 'StepListPage.dart';
import 'data.dart';

class MachineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final machineNumber = machineData.keys.elementAt(index);
          final MachineDetail = machineData[machineNumber];

              return ListTile( 
                  title: Text(machineNumber),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Name: ${MachineDetail?.productName}'),
                      Text('Material: ${MachineDetail?.material}'),
                      Text('Lot Number: ${MachineDetail?.lotNumber}'),
                      Text('Edited Date & Time: ${MachineDetail?.editedDateTime}'),
                      Text('Progress: ${MachineDetail?.progress}%'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StepListPage(machineNumber: machineNumber),
                      ),
                    );
                  },
              );
        },
      childCount: machineData.length,
      ),
    );
  }
}