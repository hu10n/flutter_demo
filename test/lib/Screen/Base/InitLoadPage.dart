import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'BasePage.dart';
import 'package:test/providers/DataProvider.dart';

class InitLoadSplashScreen extends StatefulWidget {
  @override
  _InitLoadSplashScreenState createState() => _InitLoadSplashScreenState();
}

class _InitLoadSplashScreenState extends State<InitLoadSplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // ローディング中の処理--------------------------------
    print("load start");
    await Future.delayed(Duration(milliseconds: 1000));
    
    final datanotifier = Provider.of<DataNotifier>(context, listen: false);
    await datanotifier.loadFont(); //日本語フォントをロード
    await datanotifier.getAllData(); //ローカルDBからproviderへデータ送信
    //-------------------------------------------------
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BasePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff02A676))),
      ),
    );
  }
}
