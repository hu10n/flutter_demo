//開始報告用入力フォーム

import 'package:flutter/material.dart';
import 'package:test/GlobalMethod/utils.dart';

import 'package:test/GlobalWidget/LoadingModal.dart';
import 'package:test/GlobalWidget/BuildTitleForModal.dart';

class ModalContentForClosed extends StatefulWidget {
  final Function onScrollUp;
  final Map stepInfoMap;

  const ModalContentForClosed(
      {super.key, required this.stepInfoMap, required this.onScrollUp});

  @override
  _ModalContentForClosedState createState() => _ModalContentForClosedState();
}

class _ModalContentForClosedState extends State<ModalContentForClosed> {
  //ステップ以外の入力フィールドは1つ
  List<TextEditingController> _controllers =
      List.generate(1, (index) => TextEditingController());
  List<FocusNode> _focuses = List.generate(1, (index) => FocusNode());

  bool _isLoading = false; //ローディング画面用

  void _submitData(update_state, step, BuildContext context) async {}

  void _unfocus() {}

  @override
  void dispose() {}

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
                BuildTitleForModal(context, widget.onScrollUp, "全ての工程が完了済み"),
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //ステップ表示--------------------------------------
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Name: ${widget.stepInfoMap['machine_name']}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //-------------------------------------------------
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
              bottom: bottomSafePaddingHeight(context),
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
                      onPressed: () {
                        Navigator.pop(context); // この行を追加
                        // widget.resumeScan();
                        widget.onScrollUp(bottomSafePaddingHeight(context)
                            .toInt()); //下部ナビゲーションを戻す
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size(
                            MediaQuery.of(context).size.width * 0.9,
                            40.0)), // ここで幅と高さを指定
                      ),
                      child: Text('閉じる'),
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
