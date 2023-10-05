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
        height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
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
                                    DropdownButton<String>(
                                      value: _selectedItem,  // 現在選択されている項目
                                      hint: Text('選択してください'),  // 選択されていないときのヒント
                                      onChanged: (String? newValue) {  // 項目が選択されたときの処理
                                        setState(() {
                                          _selectedItem = newValue;
                                        });
                                      },
                                      items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
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
                        // ボタンがタップされた時の処理を記述
                        //print(widget.machine);
                        //print(widget.project);
                        //_submitData(widget.machine, project, context,
                        //    widget.onScrollUp);
                        print(_selectedItem);
                        print(widget.machine["project"].isEmpty);
                        final num;

                        if(_selectedItem == "正常"){
                          if(widget.machine["project"].isEmpty){
                            num = 0;
                          }else{
                            num = 1;
                          }
                        }else if(_selectedItem == "停止"){
                          num = 2;
                        }else if(_selectedItem == "異常停止"){
                          num = 3;
                        }else if(_selectedItem == "メンテナンス"){
                          num = 4;
                        }else{
                          num = -1;
                        }
                        print(num);

                        _submitData(widget.machine, num, context, widget.onScrollUp);

                        widget.setIsModal(false);
                        //Navigator.of(context).pop();
                        //widget.onScrollUp(100);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size(
                            MediaQuery.of(context).size.width * 0.9,
                            40.0)), // ここで幅と高さを指定
                      ),
                      child: Text('変更'),
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
