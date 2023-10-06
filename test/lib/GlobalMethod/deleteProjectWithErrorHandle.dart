import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/DataProvider.dart';
import 'package:test/GlobalWidget/ShowDialog.dart';


//更新動作＋エラーハンドリング
Future<void> deleteProjectWithErrorHandle(BuildContext context,String project_id) async {
  try {
    await Provider.of<DataNotifier>(context, listen: false).deleteProject(project_id);
  } catch (e) {
    print('Error occurred: $e');
    showDialogGeneral(context, "", "");
  }
}