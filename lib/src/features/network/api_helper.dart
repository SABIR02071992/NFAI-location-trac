import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constant/api_ends_point.dart';
import '../storage/KStorage.dart';

class ApiHelper {
  static final _storage = GetStorage();

  static Map<String, String> _headers() {
    final token = _storage.read(KStorageKey.accessToken);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(ApiEndpoints.baseUrl + endpoint);

    print('🌍 POST → $uri');
    print('📦 BODY → $body');

    final response = await http.post(
      uri,
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    );

    print('📥 STATUS → ${response.statusCode}');
    print(
      '📥 RAW BODY → ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
    );

    // 🚨 NOT JSON → THROW CLEAN ERROR
    if (!response.headers['content-type']!.contains('application/json')) {
      throw Exception(
        'Server returned non-JSON response (status ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);

    return {'statusCode': response.statusCode, 'data': decoded};
  }
}
