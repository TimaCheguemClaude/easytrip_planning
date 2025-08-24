import 'dart:convert';
import 'package:easytrip/data/model/mainuser.dart';
import 'package:easytrip/data/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Loginserver {
  final String baseUrl = "http://173.249.8.175:12010/api";

  Future<Map<String, dynamic>> loginUser(User user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": user.email,
        "password": user.password,
        "remember_me": false,
      }),
    );
    final data = handleResponse(response);
    await saveAccessToken(data['data']['token']);
    return data;
  }

  Future<Map<String, dynamic>> logoutuser() async {
    final token = await getAccessToken();
    final response = await http.get(
      Uri.parse("$baseUrl/auth/logout"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final data = handleResponse(response);
    await clearAccessToken();
    return data;
  }

  Future<Map<String, dynamic>> registerUser(Character character) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user/store"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(character.toMap()),
      );

      final responseData = handleResponse(response);

      if (responseData['token'] != null) {
        await saveAccessToken(responseData['token']);
      }

      return responseData;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> activateAccount(int userId, String code) async {
    try {
      final requestBody = {"user_id": userId, "code": code};
      print('Activation request: $requestBody');

      final token = await getAccessToken();

      final response = await http.post(
        Uri.parse("$baseUrl/user/activate"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('Activation response status: ${response.statusCode}');
      print('Activation response body: ${response.body}');

      if (response.statusCode == 401) {
        throw Exception(
          'Authentication required. Please ensure you have a valid token.',
        );
      }

      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}');
      }

      final responseData = jsonDecode(response.body);
      if (!responseData['success']) {
        throw Exception(responseData['msg'] ?? 'Activation failed');
      }

      return responseData;
    } catch (e) {
      print('Activation error: $e');
      throw Exception('Activation failed: ${e.toString()}');
    }
  }

  // Utility methods
  Map<String, dynamic> handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (responseData['success'] == true) {
      return responseData;
    } else {
      final errorMessage = responseData['msg'] ?? "Tima Cheguem Claude";
      throw Exception(errorMessage);
    }
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
