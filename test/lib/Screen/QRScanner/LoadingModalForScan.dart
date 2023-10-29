// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

AlertDialog LoadingDialogForScan() {
  return AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff02A676))),
        SizedBox(width: 20),
        Text('読み込み中...'),
      ],
    ),
  );
}
