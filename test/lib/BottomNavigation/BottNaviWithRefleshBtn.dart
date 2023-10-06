import 'package:flutter/material.dart';
import 'package:test/GlobalMethod/updateLocaldbWithErrorHandle.dart';
import 'package:test/GlobalWidget/UpdateButton.dart';
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
      bottom://ボトムナビゲーションのアニメーションロジック
          showBottomBar ? 0.0 : -(kToolbarHeight + safePadding + scrollValue), 
      left: 0.0,
      right: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min, // 最小限のサイズを取るように設定
        children: [
          if (currentIndex != 1) // currentIndexが1でのみ更新ボタンを表示
            //更新ボタン(分割予定)-----------------------------------------
            UpdateButton(context,_pressUpdateButtom),
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
    await updateLocaldbWithErrorHandle(context);
    setIsLoading(false);
  }
  //-------------------------------------------------------------------
}
