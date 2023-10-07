import 'package:flutter/material.dart';

//入力フォーム---------------------------------------------------------------------

//入力タイトル＋テキストフィールド＋必須マーク
Container InputField(String title, TextEditingController controller, FocusNode focus,
 {bool isRequired = false, bool isNumOnly = false} ) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 子ウィジェットを左揃えにする
      children: [
        Container(
          margin: EdgeInsets.only(top: 0.0),
          height: 20.0,
          //width: 70.0,
          //color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //タイトル---------------------------------------------
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold
                ),
              ),
              //必須マーク--------------------------------------------
              if(isRequired)
              Container(
                //width: 100,
                //height: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2), // 角を丸めるためのプロパティ
                ),
                padding: EdgeInsets.all(3), 
                child: Center(
                  child: Text(
                    '必須',
                    style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10
                    ),
                  )
                ),
              ),
              //----------------------------------------------------
            ],
          ),
        ),
        SizedBox(height: 4,),
        //テキストフィールド-------------------------------------------
        TextField(
          keyboardType: isNumOnly ? TextInputType.number: null,
          focusNode: focus,
          controller: controller,
          decoration: InputDecoration(
            fillColor: Color.fromARGB(100, 200, 200, 200), // 背景色を指定
            filled: true,
            //labelText: 'Item 0',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(100, 200, 200, 200), width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2), // Focus時のボーダーの色を青に設定
            ),
          ),
          onTap: ()async{
            
          },
        ),
        //------------------------------------------------------------
      ],
    ),
  );
}