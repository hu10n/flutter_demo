import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/color_schemes.g.dart';

import 'Screen/Base/InitLoadPage.dart';
import 'providers/DataProvider.dart';

void main() {
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
      theme: ThemeData(useMaterial3: false, colorScheme: lightColorScheme),
      home: InitLoadSplashScreen(),
    );
  }
}
