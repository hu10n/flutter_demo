import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MachineListSliverList.dart';
import 'AlphabetCarousel.dart';
import 'ToggleButtonSliver.dart';
import '../../../DataClass.dart';


class MachineListPage extends StatefulWidget {
  final Function onScrollDown;
  final Function onScrollUp;

  MachineListPage({required this.onScrollDown, required this.onScrollUp});

  @override
  _MachineListPageState createState() => _MachineListPageState();
}

class _MachineListPageState extends State<MachineListPage> {
  final ScrollController scrollController = ScrollController();

  double lastOffset = 0.0;
  int selectedStatus = -1;

  _onToggleSelected(int index) {
    setState(() {
      selectedStatus = index;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    lastOffset = scrollController.offset; // オフセットを更新
  }

  @override
  Widget build(BuildContext context) {
    
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {

        if (notification.depth != 0) {
          return true;
        }

        if (notification.metrics.outOfRange) {
          // オーバースクロールの場合、何もしない
          return true;
        }

        double threshold = 5.0; // ここで閾値を設定

        if (notification.scrollDelta!.abs() > threshold) {
          if (notification.scrollDelta! > 0) {
            // ユーザーが下にスクロールしている場合
            widget.onScrollDown();
          } else if (notification.scrollDelta! < 0) {
            // ユーザーが上にスクロールしている場合
            widget.onScrollUp();
          }
        }
        return true;
      },
      child: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPersistentHeader(
              delegate: YourHeaderDelegate(onToggleSelected: _onToggleSelected),
              pinned: false,
              floating: true,
            ),
            SliverAppBar(
              title: null,
              backgroundColor: Colors.white,
              expandedHeight: 30.0,
              floating: false,
              pinned: true,
              actions: <Widget>[
                AlphabetCarousel(
                  onAlphabetSelected: (alphabet) {
                  // ここにアルファベットが選択されたときの処理を追加
                  Provider.of<DataNotifier>(context, listen: false).turnSelectedFlag(true);
                  Provider.of<DataNotifier>(context, listen: false).selectAlphabet(alphabet);
                  },
                ),               
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(6.0), // ここで所望のスペースの量を設定します
            ),
            MachineListSliverList(
              selectedStatus: selectedStatus,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
              controller: scrollController,
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}