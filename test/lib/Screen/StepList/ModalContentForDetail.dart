import 'package:flutter/material.dart';

import 'package:test/GlobalWidget/BuildTitleForModal.dart';
import 'package:test/GlobalMethod/utils.dart';

class ModalContentForDetail extends StatefulWidget {
  final Function onScrollUp;
  final Function setIsModal;
  final Map<String, dynamic> machine;
  final Map<String, dynamic> project;
  const ModalContentForDetail(
      {Key? key,
      required this.onScrollUp,
      required this.setIsModal,
      required this.machine,
      required this.project})
      : super(key: key);

  @override
  _ModalContentForDetail createState() => _ModalContentForDetail();
}

class _ModalContentForDetail extends State<ModalContentForDetail> {
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
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("作業機情報"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・機番：${machine['machine_group']}-${machine['machine_num']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・機名：${machine['machine_name']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・機械ステータス：${machine['machine_status']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・作成日時：${formatTime(machine['created_at'])}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・更新日時：${formatTime(machine['updated_at'])}"),
                                    ),
                                    //--------------------------------------------------------------
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // 商品情報----------------------------------------------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("部品情報"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text("・品番：${project['product_num']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・品名：${project['product_name']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・プロジェクトステータス：${project['project_status']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・材料：${project['material']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text("・ロット番号：${project['lot_num']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・生産量：${project['production_volume']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text("・担当者：${project['supervisor']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・作成日時：${formatTime(project['created_at'])}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "・更新日時：${formatTime(project['updated_at'])}"),
                                    ),
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

  Widget stepInfoWidget(int index, Map<String, dynamic> step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("工程${index + 1}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・作業名：${step['step_name']}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・ステップステータス：${step['prject_status']}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・作業者名：${step['worker']}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・生産数：${step['production_volume']}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・備考：${step['free_text']}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・開始日時：${formatTime(step['started_at'])}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・完了日時：${formatTime(step['finished_at'])}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・作成日時：${formatTime(step['created_at'])}"),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("・更新日時：${formatTime(step['updated_at'])}"),
        ),
      ],
    );
  }
}
