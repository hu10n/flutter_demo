import 'package:flutter/material.dart';

Container LoadingModal() {
  return Container(
    color: Colors.black.withOpacity(0.5),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
