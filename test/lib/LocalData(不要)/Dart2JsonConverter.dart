import 'data.dart';

List<Map<String, dynamic>> machineDataJsonList =
    machineData.entries.map((entry) {
  String machineId = entry.key;
  MachineData machine = entry.value;

  Map<String, dynamic> JsonFormatData = {
    'machineId': machineId,
    'machineCategory': machine.machineCategory,
    'productName': machine.productName,
    'material': machine.material,
    'lotNumber': machine.lotNumber,
    'editedDateTime': machine.editedDateTime,
    'progress': machine.progress,
    'machineStatus': machine.machineStatus,
    'childSteps': machine.childSteps.entries.map((stepEntry) {
      String stepId = stepEntry.key;
      SmallStep step = stepEntry.value;

      return {
        'stepId': stepId,
        'editorName': step.editorName,
        'production': step.production,
        'editedDateTime': step.editedDateTime,
        'reportDocument': step.reportDocument,
        'stepStatus': step.stepStatus,
      };
    }).toList(),
  };

  return JsonFormatData;
}).toList();
