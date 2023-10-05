import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/GlobalMethod/utils.dart';
import 'package:test/Screen/QRScanner/ModalContentForComplete.dart';
import 'package:test/Screen/QRScanner/ModalContentInQR.dart';
import 'package:test/Screen/QRScanner/ModalContentForStart.dart';
import 'package:test/providers/DataProvider.dart';

class TestPage extends StatefulWidget {
  final Function onScrollUp;
  final Function onScrollDown;

  const TestPage({
    required this.onScrollUp,
    required this.onScrollDown,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final dataList =
                Provider.of<DataNotifier>(context, listen: false).dataList;
            // final dataList = [
            //   {
            //     "machine_id": "4d789eb5-00bc-4404-8b1f-36e93387598c",
            //     "machine_group": "A",
            //     "machine_num": 3,
            //     "machine_name": "uz-cck",
            //     "machine_status": 1,
            //     "created_at": "2023-09-20T05:58:12.143Z",
            //     "updated_at": "2023-09-20T05:58:12.143Z",
            //     "project": [
            //       {
            //         "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4",
            //         "project_status": 0,
            //         "client_name": "東京電機製造株式会社",
            //         "product_name": "ターボブースターギア",
            //         "product_num": "G44556H",
            //         "material": "ステンレス鋼",
            //         "lot_num": "LHJ47E9A",
            //         "supervisor": "渡辺健二",
            //         "production_volume": null,
            //         "cycle_time": null,
            //         "box_sequence": null,
            //         "created_at": "2023-09-20T06:22:58.992Z",
            //         "updated_at": "2023-09-20T06:22:58.992Z",
            //         "machine_id": "4d789eb5-00bc-4404-8b1f-36e93387598c",
            //         "step": [
            //           {
            //             "step_id": "11358601-0155-4d87-8900-191c6c79a8aa",
            //             "step_name": "星形成形",
            //             "finished_at": null,
            //             "started_at": null,
            //             "project_status": 1,
            //             "worker": "渡辺健二",
            //             "free_text": null,
            //             "step_num": 1,
            //             "created_at": "2023-09-20T06:48:17.709Z",
            //             "updated_at": "2023-09-20T06:48:17.709Z",
            //             "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
            //           },
            //           {
            //             "step_id": "9ff082c7-2fb4-4a07-9876-e856e39b67cb",
            //             "step_name": "重力圧縮成形",
            //             "finished_at": null,
            //             "started_at": null,
            //             "project_status": 1,
            //             "worker": "渡辺健二",
            //             "free_text": null,
            //             "step_num": 2,
            //             "created_at": "2023-09-20T06:48:17.717Z",
            //             "updated_at": "2023-09-20T06:48:17.717Z",
            //             "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
            //           },
            //           {
            //             "step_id": "d3745d16-4a61-4179-8faf-128aeb609424",
            //             "step_name": "光子接着",
            //             "finished_at": null,
            //             "started_at": null,
            //             "project_status": 1,
            //             "worker": "佐藤花子",
            //             "free_text": null,
            //             "step_num": 3,
            //             "created_at": "2023-09-20T06:48:17.722Z",
            //             "updated_at": "2023-09-20T06:48:17.722Z",
            //             "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
            //           },
            //           {
            //             "step_id": "612bdc4b-b0b3-46e7-82f4-aa0bca8d7b13",
            //             "step_name": "星形成形",
            //             "finished_at": null,
            //             "started_at": null,
            //             "project_status": 0,
            //             "worker": "山田太郎",
            //             "free_text": null,
            //             "step_num": 4,
            //             "created_at": "2023-09-20T06:48:17.728Z",
            //             "updated_at": "2023-09-20T06:48:17.728Z",
            //             "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
            //           },
            //           {
            //             "step_id": "c135920f-12d0-4d76-ac0a-223ead199a9c",
            //             "step_name": "ナノ表面研磨",
            //             "finished_at": null,
            //             "started_at": null,
            //             "project_status": 0,
            //             "worker": "鈴木一郎",
            //             "free_text": null,
            //             "step_num": 5,
            //             "created_at": "2023-09-20T06:48:17.732Z",
            //             "updated_at": "2023-09-20T06:48:17.732Z",
            //             "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
            //           }
            //         ]
            //       }
            //     ]
            //   },
            // ];
            // Scan Data -----------------------------------
            final key = 'your_key';
            final projectId = '9fd9bc15-ad81-4b6e-8d76-6a1b389116d4';
            // ---------------------------------------------
            widget.onScrollDown(100);
            _showModalBottomSheet(key, projectId, dataList);
          },
          child: Text('Show Modal Bottom Sheet'),
        ),
      ),
    );
  }

  Future<dynamic> _showModalBottomSheet(
      String key, String projectId, dataList) {
    final Map stepInfoMap = getStepInfoMap(dataList, projectId);
    print(stepInfoMap);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
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
    //Future.delayed(Duration(milliseconds: 1000), () {
    //  controller?.resumeCamera(); // Restart scanner
    //});

    //setState(() {
    //_text = '';
    //});
  }
}
