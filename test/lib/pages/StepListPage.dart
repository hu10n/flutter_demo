import 'package:flutter/material.dart';

import '../body/StepListView.dart';

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
