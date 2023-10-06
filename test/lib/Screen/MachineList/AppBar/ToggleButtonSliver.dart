import 'package:flutter/material.dart';

import 'ToggleButtons.dart';

class YourHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Function(int) onToggleSelected;
  final Function onScrollDown;
  final Function onScrollUp;

  YourHeaderDelegate({
    required this.onToggleSelected,
    required this.onScrollDown, 
    required this.onScrollUp
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    //double topPadding = max(30.0 - shrinkOffset, 0);
    //double bottomPadding = max(10.0 - shrinkOffset, 0);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Spacer(),
          ToggleButtonsWidget(onToggleSelected: onToggleSelected),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap:(){ // タップ時の動作を指定
                onScrollDown(100);
                _showActionSheet(context);
              }, 
              child: Icon(Icons.menu), // ハンバーガーメニュー
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;

  
  // アクションシート用-----------------------------------------------------
  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text('追加'),
              onTap: () {
                Navigator.pop(context);  // アクションシートを閉じる
                // ここに追加の処理を実装
                _showPopup(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('キャンセル'),
              onTap: () {
                Navigator.pop(context);  // アクションシートを閉じる
              },
            ),
          ],
        );
      }
    ).whenComplete(() {
      // ここでモーダルが閉じられた際の追加処理を実行します
      onScrollUp(100);
    });
  }
  //----------------------------------------------------------------
  
  // 未実装用ポップアップ
  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Important Message'),
          content: Text('この機能は未実装です。'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                
                Navigator.of(context).pop();  // ポップアップを閉じる
              },
            ),
          ],
        );
      },
    );
  }
}