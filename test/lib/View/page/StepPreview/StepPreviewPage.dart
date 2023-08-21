import 'package:flutter/material.dart';
import '../../../LocalData/data.dart';
import '../../../common/methods.dart';

class StepPreviewPage extends StatefulWidget {
  final String stepTitle;
  final String machineNumber;

  const StepPreviewPage({
    Key? key,
    required this.stepTitle,
    required this.machineNumber,
  }) : super(key: key);

  @override
  _StepDetailPageState createState() => _StepDetailPageState();
}

class _StepDetailPageState extends State<StepPreviewPage> {
  late final SmallStep step;
  late final TextEditingController editorNameController =
      TextEditingController();
  late final TextEditingController productionController =
      TextEditingController();
  // late final TextEditingController editedDateTimeController = TextEditingController();
  late final TextEditingController reportController = TextEditingController();
  bool editingMode = false;

  @override
  void initState() {
    super.initState();

    // Get the step data from machineData using widget properties
    step = machineData[widget.machineNumber]!.childSteps[widget.stepTitle]!;

    // Initialize text controllers with step data
    editorNameController.text = step.editorName;
    productionController.text = step.production;
    // editedDateTimeController.text = step.editedDateTime;
    reportController.text = step.reportDocument;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar:
          AppBar(title: Text("${widget.machineNumber} ${widget.stepTitle}")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Editor Name", editorNameController),
            _buildTextField("Production Number", productionController),
            // _buildTextField("Edited Date & Time", editedDateTimeController),
            _buildTextField("Report", reportController),
            const SizedBox(height: 16.0),
            if (!editingMode)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    editingMode = true;
                  });
                },
                child: Text('Edit'),
              ),
            if (editingMode)
              ElevatedButton(
                onPressed: () {
                  // Switch back to non-editing mode
                  setState(() {
                    editingMode = false;
                  });
                  // Other Actions
                  _handleSaveButtonPressed(context);
                },
                child: Text('Save & Close'),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSaveButtonPressed(BuildContext context) {
    setState(() {
      // Save Entry Values to data
      step.editorName = editorNameController.text;
      step.production = productionController.text;
      step.reportDocument = reportController.text;

      // Record the time when the onTap event occurs
      String tapTime = getTapTime();
      step.editedDateTime = tapTime;

      // Change stepStatus to 1
      step.stepStatus = 1;

      // Navigate back to the previous screen
      Navigator.pop(
        context,
        true,
      ); // Passing true to indicate data was updated

      // Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes Saved')),
      );
    });
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return editingMode
        ? TextField(
            enabled: true,
            controller: controller,
            decoration: InputDecoration(labelText: labelText),
          )
        : TextField(
            enabled: false,
            controller: controller,
            decoration: InputDecoration(labelText: labelText),
          );
  }
}
