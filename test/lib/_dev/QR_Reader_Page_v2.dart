import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'StepDetailPage.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR読み取り'),
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
    controller.scannedDataStream.listen((scanData) async {
      final decodedData = jsonDecode(scanData.code!);
      final machineNumber = decodedData['machineNumber'].toString();
      final stepTitle = decodedData['stepTitle'].toString();

      // Dispose the current controller
      controller.dispose();

      // Navigate to detail page
      _transDetailPage(machineNumber, stepTitle);
    });
  }

  void _transDetailPage(String machineNumber, String stepTitle) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepDetailPage(
          machineNumber: machineNumber,
          stepTitle: stepTitle,
        ),
      ),
    );

    // After returning from detail page, create a new controller and resume
    if (mounted) {
      setState(() {
        controller?.resumeCamera();
      });
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('許可がありません')),
      );
    }
  }
}
