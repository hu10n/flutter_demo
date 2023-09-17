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

Future<Map<String, dynamic>> fetchJSONData() async {
  final response = await http.get(Uri.parse('https://2kwgnatgue.execute-api.ap-northeast-1.amazonaws.com/testconnectDB'));

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    print(json.decode(utf8.decode(response.bodyBytes))[0]);
    return json.decode(response.body);
  } else {
    // If server did not return a 200 OK response,
    // throw an exception.
    throw Exception('Failed to load data from the server');
  }
}