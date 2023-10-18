import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ModalForDetailInHistory.dart';

class HistoryListCard extends StatelessWidget {
  final machine;
  final Function onScrollDown;
  final Function onScrollUp;

  const HistoryListCard({
    required this.machine,
    required this.onScrollDown,
    required this.onScrollUp
  });

  @override
  Widget build(BuildContext context) {
    //print(machine);
    double screenWidth = MediaQuery.of(context).size.width;

    final project = machine["project"];

    final product_name = project["product_name"];
    final product_num = project["product_num"];
    final client_name = project["client_name"];
    final finished_at = project["updated_at"];

    return Card(
      
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onScrollDown(100);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: false,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => ModalContentForDetail_History(
              onScrollUp: onScrollUp,
              machine: machine,
              project: project,
            ),
          ).whenComplete(() {
            
            onScrollUp(100);
          });
        },
        child: SizedBox(
          width: screenWidth,
          //height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //情報部分--------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _createRow(context, "商品：", "$product_name ($product_num)"),
                    SizedBox(height: 10),
                    _createRow(context, "客先名：", "$client_name"),
                    SizedBox(height: 10),                  
                    _createRow(context, "納品日：", "$finished_at")          
                  ],
                ),
              ),
              //---------------------------------------------------------
              //chevron_right--------------------------------------------
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.chevron_right),
              )
              //----------------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }

  Widget _createRow(BuildContext context, title, text){
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).disabledColor, fontWeight: FontWeight.bold, fontSize: 12,
          ),
        ),
        SizedBox(width: 10,),
        Text(text)
      ],
    );
  }
}
