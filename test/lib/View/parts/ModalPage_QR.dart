import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import 'InputField.dart';
import 'LoadingModal.dart';
import '../../DataClass.dart';

class QRModal extends StatefulWidget {
  final Function onScrollUp;
  final Map stepStatus;
  final Function resumeScan;

  const QRModal({Key? key, required this.stepStatus, required this.resumeScan,required this.onScrollUp}) : super(key: key);

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
      update_state, step,status_list, BuildContext context, Function onScrollUp) async {
    setState(() {
      _isLoading = true;
    });

    final res =
        await updateStepData(update_state,step,status_list); //データを送信*********************
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
                                  children: [
                                    if (widget.stepStatus['stepToStart'] != null)
                                      _createStartSheet(widget.stepStatus, () {
                                        Navigator.pop(context);
                                        widget.resumeScan();
                                      }, () {
                                        //Button Action (開始)
                                      },_controllers[0],_focuses[0]),
                                    if (widget.stepStatus['stepOnGoing'] != null)
                                      _createCompleteSheet(widget.stepStatus, () {
                                        Navigator.pop(context);
                                        widget.resumeScan();
                                      }, () {
                                        //Button Action (完了)
                                      },_controllers[0],_focuses[0]),
                                    if (widget.stepStatus['stepToStart'] == null &&
                                        widget.stepStatus['stepOnGoing'] == null)
                                      _createCompletedSheet(widget.stepStatus, () {
                                        Navigator.pop(context);
                                        widget.resumeScan();
                                      }, () {
                                        widget.resumeScan();
                                      },_controllers[0],_focuses[0]),
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
                      onPressed: () async {
                        //print(widget.stepStatus['stepToStart']);
                        int update_status = 1;
                        Map<String, dynamic> step = widget.stepStatus['stepOnGoing'];
                        //step["worker"] = _controllers[0].text;
                        step["free_text"] = _controllers[0].text;
                        List status_list = [1,-1,0,0,0];

                        print(step);

                        //print(project);
                        _unfocus();
                        _submitData(update_status, step,status_list, context,
                             widget.onScrollUp);
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

  Widget _createCompletedSheet(Map<dynamic, dynamic> stepStatus,
      VoidCallback closeAction, VoidCallback proceedAction, TextEditingController controller, FocusNode focus) {
    // Adjust the information shown here since stepStatus['stepOnGoing'] will be null
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '全てのステップが完了しました。',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          Center(
            child: ElevatedButton(
              onPressed: proceedAction,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Text(
                  '閉じる',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCompleteSheet(Map<dynamic, dynamic> stepStatus,
          VoidCallback closeAction, VoidCallback proceedAction, TextEditingController controller, FocusNode focus) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP ${stepStatus['stepOnGoing']['step_num']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text(
                  '担当工程: ${stepStatus['stepOnGoing']['step_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            Text(
              '作業者名: ${stepStatus['stepOnGoing']['worker']}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]),
            ),
            InputField("備考", controller, focus),  // Need to be fixed
            Center(
              child: ElevatedButton(
                onPressed: proceedAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    '作業完了',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ],
        ),
      );

  Widget _createStartSheet(Map<dynamic, dynamic> stepStatus,
          VoidCallback closeAction, VoidCallback proceedAction, TextEditingController controller, FocusNode focus) =>
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP ${stepStatus['stepToStart']['step_num']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Text(
                  '担当工程: ${stepStatus['stepToStart']['step_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            InputField("作業者名", controller, focus),  // Need to be fixed
            Center(
              child: ElevatedButton(
                onPressed: proceedAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text(
                    '作業開始',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ],
        ),
      );
}
