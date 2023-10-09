import 'package:flutter/material.dart';

Align UpdateButton(BuildContext context, pressUpdateButtom) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: ElevatedButton(
        onPressed: () {
          // 更新ボタンのアクションを記述
          pressUpdateButtom(context);
        },
        child: Icon(Icons.refresh),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          fixedSize: Size(50, 50),
          padding: EdgeInsets.all(8),
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    ),
  );
}
