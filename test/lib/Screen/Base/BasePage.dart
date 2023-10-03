import 'package:flutter/material.dart';
import 'package:test/Screen/QRScanner/QRScannerPage.dart';
import 'package:test/Screen/StepSubmit/TestPage_Tab(2).dart';

import '../../BottomNavigation/BottNaviIndexStack.dart';
import '../../BottomNavigation/BottNaviWithRefleshBtn.dart';
import '../MachineList/MachineListPage.dart';
import '../../providers/NavigationData.dart';
import '../../GlobalWidget/LoadingModal.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // タブナビゲーション管理用------------------------------------
  int _currentIndex = 0;

  final _pageKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  //---------------------------------------------------------

  //ローディング管理用
  bool _isLoading = false;

  // ボトムナビゲーションのアニメ制御用----------------------------
  bool showBottomBar = true;
  int scrollValue = 0;
  //---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return NavigationData(
      //下流ツリーに提供
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
            //メイン画面--------------------------
            BottNaviIndexStack(
              currentIndex: _currentIndex,
              children: [
                _buildNavigatorPage(0),
                _buildNavigatorPage(1),
                _buildNavigatorPage(2),
              ],
            ),
            //-----------------------------------
            //ボトムナビゲーションバー＋更新ボタン-----
            BottNaviWithRefleshBtn(
              showBottomBar: showBottomBar,
              scrollValue: scrollValue,
              currentIndex: _currentIndex,
              setIsLoading: _setIsLoading,
              onTap: _onTap,
            ),
            //-----------------------------------
            //ローディング画面---
            if (_isLoading) LoadingModal()
            //----------------
          ],
        ),
      ),
    );
  }

  //ページ作成----------------------------------------------------
  Widget _buildNavigatorPage(int index) {
    return Navigator(
      key: _pageKeys[index], // 新しいNavigatorキーを設定
      onGenerateRoute: (RouteSettings settings) {
        // indexに応じて異なるページを返す
        switch (index) {
          case 0:
            return MaterialPageRoute(
              builder: (context) => MachineListPage(
                // 一覧ページ
                onScrollDown: _hideBottomBar,
                onScrollUp: _showBottomBar,
              ),
            );
          case 1:
            return MaterialPageRoute(
              builder: (context) => QRScannerPage(
                // QRスキャナー
                onScrollDown: _hideBottomBar,
                onScrollUp: _showBottomBar,
              ),
            );
          case 2:
            return MaterialPageRoute(
                builder: (context) => TestPage(
                      onScrollUp: _showBottomBar,
                      onScrollDown: _hideBottomBar,
                    ));
          default:
            return MaterialPageRoute(
              builder: (context) => MachineListPage(
                // 一覧ページ
                onScrollDown: _hideBottomBar,
                onScrollUp: _showBottomBar,
              ),
            );
        }
      },
    );
  }
  //-------------------------------------------------------------------

  //**utils-------------

  // ボトムナビゲーションのアニメーション制御---------------------------------
  void _hideBottomBar(int value) {
    setState(() {
      scrollValue = value;
      showBottomBar = false;
    });
  }

  void _showBottomBar(int value) {
    setState(() {
      scrollValue = value;
      showBottomBar = true;
    });
  }

  // ローディングアニメーション制御用----------------------------------------
  void _setIsLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  // タブ動作------------------------------------------------------------
  void _onTap(int index) {
    if (index == _currentIndex) {
      // 選択済みのタブ選択でルートに戻る
      _pageKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
