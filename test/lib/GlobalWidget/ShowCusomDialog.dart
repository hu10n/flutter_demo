import 'package:flutter/material.dart';

void showCustomDialog(BuildContext mainContext, Function onScrollUp, String title, String text) {
  showDialog(
    context: mainContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //ダイアログを閉じる
              Navigator.pop(mainContext); // モーダルを閉じる
              onScrollUp(100); //下部ナビゲーションを戻す
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}