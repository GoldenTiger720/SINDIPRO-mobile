import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAuthenticated = await _authService.isAuthenticated();
      if (_isAuthenticated) {
        _user = await _authService.getCurrentUser();
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginResponse = await _authService.login(email, password);
      if (loginResponse != null) {
        _user = loginResponse.user;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String username, String email, String password, String confirmPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final registerResponse = await _authService.register(username, email, password, confirmPassword);
      if (registerResponse != null) {
        _user = registerResponse.user;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  bool canAccessCondominium(String condominium) {
    if (_user == null) return false;
    
    // Managers can access any condominium
    if (_user!.isManager) return true;
    
    // Caretakers can only access their assigned condominium
    if (_user!.isCaretaker) {
      return _user!.condominium == condominium;
    }
    
    return false;
  }

  List<String> getAccessibleCondominiums() {
    if (_user == null) return [];
    
    // Managers can access all condominiums (this would typically come from API)
    if (_user!.isManager) {
      return [
        'Edifício Central',
        'Residencial Park',
        'Torre Sul',
        'Condomínio Vista',
      ];
    }
    
    // Caretakers can only access their assigned condominium
    if (_user!.isCaretaker && _user!.condominium != null) {
      return [_user!.condominium!];
    }
    
    return [];
  }
}