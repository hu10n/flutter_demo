import 'package:http/http.dart' as http;
import 'dart:convert';


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



Object structuredData(List records) {
  var data = {};
  for (var row in records) {
    String machine_id = row['machine_id']!;
    String project_id = row['project_id']!;
    String step_id = row['step_id']!;

    if (!data.containsKey(machine_id)) {
      data[machine_id] = {"machine_id": machine_id, "machine_status":row["machine_status"], "projects": {}};
    }

    if (!data[machine_id]['projects'].containsKey(project_id)) {
      data[machine_id]['projects'][project_id] = {
        "project_id": project_id, 
        "created_at": row["created_at"],
        "project_status": row["project_status"],
        "client_name": row["client_name"],
        "product_name": row["product_name"],
        "product_num": row["product_num"],
        "material": row["material"],
        "lot_num": row["lot_num"],
        "supervisor": row["supervisor"],
        "steps": {}
        };
    }

    data[machine_id]['projects'][project_id]['steps'][step_id] = {
      "step_id": step_id,
      "finished_at": row["finished_at"],
      "project_status": row["project_status"],
      "worker": row["worker"],
      "free_text": row["free_text"],
      "step_num": row["step_num"],
      };
  }

  print(jsonEncode(data));
  return jsonEncode(data);
}
