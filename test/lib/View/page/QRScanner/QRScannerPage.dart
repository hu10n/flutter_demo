import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../DataClass.dart';
import '../StepSubmit/StepSubmitPage.dart';

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
      print(decodedData);

      final dataList =
          Provider.of<DataNotifier>(context, listen: false).dataList;
      final project = findProject(dataList, projectId);

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("key: $key"),
                Text("ID: $projectId"),
                if (project != null) ...[
                  Text("Project ID: ${project['project_id']}"),
                  Text("Client Name: ${project['client_name']}"),
                  Text("Product Name: ${project['product_name']}"),
                  Text("Material: ${project['material']}"),
                  Text("Supervisor: ${project['supervisor']}"),
                ],
                ElevatedButton(
                  onPressed: () {
                    return;
                  },
                  child: Text('OK'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal bottom sheet
                    Future.delayed(Duration(milliseconds: 1000), () {
                      controller
                          ?.resumeCamera(); // Restart scanner after delay.
                    });

                    setState(() {
                      _text = '';
                    });
                  },
                  child: Text('やり直す'),
                ),
              ],
            ),
          );
        },
      ).whenComplete(() {
        // showModalBottomSheetが閉じたらスキャンを再開
        controller?.resumeCamera();
        setState(() {
          _text = '';
        });
      });
    } catch (e) {
      // Handle JSON decoding error if necessary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("不正なQRコードです\n$e")),
      );
    }
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

  Future<void> _transDetailPage(String machineNumber, String stepTitle) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          // Initialize the instance variables in the new page
          return StepSubmitPage(
            machineNumber: machineNumber,
            stepTitle: stepTitle,
          );
        },
      ),
    );

    // Reset the _text value when returning from the detail page
    setState(() {
      _text = '';
    });
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
