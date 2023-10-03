import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import '../../providers/DataClass.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // ローディング中の処理--------------------------------
    print("load start");
    await Future.delayed(Duration(milliseconds: 1000));
    await Provider.of<DataNotifier>(context, listen: false).loadFont(); //日本語フォントをロード
    await Provider.of<DataNotifier>(context, listen: false).getAllData(); //ローカルDBからproviderへデータ送信
    //-------------------------------------------------
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
