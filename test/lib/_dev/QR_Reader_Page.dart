import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/_dev/StepDetailPage.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      // スキャンデータをJSONとしてパース
      Map<String, dynamic> parsedData = json.decode(result!.code);

      // パースしたデータから必要な情報を抽出
      String machineNumber = parsedData['machineNumber'];
      String stepTitle = parsedData['stepTitle'];

      // 新しい画面に遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepDetailPage(
            machineNumber: machineNumber,
            stepTitle: stepTitle,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
