import 'package:flutter/material.dart';

Container InputField(String title) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 子ウィジェットを左揃えにする
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
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
      ],
    ),
  );
}