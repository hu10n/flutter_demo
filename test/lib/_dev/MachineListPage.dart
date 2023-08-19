import 'package:flutter/material.dart';
import 'package:test/_dev/QR_Reader_Page.dart';

import 'StepListPage.dart';
import 'data.dart';

class MachineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final machineNumber = machineData.keys.elementAt(index);
          final machine = machineData[machineNumber];
          return Card(
            child: ListTile(
              title: Text(machineNumber),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Name: ${machine?.productName}'),
                  Text('Material: ${machine?.material}'),
                  Text('Lot Number: ${machine?.lotNumber}'),
                  Text('Edited Date & Time: ${machine?.editedDateTime}'),
                  Text('Progress: ${machine?.progress}%'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          // StepListPage(machineNumber: machineNumber),
                          QRViewExample()),
                );
              },
            ),
          );
        },
        childCount: machineData.length,
      ),
    );
  }
}
