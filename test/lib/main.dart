import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/pages/StepListPage.dart';

import './viewmodels/HomeViewModel.dart';
import './pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        // StepListのテスト中 0719 -------------
        child: StepListPage(
          machineNumber: 'A-2',
        ),
        // -----------------------------------
      ),
    );
  }
}
