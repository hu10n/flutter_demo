import 'package:flutter/material.dart';
import 'DataBase.dart';

class DataNotifier extends ChangeNotifier {
  String _data = '1';
  List _alphabetList = [];

  int _selectedAlphabet = 0;
  bool _isSelectedAlphabet = false;
  bool _isScrollView = false;
  Map<String, Map<String, dynamic>> _machineCardCount = {};

  // 新しく追加したフィールド
  bool _isLoading = false;

  //ローカルデータベース用
  List<Map<String, dynamic>> _dataList = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // getter
  List<Map<String, dynamic>> get dataList => _dataList;
  String get data => _data;
  List get alphabetList => _alphabetList;
  int get selectedAlphabet => _selectedAlphabet;
  bool get isSelectedAlphabet => _isSelectedAlphabet;
  bool get isScrollView => _isScrollView;
  Map<String, Map<String, dynamic>> get machineCardCount => _machineCardCount;
  bool get isLoading => _isLoading; // 新しく追加したgetter

  DataNotifier() {
    // このNotifierが生成されたときにデータのロードを行う
    getAllData();
  }

  set data(String newValue) {
    _data = newValue;
    notifyListeners();
  }

  void setAlphabetList(List alphabets) {
    _alphabetList = alphabets;
    notifyListeners();
  }

  void selectAlphabet(int alphabet) {
    if (_selectedAlphabet != alphabet) {
      _selectedAlphabet = alphabet;
      notifyListeners();
    }
  }

  void turnSelectedFlag(bool flag) {
    if (_isSelectedAlphabet != flag) {
      _isSelectedAlphabet = flag;
      notifyListeners();
    }
  }

  void turnScrollFlag(bool flag) {
    _isScrollView = flag;
    notifyListeners();
  }

  void updateMachineCardCount(Map<String, Map<String, dynamic>> newCount) {
    _machineCardCount = newCount;
    notifyListeners();
  }

  void updateDataList(List<Map<String, dynamic>> dataList) {
    _dataList = dataList;
    notifyListeners();
  }

  void getAllData() async {
    _isLoading = true;
    notifyListeners();

    List<Map<String, dynamic>> machine = await _dbHelper.queryAll("machine");
    List<Map<String, dynamic>> project = await _dbHelper.queryAll("project");
    List<Map<String, dynamic>> step = await _dbHelper.queryAll("step");

    List<Map<String, dynamic>> allData = structuredData(machine, project, step);

    updateDataList(allData);

    _isLoading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> structuredData(List<Map<String, dynamic>> machine,
      List<Map<String, dynamic>> project, List<Map<String, dynamic>> step) {
    List<Map<String, dynamic>> _project = [];
    List<Map<String, dynamic>> _machine = [];

    for (var p in project) {
      var _p = Map.of(p);
      _p["step"] = step
          .where((element) => element["project_id"] == p["project_id"])
          .toList();
      _project.add(_p);
    }

    for (var m in machine) {
      var _m = Map.of(m);
      _m["project"] = _project
          .where((element) => element["machine_id"] == m["machine_id"])
          .toList();
      _machine.add(_m);
    }

    return _machine;
  }

  void updateLocalDB() async {
    await _dbHelper.update();
    notifyListeners();
  }
}
