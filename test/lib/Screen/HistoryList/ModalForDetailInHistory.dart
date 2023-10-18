import 'package:flutter/material.dart';

import 'package:test/GlobalWidget/BuildTitleForModal.dart';
import 'package:test/GlobalMethod/utils.dart';

class ModalContentForDetail_History extends StatefulWidget {
  final Function onScrollUp;
  //final Function setIsModal;
  final Map<dynamic, dynamic> machine;
  final Map<dynamic, dynamic> project;
  const ModalContentForDetail_History(
      {Key? key,
      required this.onScrollUp,
      //required this.setIsModal,
      required this.machine,
      required this.project})
      : super(key: key);

  @override
  _ModalContentForDetail_History createState() => _ModalContentForDetail_History();
}

class _ModalContentForDetail_History extends State<ModalContentForDetail_History> {
  @override
  Widget build(BuildContext context) {
    final machine = widget.machine;
    final project = widget.project;
    //print(project["step"]);
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
        child: Stack(
          children: [
            Column(
              children: [
                //モーダルの大タイトル＋クローズボタン---------------------
                BuildTitleForModal(context, widget.onScrollUp, "詳細情報を見る"),
                //---------------------------------------------------
                //スクロールビュー部分----------------------------------

                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom +
                                50.0),
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
                                    // 作業機情報----------------------------------------------------
                                    _createAlign("作業機情報"),
                                    _createAlign("・機番：${machine['machine_group']}-${machine['machine_num']}"),
                                    _createAlign("・機名：${machine['machine_name']}"),
                                    _createAlign("・機械ステータス：${machine['machine_status']}"),
                                    _createAlign("・作成日時：${formatTime(machine['created_at'])}"),
                                    _createAlign("・更新日時：${formatTime(machine['updated_at'])}"),
                                    //--------------------------------------------------------------
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // 商品情報----------------------------------------------------
                                    _createAlign("部品情報"),
                                    _createAlign("・品番：${project['product_num']}"),
                                    _createAlign("・品名：${project['product_name']}"),
                                    _createAlign("・プロジェクトステータス：${project['project_status']}"),
                                    _createAlign("・材料：${project['material']}"),
                                    _createAlign("・ロット番号：${project['lot_num']}"),
                                    _createAlign("・生産量：${project['production_volume']}"),
                                    _createAlign("・担当者：${project['supervisor']}"),
                                    _createAlign("・作成日時：${formatTime(project['created_at'])}"),
                                    _createAlign("・更新日時：${formatTime(project['updated_at'])}"),
                                    //--------------------------------------------------------------
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ...List.generate(
                                            project["step"].length,
                                            (index) => stepInfoWidget(
                                                index, project["step"][index]))
                                        .expand((widget) =>
                                            [widget, SizedBox(height: 20)])
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
                //--------------------------------------------------
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget stepInfoWidget(int index, Map<dynamic, dynamic> step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createAlign("工程${index + 1}"),
        _createAlign("・作業名：${step['step_name']}"),
        _createAlign("・ステップステータス：${step['prject_status']}"),
        _createAlign("・作業者名：${step['worker']}"),
        _createAlign("・生産数：${step['production_volume']}"),
        _createAlign("・備考：${step['free_text']}"),
        _createAlign("・開始日時：${formatTime(step['started_at'])}"),
        _createAlign("・完了日時：${formatTime(step['finished_at'])}"),
        _createAlign("・作成日時：${formatTime(step['created_at'])}"),
        _createAlign("・更新日時：${formatTime(step['updated_at'])}")
      ],
    );
  }
  Widget _createAlign(text){
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}
