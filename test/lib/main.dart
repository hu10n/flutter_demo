import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'InitialLoadingPage.dart';
import 'DataClass.dart';


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
      theme: ThemeData(
        // useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
      ),
      //home: MyHomePage(),
      home: SplashScreen(),
    );
  }
}