import 'package:flutter/material.dart';

import 'package:test/api/api.dart';
import 'package:test/GlobalMethod/updateLocaldbWithErrorHandle.dart';
import 'package:test/GlobalWidget/LoadingModal.dart';
import 'package:test/GlobalWidget/ShowCusomDialog.dart';
import 'package:test/GlobalWidget/BuildTitleForModal.dart';

class ModalContentForChangeStatus extends StatefulWidget {
  final Function onScrollUp;
  final Function setIsModal;
  final Map<String, dynamic> machine;
  final Map<String, dynamic> project;
  const ModalContentForChangeStatus(
      {Key? key,
      required this.onScrollUp,
      required this.setIsModal,
      required this.machine,
      required this.project})
      : super(key: key);

  @override
  _ModalContentForChangeStatus createState() => _ModalContentForChangeStatus();
}

class _ModalContentForChangeStatus extends State<ModalContentForChangeStatus> {
  bool _isLoading = false; //ローディング画面用

  void _submitData(machine, status, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final res = await changeMachineStatus(machine, status); //データを送信
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 500, //モーダルの高さは全画面
        child: Stack(
          children: [
            Column(
              children: [
                //モーダルの大タイトル＋クローズボタン---------------------
                BuildTitleForModal(
                    context, widget.onScrollUp, "作業機のステータスを変更する"),
                //---------------------------------------------------
                //スクロールビュー部分----------------------------------

                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom +
                                20.0),
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
                                    if (widget.project.isNotEmpty)
                                      _createOptions("稼働中", Colors.green, 1),
                                    if (widget.project.isEmpty)
                                      _createOptions("未稼働", Colors.grey, 0),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    _createOptions("停止中", Colors.pink, 2),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _createOptions("異常停止中", Colors.red, 3),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _createOptions("メンテナンス中", Colors.yellow, 4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
                //--------------------------------------------------
              ],
            ),
            //ローディング画面-----------------------------------------
            if (_isLoading) LoadingModal()
            //------------------------------------------------------
          ],
        ),
      ),
    );
  }

  Ink _createOptions(text, color, int update_status) {
    return Ink(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 243, 243), // 背景色
        borderRadius: BorderRadius.circular(8.0), // 角を丸くする場合
      ),
      child: InkWell(
        onTap: () {
          // タップ時の処理をここに記述
          _submitData(widget.machine, update_status, context);
          widget.setIsModal(false);
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 70,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.circle,
                  color: color,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
