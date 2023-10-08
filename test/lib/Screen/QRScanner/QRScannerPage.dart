import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test/Screen/QRScanner/DialogForInvalidMachineStatus.dart';
import 'package:test/Screen/QRScanner/LoadingModalForScan.dart';
import 'package:test/Screen/QRScanner/ModalContentForClosed.dart';
import 'package:test/Screen/QRScanner/ModalContentForComplete.dart';
import 'package:test/Screen/QRScanner/ModalContentForStart.dart';
import 'package:test/Screen/QRScanner/DialogForScanningError.dart';
import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalMethod/utils.dart';
import 'package:test/providers/NavigationData.dart';

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
        if (_isLoading) LoadingDialogForScan(),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // デバイスの幅または高さが400未満=>scanArea=150.0
    // それ以外300.0
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 150.0
        : 300.0;

    return Transform.translate(
      offset: Offset(0, -bottomSafePaddingHeight(context)), //safePadding分上に移動
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
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

      final int machineStatus = stepInfoMap['machine_status'];
      final String machineName = stepInfoMap['machine_name'];

      if (machineStatus == 1) {
        // showModalBottomSheet
        widget.onScrollDown(bottomSafePaddingHeight(context).toInt());
        await _showModalBottomSheet(
          key,
          stepInfoMap,
        );
      } else {
        // Show AlertDialog (when Stats is not 1[稼働中])
        _showInvalidMachStatsDialog(context, machineStatus, machineName)
            .then((_) => _resumeScan());
        return; //
      }
    } catch (e) {
      // Show Error Dialog
      _showQRErrorDialog(context, e.toString()).then((_) => _resumeScan());
      return; //
    } finally {
      if (_isLoading) {
        setState(() {
          _isLoading = false; // End Loading
        });
      }
    }
  }

  // -----------------------------------------------------------------------

  Future<dynamic> _showModalBottomSheet(
    String key,
    Map stepInfoMap,
  ) {
    final navigationData = NavigationData.of(context);
    print("navigation data[QRPage]; $navigationData");
    final stepStatusToEdit = stepInfoMap['step_status_to_edit'];

    final modalContent = stepStatusToEdit == 0
        ? ModalContentForStart(
            stepInfoMap: stepInfoMap,
            onScrollUp: widget.onScrollUp,
            onScrollDown: widget.onScrollDown,
          )
        : stepStatusToEdit == -1
            ? ModalContentForComplete(
                stepInfoMap: stepInfoMap,
                onScrollUp: widget.onScrollUp,
                onScrollDown: widget.onScrollDown,
              )
            : stepStatusToEdit == null
                ? ModalContentForClosed(
                    stepInfoMap: stepInfoMap, onScrollUp: widget.onScrollUp)
                : Container(child: Text("Error:SCAN_QR_E-1"));

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => modalContent,
    ).then((_) => _resumeScan());
  }

  Future<dynamic> _showInvalidMachStatsDialog(
      context, machineStatus, machineName) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => InvalidMachineStatusDialog(
          machineStatus: machineStatus, machineName: machineName),
    );
  }

  Future<dynamic> _showQRErrorDialog(context, e) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => QRErrorDialog(errorMessage: e),
    );
  }

  void _resumeScan() {
    Future.delayed(Duration(milliseconds: 500), () {
      controller?.resumeCamera(); // Restart scanner after delay.
    });

    setState(() {
      _text = '';
      _isLoading = false;
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
