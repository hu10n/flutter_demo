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

    bool isEmpty = projects.isEmpty;
    bool isComplete = false;

    if (!isEmpty) {
      if (projects[0]["step"].every((step) => step["project_status"] == 1)) {
        // すべてのstepが1の場合の処理をここに書く
        // ...
        //print("object");
        isComplete = true;
      }
    }

    return Card(
      color: Colors.white,
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
          _createBottomButtonBox(context, machine, isEmpty, isComplete,
              isEmpty ? {} : projects[0], 200, 150, 55),
        ],
      ),
    );
  }

  Widget _createBottomButtonBox(
    BuildContext context,
    Map<String, dynamic> machine,
    bool isEmpty,
    bool isComplete,
    Map<String, dynamic> project,
    double issueWidth,
    double assignWidth,
    double actionWidth,
  ) {
    //final modalPage = ModalPage();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1st button is positioned center
            SizedBox(
              width: isEmpty ? issueWidth : assignWidth,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: [2, 3, 4].contains(machine["machine_status"])
                      ? null
                      : () => isEmpty
                          ? pressAssignButton(machine)
                          : widget.onPressAction(),
                  child: Center(
                    child: Text(
                      isEmpty ? "プロジェクト割り当て" : "カード発行",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )),
            ),
            // 2nd Button
            Positioned(
              right: MediaQuery.of(context).size.width / 2 -
                  (isEmpty ? issueWidth : assignWidth) / 2 -
                  actionWidth -
                  8 - // padding
                  10, // margin between buttons
              child: SizedBox(
                  width: actionWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onScrollDown(100);
                      _showActionSheet(
                          context, machine, project, isEmpty, isComplete);
                    },
                    child: Icon(
                      Icons.more_horiz, // 「・・・」のアイコンを設定
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
            color: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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
                  color: Theme.of(context).colorScheme.secondary,
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
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // アクションシート用-----------------------------------------------------
  void _showActionSheet(BuildContext context, Map<String, dynamic> machine,
      Map<String, dynamic> project, bool isEmpty, bool isComplete) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: false,
        builder: (BuildContext context) {
          final tiles = <Widget>[
            if (isComplete)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                leading: Icon(Icons.local_shipping,
                    color: Color.fromARGB(255, 222, 212, 123)),
                title: Text('部品を納品する'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  setIsModal(true);
                  showModalBottomSheet(
                    context: context,
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
                    setIsModal(false);
                    widget.onScrollUp(100);
                  });
                },
              ),
            if (!isEmpty)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                leading: Icon(Icons.zoom_in, color: Colors.blue),
                title: Text('詳細情報を見る'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
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
                    setIsModal(false);
                    widget.onScrollUp(100);
                  });
                },
              ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              leading: Icon(Icons.swap_horiz, color: Colors.green),
              title: Text('作業機のステータスを変更する'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
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
                  setIsModal(false);
                  widget.onScrollUp(100);
                });
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('キャンセル'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ];

          return Wrap(
            children: ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
              ..add(Padding(
                padding: EdgeInsets.only(
                    bottom: bottomBarHeightWithSafePadding(context)),
              )),
          );
        }).whenComplete(() {
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

  void pressAssignButton(Map<String, dynamic> machine) {
    //割り当てロジック-------------------------------------------------------------------------
    widget.onScrollDown(100);

    showModalBottomSheet(
      //モーダル表示
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) =>
          MyModal(onScrollUp: widget.onScrollUp, machine: machine),
    ).whenComplete(() {
      // ここでモーダルが閉じられた際の追加処理を実行します
      widget.onScrollUp(100);
    });
    //---------------------------------------------------------------------------------------
  }
}
