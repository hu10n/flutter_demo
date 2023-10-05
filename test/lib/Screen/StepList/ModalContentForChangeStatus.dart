import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import '../../GlobalWidget/LoadingModal.dart';
import '../../providers/DataProvider.dart';
import '../../GlobalWidget/ShowDialog.dart';
import '../../GlobalWidget/BuildTitleForModal.dart';

class ModalContentForChangeStatus extends StatefulWidget {
  final Function onScrollUp;
  final Function setIsModal;
  final Map<String, dynamic> machine;
  final Map<String, dynamic> project;
  const ModalContentForChangeStatus({
    Key? key, 
    required this.onScrollUp,
    required this.setIsModal,
    required this.machine, 
    required this.project
    })  : super(key: key);

  @override
  _ModalContentForChangeStatus createState() => _ModalContentForChangeStatus();
}

class _ModalContentForChangeStatus extends State<ModalContentForChangeStatus> {

  bool _isLoading = false; //ローディング画面用
   List<String> _dropdownItems = ['正常', '停止', '異常停止','メンテナンス'];  // ここに選択項目を追加します
  String? _selectedItem;


  void _submitData(
      machine, status, BuildContext context, Function onScrollUp) async {
    setState(() {
      _isLoading = true;
    });

    final res = await changeMachineStatus(machine, status); //データを送信
    await Provider.of<DataNotifier>(context, listen: false)
        .updateLocalDB(); //最新データに更新
    print(res);

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
        height: 500, //モーダルの高さは全画面
        child: Stack(
          children: [
            Column(
              children: [
                //モーダルの大タイトル＋クローズボタン---------------------
               BuildTitleForModal(context, widget.onScrollUp, "作業機のステータスを変更する"),
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
                                    SizedBox(height: 20,),
                                    _createOptions("稼働中", Colors.green),
                                    SizedBox(height: 50,),
                                    _createOptions("停止中", Colors.pink),
                                    SizedBox(height: 20,),
                                    _createOptions("異常停止中", Colors.red),
                                    SizedBox(height: 20,),
                                    _createOptions("メンテナンス中", Colors.yellow),
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
  Container _createOptions(text,color){
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 243, 243), // 背景色
        //border: Border.all(
          //color: Colors.blue, // 枠線の色
          //width: 2.0, // 枠線の太さ
        //),
        borderRadius: BorderRadius.circular(8.0), // 角を丸くする場合
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10,),
            Icon(
              Icons.circle,
              color: color,
              size: 20,
            ),
            SizedBox(width: 10,),
            Text(
              text,
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold
              ),
            ),                                           
          ],
        ),
      ),
    );
  }
}
