import '../../../LocalData/data.dart';
import 'package:intl/intl.dart';

// Calculate Progress ----------------------------------------------------------
int calcpProgressPercentage(int totalProgress, int stepNumber) =>
    ((totalProgress / stepNumber) * 100).toInt();

int calcStepNumber(MachineData machine) => machine.childSteps.length;

int calcTotalProgress(MachineData machine) {
  int totalProgress = 0;
  for (var step in machine.childSteps.values) {
    totalProgress += step.stepStatus;
  }
  return totalProgress;
}

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

Map<String, double> calculateScrollAmount(Map<String, int> machineCardCount) {
  double totalHeight = 0.0;
  Map<String, double> scrollAmount = {};

  for (var entry in machineCardCount.entries) {
    String category = entry.key;
    int count = entry.value;
    double categoryHeight = count * 78.0 + 25.0;

    totalHeight += categoryHeight;
    scrollAmount[category] = totalHeight;
  }

  return scrollAmount;
}
