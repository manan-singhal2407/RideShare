import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';
import '../../extension/utils_extension.dart';
import '../../theme/color.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();

  final BuildContext _context;

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpCodeController = TextEditingController();

  bool _showOtpField = false;
  String? _verificationId;

  LoginViewModel(this._context) {
    _countryController.text = '+91';
  }

  TextEditingController get countryController => _countryController;

  TextEditingController get phoneNumberController => _phoneNumberController;

  TextEditingController get otpCodeController => _otpCodeController;

  bool get showOtpField => _showOtpField;

  void onClickNextButton() async {
    if (_showOtpField) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpCodeController.text,
      );
      await _firebaseAuth.signInWithCredential(credential).then((value) {
        showScaffoldMessenger(_context, 'Verified', successStateColor);
      });
    } else {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout,
      );
    }
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    await _firebaseAuth.signInWithCredential(authCredential).then((value) {
      showScaffoldMessenger(_context, 'Verified', successStateColor);
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showScaffoldMessenger(_context, 'Invalid Number', errorStateColor);
    } else {
      showScaffoldMessenger(_context, 'Unexpected error', errorStateColor);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    _verificationId = verificationId;
    _showOtpField = true;
    notifyListeners();
  }

  _onCodeTimeout(String timeout) {
    return null;
  }
}
