import 'package:flutter/material.dart';

//モーダルのタイトル作成。一応分けた。---------------------------------------
  Container BuildTitleForModal(
      BuildContext context, Function onScrollUp, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 4.0), // コンテナ間のマージン
      padding: EdgeInsets.all(8.0), // コンテナのパディング
      decoration: BoxDecoration(
          //border: Border.all(color: Colors.black, width: 1.0), // デバッグ用
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 子ウィジェットをスペースで均等に配置
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // ここでBottom Sheetを閉じます
              onScrollUp(100); //下部ナビゲーションを戻す
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
  //---------------------------------------------------------------------