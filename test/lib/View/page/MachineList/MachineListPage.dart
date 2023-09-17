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

  _onToggleSelected(int index) {
    // フィルタリング時にページ上部にジャンプ
    scrollController.animateTo(
      -0.1, duration: Duration(milliseconds: 200,), curve: Curves.easeOut
    );
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

        if (notification.metrics.outOfRange) {// オーバースクロールの場合、何もしない
          return true;
        }
        if (notification.depth != 0) { // カルーセルのスクロールでも、何もしない
          return true;
        }

        // ボトムナビゲーション用のスクロール制御-----------------------------------------------
        if (notification is ScrollUpdateNotification) { // スクロール時
          if (notification.scrollDelta!.abs() > threshold) { // 閾値を超えた時
            if (notification.scrollDelta! > 0) {
              // ユーザーが下にスクロールしている場合
              widget.onScrollDown();
            } else if (notification.scrollDelta! < 0) {
              // ユーザーが上にスクロールしている場合
              widget.onScrollUp();
            }
          }
        }
        //--------------------------------------------------------------------------------

        
        // カルーセル同期用のスクロール制御-----------------------------------------------------
        final provider = Provider.of<DataNotifier>(context, listen: false);
        int index = provider.selectedAlphabet;

        if(!provider.isSelectedAlphabet){ // カルーセル選択フラグがtrueの時
          if(scrollController.offset > provider.machineCardCount.entries.toList()[index].value["height"]){
            carouselController.animateToPage(index + 1);
          }
          if(index != 0){
            if(scrollController.offset < provider.machineCardCount.entries.toList()[index - 1].value["height"]){
              carouselController.animateToPage(index - 1);
            }
          }

          if (notification is ScrollStartNotification) { // スクロール開始時の動作
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.turnScrollFlag(true);
            });
          } else if (notification is ScrollEndNotification) { // スクロール終了時の動作
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.turnScrollFlag(false);
            });         
          }
        }else{ //カルーセル選択フラグがfalseの時
          if (notification is ScrollEndNotification) { // スクロール終了時の動作
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
            SliverPersistentHeader( //SliverAppBarの上段
              delegate: YourHeaderDelegate(onToggleSelected: _onToggleSelected),
              pinned: false,
              floating: true,
            ),
            SliverAppBar( //SliverAppBarの下段
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
            SliverPadding( //padding
              padding: EdgeInsets.only(top: 0), // ここで所望のスペースの量を設定します
            ),
            MachineListSliverList( //一覧のコンテンツ部分
              selectedStatus: selectedStatus,
              onScrollDown: widget.onScrollDown,
              onScrollUp: widget.onScrollUp,
              controller: scrollController,
            ),
            SliverPadding( //padding
              padding: EdgeInsets.only(bottom: safePadding + kToolbarHeight),
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
