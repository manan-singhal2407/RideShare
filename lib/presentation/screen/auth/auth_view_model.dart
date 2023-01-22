import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';

class AuthViewModel extends ChangeNotifier {
  final BuildContext _context;

  AuthViewModel(this._context);

  void onLoginButtonClicked() {
    Navigator.pushNamed(_context, '/login_screen');
  }

  void onRegisterButtonClicked() {
    Navigator.pushNamed(_context, '/register_screen');
  }
}
