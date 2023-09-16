import 'package:flutter/material.dart';


class DataNotifier extends ChangeNotifier {
  String _data = '1';
  List _alphabetList = []; //データタグリスト
  Map<String, double> machineCardCount = {"A": 259.0, "B": 518.0, "C": 777.0}; //各タグの終了位置
  int _selectedAlphabet = 0; //カルーセルで選択されているインデックス
  bool _isSelectedAlphabet = false; //カルーセル選択フラグ
  bool _isScrollView = false;


  String get data => _data;
  List get alphabetList => _alphabetList;
  int get selectedAlphabet => _selectedAlphabet;
  bool get isSelectedAlphabet => _isSelectedAlphabet;
  bool get isScrollView => _isScrollView;

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
}