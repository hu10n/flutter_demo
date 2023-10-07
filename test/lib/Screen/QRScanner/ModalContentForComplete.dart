//開始完了用入力フォーム

import 'package:flutter/material.dart';

import 'package:test/api/api.dart';
import 'package:test/GlobalMethod/updateLocaldbWithErrorHandle.dart';
import 'package:test/GlobalWidget/InputField.dart';
import 'package:test/GlobalWidget/LoadingModal.dart';
import 'package:test/GlobalWidget/ShowCusomDialog.dart';
import 'package:test/GlobalWidget/BuildTitleForModal.dart';

class ModalContentForComplete extends StatefulWidget {
  final Function onScrollUp;
  final Map stepInfoMap;

  const ModalContentForComplete(
      {super.key, required this.stepInfoMap, required this.onScrollUp});

  @override
  _ModalContentForCompleteState createState() =>
      _ModalContentForCompleteState();
}

class _ModalContentForCompleteState extends State<ModalContentForComplete> {
  //ステップ以外の入力フィールドは2つ
  List<TextEditingController> _controllers =
      List.generate(2, (index) => TextEditingController());
  List<FocusNode> _focuses = List.generate(2, (index) => FocusNode());

  bool _isLoading = false; //ローディング画面用
  bool _isButtonEnabled = false; //提出ボタンの制御

  void _submitData(
    update_state,
    step,
    BuildContext context,
  ) async {
    setState(() {
      _isLoading = true;
    });

    final res = await updateStepData(
        update_state,
        step,
        widget.stepInfoMap['stepStatusList'],
        widget.stepInfoMap['machine_id']); //データを送信*********************
    await updateLocaldbWithErrorHandle(context);

    setState(() {
      _isLoading = false;
    });

    if (res == 3) {
      print(res);
      showCustomDialog(context, widget.onScrollUp, "エラー",
          "データが最新ではありません。更新してから、もう一度お試しください");
    } else if (res == 1) {
      showCustomDialog(context, widget.onScrollUp, "完了", "データは正常に送信されました。");
    } else {
      print(res);
      showCustomDialog(context, widget.onScrollUp, "エラー",
          "予期せぬエラーが発生しました。しばらくしてから、もう一度お試しください");
    }
  }

  void _unfocus() {
    for (var focus in _focuses) {
      focus.unfocus();
    }
  }

  _onTextChanged() {
    bool allFieldsFilled = _controllers[0].text.isNotEmpty;
    setState(() {
      _isButtonEnabled = allFieldsFilled;
    });
  }

  @override
  void initState() {
    super.initState();
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
    final step_to_edit = widget.stepInfoMap['step_to_edit'];
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
                BuildTitleForModal(context, widget.onScrollUp, "完了報告を作成する"),
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'STEP ${step_to_edit['step_num']}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                '担当工程: ${step_to_edit['step_name']}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            '作業者名: ${step_to_edit['worker']}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //-------------------------------------------------
                                    SizedBox(
                                      height: 60,
                                    ),
                                    InputField("生産数", _controllers[0],
                                        _focuses[0], isRequired: true, isNumOnly: true),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InputField("備考", _controllers[1],
                                        _focuses[1]),
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
                      onPressed: !_isButtonEnabled ? null: () async {
                        //print(widget.stepStatus['stepToStart']);
                        int update_status = 1;
                        Map<String, dynamic> step = Map.from(step_to_edit);

                        //step["worker"] = _controllers[0].text;
                        step["production_volume"] = _controllers[0].text;
                        step["free_text"] = _controllers[1].text;

                        print(step);

                        //print(project);
                        _unfocus();
                        _submitData(
                          update_status,
                          step,
                          context,
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size(
                            MediaQuery.of(context).size.width * 0.9,
                            40.0)), // ここで幅と高さを指定
                      ),
                      child: Text('作業完了'),
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
