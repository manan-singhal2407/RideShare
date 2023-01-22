import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:btp/presentation/theme/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();

  final BuildContext _context;

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  RegisterViewModel(this._context) {
    _countryController.text = '+91';
  }

  TextEditingController get countryController => _countryController;

  TextEditingController get phoneNumberController => _phoneNumberController;

  void onClickNextButton() async {
    if (_phoneNumberController.text.length != 10) {
      showScaffoldMessenger(_context, 'Invalid Number', errorStateColor);
    } else {
      Navigator.pushNamed(
        _context,
        '/login_verify_screen',
        arguments: _phoneNumberController.text,
      );
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }
}
