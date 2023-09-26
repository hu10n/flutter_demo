import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'BottomContainer.dart';
import 'MiddleContainer.dart';
import 'UpperContainer.dart';

Future<void> createAndPrintPdf(pw.Document pdf,pw.Font? yourJapaneseFont) async {
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context) {
        return pw.Container(
          width: PdfPageFormat.letter.width,
          height: PdfPageFormat.letter.height,
          //decoration: pw.BoxDecoration(
            //border: pw.Border.all(width: 2.0), // Adding border
          //),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              //上段
              UpperContainer(yourJapaneseFont),
              //中段
              MiddleContainer(yourJapaneseFont),
              //下段------------------------------------------------------
              BottomContainer(yourJapaneseFont),
            ],
          ),
        );

      },
    ),
  );
  await Printing.layoutPdf(
    name: 'My Document',
    format: PdfPageFormat.letter,
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
