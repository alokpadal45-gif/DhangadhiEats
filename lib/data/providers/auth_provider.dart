import 'package:flutter/material.dart';
import '../models/user_model.dart';

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
      await Future.delayed(const Duration(seconds: 2));
      _user = UserModel(
        id: '1',
        fullName: 'Alok Padal',
        phone: phone,
        role: 'customer',
        isActive: true,
        createdAt: DateTime.now(),
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> register(String fullName, String phone, String password, String role) async {
    setLoading(true);
    setError(null);
    try {
      await Future.delayed(const Duration(seconds: 2));
      _user = UserModel(
        id: '1',
        fullName: fullName,
        phone: phone,
        role: role,
        isActive: true,
        createdAt: DateTime.now(),
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}