import 'package:flutter/material.dart';


class DataNotifier extends ChangeNotifier {
  String _data = '1';

  String get data => _data;

  set data(String newValue) {
    _data = newValue;
    notifyListeners();
  }
}
