import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './viewmodels/HomeViewModel.dart';
import './pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Home(),
      ),
    );
  }
}
