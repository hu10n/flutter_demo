import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


//全データ取得-----------------------------------------------------------------------------

//lambda関数：getAllData
//エラーが返ってくる場合、データベースのエラーのみなので、lambda側ではエラーハンドリングなし。
Future<Map<String,dynamic>> getAllDataGrobal() async {
  try{
    final response = await http.get(Uri.parse('https://c9sz8hr268.execute-api.ap-northeast-1.amazonaws.com/getAllData'));
    return json.decode(utf8.decode(response.bodyBytes)); //utf8デコードしないと日本語が文字化け
  }catch(e){
    print(e);
    throw Exception('Failed to load data from the server');
  }
}
//---------------------------------------------------------------------------------------
//更新データのみ取得------------------------------------------------------------------------

//lambda関数：TestConnectDB
//lambda側でエラーハンドリングなし。
//この関数がよばれる際にローカルDBの前回更新時間も更新されるため引数で渡した方が効率的
Future<Map<String,dynamic>> postJSONData(lastUpdated) async {
  final response = await http.post(
      Uri.parse('https://2kwgnatgue.execute-api.ap-northeast-1.amazonaws.com/testconnectDB'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 必要に応じてヘッダーを追加
        // 'Authorization': 'Bearer YOUR_API_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'last_updated': lastUpdated,
      }
    ),
  );
  if (response.statusCode == 200) {
    return json.decode(utf8.decode(response.bodyBytes));// as List<Map<String, dynamic>>;
  } else {
    print(response.body);
    print(response.statusCode);
    throw Exception('Failed to load data from the server');
  }
}
//---------------------------------------------------------------------------------------
//ステップの開始＆完了報告用----------------------------------------------------------------------------------

//lambda関数：submitStep
//開始報告と完了報告に１回づつしか呼ばれないことを前提としたロジック。
//入力フォームに記入がないと、そのカラムはnull値で更新される。
//マシンステータスが稼働中かつステップのステータスリストが一致しないとデータ不一致となる。
Future<int> updateStepData(update_status,step,status_list,machine_id) async {
  final prefs = await SharedPreferences.getInstance();
  final last_updated = prefs.getString('last_updated') ?? "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す

  try{
    final response = await http.post(
      Uri.parse('https://khsph63fwl.execute-api.ap-northeast-1.amazonaws.com/SubmitStep/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 必要に応じてヘッダーを追加
        // 'Authorization': 'Bearer YOUR_API_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'last_updated': last_updated,
        'update_status': update_status,
        'step_id': step['step_id'],
        'project_id': step['project_id'],
        'worker': step['worker'],
        'free_text': step['free_text'],
        'production_volume': step['production_volume'],
        'statusList': status_list,
        "machine_id": machine_id
      }),
    );

    //1:正常終了,2:ほぼデータベースエラー,3:データ不一致,4:labmdaの不具合
    return json.decode(response.body)["return_status"];
  }catch(e){
    print('Error occurred: $e');
    return -1; //エラーハンドリングの都合上、ステータスコードを返す。-1は暫定。
  }
}
//--------------------------------------------------------------------------------------------
//プロジェクト完了用-----------------------------------------------------------------------------

//lambda関数：CompleteProject
//マシンステータスが稼働中かつステップのステータスリストが全て１でないと不一致。リストの長さも一致する必要あり。
Future<int> completeProject(machine) async {
  final prefs = await SharedPreferences.getInstance();
  final last_updated = prefs.getString('last_updated') ?? "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す

  List status_list = [];

  for(var step in machine["project"][0]["step"]){
    status_list.add(step["project_status"]);
  }

  try{
    final response = await http.post(
      Uri.parse('https://aohgd352mg.execute-api.ap-northeast-1.amazonaws.com/completeProject/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 必要に応じてヘッダーを追加
        // 'Authorization': 'Bearer YOUR_API_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'last_updated': last_updated,
        'machine_id': machine["machine_id"],
        'machine_status': machine["machine_status"],
        'project_id': machine["project"][0]['project_id'],
        'statusList': status_list,
      }),
    );

    return json.decode(response.body)["return_status"];
  }catch(e){
    print('Error occurred: $e');
    return -1;
  }
}
//-----------------------------------------------------------------------------------------
//プロジェクト割り当て用-----------------------------------------------------------------------
//lambda関数：AssignProject
//マシンステータスが未稼働でないとデータ不一致。
Future<int> assignProjectInfo(machine,project) async {
  final prefs = await SharedPreferences.getInstance();
  final last_updated = prefs.getString('last_updated') ?? "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す

  try{
    final response = await http.post(
      Uri.parse('https://b7xglncdlj.execute-api.ap-northeast-1.amazonaws.com/AssignProjectFunc/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 必要に応じてヘッダーを追加
        // 'Authorization': 'Bearer YOUR_API_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'last_updated': last_updated,
        'machine_id': machine['machine_id'],
        'machine_status': machine['machine_status'],
        'client_name': project['client_name'],
        'product_name': project['product_name'],
        'product_num': project['product_num'],
        'material': project['material'],
        'lot_num': project['lot_num'],
        'production_volume': project['production_volume'],
        'supervisor': project['supervisor'],
        'step': project['step']
      }),
    );
    //print(response);
    return json.decode(response.body)["return_status"];
  }catch(e){
    print('Error occurred: $e');
    return -1;
  }
}
//-------------------------------------------------------------------------------
//作業機ステータス変更用-------------------------------------------------------------

//lambda関数：changeMachineStatus
//RDSとLDBでマシンステータスが一致してないとデータ不一致。
Future<int> changeMachineStatus(machine,status) async {
  final prefs = await SharedPreferences.getInstance();
  final last_updated = prefs.getString('last_updated') ?? "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す

  try{
    final response = await http.post(
      Uri.parse('https://btf2yqv7s4.execute-api.ap-northeast-1.amazonaws.com/changeMachineStatus/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 必要に応じてヘッダーを追加
        // 'Authorization': 'Bearer YOUR_API_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'last_updated': last_updated,
        'machine_id': machine['machine_id'],
        'machine_status': machine['machine_status'],
        'update_status': status
      }),
    );
    //print(response.body);
    return json.decode(response.body)["return_status"];
  }catch(e){
    print('Error occurred: $e');
    return -1;
  }
}
//--------------------------------------------------------------------------------------------