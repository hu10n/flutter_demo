import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'StepListSliverList.dart';
import 'ModalContentForHistory.dart';

class StepListPage extends StatefulWidget {
  final String machineId;
  final onScrollDown;
  final onScrollUp;

  StepListPage(
      {required this.machineId,
      required this.onScrollDown,
      required this.onScrollUp});

  @override
  _StepListPageState createState() => _StepListPageState();
}

class _StepListPageState extends State<StepListPage> {
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
    final safePadding = MediaQuery.of(context).padding.bottom;
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
              expandedHeight: 50.0,
              floating: true,
              pinned: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.history),
                  onPressed: () {
                    // アイコンを押したときの処理（ここではSnackBarを表示）
                    _handleHistoryIconTap(context, widget.machineId);
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text('作業工程一覧'),
              ),
            ),
            StepListSliverList(
              machineId: widget.machineId,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: safePadding + kToolbarHeight),
            ),
          ],
        ),
      ),
    );
  }

  void _handleHistoryIconTap(BuildContext context, String machineId) {
    widget.onScrollDown(100);
    //Navigator.of(context)
    //    .push(MaterialPageRoute(
    //        builder: (context) => HistoryListPage(
    //              machineId: machineId,
    //              onScrollDown: widget.onScrollDown,
    //              onScrollUp: widget.onScrollUp,
    //            )))
    //    .then((dataUpdated) {
    //  setState(() {});
    //});

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => ModalContentForHistory(
        onScrollUp: widget.onScrollUp,
        machineId: machineId,
      ),
    );
  }
}
