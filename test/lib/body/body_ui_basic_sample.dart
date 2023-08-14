import 'package:flutter/material.dart';

class bodyUI extends StatelessWidget {
  final String title;

  bodyUI({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}