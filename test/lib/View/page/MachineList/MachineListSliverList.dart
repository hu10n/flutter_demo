import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/common/methods.dart';

import '../../../DataClass.dart';
import '../../../LocalData/data.dart';
import '../StepList/StepListPage.dart';
import 'MachineListCard.dart';
//import '../../../api/TestAPI.dart';

class MachineListSliverList extends StatefulWidget {
  final int selectedStatus;
  final Function onScrollDown;
  final Function onScrollUp;

  final ScrollController? controller;

  MachineListSliverList({
    required this.selectedStatus,
    required this.onScrollDown,
    required this.onScrollUp,
    this.controller,
  });

  // renderされたCardのカウント ----------------------------------------------
  final Map<String, int> machineCardCount = {};
  // ----------------------------------------------------------------------

  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  List<String> getFilteredMachines() {
    if (widget.selectedStatus == -1) {
      return machineData.keys.toList();
    } else if (widget.selectedStatus == 0 || widget.selectedStatus == 1) {
      return machineData.entries
          .where((entry) => entry.value.machineStatus == widget.selectedStatus)
          .map((entry) => entry.key)
          .toList();
    } else {
      return machineData.entries
          .where((entry) =>
              entry.value.machineStatus != 0 && entry.value.machineStatus != 1)
          .map((entry) => entry.key)
          .toList();
    }
  }

  // Filtering用のMap
  late Map<String, List<String>> categorizedMachines;
  

  @override
  Widget build(BuildContext context) {
    final alphabetProvider = Provider.of<DataNotifier>(context);
    //final dataNotifier = context.watch<DataNotifier>();

    if (alphabetProvider.isSelectedAlphabet) {
      scrollToCategory(alphabetProvider.selectedAlphabet);
    }

    categorizedMachines = {};

    for (var machineNumber in getFilteredMachines()) {
      final machine = machineData[machineNumber]!;
      final category = machine.machineCategory;

      if (!categorizedMachines.containsKey(category)) {
        categorizedMachines[category] = [];
      }

      categorizedMachines[category]!.add(machineNumber);
    }

    // ビルドが完了した後に中身を取得----------------(Debug用)--------------------
    //WidgetsBinding.instance.addPostFrameCallback((_) {
      //Map<String, double> scrollAmount =
          //calculateScrollAmount(widget.machineCardCount);
      //print('machineCardCount: ${widget.machineCardCount}');
      //print('scrollAmount: $scrollAmount');
    //}); // Check Debug Console
    // ----------------------------------------------------------------------

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final categories = categorizedMachines.keys.toList();

          if (index < categories.length) {
            final category = categories[index];
            final machinesInCategory = categorizedMachines[category]!;

            // カテゴリごとのカードのカウント-------------------------------------
            int categoryMachineCount = machinesInCategory.length;

            // カウントをmachineCardCountマップに格納
            widget.machineCardCount[category] = categoryMachineCount;
            // --------------------------------------------------------------

            return Column(
              children: [
                CategoryTitle(category: category),
                Column(
                  children: machinesInCategory.map((machineNumber) {
                    final machine = machineData[machineNumber]!;
                    return MachineListCard(
                      machineNumber: machineNumber,
                      machine: machine,
                      context: context,
                      ontapAction: () => _handleMachineCardTap(
                          context, machineNumber, machine),
                    );
                  }).toList(),
                ),
              ],
            );
          }
          return null;
        },
        childCount: categorizedMachines.length + 1,
      ),
    );
  }

  void _handleMachineCardTap(
      BuildContext context, String machineNumber, MachineData machine) {
    widget.onScrollUp();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => StepListPage(
                  machineNumber: machineNumber,
                  onScrollDown: widget.onScrollDown,
                  onScrollUp: widget.onScrollUp,
                )))
        .then((dataUpdated) {
      setState(() {});
    });
  }

  void scrollToCategory(int categoryIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataNotifier>(context, listen: false).turnSelectedFlag(false);
    });

    print(Provider.of<DataNotifier>(context, listen: false).selectedAlphabet);
    print(Provider.of<DataNotifier>(context, listen: false).machineCardCount.entries.toList()[1].value);
    //var categories = categorizedMachines.keys.toList();
    //var index = categories.indexOf(categoryName);

    // スクロール位置を計算する
    //var offset = index * 60.0;  // 仮の計算
    //widget.controller?.animateTo(
      //offset, duration: Duration(milliseconds: 500,), curve: Curves.easeInOut
    //);
    var offset = 0.0;
    if (Provider.of<DataNotifier>(context, listen: false).selectedAlphabet != 0){
      offset = Provider.of<DataNotifier>(context, listen: false).machineCardCount.entries.toList()[categoryIndex - 1].value + 1.0;
    }

    widget.controller?.animateTo(
      offset, duration: Duration(milliseconds: 500,), curve: Curves.easeInOut
    );
    
  }
}

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
          width: 25,
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).disabledColor),
            ),
          ),
        ),
      ],
    );
  }
}
