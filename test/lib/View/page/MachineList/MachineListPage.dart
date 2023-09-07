import 'package:flutter/material.dart';

import 'MachineListSliverList.dart';
import 'ToggleButtons.dart';
import 'AlphabetCarousel.dart';


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
            SliverAppBar(
              title: null,
              expandedHeight: 50.0,
              floating: true,
              pinned: false,
              actions: <Widget>[
                Spacer(),
                ToggleButtonsWidget(onToggleSelected: _onToggleSelected),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.menu), // ハンバーガーメニュー
                ),
                Spacer(),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(6.0), // ここで所望のスペースの量を設定します
            ),
            SliverToBoxAdapter(
              child: AlphabetCarousel(
                onAlphabetSelected: (alphabet) {
                // ここにアルファベットが選択されたときの処理を追加
                },
              ),
            ),
            
            MachineListSliverList(
              selectedStatus: selectedStatus,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
            )
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