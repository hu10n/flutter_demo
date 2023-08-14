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
  final String productName;
  final String material;
  final String lotNumber;
  String editedDateTime;
  int progress;
  Map<String, SmallStep> childSteps; // データの型を指定

  MachineData({
    required this.productName,
    required this.material,
    required this.lotNumber,
    required this.editedDateTime,
    required this.progress,
    required this.childSteps,
  });
}

Map<String, MachineData> machineData = {
  "A-1": MachineData(
    productName: "Product A-1",
    material: "Material A-1",
    lotNumber: "lot A-1",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor A-1 S1",
        production: "A-1 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report A-1 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor A-1 S2",
        production: "A-1 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report A-1 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor A-1 S3",
        production: "A-1 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report A-1 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "A-2": MachineData(
    productName: "Product A-2",
    material: "Material A-2",
    lotNumber: "lot A-2",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor A-2 S1",
        production: "A-2 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report A-2 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor A-2 S2",
        production: "A-2 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report A-2 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor A-2 S3",
        production: "A-2 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report A-2 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "A-3": MachineData(
    productName: "Product A-3",
    material: "Material A-3",
    lotNumber: "lot A-3",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor A-3 S1",
        production: "A-3 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report A-3 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor A-3 S2",
        production: "A-3 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report A-3 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor A-3 S3",
        production: "A-3 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report A-3 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),

  "B-1": MachineData(
    productName: "Product B-1",
    material: "Material B-1",
    lotNumber: "lot B-1",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor B-1 S1",
        production: "B-1 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report B-1 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor B-1 S2",
        production: "B-1 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report B-1 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor B-1 S3",
        production: "B-1 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report B-1 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "B-2": MachineData(
    productName: "Product B-2",
    material: "Material B-2",
    lotNumber: "lot B-2",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor B-2 S1",
        production: "B-2 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report B-2 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor B-2 S2",
        production: "B-2 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report B-2 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor B-2 S3",
        production: "B-2 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report B-2 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "B-3": MachineData(
    productName: "Product B-3",
    material: "Material B-3",
    lotNumber: "lot B-3",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor B-3 S1",
        production: "B-3 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report B-3 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor B-3 S2",
        production: "B-3 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report B-3 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor B-3 S3",
        production: "B-3 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report B-3 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  "B-34": MachineData(
    productName: "Product B-3",
    material: "Material B-3",
    lotNumber: "lot B-3",
    editedDateTime: "2023-08-13 10:00",
    progress: 50,
    childSteps: {
      "Step 1": SmallStep(
        editorName: "Editor B-3 S1",
        production: "B-3 S1",
        editedDateTime: "2023-08-13 11:00",
        reportDocument: "Report B-3 S1",
        stepStatus: 0,
      ),
      "Step 2": SmallStep(
        editorName: "Editor B-3 S2",
        production: "B-3 S2",
        editedDateTime: "2023-08-13 12:00",
        reportDocument: "Report B-3 S2",
        stepStatus: 0,
      ),
      "Step 3": SmallStep(
        editorName: "Editor B-3 S3",
        production: "B-3 S3",
        editedDateTime: "2023-08-13 13:00",
        reportDocument: "Report B-3 S3",
        stepStatus: 0,
      ),
      // 他のステップ
    },
  ),
  // 他のマシン番号
};