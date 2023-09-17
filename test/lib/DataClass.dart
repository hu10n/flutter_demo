import 'package:flutter/material.dart';

class DataNotifier extends ChangeNotifier {
  String _data = '1';
  List _alphabetList = [];
  int _selectedAlphabet = 0;        //カルーセルで選択されているインデックス
  bool _isSelectedAlphabet = false; //カルーセル選択フラグ
  bool _isScrollView = false;       //スクロールフラグ
  Map<String, Map<String, dynamic>> _machineCardCount = {}; // カードリスト ex.{A: {machines: [A-1, A-2], count: 3, height: 259}, B:..}

  String get data => _data;
  List get alphabetList => _alphabetList;
  int get selectedAlphabet => _selectedAlphabet;
  bool get isSelectedAlphabet => _isSelectedAlphabet;
  bool get isScrollView => _isScrollView;
  Map<String, Map<String, dynamic>> get machineCardCount => _machineCardCount;

  set data(String newValue) {
    _data = newValue;
    notifyListeners();
  }

  void setAlphabetList(List alphabets) {
    _alphabetList = alphabets;
    notifyListeners();
  }

  void selectAlphabet(int alphabet) {
    _selectedAlphabet = alphabet;
    notifyListeners();
  }

  void turnSelectedFlag(bool flag) {
    _isSelectedAlphabet = flag;
    notifyListeners();
  }

  void turnScrollFlag(bool flag) {
    _isScrollView = flag;
    notifyListeners();
  }

  void updateMachineCardCount(Map<String, Map<String, dynamic>> newCount) {
    _machineCardCount = newCount;
    notifyListeners();
  }
}
