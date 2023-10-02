import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/View/page/QRScanner/ModalContentInQR.dart';
import 'package:test/DataClass.dart';
import 'package:test/common/methods.dart';

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
        title: Text('QRコードをスキャン'),
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

  // Procedure when scan data is aquired -----------------------------------
  Future<void> _processScannedData(String text) async {
    try {
      final decodedData = jsonDecode(text);
      final key = decodedData['key'].toString();
      // Update LocalDB, then transfer the data to next Page
      await Provider.of<DataNotifier>(context, listen: false)
          .updateLocalDB(); //LocalDBを最新データに更新
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
  // -----------------------------------------------------------------------

  Future<dynamic> _showModalBottomSheet(
      String key, String projectId, dataList) {
    final Map stepInfoMap = getStepInfoMap(dataList, projectId);
    print(stepInfoMap);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ModalContentInQR(
          onScrollUp: widget.onScrollUp,
          stepInfoMap: stepInfoMap,
          resumeScan: () => _resumeScan(),
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

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There is No Permission to Access Camaera')),
      );
    }
  }
}
