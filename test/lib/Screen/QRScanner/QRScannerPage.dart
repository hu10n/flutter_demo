import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/Screen/QRScanner/LoadingModalForScan.dart';
import 'package:test/Screen/QRScanner/ModalContentForComplete.dart';
import 'package:test/Screen/QRScanner/ModalContentForStart.dart';
import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalMethod/utils.dart';

class QRScannerPage extends StatefulWidget {
  final Function onScrollUp;
  final Function onScrollDown;

  const QRScannerPage({
    required this.onScrollDown,
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

  bool _isLoading = false;

  @override
  void dispose() {
    controller?.dispose(); // Dispose the QRViewController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('QRコードをスキャン'),
            centerTitle: true,
          ),
          body: _buildQrView(context),
        ),
        if (_isLoading) LoadingDialogForScan()
      ],
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
      setState(() {
        _isLoading = true; // loading start
      });
      result = scanData;
      final newText = scanData.code.toString();
      if (newText != _text) {
        setState(() {
          _text = newText;
          _processScannedData(_text);
        });
        controller.pauseCamera();
      }
    });
  }

  // Procedure when scan data is aquired -----------------------------------
  Future<void> _processScannedData(String text) async {
    try {
      final decodedData = jsonDecode(text);
      final key = decodedData['key'].toString();

      // updateLocalDB
      await Provider.of<DataNotifier>(context, listen: false).updateLocalDB();

      final projectId = decodedData['projectId'].toString();
      final dataList =
          Provider.of<DataNotifier>(context, listen: false).dataList;
      final Map stepInfoMap = getStepInfoMap(dataList, projectId);

      // showModalBottomSheet
      widget.onScrollDown(100);
      await _showModalBottomSheet(
        key,
        stepInfoMap,
      );

      // resume scan when swiped down
      _resumeScan();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("不正なQRコードです\n$e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // End Loading
      });
    }
  }

  // -----------------------------------------------------------------------

  Future<dynamic> _showModalBottomSheet(
    String key,
    Map stepInfoMap,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        if (stepInfoMap['step_status_to_edit'] == 0)
          return ModalContentForStart(
              stepInfoMap: stepInfoMap,
              resumeScan: _resumeScan,
              onScrollUp: widget.onScrollUp);
        if (stepInfoMap['step_status_to_edit'] == -1)
          return ModalContentForComplete(
              stepInfoMap: stepInfoMap,
              resumeScan: _resumeScan,
              onScrollUp: widget.onScrollUp);
        if (stepInfoMap['step_status_to_edit'] == null) return Container();
        return Container();
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
        SnackBar(content: Text('カメラへのアクセス権がありません')),
      );
    }
  }
}
