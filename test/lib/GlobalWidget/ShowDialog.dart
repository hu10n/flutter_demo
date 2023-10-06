import 'package:flutter/material.dart';

//未実装用ポップアップ
void showDialogGeneral(BuildContext mainContext, String title, String text) {
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
              //Navigator.pop(mainContext); // モーダルを閉じる
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}