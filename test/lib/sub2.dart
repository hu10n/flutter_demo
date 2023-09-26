import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'View/page/JobCard/UpperContainer.dart';
import 'View/page/JobCard/MiddleContainer.dart';
import 'View/page/JobCard/BottomContainer.dart';

pw.Font? yourJapaneseFont;

Future<void> loadFont() async {
  final fontData = await rootBundle.load('assets/fonts/NotoSansJP-Medium.ttf');
  yourJapaneseFont = pw.Font.ttf(fontData);
  print("ok");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<void> _fontLoading = loadFont();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'デモ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<void>(
        future: _fontLoading,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyHomePage();
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final pdf = pw.Document();

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('デモ'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
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
          },
          child: Text('Print Letter PDF with Border and Scaled Content'),
        ),
      ),
    );
  }
}
