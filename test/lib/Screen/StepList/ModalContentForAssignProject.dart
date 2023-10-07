import 'package:flutter/material.dart';

import 'package:test/api/api.dart';
import 'package:test/GlobalMethod/updateLocaldbWithErrorHandle.dart';
import 'package:test/GlobalWidget/InputField.dart';
import 'package:test/GlobalWidget/LoadingModal.dart';
import 'package:test/GlobalWidget/ShowCusomDialog.dart';
import 'package:test/GlobalWidget/BuildTitleForModal.dart';

//入力項目が増えると書き直す部分が多いためハードコードを少なめにしたい

class MyModal extends StatefulWidget {
  final Function onScrollUp;
  final Map<String, dynamic> machine;
  const MyModal({Key? key, required this.onScrollUp, required this.machine})
      : super(key: key);

  @override
  _MyModalState createState() => _MyModalState();
}

class _MyModalState extends State<MyModal> {
  //ステップ以外の入力フィールドは7つ
  List<TextEditingController> _controllers =
      List.generate(7, (index) => TextEditingController());
  List<FocusNode> _focuses = List.generate(7, (index) => FocusNode());
  int _counter = 0; //ステップ数
  List<Widget> stepFields = [];

  bool _isLoading = false; //ローディング画面用

  bool _isButtonEnabled = false; //提出ボタンの制御

  void _plusCounter() {
    setState(() {
      _counter++;
    });
  }

  void _minusCounter() {
    setState(() {
      _counter--;
    });
  }

  void _addStepField() {
    setState(() {
      _isButtonEnabled = false;
      TextEditingController newController = TextEditingController();
      _controllers.add(newController);
      newController.addListener(_onTextChanged);
      _focuses.add(FocusNode());
      stepFields.add(InputField("ステップ${_counter + 1}",
          _controllers[_counter + 7], _focuses[_counter + 7], isRequired: true));
      stepFields.add(SizedBox(
        height: 20,
      ));
    });
  }

