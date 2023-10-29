import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:test/GlobalMethod/utils.dart';

import 'MachineListSliverList.dart';
import 'AppBar/AlphabetCarousel.dart';
import 'AppBar/ToggleButtonSliver.dart';
import 'package:test/providers/DataProvider.dart';

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
    await carouselController.animateToPage(0,
        duration: Duration(microseconds: 1));

    widget.onScrollUp(0);
    setState(() {
      selectedStatus = index;
    });
  }
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
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

        //カルーセル同期のスクロール用--------------------------------------------------------
        final provider = Provider.of<DataNotifier>(context, listen: false);
        int index = provider.selectedAlphabet;
        //-------------------------------------------------------------------------------

        // ボトムナビゲーション用のスクロール制御-----------------------------------------------
        if (notification is ScrollUpdateNotification) {
          // スクロール時
          if (notification.scrollDelta!.abs() > threshold) {
            // 閾値を超えた時
            if (notification.scrollDelta! > 0) {
              // ユーザーが下にスクロールしている場合
              widget.onScrollDown(0);
            } else if (notification.scrollDelta! < 0 &&
                (!provider.isSelectedAlphabet || index == 0)) {
              // ユーザーが上にスクロールしている場合
              widget.onScrollUp(0);
            }
          }
        }
        //--------------------------------------------------------------------------------

        // カルーセル同期用のスクロール制御-----------------------------------------------------

        if (!provider.isSelectedAlphabet) {
          // カルーセル選択フラグがfalseの時

          List<MapEntry> entries = provider.machineCardCount.entries.toList();

          // Ensure that the list isn't empty and the desired index is valid.
          if (entries.isNotEmpty && index < entries.length) {
            if (scrollController.offset > entries[index].value["height"]) {
              if(scrollController.offset > entries[entries.length - 1].value["height"]){

              }else{
                carouselController.animateToPage(
                  index + 1,
                  duration: Duration(
                    milliseconds: 1,
                  ),
                );
                //print("+1");
              }
            }

            if (index != 0 && index - 1 < entries.length) {
              if (scrollController.offset <
                  entries[index - 1].value["height"]) {
                //print(DateTime.now());
                carouselController.animateToPage(
                  index - 1,
                  duration: Duration(
                    milliseconds: 1,
                  ),
                );
                //print("-1");
              }
            }
          }

          if (notification is ScrollStartNotification) {
            // スクロール開始時の動作
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //print("srart");
              provider.turnScrollFlag(true);
            });
          } else if (notification is ScrollEndNotification) {
            // スクロール終了時の動作

            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.turnScrollFlag(false);
            });
          }
        } else {
          //カルーセル選択フラグがtrueの時
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              expandedHeight: 30.0,
              floating: false,
              pinned: true,
              actions: <Widget>[
                AlphabetCarousel(
                  controller: carouselController,
                ),
              ],
              systemOverlayStyle: SystemUiOverlayStyle.light,
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
              padding: EdgeInsets.only(
                  bottom: bottomBarHeightWithSafePadding(context) + 600),
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
