import 'package:flutter/material.dart';
import 'data.dart' as myData;

class StepDetailPage extends StatefulWidget {
  final myData.SmallStep step;
  final String stepTitle;
  final String machineNumber;

  StepDetailPage({
    required this.step,
    required this.stepTitle,
    required this.machineNumber,
  });

  @override
  _StepDetailPageState createState() => _StepDetailPageState();
}

class _StepDetailPageState extends State<StepDetailPage> {
  late TextEditingController editorNameController;
  late TextEditingController productionController;
  late TextEditingController editedDateTimeController;
  late TextEditingController reportController;

  @override
  void initState() {
    super.initState();
    editorNameController = TextEditingController(text: widget.step.editorName);
    productionController = TextEditingController(text: widget.step.production);
    editedDateTimeController =
        TextEditingController(text: widget.step.editedDateTime);
    reportController = TextEditingController(text: widget.step.reportDocument);
  }

  @override
  void dispose() {
    editorNameController.dispose();
    productionController.dispose();
    editedDateTimeController.dispose();
    reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("${widget.machineNumber} ${widget.stepTitle}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: editorNameController,
                decoration: InputDecoration(labelText: 'Editor Name')),
            TextField(
                controller: productionController,
                decoration: InputDecoration(labelText: 'Production Number')),
            TextField(
                controller: editedDateTimeController,
                decoration: InputDecoration(labelText: 'Edited Date & Time')),
            TextField(
                controller: reportController,
                decoration: InputDecoration(labelText: 'Report')),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save Button Action
                widget.step.editorName = editorNameController.text;
                widget.step.production = productionController.text;
                widget.step.editedDateTime = editedDateTimeController.text;
                widget.step.reportDocument = reportController.text;
                Navigator.pop(context, widget.machineNumber);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}