import 'package:btp/data/cache/database/dao/users_dao.dart';
import 'package:btp/data/network/model/users.dart';
import 'package:btp/domain/extension/model_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';
import '../../extension/utils_extension.dart';
import '../../theme/color.dart';

// todo database updating everytime after login
// todo create separate repository for database work

class LoginViewModel extends ChangeNotifier {
  final UsersDao _usersDao = getIt<UsersDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  final BuildContext _context;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpCodeController = TextEditingController();

  bool _showOtpField = false;
  String? _verificationId;

  LoginViewModel(this._context) {
    _countryController.text = '+91';
  }

  TextEditingController get nameController => _nameController;

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
      await _firebaseAuth.signInWithCredential(credential).then((value) async {
        Users users = Users(
          DateTime.now().millisecondsSinceEpoch,
          '',
          _phoneNumberController.text.trim(),
          '+91 ${_phoneNumberController.text.trim()}',
          '',
          _nameController.text.trim(),
          _firebaseAuth.currentUser!.uid,
          'active',
          'user',
          0,
          0,
          0,
          0,
          900,
          40,
          true,
        );
        await _firebaseFirestore
            .collection('Users')
            .doc(_firebaseAuth.currentUser!.uid)
            .set(users.toJson())
            .then((value) async {
          await _usersDao.insertUsersEntity(convertUsersToUsersEntity(users)).then((value) {
            Navigator.pushNamedAndRemoveUntil(
              _context,
              '/rider/home_screen',
                  (r) => false,
            );
          });
        });
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
    await _firebaseAuth
        .signInWithCredential(authCredential)
        .then((value) async {
      Users users = Users(
        DateTime.now().millisecondsSinceEpoch,
        '',
        _phoneNumberController.text.trim(),
        '+91 ${_phoneNumberController.text.trim()}',
        '',
        _nameController.text.trim(),
        _firebaseAuth.currentUser!.uid,
        'active',
        'user',
        0,
        0,
        0,
        0,
        900,
        40,
        true,
      );
      await _firebaseFirestore
          .collection('Users')
          .doc(_firebaseAuth.currentUser!.uid)
          .set(users.toJson())
          .then((value)  async {
        await _usersDao.insertUsersEntity(convertUsersToUsersEntity(users)).then((value) {
          Navigator.pushNamedAndRemoveUntil(
            _context,
            '/rider/home_screen',
                (r) => false,
          );
        });
      });
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
