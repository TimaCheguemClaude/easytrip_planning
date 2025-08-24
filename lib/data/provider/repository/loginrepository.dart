import 'package:easytrip/data/model/mainuser.dart';
import 'package:easytrip/data/provider/server/loginserver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';

class LoginRepository {
  final Loginserver loginserver;

  LoginRepository({required this.loginserver});

  // Login Functionality
  Future<Map<String, dynamic>> loginUser(User user) async {
    try {
      final response = await loginserver.loginUser(user);

      // First, validate basic response structure
      if (response == null) {
        throw Exception('No response from server');
      }

      // Create a standardized response structure
      Map<String, dynamic> standardResponse = {
        "data": {},
        "success": response['success'] ?? false,
        "msg": response['msg'] ?? 'Unknown response',
      };

      // Handle the data field separately
      if (response['data'] != null) {
        // For unactivated accounts, the structure might be different
        if (response['data']['user'] != null) {
          final userData = response['data']['user'];
          print('Raw login response: $response');
          // Check for activation status
          final isActivated = userData['activated'] == 1;

          // Only try to get token if account is activated
          if (isActivated && response['data']['token'] != null) {
            final accessToken = response['data']['token'] as String;
            if (accessToken.isNotEmpty) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', accessToken);
            }
          }

          // Store user ID regardless of activation status
          if (userData['id'] != null) {
            final userId = userData['id'] as int;
            await UserDataManager.saveUserId(userId);
          }

          // Include the full data in the response
          standardResponse['data'] = response['data'];
        }
      }

      return standardResponse;
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login process failed: ${e.toString()}');
    }
  }

  // Logout Functionality
  Future<Map<String, dynamic>> logoutuser() async {
    try {
      final response = await loginserver.logoutuser();

      // Validate response
      if (response == null) {
        throw Exception('No response from server');
      }

      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await UserDataManager.clearUserData();

      return {
        "data": response['data'] ?? {},
        "success": response['success'] ?? false,
        "msg": response['msg'] ?? 'Logout successful',
      };
    } catch (e) {
      print('Logout error: $e');
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // Registration Functionality
  Future<Map<String, dynamic>> registerUser(Character character) async {
    try {
      final response = await loginserver.registerUser(character);

      // Validate response
      if (response == null) {
        throw Exception('No response from server');
      }

      return {
        "data": response['data'] ?? {},
        "success": response['success'] ?? false,
        "msg": response['msg'] ?? 'Registration status unknown',
      };
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Account Activation Functionality
  Future<Map<String, dynamic>> activateAccount(int userId, String code) async {
    try {
      print('Attempting to activate account for user $userId with code $code');
      final response = await loginserver.activateAccount(userId, code);

      // Validate response
      if (response == null) {
        throw Exception('No response from server');
      }

      // Check for explicit failure
      if (response['success'] == false) {
        throw Exception(response['msg'] ?? 'Activation failed');
      }

      return {
        "data": response['data'] ?? {},
        "success": response['success'] ?? false,
        "msg": response['msg'] ?? 'Activation status unknown',
      };
    } catch (e) {
      print('Account activation error: $e');
      throw Exception('Account activation failed: ${e.toString()}');
    }
  }
}

class UserDataManager {
  static const String _userIdKey = 'user_id';
  static const String _tokenKey = 'token';

  static Future<void> saveUserId(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userIdKey, userId);
    } catch (e) {
      print('Error saving user ID: $e');
      throw Exception('Failed to save user data');
    }
  }

  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userIdKey);
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error clearing user data: $e');
      throw Exception('Failed to clear user data');
    }
  }
}
