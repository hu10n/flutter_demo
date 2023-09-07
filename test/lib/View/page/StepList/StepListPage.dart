import 'package:flutter/material.dart';
import 'StepListSliverList.dart';

class StepListPage extends StatefulWidget {
  final String machineNumber;
  final onScrollDown;
  final onScrollUp;

  StepListPage(
      {required this.machineNumber,
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
              expandedHeight: 50.0,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Machine ${widget.machineNumber} Step List'),
              ),
            ),
            StepListSliverList(
              machineNumber: widget.machineNumber,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
            ),
            SliverPadding(
              padding:
                  EdgeInsets.fromLTRB(0, safePadding + kToolbarHeight, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
