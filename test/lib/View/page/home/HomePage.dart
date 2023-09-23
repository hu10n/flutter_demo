import 'package:flutter/material.dart';

class PageWithCustomScroll extends StatefulWidget {
  final Function onScrollDown;
  final Function onScrollUp;

  PageWithCustomScroll({required this.onScrollDown, required this.onScrollUp});

  @override
  _PageWithCustomScrollState createState() => _PageWithCustomScrollState();
}

class _PageWithCustomScrollState extends State<PageWithCustomScroll> {
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
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Custom Scroll View'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                  onTap: () {
                    widget.onScrollUp(0);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubPage(title: 'Sub Page from Custom Scroll')));
                  },
                );
              },
              childCount: 50,
            ),
          ),
        ],
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

class SubPage extends StatelessWidget {
  final String title;

  SubPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('This is a sub page.'),
      ),
    );
  }
}