  void _removeStepField() {
    setState(() {
      stepFields.removeAt(stepFields.length - 1);
      stepFields.removeAt(stepFields.length - 1);
      _controllers.removeAt(_counter + 8);
      _focuses.removeAt(_counter + 8);

      _isButtonEnabled = _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  void _submitData(machine, project, BuildContext context,) async {
    setState(() {
      _isLoading = true;
    });

    final res = await assignProjectInfo(machine, project); //データを送信
    await updateLocaldbWithErrorHandle(context);
    

    setState(() {
      _isLoading = false;
    });
  
    if(res == 3){
      print(res);
      showCustomDialog(context, widget.onScrollUp,"エラー","データが最新ではありません。更新してから、もう一度お試しください");
    }else if(res == 1){
      showCustomDialog(context, widget.onScrollUp,"完了","データは正常に送信されました。");
    }else{
      print(res);
      showCustomDialog(context, widget.onScrollUp,"エラー","予期せぬエラーが発生しました。しばらくしてから、もう一度お試しください");
    }
  }

  void _unfocus() {
    for (var focus in _focuses) {
      focus.unfocus();
    }
  }

  _onTextChanged() {
    bool allFieldsFilled = _controllers.every((controller) => controller.text.isNotEmpty);
    setState(() {
      _isButtonEnabled = allFieldsFilled;
    });
  }

  @override
  void initState() {
    super.initState();
    // initStateの中でstepFieldsを初期化
    _controllers.add(TextEditingController());
    _focuses.add(FocusNode());
    stepFields.add(InputField("ステップ1", _controllers[7], _focuses[7], isRequired: true));
    stepFields.add(SizedBox(
      height: 20,
    ));

    for (var controller in _controllers) {
      controller.addListener(_onTextChanged);
    }
  }

  

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focuses.forEach((focus) => focus.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unfocus(); //入力フィールド以外をタップするとフォーカスが外れる
      },
      child: Container(
        height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
        child: Stack(
          children: [
            Column(
              children: [
                //モーダルの大タイトル＋クローズボタン---------------------
                BuildTitleForModal(context, widget.onScrollUp, "プロジェクトを割り当てる"),
                //---------------------------------------------------
                //スクロールビュー部分----------------------------------

                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom +
                                70.0),
                        child: ListView(
                          //controller: scrollController,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  //border: Border.all() //デバッグ用
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal:
                                        25.0), //上下左右のパディング設定。できれば数値指定したくない
                                child: Column(
                                  children: [
                                    //商品情報----------------------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・商品情報"),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InputField(
                                        "品名", _controllers[0], _focuses[0], isRequired: true),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InputField(
                                        "品番", _controllers[1], _focuses[1], isRequired: true),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InputField(
                                        "材料", _controllers[2], _focuses[2], isRequired: true),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InputField(
                                        "ロットNo.", _controllers[3], _focuses[3], isRequired: true),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InputField(
                                        "生産数", _controllers[4], _focuses[4], isRequired: true, isNumOnly: true),
                                    SizedBox(
                                      height: 80,
                                    ),
                                    //-----------------------------------
                                    //お客様情報---------------------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "・お客様情報",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InputField(
                                        "客先名", _controllers[5], _focuses[5], isRequired: true),
                                    SizedBox(
                                      height: 80,
                                    ),
                                    //------------------------------------
                                    //担当者情報---------------------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・担当者情報"),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InputField(
                                        "担当者名", _controllers[6], _focuses[6], isRequired: true),
                                    SizedBox(
                                      height: 80,
                                    ),
                                    //------------------------------------
                                    //作業工程-----------------------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・作業工程"),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    ...stepFields, //ステップの入力フィールド

                                    //+-ボタン(少し冗長かも)------------------------
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            _unfocus();
                                            _plusCounter();
                                            _addStepField();
                                          },
                                          child: Text('+',
                                              style: TextStyle(fontSize: 20)),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // 四角にする
                                              ),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    Size(100, 40)),
                                          ),
                                        ),
                                        if (_counter > 0)
                                          ElevatedButton(
                                            onPressed: () {
                                              _unfocus();
                                              _minusCounter();
                                              _removeStepField();
                                            },
                                            child: Text('-',
                                                style: TextStyle(fontSize: 20)),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color.fromARGB(
                                                          255, 243, 33, 93)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // 四角にする
                                                ),
                                              ),
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size(100, 40)),
                                            ),
                                          ),
                                      ],
                                    ),
                                    //----------------------------
                                    SizedBox(
                                      height: 80,
                                    ),
                                    //------------------------------------
                                    //SizedBox(height: 500,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
                //--------------------------------------------------
              ],
            ),

            // スクロール可能なウィジェットの上に配置される固定ボタン--------
            Positioned.fill(
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // キーパッドの高さ + 20.0
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: !_isButtonEnabled ? null :() async {
                        // ボタンがタップされた時の処理を記述
                        //print(await postStepData("ok"));
                        //print(await assignProjectInfo(machine["machine_id"],machine["machine_status"]));
                        Map<String, dynamic> project = {
                          "product_name": _controllers[0].text,
                          "product_num": _controllers[1].text,
                          "material": _controllers[2].text,
                          "lot_num": _controllers[3].text,
                          "production_volume": _controllers[4].text,
                          "client_name": _controllers[5].text,
                          "supervisor": _controllers[6].text,
                          "step": []
                        };

                        for (var i = 0; i < _controllers.length; i++) {
                          if (i < 7) continue; // _controllers[6]以降のみ処理する。
                          project["step"]
                              .add({"step_name": _controllers[i].text});
                        }
                        //print(project);
                        _unfocus();
                        _submitData(widget.machine, project, context);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size(
                            MediaQuery.of(context).size.width * 0.9,
                            40.0)), // ここで幅と高さを指定
                      ),
                      child: Text('割り当て'),
                    ),
                  ),
                ),
              ),
            ),
            //------------------------------------------------------
            //ローディング画面-----------------------------------------
            if (_isLoading) LoadingModal()
            //------------------------------------------------------
          ],
        ),
      ),
    );
  }
}
