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

// Get Tapped DateTime  ---------------------------
String getTapTime() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd HH:mm');
  return formatter.format(now); // 指定したフォーマットで日付と時刻を返す
}

// Get Latest Step Editted Time --------------------
String getLatestUpdatedAt(Map<String, dynamic> machine) {
  DateTime? latestUpdated;

  if (machine['project'] is List) {
    for (var project in machine['project']) {
      if (project['step'] is List) {
        for (var step in project['step']) {
          final updatedAtStr = step['updated_at'];
          if (updatedAtStr is String) {
            try {
              final updatedAt = DateTime.parse(updatedAtStr);
              if (latestUpdated == null || updatedAt.isAfter(latestUpdated)) {
                latestUpdated = updatedAt;
              }
            } catch (e) {
              print('Error parsing date: $e');
            }
          }
        }
      }
    }
  }

  return latestUpdated != null ? latestUpdated.toIso8601String() : "N/A";
}

// Formatting Unix DateTime to Readable Format -----------------------------------------------
String formatTime(String time) {
  if (time == 'N/A') {
    return time;
  }

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

Map<String, dynamic> getStepInfoMap(List dataList, String projectId) {
  Map<String, dynamic> stepInfoMap = {
    'step_status_to_edit': null,
    'step_to_edit': null,
    'stepStatusList': [],
  };

  for (var data in dataList) {
    for (var project in data['project']) {
      if (project['project_id'] == projectId) {
        List<int> stepStatusList = [];
        for (var step in project['step']) {
          stepStatusList
              .add(step['project_status']); // constructing stepStatusList
          if (step['project_status'] <= 0) {
            // prioritizing -1 over 0 for step_status_to_edit and step_to_edit assignment
            if (stepInfoMap['step_status_to_edit'] == null ||
                step['project_status'] < stepInfoMap['step_status_to_edit']) {
              stepInfoMap['step_status_to_edit'] = step['project_status'];
              stepInfoMap['step_to_edit'] = step;
            }
          }
        }
        stepInfoMap['stepStatusList'] = stepStatusList;
        break; // break early when the projectId is found
      }
    }
  }

  return stepInfoMap;
}
