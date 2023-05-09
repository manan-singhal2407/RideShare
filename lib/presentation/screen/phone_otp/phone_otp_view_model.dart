import 'package:flutter/material.dart';

import '../../../data/network/model/users.dart';
import '../../../domain/enums/account_type_enum.dart';
import '../../../domain/enums/phone_auth_enum.dart';
import '../../../domain/repositories/i_phone_otp_repository.dart';
import '../../base/injectable.dart';
import '../../extension/utils_extension.dart';
import '../../theme/color.dart';
import '../../theme/widgets/loading.dart';

class PhoneOtpViewModel extends ChangeNotifier {
  final IPhoneOtpRepository _phoneOtpRepository = getIt<IPhoneOtpRepository>();

  final BuildContext _context;
  final String _name;
  final String _phoneNumber;
  final String _countryCode;
  final PhoneAuthEnum _phoneAuthEnum;
  final AccountTypeEnum _accountTypeEnum;

  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();

  String _verificationId = '';

  PhoneOtpViewModel(
    this._context,
    this._name,
    this._phoneNumber,
    this._countryCode,
    this._phoneAuthEnum,
    this._accountTypeEnum,
  ) {
    _sendOtpToEmailId();
  }

  TextEditingController get otpController1 => _otpController1;

  TextEditingController get otpController2 => _otpController2;

  TextEditingController get otpController3 => _otpController3;

  TextEditingController get otpController4 => _otpController4;

  TextEditingController get otpController5 => _otpController5;

  TextEditingController get otpController6 => _otpController6;

  void _sendOtpToEmailId() async {
    await _phoneOtpRepository.checkForAutoOtpVerification(
      '$_countryCode$_phoneNumber',
      (value) {
        _loginSuccessful();
      },
      (value) {
        Navigator.pop(_context);
        if (value.code == 'invalid-phone-number') {
          showScaffoldMessenger(
            _context,
            'Invalid Phone Number',
            errorStateColor,
          );
        } else {
          showScaffoldMessenger(
            _context,
            'Unexpected error',
            errorStateColor,
          );
        }
      },
      (value) {
        _verificationId = value;
      },
    );
  }

  void onNextButtonClick() async {
    showLoadingDialogBox(_context);
    await _phoneOtpRepository
        .checkForOtpVerification(
      _verificationId,
      '${_otpController1.text.trim()}${_otpController2.text.trim()}${_otpController3.text.trim()}${_otpController4.text.trim()}${_otpController5.text.trim()}${_otpController6.text.trim()}',
    )
        .then((value) {
      if (value.data != null) {
        _loginSuccessful();
      } else {
        Navigator.pop(_context);
        showScaffoldMessenger(
          _context,
          'Something went wrong',
          errorStateColor,
        );
      }
    }).onError((error, stackTrace) {
      Navigator.pop(_context);
      showScaffoldMessenger(
        _context,
        'Something went wrong',
        errorStateColor,
      );
    });
  }

  void _loginSuccessful() {
    if (_phoneAuthEnum == PhoneAuthEnum.login) {
      _setupLoginAccount();
    } else if (_phoneAuthEnum == PhoneAuthEnum.register) {
      _setupRegisterAccount();
    }
  }

  void _setupLoginAccount() async {
    await _phoneOtpRepository
        .settingUpLoginAccount(_accountTypeEnum == AccountTypeEnum.driver)
        .then((value) {
      Navigator.pop(_context);
      if (value.data != null) {
        openHomeScreenAndClearStack(_context, _accountTypeEnum);
      } else {
        showScaffoldMessenger(
          _context,
          'Something went wrong',
          errorStateColor,
        );
      }
    }).onError((error, stackTrace) {
      Navigator.pop(_context);
      showScaffoldMessenger(
        _context,
        'Something went wrong',
        errorStateColor,
      );
    });
  }

  void _setupRegisterAccount() async {
    Users users = Users(
      DateTime.now().millisecondsSinceEpoch,
      '',
      _phoneNumber,
      '$_countryCode $_phoneNumber',
      '',
      _name,
      '',
      'active',
      'user',
      0,
      0,
      0,
      0,
      900,
      40,
      true,
      '',
    );
    await _phoneOtpRepository.settingUpNewAccount(users).then((value) {
      Navigator.pop(_context);
      if (value.data != null) {
        openHomeScreenAndClearStack(_context, _accountTypeEnum);
      } else {
        showScaffoldMessenger(
          _context,
          'Something went wrong',
          errorStateColor,
        );
      }
    }).onError((error, stackTrace) {
      Navigator.pop(_context);
      showScaffoldMessenger(
        _context,
        'Something went wrong',
        errorStateColor,
      );
    });
  }
}
