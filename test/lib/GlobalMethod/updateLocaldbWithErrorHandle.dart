import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalWidget/ShowDialog.dart';


//更新動作＋エラーハンドリング
Future<void> updateLocaldbWithErrorHandle(BuildContext context) async {
  try {
    await Provider.of<DataNotifier>(context, listen: false).updateLocalDB();
    //print("更新");
  } catch (e) {
    print('Error occurred: $e');
    showDialogGeneral(context, "エラー", "予期せぬエラーが発生しました。しばらくして、もう一度お試しください。");
  }
}