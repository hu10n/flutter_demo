import '../../../LocalData/data.dart';
import 'package:intl/intl.dart';

// Calculate Progress ----------------------------------------------------------
int calcpProgressPercentage(int totalProgress, int stepNumber) =>
    stepNumber > 0 ? ((totalProgress / stepNumber) * 100).toInt() : 0;

// int calcStepNumber(MachineData machine) => machine.childSteps.length;

// int calcTotalProgress(MachineData machine) {
//   int totalProgress = 0;
//   for (var step in machine.childSteps.values) {
//     totalProgress += step.stepStatus;
//   }
//   return totalProgress;
// }

// Get DateTime  ----------------------------------------------------------
String getTapTime() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd HH:mm');
  return formatter.format(now); // 指定したフォーマットで日付と時刻を返す
}

// Get Latest Step Editted Time
String getLatestEditedDateTime(String machineNumber) {
  MachineData machine = machineData[machineNumber]!;
  String latestEditedDateTime = machine.editedDateTime;

  for (SmallStep step in machine.childSteps.values) {
    if (step.editedDateTime.compareTo(latestEditedDateTime) > 0) {
      latestEditedDateTime = step.editedDateTime;
    }
  }

  return latestEditedDateTime;
}

// Added 0924 -----------------------------------------------
String formatTime(String time) {
  try {
    DateTime parsedTime = DateTime.parse(time);
    return DateFormat('yyyy/MM/dd HH:mm').format(parsedTime);
  } catch (e) {
    print('Error formatting time: $e');
    return 'Invalid Time';
  }
}

String getProductName(Map<String, dynamic> machine) {
  String productName;
  if (machine['project'] is List &&
      (machine['project'] as List).isNotEmpty &&
      machine['project'][0]['product_name'] != null) {
    productName = machine['project'][0]['product_name'];
  } else {
    productName = 'Product Name: N/A';
  }
  return productName;
}

int calculateTotalSteps(Map<String, dynamic> machine) {
  int totalSteps = 0;
  if (machine['project'] is List) {
    for (var project in machine['project']) {
      if (project['step'] is List) {
        totalSteps += (project['step'] as List).length;
      }
    }
  }
  return totalSteps;
}

int calculateTotalProgress(Map<String, dynamic> machine) {
  int sumOfProjectStatus = 0;
  if (machine['project'] is List) {
    for (var project in machine['project']) {
      if (project['step'] is List) {
        for (var step in project['step']) {
          if (step['project_status'] is num) {
            sumOfProjectStatus += (step['project_status'] as num).toInt();
          }
        }
      }
    }
  }
  return sumOfProjectStatus;
}
