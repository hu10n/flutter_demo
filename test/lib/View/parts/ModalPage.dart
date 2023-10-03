import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import 'InputField.dart';
import 'LoadingModal.dart';
import '../../providers/DataClass.dart';

class MyModal extends StatefulWidget {
  final Function onScrollUp;
  final Map<String, dynamic> machine;
  const MyModal({Key? key, required this.onScrollUp, required this.machine}) : super(key: key);

  @override
  _MyModalState createState() => _MyModalState();
}

class _MyModalState extends State<MyModal> {
  //ステップ以外の入力フィールドは６つ
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focuses = List.generate(6, (index) => FocusNode());
  int _counter = 0; //ステップ数
  List<Widget> stepFields = [];

  bool _isLoading = false; //ローディング画面用
  

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

  void _addStepField(){
    setState(() {
      _controllers.add(TextEditingController());
      _focuses.add(FocusNode());
      stepFields.add(InputField("ステップ${_counter + 1}",_controllers[_counter + 6],_focuses[_counter + 6]));
      stepFields.add(SizedBox(height: 20,));     
    });
  }

  void _removeStepField(){
    setState(() {
      stepFields.removeAt(stepFields.length - 1);
      stepFields.removeAt(stepFields.length - 1);
      _controllers.removeAt(_counter + 7);
      _focuses.removeAt(_counter + 7);
    });
  }

  void _submitData(machine,project,BuildContext context, Function onScrollUp)async{
    setState(() {
      _isLoading = true;
    });

    final res = await assignProjectInfo(machine, project);//データを送信
    await Provider.of<DataNotifier>(context, listen: false).updateLocalDB();//最新データに更新
    print(res);

    setState(() {
        _isLoading = false;
    });
    _showCompleteDialog(context,onScrollUp); //完了ダイアログ
  }

  void _showCompleteDialog(BuildContext mainContext,Function onScrollUp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete'),
          content: Text('Loading Complete!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();//ダイアログを閉じる
                Navigator.pop(mainContext); // モーダルを閉じる
                onScrollUp(100); //下部ナビゲーションを戻す
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _unfocus(){
    for(var focus in _focuses){
      focus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    // initStateの中でstepFieldsを初期化
    _controllers.add(TextEditingController());
    _focuses.add(FocusNode());
    stepFields.add(InputField("ステップ1", _controllers[6],_focuses[6]));
    stepFields.add(SizedBox(height: 20,));
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
      onTap: (){
        _unfocus(); //入力フィールド以外をタップするとフォーカスが外れる
      },
      child: Container(
        height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
        child: Stack(
          children: [
            Column(
              children: [
                //モーダルの大タイトル＋クローズボタン---------------------
                _buildContainer(context,widget.onScrollUp,"プロジェクトを割り当てる"),
                //---------------------------------------------------
                //スクロールビュー部分----------------------------------
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 70.0),
                    child: ListView(
                      //controller: scrollController,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            //border: Border.all() //デバッグ用
                          ),
                          child: Padding(                             
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0), //上下左右のパディング設定。できれば数値指定したくない
                            child: Column(
                              children: [
                                //商品情報----------------------------
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("・商品情報"),
                                ),   
                                SizedBox(height: 20,), 
                                InputField("品名",_controllers[0],_focuses[0]),
                                SizedBox(height: 15,),
                                InputField("品番",_controllers[1],_focuses[1]),
                                SizedBox(height: 15,),
                                InputField("材料",_controllers[2],_focuses[2]),
                                SizedBox(height: 15,),
                                InputField("ロットNo.",_controllers[3],_focuses[3]),
                                SizedBox(height: 80,),
                                //-----------------------------------
                                //お客様情報---------------------------
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("・お客様情報",),
                                ),   
                                SizedBox(height: 20,), 
                                InputField("客先名",_controllers[4],_focuses[4]),
                                SizedBox(height: 80,),
                                //------------------------------------
                                //担当者情報---------------------------
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("・担当者情報"),
                                ),   
                                SizedBox(height: 20,), 
                                InputField("担当者名",_controllers[5],_focuses[5]),
                                SizedBox(height: 80,),
                                //------------------------------------
                                //作業工程-----------------------------
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("・作業工程"),
                                ),   
                                SizedBox(height: 20,), 
                                
                                ...stepFields, //ステップの入力フィールド

                                //+-ボタン(少し冗長かも)------------------------
                                Row(                         
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: (){
                                        _unfocus();
                                        _plusCounter();
                                        _addStepField();                          
                                      },
                                      child: Text('+', style: TextStyle(fontSize: 20)),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // 四角にする
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(Size(100, 40)),
                                      ),
                                    ),
                                    if(_counter > 0)
                                      ElevatedButton(
                                        onPressed: (){
                                          _unfocus();
                                          _minusCounter();
                                          _removeStepField();                     
                                        },
                                        child: Text('-', style: TextStyle(fontSize: 20)),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 243, 33, 93)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), // 四角にする
                                            ),
                                          ),
                                          minimumSize: MaterialStateProperty.all(Size(100, 40)),
                                        ),
                                      ),
                                  ],
                                ),
                                //----------------------------
                                SizedBox(height: 80,),
                                //------------------------------------
                                //SizedBox(height: 500,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                ),
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
                    bottom: MediaQuery.of(context).viewInsets.bottom, // キーパッドの高さ + 20.0
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () async{
                        // ボタンがタップされた時の処理を記述
                        //print(await postStepData("ok"));
                        //print(await assignProjectInfo(machine["machine_id"],machine["machine_status"]));
                        Map<String,dynamic> project = {
                          "product_name": _controllers[0].text,
                          "product_num": _controllers[1].text,
                          "material": _controllers[2].text,
                          "lot_num": _controllers[3].text,
                          "client_name": _controllers[4].text,
                          "supervisor": _controllers[5].text,
                          "step": []
                        };

                        for (var i = 0; i < _controllers.length; i++) {
                          if (i < 6) continue; // _controllers[6]以降のみ処理する。
                          project["step"].add({"step_name": _controllers[i].text});
                        }
                        //print(project);
                        _unfocus();
                        _submitData(widget.machine, project,context,widget.onScrollUp);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.9, 40.0)), // ここで幅と高さを指定
                      ),
                      child: Text('割り当て'),
                    ),
                  ),
                ),
              ),                            
            ),
            //------------------------------------------------------
            //ローディング画面-----------------------------------------
            if (_isLoading)
              LoadingModal()
            //------------------------------------------------------
          ],
        ), 
      ),
    );
  }
  //モーダルのタイトル作成。一応分けた。---------------------------------------
  Container _buildContainer(BuildContext context, Function onScrollUp, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 4.0), // コンテナ間のマージン
      padding: EdgeInsets.all(8.0), // コンテナのパディング
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.black, width: 1.0), // デバッグ用
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 子ウィジェットをスペースで均等に配置
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // ここでBottom Sheetを閉じます
              onScrollUp(100); //下部ナビゲーションを戻す
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
  //---------------------------------------------------------------------
}