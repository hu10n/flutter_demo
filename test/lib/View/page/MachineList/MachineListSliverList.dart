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

  @override
  State<MachineListSliverList> createState() => _MachineListSliverListState();
}

class _MachineListSliverListState extends State<MachineListSliverList> {
  // Filtering ex.)[A-1, A-2, A-3, B-3, C-1, C-2, C-3]
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

// ex. {B: {machines: [B-2], count: 1, height: 103}, C: {machines: [C-2], count: 1, height: 206}}
  Map<String, Map<String, dynamic>> calculateMachineStats(
      List<String> filteredMachines) {
    final Map<String, List<String>> categorizedMachines = {};
    final Map<String, Map<String, dynamic>> machineCardCount = {};
    for (var machineNumber in filteredMachines) {
      final machine = machineData[machineNumber]!;
      final category = machine.machineCategory;

      if (!categorizedMachines.containsKey(category)) {
        categorizedMachines[category] = [];
      }

      categorizedMachines[category]!.add(machineNumber);
    }

    int accumulatedHeight = 0;

    for (var category in categorizedMachines.keys) {
      final machines = categorizedMachines[category]!;
      final count = machines.length;
      final height = 78 * count + 25;

      accumulatedHeight += height;

      machineCardCount[category] = {
        'machines': machines,
        'count': count,
        'height': accumulatedHeight
      };
    }

    return machineCardCount;
  }

//
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final machineCardCount = calculateMachineStats(getFilteredMachines());
      final dataNotifier = Provider.of<DataNotifier>(context, listen: false);
      dataNotifier.updateMachineCardCount(machineCardCount);
    });
  }

// selectedStatusが更新された際に計算しProviderをアップデート
  @override
  void didUpdateWidget(covariant MachineListSliverList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedStatus != oldWidget.selectedStatus) {
      Future.microtask(() {
        final machineCardCount = calculateMachineStats(getFilteredMachines());
        final dataNotifier = Provider.of<DataNotifier>(context, listen: false);
        dataNotifier.updateMachineCardCount(machineCardCount);
      });
    }
  }

// 最初期build時に計算しProviderをアップデート
  @override
  Widget build(BuildContext context) {
    final machineCardCount = calculateMachineStats(getFilteredMachines());

    final alphabetProvider = Provider.of<DataNotifier>(context);
    if (alphabetProvider.isSelectedAlphabet) {
      scrollToCategory(alphabetProvider.selectedAlphabet);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final categories = machineCardCount.keys.toList();

          if (index < categories.length) {
            final category = categories[index]; //カテゴリ[A,B,C,...]
            final machinesInCategory = machineCardCount[category]![
                "machines"]!; //カテゴリに属する[A-1,A-2,...]

            return Column(
              children: [
                CategoryTitle(category: category),
                Column(
                  children: machinesInCategory.map<Widget>((machineNumber) {
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
        childCount: machineCardCount.length + 1,
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
      offset = Provider.of<DataNotifier>(context, listen: false).machineCardCount.entries.toList()[categoryIndex - 1].value["height"] + 1.0;
    }

    widget.controller?.animateTo(
      offset, duration: Duration(milliseconds: 200,), curve: Curves.easeOut
    );

    
  }
}

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    // print("A");
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
