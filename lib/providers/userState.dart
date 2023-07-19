import 'package:app_desafio/models/user.dart';
import 'package:flutter/material.dart';

class UserState with ChangeNotifier {

  final BuildContext context;

  UserState(this.context);

  bool _isLoggedIn = false;
  String _perfil = '';
  String _account = '' ;

  bool get isLoggedIn => _isLoggedIn;
  String get perfil => _perfil;
  String get account => _account;

  void login(User user) {
    _isLoggedIn = true;
    _perfil = user.perfil;
    _account = user.account;
    notifyListeners();
  }

  void logout() {
    print("DESLOGADO");
    _isLoggedIn = false;
    _perfil = '';
    _account = '';
    notifyListeners();
  }
}