import 'package:flutter/material.dart';


class DataNotifier extends ChangeNotifier {
  String _data = '1';
  List _alphabetList = [];
  String _selectedAlphabet = "A";
  bool _isSelectedAlphabet = false;


  String get data => _data;
  List get alphabetList => _alphabetList;
  String get selectedAlphabet => _selectedAlphabet;
  bool get isSelectedAlphabet => _isSelectedAlphabet;

  set data(String newValue) {
    _data = newValue;
    notifyListeners();
  }
  void setAlphabetList(List alphabets) {
    _alphabetList = alphabets;
    notifyListeners();
  }
  void selectAlphabet(String alphabet) {
    _selectedAlphabet = alphabet;
    notifyListeners();
  }
  void turnSelectedFlag(bool flag) {
    _isSelectedAlphabet = flag;
    notifyListeners();
  }
}