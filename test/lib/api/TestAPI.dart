import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


Future<String?> fetchData() async {
  try {
    final response = await http.get(Uri.parse('https://2kwgnatgue.execute-api.ap-northeast-1.amazonaws.com/testconnectDB'));

    if (response.statusCode == 200) {
      print(response.body[0]);
      return response.body;
    } else {
      return 'データの取得に失敗しました';
    }
  } catch (error) {
    return 'エラー: $error';
  }
}

Future<List<dynamic>> fetchJSONData() async {
  final response = await http.get(Uri.parse('https://2kwgnatgue.execute-api.ap-northeast-1.amazonaws.com/testconnectDB'));

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    //print(json.decode(utf8.decode(response.bodyBytes)));
    
    return json.decode(utf8.decode(response.bodyBytes));// as List<Map<String, dynamic>>;
  } else {
    // If server did not return a 200 OK response,
    // throw an exception.
    throw Exception('Failed to load data from the server');
  }
}

Future<Map<String,dynamic>> postJSONData(lastUpdated) async {
  final response = await http.post(
      Uri.parse('https://2kwgnatgue.execute-api.ap-northeast-1.amazonaws.com/testconnectDB'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 必要に応じてヘッダーを追加
        // 'Authorization': 'Bearer YOUR_API_TOKEN',
      },
      body: jsonEncode(<String, dynamic>{
        'last_updated': lastUpdated,
      }),
    );

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    //print(json.decode(utf8.decode(response.bodyBytes)));
    
    return json.decode(utf8.decode(response.bodyBytes));// as List<Map<String, dynamic>>;
  } else {
    // If server did not return a 200 OK response,
    // throw an exception.
    print(response.body);
    print(response.statusCode);
    throw Exception('Failed to load data from the server');
  }
}

Future<Map<String,dynamic>> updateStepData(update_status,step,status_list) async {
  final prefs = await SharedPreferences.getInstance();
  final last_updated = prefs.getString('last_updated') ?? "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す

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
        'statusList': status_list
      }),
    );

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    print(json.decode(utf8.decode(response.bodyBytes))["return_status"]);
    
    return json.decode(utf8.decode(response.bodyBytes));// as List<Map<String, dynamic>>;
  } else {
    // If server did not return a 200 OK response,
    // throw an exception.
    print(response.body);
    print(response.statusCode);
    throw Exception('Failed to load data from the server');
  }
}

Future<Map<String,dynamic>> assignProjectInfo(machine,project) async {
  final prefs = await SharedPreferences.getInstance();
  final last_updated = prefs.getString('last_updated') ?? "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す

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
        'supervisor': project['supervisor'],
        'step': project['step']
      }),
    );

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    print(json.decode(utf8.decode(response.bodyBytes))["return_status"]);
    
    return json.decode(utf8.decode(response.bodyBytes));// as List<Map<String, dynamic>>;
  } else {
    // If server did not return a 200 OK response,
    // throw an exception.
    print(response.body);
    print(response.statusCode);
    throw Exception('Failed to load data from the server');
  }
}

