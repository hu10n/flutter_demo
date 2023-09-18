import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/View/page/QRScanner/QRScannerPage.dart';

import 'MyIndexedStack.dart';
import 'MyAnimatedPositioned.dart';
import 'MyBottomNavigationBar.dart';
import 'View/page/MachineList/MachineListPage.dart';
import 'View/page/home/HomePage.dart';
import 'DataClass.dart';
import 'NavigationData.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // タブナビゲーション管理用------------------------------------
  int _currentIndex = 0; 

  final _pageKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  //---------------------------------------------------------

  bool showBottomBar = true; // ボトムナビゲーションのアニメ制御用

  @override
  Widget build(BuildContext context) {
    return NavigationData(
      currentIndex: _currentIndex,
      pageKeys: _pageKeys,
      onTabChange: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // キーパッド表示時のレイアウト制御
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // ここで高さを設定
          child: AppBar(
            elevation: 0, // AppBarの影の濃さ
          ),
        ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min, // 最小限のサイズを取るように設定
                children: [
                  if (_currentIndex == 0) // currentIndexが2でない場合のみウィジェットを表示
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // 更新ボタンのアクションを記述
                          },
                          child: Icon(Icons.refresh),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            fixedSize: Size(50, 50),
                            padding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ),
                  MyBottomNavigationBar(onTap: _onTap, selectedIndex:_currentIndex),
                ],
              ),
            ),
          ],
        ),
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
              builder: (context) => MachineListPage( // 一覧ページ
                onScrollDown: _hideBottomBar,
                onScrollUp: _showBottomBar,
              ),
            );
          case 1:
            return MaterialPageRoute(
              builder: (context) => QRScannerPage( // QRスキャナー
                  // onScrollDown: _hideBottomBar,
                  // onScrollUp: _showBottomBar,
                  ),
            );
          case 2:
            return MaterialPageRoute(
              builder: (context) => Placeholder( // 未実装
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

  // ボトムナビゲーションのアニメーション制御---------------------------------
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
  // ------------------------------------------------------------------

  // タブ動作-----------------------------------------------------------
  void _onTap(int index) {
    if (index == _currentIndex) { // 選択済みのタブ選択でルートに戻る
      _pageKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
