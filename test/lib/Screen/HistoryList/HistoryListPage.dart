import 'package:flutter/material.dart';
import 'package:test/GlobalMethod/utils.dart';
import 'package:test/Screen/HistoryList/HistorySliverList.dart';

class HistoryListPage extends StatefulWidget {
  final String machineId;
  final onScrollDown;
  final onScrollUp;

  HistoryListPage(
      {required this.machineId,
      required this.onScrollDown,
      required this.onScrollUp});

  @override
  _HistoryListPageState createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  final ScrollController scrollController = ScrollController();
  double lastOffset = 0.0;

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
    // print("S");
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.outOfRange) {
          // オーバースクロールの場合、何もしない
          return true;
        }

        double threshold = 5.0; // ここで閾値を設定

        if (notification.scrollDelta!.abs() > threshold) {
          if (notification.scrollDelta! > 0) {
            // ユーザーが下にスクロールしている場合
            widget.onScrollDown(0);
          } else if (notification.scrollDelta! < 0) {
            // ユーザーが上にスクロールしている場合
            widget.onScrollUp(0);
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).colorScheme.secondary), // ここで色を変更
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              expandedHeight: 50.0,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '稼働履歴',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            HistoryListSliverList(
              machineId: widget.machineId,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: bottomBarHeightWithSafePadding(context)),
            ),
          ],
        ),
      ),
    );
  }
}