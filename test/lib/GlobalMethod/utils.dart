import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/Screen/StepList/StepListPage.dart';
import 'package:test/providers/NavigationData.dart';

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
    'machine_id': null,
    'machine_status': null,
    'machine_name': null // <- Add this line
  };

  for (var data in dataList) {
    for (var project in data['project']) {
      if (project['project_id'] == projectId) {
        stepInfoMap["machine_id"] = project["machine_id"];
        stepInfoMap["machine_status"] = data["machine_status"];
        stepInfoMap["machine_name"] = data["machine_name"]; // <- Add this line

        // Sort the steps by step_num before processing
        List stepList = project['step'];
        stepList.sort((a, b) => a['step_num'].compareTo(b['step_num']));

        List<int> stepStatusList = [];
        for (var step in stepList) {
          stepStatusList.add(step['project_status']);
          if (step['project_status'] <= 0) {
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

// 画面遷移 -------------------------------------------------------------
void navigateToStepListPage(BuildContext context, String machineId,
    Function onScrollUp, Function onScrollDown) {
  final navigationData = NavigationData.of(context);
  Navigator.of(context).pop();
  if (navigationData != null) {
    final navigatorState = navigationData.pageKeys[0].currentState;
    if (navigatorState != null) {
      navigatorState.popUntil((route) => route.isFirst);
      navigationData.onTabChange(0);
    }
    navigateFromMachinToStepPage(
        context, navigatorState, machineId, onScrollUp, onScrollDown);
  }
}

void navigateFromMachinToStepPage(BuildContext context, navigatorState,
    String machineId, Function onScrollUp, Function onScrollDown) {
  onScrollUp(0);
  // 新しいページをプッシュします
  navigatorState
      .push(
    MaterialPageRoute(
      builder: (context) => StepListPage(
        machineId: machineId,
        onScrollDown: onScrollDown,
        onScrollUp: onScrollUp,
      ),
    ),
  )
      .then((dataUpdated) {
    // 新しいページから戻った後に状態を更新する必要がある場合
    // setState(() {});
  });
}

// Bottom Naviに関するPaddingを提供 -----------------------------------------
double bottomSafePaddingHeight(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}

double bottomBarHeightWithSafePadding(BuildContext context) {
  final safePadding = bottomSafePaddingHeight(context);

  return kToolbarHeight + safePadding;
}
