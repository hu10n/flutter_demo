import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/DataProvider.dart';
import 'BottNaviBar.dart';

class BottNaviWithRefleshBtn extends StatelessWidget {
  final bool showBottomBar; //
  final int scrollValue; //スクロールアニメーション制御用
  final Function setIsLoading; //更新アニメーション用
  final int currentIndex; //現在のタブ位置
  final Function(int) onTap; //タブを押した際のタブ移動ロジック

  BottNaviWithRefleshBtn({
    required this.showBottomBar,
    required this.scrollValue,
    required this.currentIndex,
    required this.setIsLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom:
          showBottomBar ? 0.0 : -(kToolbarHeight + safePadding + scrollValue),
      left: 0.0,
      right: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min, // 最小限のサイズを取るように設定
        children: [
          if (currentIndex == 0) // currentIndexが1でのみ更新ボタンを表示
            //更新ボタン(分割予定)-----------------------------------------
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // 更新ボタンのアクションを記述
                    _pressUpdateButtom(context);
                  },
                  child: Icon(Icons.refresh),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    fixedSize: Size(50, 50),
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
          //----------------------------------------------------------
          //ボトムナビゲーション部分----------------------------------------
          BottNaviBar(onTap: onTap, selectedIndex: currentIndex),
          //------------------------------------------------------------
        ],
      ),
    );
  }

  //更新ボタン用---------------------------------------------------------
  void _pressUpdateButtom(BuildContext context) async {
    setIsLoading(true);
    await Provider.of<DataNotifier>(context, listen: false)
        .updateLocalDB(); //更新
    print("更新");
    setIsLoading(false);
  }
  //-------------------------------------------------------------------
}
