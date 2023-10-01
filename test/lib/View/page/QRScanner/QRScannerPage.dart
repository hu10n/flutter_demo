import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/View/parts/InputField.dart';

import '../../../DataClass.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  String _text = '';

  @override
  void dispose() {
    controller?.dispose(); // Dispose the QRViewController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        centerTitle: true,
      ),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      final newText = scanData.code.toString();
      if (newText != _text) {
        setState(() {
          _text = newText;
          _processScannedData(_text);
        });
      }
    });
  }

  void _processScannedData(String text) {
    try {
      final decodedData = jsonDecode(text);
      final key = decodedData['key'].toString();
      final projectId = decodedData['projectId'].toString();

      final dataList =
          Provider.of<DataNotifier>(context, listen: false).dataList;

      _showModalBottomSheet(key, projectId, dataList).whenComplete(() {
        // Proc when swipe down showModalBottomSheet
        _resumeScan();
      });
    } catch (e) {
      // Handle JSON decoding error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("不正なQRコードです\n$e")),
      );
    }
  }

  Future<dynamic> _showModalBottomSheet(
      String key, String projectId, dataList) {
    final Map stepStatus = _getStepStatus(dataList, projectId);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (stepStatus['stepToStart'] != null)
                  _createStartSheet(stepStatus, () {
                    Navigator.pop(context);
                    _resumeScan();
                  }, () {
                    //Button Action (開始)
                  }),
                if (stepStatus['stepOnGoing'] != null)
                  _createCompleteSheet(stepStatus, () {
                    Navigator.pop(context);
                    _resumeScan();
                  }, () {
                    //Button Action (完了)
                  }),
                if (stepStatus['stepToStart'] == null &&
                    stepStatus['stepOnGoing'] == null)
                  _createCompletedSheet(stepStatus, () {
                    Navigator.pop(context);
                    _resumeScan();
                  }, () {
                    _resumeScan();
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createCompletedSheet(Map<dynamic, dynamic> stepStatus,
      VoidCallback closeAction, VoidCallback proceedAction) {
    // Adjust the information shown here since stepStatus['stepOnGoing'] will be null
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "完了済プロジェクト",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: closeAction,
              ),
            ],
          ),
          Text(
            '全てのステップが完了しました。',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          Center(
            child: ElevatedButton(
              onPressed: proceedAction,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Text(
                  '閉じる',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCompleteSheet(Map<dynamic, dynamic> stepStatus,
          VoidCallback closeAction, VoidCallback proceedAction) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "完了報告を作成",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: closeAction,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP ${stepStatus['stepOnGoing']['step_num']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text(
                  '担当工程: ${stepStatus['stepOnGoing']['step_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            Text(
              '作業者名: ${stepStatus['stepOnGoing']['worker']}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]),
            ),
            // InputField("備考", ScrollController()),  // Need to be fixed
            Center(
              child: ElevatedButton(
                onPressed: proceedAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    '作業完了',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ],
        ),
      );

  Widget _createStartSheet(Map<dynamic, dynamic> stepStatus,
          VoidCallback closeAction, VoidCallback proceedAction) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "開始報告を作成",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: closeAction,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP ${stepStatus['stepToStart']['step_num']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text(
                  '担当工程: ${stepStatus['stepToStart']['step_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            // InputField("作業者名", ScrollController()),  // Need to be fixed
            Center(
              child: ElevatedButton(
                onPressed: proceedAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    '作業開始',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ],
        ),
      );

  void _resumeScan() {
    Future.delayed(Duration(milliseconds: 1000), () {
      controller?.resumeCamera(); // Restart scanner after delay.
    });

    setState(() {
      _text = '';
    });
  }

  Map? findProject(List dataList, String projectId) {
    for (var machine in dataList) {
      for (var project in machine['project']) {
        if (project['project_id'] == projectId) {
          return project;
        }
      }
    }
    return null;
  }

  String? findMachineNumByProjectId(List dataList, String projectId) {
    for (var machine in dataList) {
      if (machine['project'] != null) {
        for (var project in machine['project']) {
          if (project['project_id'] == projectId) {
            return machine['machine_name'];
          }
        }
      }
    }
    return null;
  }

  Map<String, Map?> _getStepStatus(List dataList, String projectId) {
    Map? step_to_start;
    Map? step_on_going;

    for (var data in dataList) {
      for (var project in data['project']) {
        if (project['project_id'] == projectId) {
          for (var step in project['step']) {
            if (step['project_status'] == -1) {
              step_on_going = step;
              break;
            } else if (step['project_status'] == 0) {
              if (step_to_start == null ||
                  step['step_num'] < step_to_start['step_num']) {
                step_to_start = step;
              }
            }
          }
        }
        if (step_on_going != null) break;
      }
      if (step_on_going != null) break;
    }

    return {'stepToStart': step_to_start, 'stepOnGoing': step_on_going};
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There is No Permission to Access Camaera')),
      );
    }
  }
}
