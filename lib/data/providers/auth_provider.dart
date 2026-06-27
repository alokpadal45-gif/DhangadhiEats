import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  String get userRole => _user?.role ?? 'customer';

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    setLoading(true);
    setError(null);
    try {
      final response = await AuthService.login(
        phone: phone,
        password: password,
      );
      if (response['success'] == true) {
        final userData = response['user'];
        _user = UserModel(
          id: userData['id'],
          fullName: userData['full_name'],
          phone: userData['phone'],
          email: userData['email'],
          role: userData['role'],
          address: userData['address'],
          profileImage: userData['profile_image'],
          isActive: true,
          createdAt: DateTime.now(),
        );
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        setError(response['message']);
        return false;
      }
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> register(
    String fullName,
    String phone,
    String password,
    String role,
  ) async {
    setLoading(true);
    setError(null);
    try {
      final response = await AuthService.register(
        fullName: fullName,
        phone: phone,
        password: password,
        role: role,
      );
      if (response['success'] == true) {
        final userData = response['user'];
        _user = UserModel(
          id: userData['id'],
          fullName: userData['full_name'],
          phone: userData['phone'],
          email: userData['email'],
          role: userData['role'],
          address: userData['address'],
          isActive: true,
          createdAt: DateTime.now(),
        );
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        setError(response['message']);
        return false;
      }
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}