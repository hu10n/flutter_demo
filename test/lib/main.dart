import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './viewmodels/HomeViewModel.dart';
import './wigets/app_bar.dart';
import './wigets/home_body.dart';
import './wigets/custom_bottom_navigation_bar.dart';

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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), //CustomAppBar
      body: HomeBody(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}


