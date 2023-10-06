import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalMethod/utils.dart';
import 'package:test/GlobalWidget/MachineStatusIndicator.dart';
import 'ModalContentForAssignProject.dart';
import 'ModalContentForDelivery.dart';
import 'ModalContentForDetail.dart';
import 'ModalContentForChangeStatus.dart';

class MachineSummaryCard extends StatefulWidget {
  final Function onScrollDown;
  final Function onScrollUp;
  final ScrollController scrollController;
  final machineId;
  final VoidCallback onPressAction;

  const MachineSummaryCard({
    required this.machineId,
    required this.onPressAction,
    required this.onScrollDown,
    required this.onScrollUp,
    required this.scrollController,
  });

  @override
  _MachineSummaryCardState createState() => _MachineSummaryCardState();
}

class _MachineSummaryCardState extends State<MachineSummaryCard> {
  bool isModal = false; //モーダル表示制御用

  @override
  Widget build(BuildContext context) {
    final dataList = Provider.of<DataNotifier>(context).dataList;
    Map<String, dynamic> machine = dataList.firstWhere(
      (element) => element['machine_id'] == widget.machineId,
      orElse: () => {},
    );
    List<dynamic> projects = machine['project'] ?? [];
    //print(projects[0]);

    int totalProgress = calculateTotalProgress(machine);
    int totalSteps = calculateTotalSteps(machine);

    final progressPercentage =
        calcpProgressPercentage(totalProgress, totalSteps);

    String updateDate = formatTime(getLatestUpdatedAt(machine));

    final machineStatus = machine['machine_status'] ?? 0;
    String machineName = machine['machine_name'] ?? '';
    String machineNumber =
        "${machine['machine_group']}-${machine['machine_num'].toString()}";
    String productName =
        projects.isNotEmpty ? projects[0]['product_name'] ?? '' : '';
    String productNumber =
        projects.isNotEmpty ? projects[0]['product_num'] ?? '' : '';
    String material = projects.isNotEmpty ? projects[0]['material'] ?? '' : '';
    String lotNumber = projects.isNotEmpty ? projects[0]['lot_num'] ?? '' : '';
    String productionVolume = projects.isNotEmpty
        ? formatNumber(projects[0]['production_volume']) ?? ''
        : '';
    String cliantName =
        projects.isNotEmpty ? projects[0]['client_name'] ?? '' : '';

    bool isEmpty = machine["project"].isEmpty;

    return Card(
      child: Column(
        children: [
          _createTitleBox(machineNumber, machineName, productNumber),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _createMachineStatusBox(context, machineStatus,
                  progressPercentage, totalProgress, totalSteps),
              _createProductInfoBox(productName, material, lotNumber,
                  updateDate, productionVolume, cliantName)
            ],
          ),
          if (!isEmpty)
            _createBottomButtonBox(
                context, widget.onPressAction, machine, projects[0]),
          if (isEmpty)
            _createBottomButtonBoxEmpty(context, widget.onPressAction, machine)
        ],
      ),
    );
  }

  Widget _createBottomButtonBox(
      BuildContext context,
      VoidCallback onPressAction,
      Map<String, dynamic> machine,
      Map<String, dynamic> project) {
    //final modalPage = ModalPage();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
                child: ElevatedButton(
                    onPressed: () {
                      onPressAction();
                    },
                    child: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "カード発行",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )))),
            Positioned(
              right: 50,
              child: SizedBox(
                  width: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onScrollDown(100);
                      _showActionSheet(context, machine, project);
                    },
                    child: Icon(
                      Icons.more_horiz, // ここで「・・・」のアイコンを設定します。
                      color: Colors.white, // アイコンの色を設定します。
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createBottomButtonBoxEmpty(BuildContext context,
      VoidCallback onPressAction, Map<String, dynamic> machine) {
    //final modalPage = ModalPage();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
                child: ElevatedButton(
                    onPressed: () {
                      //割り当てロジック-------------------------------------------------------------------------
                      widget.onScrollDown(100);

                      showModalBottomSheet(
                        //モーダル表示
                        context: context,
                        isScrollControlled: true,
                        enableDrag: false,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        builder:(context) => MyModal(onScrollUp: widget.onScrollUp, machine: machine),
                      ).whenComplete(() {
                        // ここでモーダルが閉じられた際の追加処理を実行します
                         widget.onScrollUp(100);
                      });
                      //---------------------------------------------------------------------------------------
                    },
                    child: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "プロジェクト割り当て",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )))),
            Positioned(
              right: 50,
              child: SizedBox(
                  width: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onScrollDown(100);
                      _showActionSheet(context, machine, {});
                    },
                    child: Icon(
                      Icons.more_horiz, // ここで「・・・」のアイコンを設定します。
                      color: Colors.white, // アイコンの色を設定します。
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _createProductInfoBox(
      String productName,
      String material,
      String lotNumber,
      String updateDate,
      String productionVolume,
      String cliantName) {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("品名: $productName"),
          Text("材質: $material"),
          Text("Lot番号: $lotNumber"),
          Text("生産数: $productionVolume"),
          Text("客先: $cliantName"),
          Text("前回更新:$updateDate")
        ],
      ),
    );
  }

  Widget _createMachineStatusBox(BuildContext context, int machineStatus,
      int progressPercentage, int totalProgress, int totalSteps) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MachineStatusIndicator(
              context: context, machineStatus: machineStatus),
          SizedBox(
            height: 10,
          ),
          _createProgressCircle(
              context, progressPercentage, totalProgress, totalSteps, 100),
        ],
      ),
    );
  }

  Widget _createTitleBox(machineNumber, machineName, productNumber) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    machineNumber,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    machineName,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text(
                productNumber,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _createProgressCircle(BuildContext context, int progressPercentage,
      int totalProgress, int totalSteps, double circleRadius) {
    return Stack(
      children: [
        // Circle
        SizedBox(
          height: circleRadius,
          width: circleRadius,
          child: CircularProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Theme.of(context).disabledColor,
            strokeWidth: 9,
          ),
        ),
        // Indicator Text
        SizedBox(
          height: circleRadius,
          width: circleRadius,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$progressPercentage%",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Container(
                width: 60, // Width of Divider
                child: Divider(
                  color: Theme.of(context).disabledColor,
                  thickness: 2,
                  height: 10, // space on the top / bot of divider
                ),
              ),
              Text(
                "$totalProgress / $totalSteps",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // アクションシート用-----------------------------------------------------
  void _showActionSheet(BuildContext context, Map<String, dynamic> machine,
      Map<String, dynamic> project) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: false,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              if (project.isNotEmpty)
                ListTile(
                  leading: Icon(Icons.local_shipping,
                      color: Color.fromARGB(255, 222, 212, 123)),
                  title: Text('部品を納品する'),
                  onTap: () {
                    Navigator.pop(context); // アクションシートを閉じる
                    // ここに追加の処理を実装

                    setIsModal(true);
                    showModalBottomSheet(
                      context: context,
                      //isScrollControlled: true,
                      enableDrag: false,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => ModalContentForDelivery(
                        onScrollUp: widget.onScrollUp,
                        machine: machine,
                        project: project,
                        setIsModal: setIsModal,
                      ),
                    ).whenComplete(() {
                      // ここでモーダルが閉じられた際の追加処理を実行します
                      setIsModal(false);
                      widget.onScrollUp(100);
                    });
                  },
                ),
              if (project.isNotEmpty)
                ListTile(
                  leading: Icon(Icons.zoom_in, color: Colors.blue),
                  title: Text('詳細情報を見る'),
                  onTap: () {
                    Navigator.pop(context); // アクションシートを閉じる
                    // ここに追加の処理を実装
                    print(project);
                    print(machine);
                    setIsModal(true);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => ModalContentForDetail(
                        onScrollUp: widget.onScrollUp,
                        machine: machine,
                        project: project,
                        setIsModal: setIsModal,
                      ),
                    ).whenComplete(() {
                      // ここでモーダルが閉じられた際の追加処理を実行します
                      setIsModal(false);
                      widget.onScrollUp(100);
                    });
                  },
                ),
              ListTile(
                leading: Icon(
                  Icons.swap_horiz,
                  color: Colors.green,
                ),
                title: Text('作業機のステータスを変更する'),
                onTap: () {
                  Navigator.pop(context); // アクションシートを閉じる
                  // ここに追加の処理を実装
                  setIsModal(true);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: false,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => ModalContentForChangeStatus(
                      onScrollUp: widget.onScrollUp,
                      machine: machine,
                      project: project,
                      setIsModal: setIsModal,
                    ),
                  ).whenComplete(() {
                    // ここでモーダルが閉じられた際の追加処理を実行します
                    setIsModal(false);
                    widget.onScrollUp(100);
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                title: Text('キャンセル'),
                onTap: () {
                  Navigator.pop(context); // アクションシートを閉じる
                },
              ),
            ],
          );
        }).whenComplete(() {
      // ここでモーダルが閉じられた際の追加処理を実行します
      if (!isModal) {
        widget.onScrollUp(100);
      }
    });
  }

  //----------------------------------------------------------------
  void setIsModal(bool flag) {
    setState(() {
      isModal = flag;
    });
  }
}
