import 'package:flutter/material.dart';

import '../_dev/data.dart';
import '../body/StepListView_v2.dart';

class StepListPage extends StatelessWidget {
  final String machineNumber;

  StepListPage({required this.machineNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Machine $machineNumber Steps")),
      body: StepListView(machineNumber: machineNumber), // ここで新しいウィジェットを使用
    );
  }
}
