import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test/api/TestAPI.dart';
import '../../GlobalWidget/LoadingModal.dart';
import '../../providers/DataProvider.dart';
import '../../GlobalWidget/ShowDialog.dart';
import '../../GlobalWidget/BuildTitleForModal.dart';

class ModalContentForDelivery extends StatefulWidget {
  final Function onScrollUp;
  final Function setIsModal;
  final Map<String, dynamic> machine;
  final Map<String, dynamic> project;
  const ModalContentForDelivery({
    Key? key, 
    required this.onScrollUp,
    required this.setIsModal,
    required this.machine, 
    required this.project
    })  : super(key: key);

  @override
  _ModalContentForDelivery createState() => _ModalContentForDelivery();
}

class _ModalContentForDelivery extends State<ModalContentForDelivery> {

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
    return Container(
      height: 250,
      //height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
      child: Stack(
        children: [
          Column(
            children: [
              //モーダルの大タイトル＋クローズボタン---------------------
              BuildTitleForModal(context, widget.onScrollUp, "部品を納品する"),
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
          // スクロール可能なウィジェットの上に配置される固定ボタン--------
          Positioned.fill(
            bottom: 70,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  // ボタンがタップされた時の処理を記述
                  print(widget.machine);
                  print(widget.project);
                  //_submitData(widget.machine, project, context,
                  //    widget.onScrollUp);

                  widget.setIsModal(false);
                  Navigator.of(context).pop();
                  widget.onScrollUp(100);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width * 0.9,
                      40.0)), // ここで幅と高さを指定
                ),
                child: Text('納品する'),
              ),
            ),
          ),
          //------------------------------------------------------
          
          //ローディング画面-----------------------------------------
          if (_isLoading) LoadingModal()
          //------------------------------------------------------
        ],
      ),     
    );
  }

  
}
