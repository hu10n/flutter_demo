import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import '../../GlobalWidget/LoadingModal.dart';
import '../../providers/DataProvider.dart';
import '../../GlobalWidget/ShowDialog.dart';
import '../../GlobalWidget/BuildTitleForModal.dart';

class ModalContentForDetail extends StatefulWidget {
  final Function onScrollUp;
  final Function setIsModal;
  final Map<String, dynamic> machine;
  final Map<String, dynamic> project;
  const ModalContentForDetail({
    Key? key, 
    required this.onScrollUp,
    required this.setIsModal,
    required this.machine, 
    required this.project
    })  : super(key: key);

  @override
  _ModalContentForDetail createState() => _ModalContentForDetail();
}

class _ModalContentForDetail extends State<ModalContentForDetail> {

  bool _isLoading = false; //ローディング画面用



  void _submitData(
      machine, project, BuildContext context, Function onScrollUp) async {
    setState(() {
      _isLoading = true;
    });

    final res = await assignProjectInfo(machine, project); //データを送信
    await Provider.of<DataNotifier>(context, listen: false)
        .updateLocalDB(); //最新データに更新
    

    setState(() {
      _isLoading = false;
    });
  
    if(res == 3){
      print(res);
      showCustomDialog(context, onScrollUp,"エラー","データが最新ではありません。更新してから、もう一度お試しください");
    }else if(res == 1){
      showCustomDialog(context, onScrollUp,"完了","データは正常に送信されました。");
    }else{
      print(res);
      showCustomDialog(context, onScrollUp,"エラー","予期せぬエラーが発生しました。しばらくしてから、もう一度お試しください");
    }
  }


  @override
  Widget build(BuildContext context) {
    final machine = widget.machine;
    final project = widget.project;
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
                                    SizedBox(height: 20,),
                                    // 作業機情報----------------------------------------------------
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("作業機情報"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・機番：${machine['machine_group']}-${machine['machine_num']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・機名：${machine['machine_name']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・機械ステータス：${machine['machine_status']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・作成日時：${machine['created_at']}"),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("・作成日時：${machine['created_at']}"),
                                    ),
                                    //--------------------------------------------------------------
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
}
