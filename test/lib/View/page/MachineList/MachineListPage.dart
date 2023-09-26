import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MachineListSliverList.dart';
import 'AlphabetCarousel.dart';
import 'ToggleButtonSliver.dart';
import '../../../DataClass.dart';

import 'package:carousel_slider/carousel_slider.dart';

class MachineListPage extends StatefulWidget {
  final Function onScrollDown;
  final Function onScrollUp;

  MachineListPage({required this.onScrollDown, required this.onScrollUp});

  @override
  _MachineListPageState createState() => _MachineListPageState();
}

class _MachineListPageState extends State<MachineListPage> {
  // スクロールアニメーション用----------------------------------------
  final ScrollController scrollController = ScrollController();
  final CarouselController carouselController = CarouselController();

  double lastOffset = 0.0; // スクロール状況監視用
  double threshold = 5.0; // ここで閾値を設定

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    lastOffset = scrollController.offset; // オフセットを更新
  }
  //---------------------------------------------------------------

  // フィルタリング用-------------------------------------------------
  int selectedStatus = -1;

  _onToggleSelected(int index) async {
    // フィルタリング時にページ上部にジャンプ
    await scrollController.animateTo(-0.1,
        duration: Duration(
          milliseconds: 1000,
        ),
        curve: Curves.easeOut);
    //scrollController.jumpTo(-0.1);

    widget.onScrollUp(0);
    setState(() {
      selectedStatus = index;
    });
  }
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.outOfRange) {
          // オーバースクロールの場合、何もしない
          return true;
        }
        if (notification.depth != 0) {
          // カルーセルのスクロールでも、何もしない
          return true;
        }

        // ボトムナビゲーション用のスクロール制御-----------------------------------------------
        if (notification is ScrollUpdateNotification) {
          // スクロール時
          if (notification.scrollDelta!.abs() > threshold) {
            // 閾値を超えた時
            if (notification.scrollDelta! > 0) {
              // ユーザーが下にスクロールしている場合
              widget.onScrollDown(0);
            } else if (notification.scrollDelta! < 0) {
              // ユーザーが上にスクロールしている場合
              widget.onScrollUp(0);
            }
          }
        }
        //--------------------------------------------------------------------------------

        // カルーセル同期用のスクロール制御-----------------------------------------------------
        final provider = Provider.of<DataNotifier>(context, listen: false);
        int index = provider.selectedAlphabet;

        if (!provider.isSelectedAlphabet) {
          // カルーセル選択フラグがtrueの時
          List<MapEntry> entries = provider.machineCardCount.entries.toList();

          // Ensure that the list isn't empty and the desired index is valid.
          if (entries.isNotEmpty && index < entries.length) {
            if (scrollController.offset > entries[index].value["height"]) {
              carouselController.animateToPage(index + 1);
            }

            if (index != 0 && index - 1 < entries.length) {
              if (scrollController.offset <
                  entries[index - 1].value["height"]) {
                carouselController.animateToPage(index - 1);
              }
            }
          }

          if (notification is ScrollStartNotification) {
            // スクロール開始時の動作
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print("srart");
              provider.turnScrollFlag(true);
            });
          } else if (notification is ScrollEndNotification) {
            // スクロール終了時の動作
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print("end");
              Future.delayed(Duration(milliseconds: 1000), () {
                provider.turnScrollFlag(false);
              });
              //Future.delayed(Duration(milliseconds: 1000));
              //provider.turnScrollFlag(false);
            });
          }
        } else {
          //カルーセル選択フラグがfalseの時
          if (notification is ScrollEndNotification) {
            // スクロール終了時の動作
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.turnSelectedFlag(false);
            });
          }
        }
        //------------------------------------------------------------------------------
        return true;
      },
      child: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPersistentHeader(
              //SliverAppBarの上段
              delegate: YourHeaderDelegate(
                onToggleSelected: _onToggleSelected,
                onScrollDown: widget.onScrollDown,
                onScrollUp: widget.onScrollUp,
              ),
              pinned: false,
              floating: true,
            ),
            SliverAppBar(
              //SliverAppBarの下段
              title: null,
              backgroundColor: Colors.white,
              expandedHeight: 30.0,
              floating: false,
              pinned: true,
              actions: <Widget>[
                AlphabetCarousel(
                  controller: carouselController,
                ),
              ],
            ),
            SliverPadding(
              //padding
              padding: EdgeInsets.only(top: 0), // ここで所望のスペースの量を設定します
            ),
            MachineListSliverList(
              //一覧のコンテンツ部分
              selectedStatus: selectedStatus,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
              controller: scrollController,
            ),
            SliverPadding(
              //padding
              padding:
                  EdgeInsets.only(bottom: safePadding + kToolbarHeight + 500),
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
