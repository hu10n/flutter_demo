import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/color_schemes.g.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Screen/Base/InitLoadPage.dart';
import 'providers/DataProvider.dart';


void main() async{
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: lightColorScheme,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14.0),
          labelLarge: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      home: InitLoadSplashScreen(),
    );
  }
}
