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

  double lastOffset = 0.0; // スクロール状況監視用

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    lastOffset = scrollController.offset; // オフセットを更新
  }
  //---------------------------------------------------------------
  final CarouselController carouselController = CarouselController();
  int carouselIndex = 0;
  // フィルタリング用-------------------------------------------------
  int selectedStatus = -1;

  _onToggleSelected(int index) {
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

        double threshold = 5.0; // ここで閾値を設定

        int index = Provider.of<DataNotifier>(context, listen: false).selectedAlphabet;
        print(index);
        print(Provider.of<DataNotifier>(context, listen: false).machineCardCount);
        print(scrollController.offset);

        if(scrollController.offset > Provider.of<DataNotifier>(context, listen: false)
        .machineCardCount.entries.toList()[index].value){
          carouselController.animateToPage(index + 1);
          _onAlphabetSelected(index + 1);
        }

        if(index != 0){
          if(scrollController.offset < Provider.of<DataNotifier>(context, listen: false)
          .machineCardCount.entries.toList()[index - 1].value){
            carouselController.animateToPage(index - 1);
            _onAlphabetSelected(index - 1);
          }
        }


        if (notification is ScrollStartNotification) { // スクロール開始時の動作
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<DataNotifier>(context, listen: false).turnScrollFlag(true);
            //print("start");
          });
        } else if (notification is ScrollEndNotification) { // スクロール終了時の動作
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<DataNotifier>(context, listen: false).turnScrollFlag(false);
            //print("end");
          });         
        } else if (notification is ScrollUpdateNotification) { // スクロール時
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
                  onAlphabetSelected: _onAlphabetSelected,
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

  void _onAlphabetSelected(alphabet) { //カルーセルでアルファベット選択時
    Provider.of<DataNotifier>(context, listen: false).selectAlphabet(alphabet);
    if(!Provider.of<DataNotifier>(context, listen: false).isScrollView){ //スクロールによるカルーセル遷移では発火しない。
      Provider.of<DataNotifier>(context, listen: false).turnSelectedFlag(true);
      
    }
  }
  void updateCurrentIndex(int index) {
    setState(() {
      carouselIndex = index;
    });

    //widget.onAlphabetSelected(alphabetList[index]);
    _onAlphabetSelected(index);
  }
}
