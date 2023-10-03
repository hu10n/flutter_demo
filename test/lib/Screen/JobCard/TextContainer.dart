import 'package:pdf/widgets.dart' as pw;

pw.Stack TextContainer(pw.Font? fontJP,String text, String title, double uleft,double bleft, double width, double ufont, double bfont) {
  return pw.Stack(
    children: [
      pw.Positioned(
        top: 0, // 上側の位置を調整
        left: uleft,
        child: pw.Container(
          width: width,
          height: 60,
          child: pw.Center(
            child: pw.Text(text, style: pw.TextStyle(fontSize: ufont,font: fontJP)),
          ),
        ),
      ),
      pw.Positioned(
        bottom: 10, // 下側の位置を調整
        left: bleft,
        child: pw.Container(
          child: pw.Text(title, style: pw.TextStyle(fontSize: bfont,font: fontJP)),
        ),
      ),
    ],
  );
}
