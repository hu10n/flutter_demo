import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:test/LocalDataBase/LocalDataBase.dart';

class DataNotifier extends ChangeNotifier {
  //----------------------------------------------------
  pw.Font? _jpaneseFont;            //日本語フォント、pdf用

  int _selectedAlphabet = 0;        //カルーセルの選択バー位置管理用
  bool _isSelectedAlphabet = false; //カルーセル操作中フラグ
  bool _isScrollView = false;       //スクロール操作中フラグ
  Map<String, Map<String, dynamic>> _machineCardCount = {};  //作業機グループの開始位置特定用

  //ローカルデータベース用
  List<Map<String, dynamic>> _dataList = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  //-----------------------------------------------------

  // getter----------------------------------------------
  List<Map<String, dynamic>> get dataList => _dataList;
  pw.Font? get japaneseFont => _jpaneseFont; 
  int get selectedAlphabet => _selectedAlphabet;
  bool get isSelectedAlphabet => _isSelectedAlphabet;
  bool get isScrollView => _isScrollView;
  Map<String, Map<String, dynamic>> get machineCardCount => _machineCardCount;
  //-----------------------------------------------------
 

  //日本語フォントを起動時に読み込み
  Future<void> loadFont() async {
    final fontData =
        await rootBundle.load('assets/fonts/NotoSansJP-Medium.ttf');
    pw.Font? yourJapaneseFont = pw.Font.ttf(fontData);
    _jpaneseFont = yourJapaneseFont;
    //print("ok");
  }

  //setState------------------------------------------------
  void selectAlphabet(int alphabet) {
    if (_selectedAlphabet != alphabet) {
      _selectedAlphabet = alphabet;
      notifyListeners();
    }
  }

  void turnSelectedFlag(bool flag) {
    if (_isSelectedAlphabet != flag) {
      _isSelectedAlphabet = flag;
      //print("selectedFlag:$flag ${DateTime.now()}");
      notifyListeners();
    }
  }

  void turnScrollFlag(bool flag) {
    //print("$flag : ${DateTime.now()}");
    _isScrollView = flag;
    notifyListeners();
  }

  void updateMachineCardCount(Map<String, Map<String, dynamic>> newCount) {
    _machineCardCount = newCount;
    notifyListeners();
  }

  void updateDataList(List<Map<String, dynamic>> dataList) {
    _dataList = dataList;
    //print("updateDataList Timig");
    notifyListeners();
  }
  //-----------------------------------------------------------

  //LDBから全データを取得
  Future<void> getAllData() async {
    List<Map<String, dynamic>> machine = await _dbHelper.queryAll("machine");
    List<Map<String, dynamic>> project = await _dbHelper.queryAll("project");
    List<Map<String, dynamic>> step = await _dbHelper.queryAll("step");

    List<Map<String, dynamic>> allData = structuredData(machine, project, step);
    //print(allData);

    updateDataList(allData);
  }

  //ソート済の構造化データに変換
  List<Map<String, dynamic>> structuredData(List<Map<String, dynamic>> machine,
      List<Map<String, dynamic>> project, List<Map<String, dynamic>> step) {
    List<Map<String, dynamic>> _project = [];
    List<Map<String, dynamic>> _machine = [];

    // sorting step by 'step_num'
    List<Map<String, dynamic>> sortedStep = List.from(step);
    sortedStep.sort((a, b) => a["step_num"].compareTo(b["step_num"]));

    for (var p in project) {
      var _p = Map.of(p);
      _p["step"] = sortedStep
          .where((element) => element["project_id"] == p["project_id"])
          .toList();
      _project.add(_p);
    }

    // sorting machine List by 'machine_group' ,then by 'machine_num'
    List<Map<String, dynamic>> sortedMachine = List.from(machine);
    sortedMachine.sort((a, b) {
      int compare = a["machine_group"].compareTo(b["machine_group"]);
      if (compare == 0) {
        return a["machine_num"].compareTo(b["machine_num"]);
      }
      return compare;
    });

    for (var m in sortedMachine) {
      var _m = Map.of(m);
      _m["project"] = _project
          .where((element) => element["machine_id"] == m["machine_id"])
          .toList();
      _machine.add(_m);
    }

    return _machine;
  }

  //任意のプロジェクトレコードをLDBから削除
  Future deleteProject(String project_id) async {
    await _dbHelper.delete(project_id, "project");
  }

  //更新
  Future updateLocalDB() async {
    await _dbHelper.update(false); //trueで全データ更新
    getAllData();
    notifyListeners();
  }
}
