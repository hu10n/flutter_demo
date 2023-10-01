import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/DataClass.dart';

import '../../parts/ModalPage_QR.dart';

import '../../parts/InputField.dart';

class TestPage extends StatefulWidget {
  final Function onScrollUp;

  const TestPage({
    // required this.onScrollDown,
    required this.onScrollUp,
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
            final dataList = [
              {
                "machine_id": "4d789eb5-00bc-4404-8b1f-36e93387598c",
                "machine_group": "A",
                "machine_num": 3,
                "machine_name": "uz-cck",
                "machine_status": 1,
                "created_at": "2023-09-20T05:58:12.143Z",
                "updated_at": "2023-09-20T05:58:12.143Z",
                "project": [
                  {
                    "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4",
                    "project_status": 0,
                    "client_name": "東京電機製造株式会社",
                    "product_name": "ターボブースターギア",
                    "product_num": "G44556H",
                    "material": "ステンレス鋼",
                    "lot_num": "LHJ47E9A",
                    "supervisor": "渡辺健二",
                    "production_volume": null,
                    "cycle_time": null,
                    "box_sequence": null,
                    "created_at": "2023-09-20T06:22:58.992Z",
                    "updated_at": "2023-09-20T06:22:58.992Z",
                    "machine_id": "4d789eb5-00bc-4404-8b1f-36e93387598c",
                    "step": [
                      {
                        "step_id": "11358601-0155-4d87-8900-191c6c79a8aa",
                        "step_name": "星形成形",
                        "finished_at": null,
                        "started_at": null,
                        "project_status": 1,
                        "worker": "渡辺健二",
                        "free_text": null,
                        "step_num": 1,
                        "created_at": "2023-09-20T06:48:17.709Z",
                        "updated_at": "2023-09-20T06:48:17.709Z",
                        "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
                      },
                      {
                        "step_id": "9ff082c7-2fb4-4a07-9876-e856e39b67cb",
                        "step_name": "重力圧縮成形",
                        "finished_at": null,
                        "started_at": null,
                        "project_status": -1,
                        "worker": "渡辺健二",
                        "free_text": null,
                        "step_num": 2,
                        "created_at": "2023-09-20T06:48:17.717Z",
                        "updated_at": "2023-09-20T06:48:17.717Z",
                        "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
                      },
                      {
                        "step_id": "d3745d16-4a61-4179-8faf-128aeb609424",
                        "step_name": "光子接着",
                        "finished_at": null,
                        "started_at": null,
                        "project_status": 0,
                        "worker": "佐藤花子",
                        "free_text": null,
                        "step_num": 3,
                        "created_at": "2023-09-20T06:48:17.722Z",
                        "updated_at": "2023-09-20T06:48:17.722Z",
                        "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
                      },
                      {
                        "step_id": "612bdc4b-b0b3-46e7-82f4-aa0bca8d7b13",
                        "step_name": "星形成形",
                        "finished_at": null,
                        "started_at": null,
                        "project_status": 0,
                        "worker": "山田太郎",
                        "free_text": null,
                        "step_num": 4,
                        "created_at": "2023-09-20T06:48:17.728Z",
                        "updated_at": "2023-09-20T06:48:17.728Z",
                        "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
                      },
                      {
                        "step_id": "c135920f-12d0-4d76-ac0a-223ead199a9c",
                        "step_name": "ナノ表面研磨",
                        "finished_at": null,
                        "started_at": null,
                        "project_status": 0,
                        "worker": "鈴木一郎",
                        "free_text": null,
                        "step_num": 5,
                        "created_at": "2023-09-20T06:48:17.732Z",
                        "updated_at": "2023-09-20T06:48:17.732Z",
                        "project_id": "9fd9bc15-ad81-4b6e-8d76-6a1b389116d4"
                      }
                    ]
                  }
                ]
              },
            ];
            final key = 'your_key'; // キーの値を設定してください
            final projectId =
                '9fd9bc15-ad81-4b6e-8d76-6a1b389116d4'; // プロジェクトIDを設定してください
            _showModalBottomSheet(key, projectId, dataList);
          },
          child: Text('Show Modal Bottom Sheet'),
        ),
      ),
    );
  }

  Future<dynamic> _showModalBottomSheet(
      String key, String projectId, dataList) {
    final Map stepStatus = _getStepStatus(dataList, projectId);
    //print(projectId);
    //print(dataList);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
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

  Widget _createCompletedSheet(Map<dynamic, dynamic> stepStatus,
      VoidCallback closeAction, VoidCallback proceedAction) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
            InputField(
                "備考", TextEditingController(), FocusNode()), // Need to be fixed
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
            InputField("作業者名", TextEditingController(),
                FocusNode()), // Need to be fixed
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
     //Future.delayed(Duration(milliseconds: 1000), () {
     //  controller?.resumeCamera(); // Restart scanner
     //});

     //setState(() {
       //_text = '';
     //});
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
}
