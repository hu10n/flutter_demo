import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import 'InputField.dart';
import 'LoadingModal.dart';
import '../../DataClass.dart';

class QRModal extends StatefulWidget {
  final Function onScrollUp;

  const QRModal({Key? key, required this.onScrollUp}) : super(key: key);

  @override
  _QRModalState createState() => _QRModalState();
}

class _QRModalState extends State<QRModal> {
  //ステップ以外の入力フィールドは６つ
  List<TextEditingController> _controllers =
      List.generate(1, (index) => TextEditingController());
  List<FocusNode> _focuses = List.generate(1, (index) => FocusNode());

  bool _isLoading = false; //ローディング画面用

  void _submitData(
      machine, project, BuildContext context, Function onScrollUp) async {
    setState(() {
      _isLoading = true;
    });

    final res =
        await assignProjectInfo(machine, project); //データを送信*********************
    await Provider.of<DataNotifier>(context, listen: false)
        .updateLocalDB(); //最新データに更新
    print(res);

    setState(() {
      _isLoading = false;
    });
    _showCompleteDialog(context, onScrollUp); //完了ダイアログ
  }

  void _showCompleteDialog(BuildContext mainContext, Function onScrollUp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete'),
          content: Text('Loading Complete!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //ダイアログを閉じる
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

  void _unfocus() {
    for (var focus in _focuses) {
      focus.unfocus();
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
                _buildContainer(context, widget.onScrollUp, "プロジェクトを割り当てる"),
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
                                  children: [],
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
                      onPressed: () async {
                        Map<String, dynamic> project = {
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
                          project["step"]
                              .add({"step_name": _controllers[i].text});
                        }
                        //print(project);
                        _unfocus();
                        // _submitData(widget.machine, project, context,
                        //     widget.onScrollUp);
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

  //モーダルのタイトル作成。一応分けた。---------------------------------------
  Container _buildContainer(
      BuildContext context, Function onScrollUp, String title) {
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
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
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
