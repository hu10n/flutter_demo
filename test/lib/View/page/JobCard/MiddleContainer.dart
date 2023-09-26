import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'TextContainer.dart';

pw.Container MiddleContainer(pw.Font? fontJP) {
  return pw.Container(
    width: PdfPageFormat.letter.width,
    height: 240,
    child: pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.center, // 中央に配置
    crossAxisAlignment: pw.CrossAxisAlignment.center, // 中央に配置
    children: [
        //客先-----------------------------------------
        pw.Container(
          width: PdfPageFormat.letter.width,
          height: 60,
          decoration: pw.BoxDecoration(
            //color: PdfColors.green,
            border: pw.Border(bottom: pw.BorderSide(width: 1.5)),
          ),
          child: TextContainer(fontJP, "株式会社ラ・ハイナ", "客先", 44, 0, 380, 30 ,20)
        ),
        //------------------------------------------------------------
        //品番-----------------------------------------
        pw.Container(
          width: PdfPageFormat.letter.width,
          height: 60,
          decoration: pw.BoxDecoration(
            //color: PdfColors.green,
            border: pw.Border(bottom: pw.BorderSide(width: 1.5)),
          ),
          child: TextContainer(fontJP, "GTX-23659", "品番", 44, 0, 380, 30 ,20)
        ),
        //------------------------------------------------------------
        //品名-----------------------------------------
        pw.Container(
          width: PdfPageFormat.letter.width,
          height: 60,
          decoration: pw.BoxDecoration(
            //color: PdfColors.green,
            border: pw.Border(bottom: pw.BorderSide(width: 1.5)),
          ),
          child: TextContainer(fontJP, "可動式ボトムピンφ=119m", "品名", 44, 0, 380, 30 ,20)
        ),
        //------------------------------------------------------------
        //材料とロットナンバー-------------------------------------------
        pw.Container(
          width: PdfPageFormat.letter.width,
          height: 60,
          decoration: pw.BoxDecoration(
            //color: PdfColors.green,
            border: pw.Border(bottom: pw.BorderSide(width: 1.5)),
          ),
          child: pw.Row( // ここでpw.Rowウィジェットを使用
            children: [
              pw.Container(
                width: 220, // 親コンテナの半分の幅
                child: TextContainer(fontJP, "可動式ボトムピン", "材料", 40, 3, 180, 15 ,15)
              ),
              pw.Container(
                width: 245, // 親コンテナの半分の幅
                child: TextContainer(fontJP, "6238D-2", "ロットNo.", 50, 3, 160, 15 ,15)
              ),
            ],
          ),
        ),
        //-------------------------------------------------------------
      ],
    ),
  );
}