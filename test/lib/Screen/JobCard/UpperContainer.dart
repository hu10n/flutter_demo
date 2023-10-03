import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Container UpperContainer(pw.Font? fontJP) {
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
              data: 'https://www.example.com', // ここにQRコードのデータ（テキストやURL）を設定します。
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
              pw.Text('発行日付：2023/09/22',
                style: pw.TextStyle(font: fontJP,fontSize: 16)
              ),
              pw.Text('作業機：K-9|B(2)',
                style: pw.TextStyle(font: fontJP,fontSize: 16)
              ),
              pw.Text('担当者：村上拓也',
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

