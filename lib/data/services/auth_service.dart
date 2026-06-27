import 'api_service.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
    String? email,
    String? address,
  }) async {
    final response = await ApiService.post('/auth/register', {
      'full_name': fullName,
      'phone': phone,
      'password': password,
      'role': role,
      'email': email,
      'address': address,
    });

    if (response['success'] == true) {
      await ApiService.saveToken(response['token']);
    }

    return response;
  }

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await ApiService.post('/auth/login', {
      'phone': phone,
      'password': password,
    });

    if (response['success'] == true) {
      await ApiService.saveToken(response['token']);
    }

    return response;
  }

  static Future<Map<String, dynamic>> getMe() async {
    return await ApiService.get('/auth/me', auth: true);
  }

  static Future<void> logout() async {
    await ApiService.removeToken();
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
    String? address,
  }) async {
    return await ApiService.put('/auth/profile', {
      'full_name': fullName,
      'email': email,
      'address': address,
    }, auth: true);
  }
}