import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:m_app/src/features/storage/KStorage.dart';

import '../constant/api_ends_point.dart';

class ApiHelper {
  static final _storage = GetStorage();

  static Map<String, String> _headers() {
    final token = _storage.read(KStorageKey.accessToken);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic POST request
 /* static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: _headers(),
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      'data': data,
    };
  }*/
  static Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      'data': data,
    };
  }


  // Generic GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: _headers(),
    );

    final data = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      'data': data,
    };
  }

// Optional: PUT, DELETE methods can be added similarly
}
