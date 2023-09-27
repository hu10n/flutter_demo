import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/common/methods.dart';

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
    final project = findProject(dataList, projectId);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 100),
          // height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                if (project != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "担当する作業を確認してください",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  _buildNonEditableTextField(
                      "発行日", formatTime(project['created_at']), context),
                  _buildNonEditableTextField("作業機",
                      findMachineNumByProjectId(dataList, projectId)!, context),
                  _buildNonEditableTextField(
                      "担当者", project['supervisor'], context),
                  _buildNonEditableTextField(
                      "客先", project['client_name'], context),
                  _buildNonEditableTextField(
                      "品番", project['product_num'], context),
                  _buildNonEditableTextField(
                      "品名", project['product_name'], context),
                  _buildNonEditableTextField(
                      "材料", project['material'], context),
                  _buildNonEditableTextField(
                      "ロット番号", project['lot_num'], context),
                ],
                ElevatedButton(
                  onPressed: () {
                    // ここにOKボタンを押した時の処理を記述して
                  },
                  child: Text('OK'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal bottom sheet
                    _resumeScan();
                  },
                  child: Text('やり直す'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildNonEditableTextField(
      String labelText, String text, BuildContext context) {
    return TextField(
      controller: TextEditingController(text: text),
      enabled: false,
      decoration: InputDecoration(labelText: labelText),
      style: TextStyle(color: Theme.of(context).primaryColor),
    );
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

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There is No Permission to Access Camaera')),
      );
    }
  }
}