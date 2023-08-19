import 'package:flutter/material.dart';
import 'data.dart';

class StepDetailPage extends StatefulWidget {
  final String stepTitle;
  final String machineNumber;

  const StepDetailPage({
    Key? key,
    required this.stepTitle,
    required this.machineNumber,
  }) : super(key: key);

  @override
  _StepDetailPageState createState() => _StepDetailPageState();
}

class _StepDetailPageState extends State<StepDetailPage> {
  late SmallStep step;
  late TextEditingController editorNameController;
  late TextEditingController productionController;
  late TextEditingController editedDateTimeController;
  late TextEditingController reportController;

  @override
  void initState() {
    super.initState();

    // Get the step data from machineData using widget properties
    step = machineData[widget.machineNumber]!.childSteps[widget.stepTitle]!;

    // Initialize text controllers with step data
    editorNameController = TextEditingController(text: step.editorName);
    productionController = TextEditingController(text: step.production);
    editedDateTimeController = TextEditingController(text: step.editedDateTime);
    reportController = TextEditingController(text: step.reportDocument);
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
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: editorNameController,
              decoration: InputDecoration(labelText: 'Editor Name'),
            ),
            TextField(
              controller: productionController,
              decoration: InputDecoration(labelText: 'Production Number'),
            ),
            TextField(
              controller: editedDateTimeController,
              decoration: InputDecoration(labelText: 'Edited Date & Time'),
            ),
            TextField(
              controller: reportController,
              decoration: InputDecoration(labelText: 'Report'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save Button Action
                step.editorName = editorNameController.text;
                step.production = productionController.text;
                step.editedDateTime = editedDateTimeController.text;
                step.reportDocument = reportController.text;

                // Change stepStatus to 1
                step.stepStatus = 1;

                // Navigate back to the previous screen
                Navigator.pop(
                  context,
                  true,
                ); // Passing true to indicate data was updated
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
