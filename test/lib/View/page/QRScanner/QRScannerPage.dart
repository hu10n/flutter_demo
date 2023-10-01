import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/View/parts/ModalPage_QR.dart';
import 'package:test/DataClass.dart';

class QRScannerPage extends StatefulWidget {
  final Function onScrollUp;
  // final Function onScrollDown;

  const QRScannerPage({
    // required this.onScrollDown,
    required this.onScrollUp,
  });

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
        return
            // ModalContentInQR(
            //   stepStatus: stepStatus,
            //   resumeScan: () => _resumeScan(),
            // );
            QRModal(
          onScrollUp: widget.onScrollUp,
          stepStatus: stepStatus,
          resumeScan: () => _resumeScan(),
        );
      },
    );
  }

// Proc of QR Page ------------
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

  void _resumeScan() {
    Future.delayed(Duration(milliseconds: 1000), () {
      controller?.resumeCamera(); // Restart scanner after delay.
    });

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
