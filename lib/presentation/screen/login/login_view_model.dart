import 'package:flutter/material.dart';

import '../../../domain/enums/account_type_enum.dart';
import '../../../domain/enums/phone_auth_enum.dart';
import '../../../domain/repositories/i_login_repository.dart';
import '../../base/injectable.dart';
import '../../extension/utils_extension.dart';
import '../../theme/color.dart';
import '../phone_otp/arguments/phone_otp_screen_arguments.dart';

class LoginViewModel extends ChangeNotifier {
  final ILoginRepository _loginRepository = getIt<ILoginRepository>();

  final BuildContext _context;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _showInvalidNameMessage = false;
  bool _showInvalidPhoneNumber = false;
  final String _countryCode = '+91';

  LoginViewModel(this._context);

  TextEditingController get nameController => _nameController;

  TextEditingController get phoneNumberController => _phoneNumberController;

  bool get showInvalidNameMessage => _showInvalidNameMessage;

  bool get showInvalidPhoneNumber => _showInvalidPhoneNumber;

  String get countryCode => _countryCode;

  void onNextButtonClick() async {
    if (_nameController.text.trim().isEmpty) {
      _showInvalidNameMessage = true;
    } else {
      _showInvalidNameMessage = false;
    }
    if (_phoneNumberController.text.trim().length < 9) {
      _showInvalidPhoneNumber = true;
    } else {
      _showInvalidPhoneNumber = false;
    }
    notifyListeners();

    if (!_showInvalidNameMessage && !_showInvalidPhoneNumber) {
      String phone = '$_countryCode ${_phoneNumberController.text.trim()}';
      await _loginRepository
          .checkIfPhoneNumberAccountExists(phone)
          .then((value) {
        if (value.data != null) {
          Navigator.pushNamed(
            _context,
            '/phone_otp_screen',
            arguments: PhoneOtpScreenArguments(
              _nameController.text.trim(),
              _phoneNumberController.text.trim(),
              _countryCode,
              value.data[0] as PhoneAuthEnum,
              value.data[1] as AccountTypeEnum,
            ),
          ).then((value) {
            FocusManager.instance.primaryFocus?.unfocus();
          });
        } else {
          showScaffoldMessenger(
            _context,
            'Something Went Wrong',
            errorStateColor,
          );
        }
      }).onError((error, stackTrace) {
        showScaffoldMessenger(
          _context,
          'Something Went Wrong',
          errorStateColor,
        );
      });
    }
  }
}
