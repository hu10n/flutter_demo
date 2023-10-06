// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

AlertDialog LoadingDialogForScan() {
  return AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(width: 20),
        Text('読み込み中...'),
      ],
    ),
  );
}
