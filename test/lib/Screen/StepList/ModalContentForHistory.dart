import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import 'package:test/GlobalWidget/LoadingModal.dart';
import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalWidget/ShowCusomDialog.dart';
import 'package:test/GlobalWidget/BuildTitleForModal.dart';

class ModalContentForHistory extends StatefulWidget {
  final Function onScrollUp;
  final String machineId;
  const ModalContentForHistory({
    Key? key, 
    required this.onScrollUp,
    required this.machineId, 
    })  : super(key: key);

  @override
  _ModalContentForHistory createState() => _ModalContentForHistory();
}

class _ModalContentForHistory extends State<ModalContentForHistory> {

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
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
        child: Stack(
          children: [
            Column(
              children: [
                //モーダルの大タイトル＋クローズボタン---------------------
               BuildTitleForModal(context, widget.onScrollUp, "稼働履歴を見る"),
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
