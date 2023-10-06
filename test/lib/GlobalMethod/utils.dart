import 'package:intl/intl.dart';

// format large Number
String formatNumber(int? number) {
  if (number == null) {
    return "N/A";
  }
  return NumberFormat("#,###").format(number);
}

// Calculate Progress ----------------------------------------------------------
int calcpProgressPercentage(int totalProgress, int stepNumber) =>
    stepNumber > 0 ? ((totalProgress / stepNumber) * 100).toInt() : 0;

// Get Tapped DateTime  ---------------------------
String getTapTime() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd HH:mm');
  return formatter.format(now); // 指定したフォーマットで日付と時刻を返す
}

// Get Latest Step Editted Time --------------------
String getLatestUpdatedAt(Map<String, dynamic> machine) {
  DateTime? latestUpdated;

  // Helper function to compare and update the latestUpdated date
  void updateLatestUpdated(String? updatedAtStr) {
    if (updatedAtStr is String) {
      try {
        final updatedAt = DateTime.parse(updatedAtStr);
        if (latestUpdated == null || updatedAt.isAfter(latestUpdated!)) {
          latestUpdated = updatedAt;
        }
      } catch (e) {
        // print('Error parsing date: $e');
      }
    }
  }

  // Check machine["updated_at"]
  updateLatestUpdated(machine['updated_at'] as String?);

  if (machine['project'] is List) {
    for (var project in machine['project']) {
      // Check project["updated_at"]
      updateLatestUpdated(project['updated_at'] as String?);

      if (project['step'] is List) {
        for (var step in project['step']) {
          updateLatestUpdated(step['updated_at'] as String?);
        }
      }
    }
  }

  // Ensure latestUpdated is not null before calling toIso8601String
  return latestUpdated?.toIso8601String() ?? "N/A";
}

// Formatting Unix DateTime to Readable Format -----------------------------------------------
String formatTime(String? time) {
  if (time == null || time == 'N/A') {
    return 'N/A';
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
    productName = 'N/A';
  }
  return productName;
}

String getProductNumber(Map<String, dynamic> machine) {
  String productNumber;
  if (machine['project'] is List &&
      (machine['project'] as List).isNotEmpty &&
      machine['project'][0]['product_num'] != null) {
    productNumber = machine['project'][0]['product_num'];
  } else {
    productNumber = 'N/A';
  }
  return productNumber;
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
  int countOfCompletedSteps = 0;
  if (machine['project'] is List) {
    for (var project in machine['project']) {
      if (project['step'] is List) {
        for (var step in project['step']) {
          if (step['project_status'] is num && step['project_status'] == 1) {
            countOfCompletedSteps++;
          }
        }
      }
    }
  }
  return countOfCompletedSteps;
}

Map<String, dynamic> getStepInfoMap(List dataList, String projectId) {
  Map<String, dynamic> stepInfoMap = {
    'step_status_to_edit': null,
    'step_to_edit': null,
    'stepStatusList': [],
    'machine_id': null
  };

  for (var data in dataList) {
    for (var project in data['project']) {
      if (project['project_id'] == projectId) {
        stepInfoMap["machine_id"] = project["machine_id"];
        // Sort the steps by step_num before processing
        List stepList = project['step'];
        stepList.sort((a, b) => a['step_num'].compareTo(b['step_num']));

        List<int> stepStatusList = [];
        for (var step in stepList) {
          stepStatusList
              .add(step['project_status']); // constructing stepStatusList
          if (step['project_status'] <= 0) {
            // prioritizing -1 over 0 for stepStatus and step_to_edit assignment
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
