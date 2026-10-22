import 'package:flutter/foundation.dart';

/// Simple in-memory auth service with ChangeNotifier for go_router refreshListenable.
class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _name = '';
  String _cardNumber = '';

  bool get isLoggedIn => _isLoggedIn;
  String get name => _name;
  String get cardNumber => _cardNumber;

  void login({String name = 'Студент', String cardNumber = 'KB-001'}) {
    _isLoggedIn = true;
    _name = name;
    _cardNumber = cardNumber;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _name = '';
    _cardNumber = '';
    notifyListeners();
  }

  void updateProfile(String name, String cardNumber) {
    _name = name;
    _cardNumber = cardNumber;
    notifyListeners();
  }
}

/// Global instance used by the router and screens.
final authService = AuthService();
