import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Container BottomContainer(pw.Font? fontJP) {
  return pw.Container(
    width: PdfPageFormat.letter.width,
    height: 240,
    //decoration: pw.BoxDecoration(
      //color: PdfColors.green,
      //border: pw.Border.all(),
    //),
    child: pw.Center(
      child: pw.Table(
        border: pw.TableBorder.all(),
        children: List<pw.TableRow>.generate(
          6, // 6行生成
          (index) => pw.TableRow(
            children: [
              pw.Container(
                height: index == 0 ? 30 : 40,
                width: 30,
                padding: pw.EdgeInsets.all(8.0),
                child: pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(index == 0 ? '番号':'${index}',style: pw.TextStyle(font: fontJP)),
                ),
              ),
              pw.Container(
                height: index == 0 ? 30 : 40,
                padding: pw.EdgeInsets.all(8.0),
                child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text('作業工程',style: pw.TextStyle(font: fontJP)),
                ),
              ),
              pw.Container(
                height: index == 0 ? 30 : 40,
                width: 30,
                padding: pw.EdgeInsets.all(8.0),
                child: pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(index == 0 ? '番号':'${index + 5}',style: pw.TextStyle(font: fontJP)),
                ),
              ),
              pw.Container(
                height: index == 0 ? 30 : 40,
                padding: pw.EdgeInsets.all(8.0),
                child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text('作業工程',style: pw.TextStyle(font: fontJP)),
                ),
              ),
            ],
          ),
        ),
        
      ),
    ),
  );
}

