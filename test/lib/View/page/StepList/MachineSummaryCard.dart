import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../../LocalData/data.dart';
import '../../../DataClass.dart';
import '../../../common/methods.dart';
import '../../../common/MachineStatusText.dart';
import '../../parts/ModalPage.dart';

class MachineSummaryCard extends StatelessWidget {
  final Function onScrollDown;
  final Function onScrollUp;
  final ScrollController scrollController;

  const MachineSummaryCard(
      {required this.machineId, required this.onPressAction, required this.onScrollDown,
       required this.onScrollUp, required this.scrollController});

  final machineId;
  final VoidCallback onPressAction;
  @override
  Widget build(BuildContext context) {
    final dataList = Provider.of<DataNotifier>(context).dataList;
    Map<String, dynamic> machine = dataList.firstWhere(
      (element) => element['machine_id'] == machineId,
      orElse: () => {},
    );
    List<dynamic> projects = machine['project'] ?? [];

    int totalProgress = calculateTotalProgress(machine);
    int totalSteps = calculateTotalSteps(machine);

    final progressPercentage =
        calcpProgressPercentage(totalProgress, totalSteps);

    String updateDate = formatTime(machine['updated_at'] ?? '');
    final machineStatus = machine['machine_status'] ?? 0;
    String machineName = machine['machine_name'] ?? '';
    String machineNumber =
        "${machine['machine_group']}-${machine['machine_num'].toString()}";
    String productName =
        projects.isNotEmpty ? projects[0]['product_name'] ?? '' : '';
    String material = projects.isNotEmpty ? projects[0]['material'] ?? '' : '';
    String lotNumber = projects.isNotEmpty ? projects[0]['lot_num'] ?? '' : '';

    return Card(
      child: Column(
        children: [
          _buildTitleBox(machineNumber, machineName),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMachineStatusBox(context, machineStatus, progressPercentage,
                  totalProgress, totalSteps),
              _buildProductSpecBox(productName, material, lotNumber, updateDate)
            ],
          ),
          _buildBottomButtonBox(context, onPressAction, machine)
        ],
      ),
    );
  }

  Widget _buildBottomButtonBox(
      BuildContext context, VoidCallback onPressAction, Map<String, dynamic> machine) {
    //final modalPage = ModalPage();
    bool isEmpty = machine["project"].isEmpty;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          child: ElevatedButton(
              onPressed: () {
                if(isEmpty){
                  //割り当てロジック-------------------------------------------------------------------------
                  onScrollDown(100);
                  
                  showModalBottomSheet(//モーダル表示
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => MyModal(onScrollUp: onScrollUp,machine: machine),
                  );
                  //---------------------------------------------------------------------------------------
                }else{
                  onPressAction();
                }
              },
              child: SizedBox(
                  width: isEmpty ? 200 : 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isEmpty ? "プロジェクト割り当て"
                        : "カード発行",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )))),
    );
  }

  SizedBox _buildProductSpecBox(String productName, String material,
      String lotNumber, String updateDate) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("品名:$productName"),
          SizedBox(
            height: 10,
          ),
          Text("材質:$material"),
          SizedBox(
            height: 10,
          ),
          Text("Lot番号:$lotNumber"),
          SizedBox(
            height: 10,
          ),
          Text("前回更新:$updateDate")
        ],
      ),
    );
  }

  Widget _buildMachineStatusBox(BuildContext context, int machineStatus,
      int progressPercentage, int totalProgress, int totalSteps) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MachineStatusText(context: context, machineStatus: machineStatus),
          SizedBox(
            height: 10,
          ),
          _buildProgressCircle(
              context, progressPercentage, totalProgress, totalSteps, 100),
        ],
      ),
    );
  }

  Widget _buildTitleBox(machineNumber, machineName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(child: Text("$machineNumber")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text(
                machineName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context, int progressPercentage,
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

  // 枠線付きコンテナの生成メソッド(sample)---------------------------------------------------------------
  Widget _buildContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 4.0), // コンテナ間のマージン
      padding: EdgeInsets.all(8.0), // コンテナのパディング
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.black, width: 1.0), // 枠線の色と幅
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 子ウィジェットをスペースで均等に配置
        children: [
          Text("プロジェクトを割り当てる", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // ここでBottom Sheetを閉じます
              onScrollUp(100);
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
  //-----------------------------------------------------------------------------------------
}
