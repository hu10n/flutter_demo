class SmallStep {
  String editorName;
  String production;
  String editedDateTime;
  String reportDocument;
  int stepStatus;

  SmallStep({
    required this.editorName,
    required this.production,
    required this.editedDateTime,
    required this.reportDocument,
    required this.stepStatus,
  });
}

class MachineData {
  final String machineCategory;
  final String machineRole;
  final String productName;
  final String material;
  final String lotNumber;
  String editedDateTime;
  int progress;
  int machineStatus;
  Map<String, SmallStep> childSteps;

  var machineNumber; // データの型を指定

  MachineData({
    required this.machineCategory,
    required this.machineRole,
    required this.productName,
    required this.material,
    required this.lotNumber,
    required this.editedDateTime,
    required this.progress,
    required this.childSteps,
    required this.machineStatus,
  });
}

Map<String, MachineData> machineData = {
  "A-1": MachineData(
    machineCategory: "A",
    machineRole: "Machine Role A-1",
    productName: "Product A-1",
    material: "Material A-1",
    lotNumber: "lot A-1",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 0,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[A-1 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report A-1 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[A-1 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report A-1 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[A-1 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S3",
        stepStatus: 0,
      ),
      "Step 4": SmallStep(
        editorName: "Editor[A-1 S4]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S4",
        stepStatus: 0,
      ),
      "Step 5": SmallStep(
        editorName: "Editor[A-1 S5]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S5",
        stepStatus: 0,
      ),
      "Step 6": SmallStep(
        editorName: "Editor[A-1 S6]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S6",
        stepStatus: 0,
      ),
      "Step 7": SmallStep(
        editorName: "Editor[A-1 S7]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S7",
        stepStatus: 0,
      ),
      "Step 8": SmallStep(
        editorName: "Editor[A-1 S7]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S7",
        stepStatus: 0,
      ),
      "Step 9": SmallStep(
        editorName: "Editor[A-1 S7]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-1 S7",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "A-2": MachineData(
    machineCategory: "A",
    machineRole: "Machine Role A-2",
    productName: "Product A-2",
    material: "Material A-2",
    lotNumber: "lot A-2",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 1,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[A-2 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report A-2 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[A-2 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report A-2 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[A-2 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-2 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "A-3": MachineData(
    machineCategory: "A",
    machineRole: "Machine Role A-3",
    productName: "Product A-3",
    material: "Material A-3",
    lotNumber: "lot A-3",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 2,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[A-3 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report A-3 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[A-3 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report A-3 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[A-3 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report A-3 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "B-1": MachineData(
    machineCategory: "B",
    machineRole: "Machine Role B-1",
    productName: "Product B-1",
    material: "Material B-1",
    lotNumber: "lot B-1",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 0,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[B-1 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report B-1 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[B-1 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report B-1 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[B-1 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report B-1 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "B-2": MachineData(
    machineCategory: "B",
    machineRole: "Machine Role B-1",
    productName: "Product B-2",
    material: "Material B-2",
    lotNumber: "lot B-2",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 1,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[B-2 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report B-2 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[B-2 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report B-2 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[B-2 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report B-2 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "B-3": MachineData(
    machineCategory: "B",
    machineRole: "Machine Role B-1",
    productName: "Product B-3",
    material: "Material B-3",
    lotNumber: "lot B-3",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 3,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[B-3 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report B-3 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[B-3 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report B-3 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[B-3 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report B-3 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "C-1": MachineData(
    machineCategory: "C",
    machineRole: "Machine Role C-1",
    productName: "Product C-1",
    material: "Material C-1",
    lotNumber: "lot C-1",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 0,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[C-1 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report C-1 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[C-1 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report C-1 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[C-1 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report C-1 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "C-2": MachineData(
    machineCategory: "C",
    machineRole: "Machine Role C-1",
    productName: "Product C-2",
    material: "Material C-2",
    lotNumber: "lot C-2",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 1,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[C-2 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report C-2 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[C-2 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report C-2 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[C-2 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report C-2 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "C-3": MachineData(
    machineCategory: "C",
    machineRole: "Machine Role C-1",
    productName: "Product C-3",
    material: "Material C-3",
    lotNumber: "lot C-3",
    editedDateTime: "2023/08/13 10:00",
    progress: 0,
    machineStatus: 4,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor[C-3 S1]",
        production: "10,000",
        editedDateTime: "2023/08/13 11:00",
        reportDocument: "Report C-3 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor[C-3 S2]",
        production: "10,000",
        editedDateTime: "2023/08/13 12:00",
        reportDocument: "Report C-3 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor[C-3 S3]",
        production: "10,000",
        editedDateTime: "2023/08/13 13:00",
        reportDocument: "Report C-3 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
};
