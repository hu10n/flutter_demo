import 'package:flutter/material.dart';
import 'package:test/View/page/QRScanner/QRScannerPage.dart';

import 'MyIndexedStack.dart';
import 'MyAnimatedPositioned.dart';
import 'MyBottomNavigationBar.dart';
import 'View/page/MachineList/MachineListPage.dart';
import 'View/page/home/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool showBottomBar = true;

  final _pageKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //この行を追加
      body: Stack(
        children: [
          MyIndexedStack(
            currentIndex: _currentIndex,
            children: [
              _buildNavigatorPage(0),
              _buildNavigatorPage(1),
              _buildNavigatorPage(2),
            ],
          ),
          MyAnimatedPositioned(
            showBottomBar: showBottomBar,
            child: MyBottomNavigationBar(onTap: _onTap),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorPage(int index) {
    return Navigator(
      key: _pageKeys[index], // 新しいNavigatorキーを設定
      onGenerateRoute: (RouteSettings settings) {
        // indexに応じて異なるページを返す
        switch (index) {
          case 0:
            return MaterialPageRoute(
              builder: (context) => MachineListPage(
                onScrollDown: _hideBottomBar,
                onScrollUp: _showBottomBar,
              ),
            );
          case 1:
            return MaterialPageRoute(
              builder: (context) => QRScannerPage(
                  // onScrollDown: _hideBottomBar,
                  // onScrollUp: _showBottomBar,
                  ),
            );
          case 2:
            return MaterialPageRoute(
              builder: (context) => Placeholder(
                  // onScrollDown: _hideBottomBar,
                  // onScrollUp: _showBottomBar,
                  ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => PageWithCustomScroll(
                onScrollDown: _hideBottomBar,
                onScrollUp: _showBottomBar,
              ),
            );
        }
      },
    );
  }

  void _hideBottomBar() {
    setState(() {
      showBottomBar = false;
    });
  }

  void _showBottomBar() {
    setState(() {
      showBottomBar = true;
    });
  }

  void _onTap(int index) {
    if (index == _currentIndex) {
      _pageKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
