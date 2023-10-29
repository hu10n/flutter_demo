import 'package:flutter/material.dart';
import 'package:test/GlobalMethod/utils.dart';
//現在、モーダルフォームのタイトルに使用。

//大タイトル+モーダルを閉じるボタン---------------------------------------
Container BuildTitleForModal(
    BuildContext context, Function onScrollUp, String title) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    margin: EdgeInsets.symmetric(vertical: 4.0), // コンテナ間のマージン
    padding: EdgeInsets.all(8.0), // コンテナのパディング

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 子ウィジェットをスペースで均等に配置
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context); // ここでBottom Sheetを閉じます
            onScrollUp(100); //下部ナビゲーションを戻す
          },
          icon: Icon(Icons.close),
        ),
      ],
    ),
  );
}
  //---------------------------------------------------------------------