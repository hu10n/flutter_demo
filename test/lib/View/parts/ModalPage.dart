import 'package:flutter/material.dart';
import 'InputField.dart';

class ModalPage {
  final ScrollController scrollController = ScrollController();
  void show(BuildContext context, Function onScrollUp, Function onScrollDown) {

    onScrollDown(100);//下部ナビゲーションのアニメーション

    //モーダル表示
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return GestureDetector(
          // TextFielをfocus時のアニメーション用。まだ未使用-------------------
          onTapDown: (TapDownDetails details) {
            // タップされた位置を取得
            //final localPosition = details.localPosition;
            //final globalPosition = details.globalPosition;
            //print('Local Position: $localPosition');
            //print('Global Position: $globalPosition');
            //scrollFocus(localPosition.dy, globalPosition.dy);
          },
          //-------------------------------------------------------------
          child: Container(
            height: MediaQuery.of(context).size.height, //モーダルの高さは全画面
            child: Stack(
              children: [
                Column(
                  children: [
                    //モーダルの大タイトル＋クローズボタン---------------------
                    _buildContainer(context,onScrollUp,"プロジェクトを割り当てる"),
                    //---------------------------------------------------
                    //スクロールビュー部分----------------------------------
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //border: Border.all() //デバッグ用
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0), //上下左右のパディング設定。できれば数値指定したくない
                              child: Column(
                                children: [
                                  //商品情報----------------------------
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("・商品情報"),
                                  ),   
                                  SizedBox(height: 20,), 
                                  InputField("品名",scrollController),
                                  SizedBox(height: 15,),
                                  InputField("品番",scrollController),
                                  SizedBox(height: 15,),
                                  InputField("材料",scrollController),
                                  SizedBox(height: 15,),
                                  InputField("ロットNo.",scrollController),
                                  SizedBox(height: 80,),
                                  //-----------------------------------
                                  //お客様情報---------------------------
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("・お客様情報"),
                                  ),   
                                  SizedBox(height: 20,), 
                                  InputField("客先名",scrollController),
                                  SizedBox(height: 80,),
                                  //------------------------------------
                                  //担当者情報---------------------------
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("・担当者情報"),
                                  ),   
                                  SizedBox(height: 20,), 
                                  InputField("担当者名",scrollController),
                                  SizedBox(height: 80,),
                                  //------------------------------------
                                  //作業工程---------------------------
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("・作業工程"),
                                  ),   
                                  SizedBox(height: 20,), 
                                  InputField("ステップ1",scrollController),
                                  SizedBox(height: 80,),
                                  //------------------------------------
                                  SizedBox(height: 500,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )                            
                    ),
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
                        bottom: MediaQuery.of(context).viewInsets.bottom, // キーパッドの高さ + 20.0
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            // ボタンがタップされた時の処理を記述
                          },
                          child: Text('割り当て'),
                        ),
                      ),
                    ),
                  ),                            
                ),
                //------------------------------------------------------
              ],
            ),
          ),
        );    
      }
    );
  }

  //モーダルのタイトル作成。一応分けた。---------------------------------------
  Container _buildContainer(BuildContext context, Function onScrollUp, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 4.0), // コンテナ間のマージン
      padding: EdgeInsets.all(8.0), // コンテナのパディング
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.black, width: 1.0), // デバッグ用
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 子ウィジェットをスペースで均等に配置
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // ここでBottom Sheetを閉じます
              onScrollUp(100); //下部ナビゲーションを戻す
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
  //---------------------------------------------------------------------

  //未完成
  void scrollFocus(double local, double grobal) async{
    double position = grobal - (local - 100);
    await scrollController.animateTo(
      100,
      duration: Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeOut
    );
  }
}
