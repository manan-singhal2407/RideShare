import '../../../../domain/enums/account_type_enum.dart';
import '../../../../domain/enums/phone_auth_enum.dart';

class PhoneOtpScreenArguments {
  final String name;
  final String phoneNumber;
  final String countryCode;
  final PhoneAuthEnum phoneAuthEnum;
  final AccountTypeEnum accountTypeEnum;

  PhoneOtpScreenArguments(
    this.name,
    this.phoneNumber,
    this.countryCode,
    this.phoneAuthEnum,
    this.accountTypeEnum,
  );
}
