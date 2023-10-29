import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Container UpperContainer(pw.Font? fontJP,machine, date) {
  return pw.Container(
    width: PdfPageFormat.letter.width,
    height: 150,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, // 左詰めと右詰め
      children: [
      //QRコードコンテナ-------------
        pw.Container(
          height: 150,
          width: 150,
          child: pw.Center(
            child: pw.BarcodeWidget(
              data: '{"key":"key-12345","projectId": "${machine["project"][0]["project_id"]}"}', // ここにQRコードのデータ（テキストやURL）を設定します。
              barcode: pw.Barcode.qrCode(),
              width: 120,
              height: 120,
            ), // 左に配置するコンテナ
          ),               
        ),
        //----------------------------
        //発行日付など------------------
        pw.Container(
          height: 150,
          width: 200,                      
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start, 
            crossAxisAlignment: pw.CrossAxisAlignment.start, 
            children: [
              pw.Text('発行日付：${date}',
                style: pw.TextStyle(font: fontJP,fontSize: 16)
              ),
              pw.Text('作業機：${machine["machine_group"]}-${machine["machine_num"]}|${machine["machine_name"]}',
                style: pw.TextStyle(font: fontJP,fontSize: 16)
              ),
              pw.Text('担当者：${machine["project"][0]["supervisor"]}',
                style: pw.TextStyle(font: fontJP,fontSize: 16)
              ),
            ],
          ), 
        ),
        //----------------------------
      ],
    ),
  );
}

