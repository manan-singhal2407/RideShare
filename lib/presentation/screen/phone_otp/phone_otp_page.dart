import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../domain/enums/account_type_enum.dart';
import '../../../domain/enums/phone_auth_enum.dart';
import '../../theme/color.dart';
import '../../theme/widgets/onboarding_button.dart';
import '../../theme/widgets/text_input_field.dart';
import 'phone_otp_view_model.dart';

class PhoneOtpPage extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String countryCode;
  final PhoneAuthEnum phoneAuthEnum;
  final AccountTypeEnum accountTypeEnum;

  const PhoneOtpPage({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.phoneAuthEnum,
    required this.accountTypeEnum,
  });

  @override
  State<PhoneOtpPage> createState() => _PhoneOtpPageState();
}

class _PhoneOtpPageState extends State<PhoneOtpPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhoneOtpViewModel>(
      create: (context) => PhoneOtpViewModel(
        context,
        widget.name,
        widget.phoneNumber,
        widget.countryCode,
        widget.phoneAuthEnum,
        widget.accountTypeEnum,
      ),
      child: Consumer<PhoneOtpViewModel>(
        builder: (context, viewModel, child) {
          var screenWidth = MediaQuery.of(context).size.width;
          var sizedBoxWidth = screenWidth - 64;
          return Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: 200,
                      bottom: 52,
                      left: 24,
                      right: 40,
                      child: SizedBox(
                        width: sizedBoxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter OTP',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 28,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Enter the 6-digit code sent to',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              '${widget.countryCode} ${widget.phoneNumber}',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OtpTextField(
                                  textEditingController:
                                  viewModel.otpController1,
                                  onChangedText: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                OtpTextField(
                                  textEditingController:
                                  viewModel.otpController2,
                                  onChangedText: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                OtpTextField(
                                  textEditingController:
                                  viewModel.otpController3,
                                  onChangedText: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                OtpTextField(
                                  textEditingController:
                                  viewModel.otpController4,
                                  onChangedText: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                OtpTextField(
                                  textEditingController:
                                  viewModel.otpController5,
                                  onChangedText: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                                OtpTextField(
                                  textEditingController:
                                      viewModel.otpController6,
                                  onChangedText: (value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 72,
                            ),
                            OnboardingButton(
                              onButtonClicked: viewModel.onNextButtonClick,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OtpTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueSetter<String> onChangedText;

  const OtpTextField({
    super.key,
    required this.textEditingController,
    required this.onChangedText,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var sizedBoxWidth = screenWidth - 64;
    var otpWidth = min(64.0, sizedBoxWidth / 7);
    return SizedBox(
      width: otpWidth,
      child: TextInputField(
        textEditingController: textEditingController,
        onChangedText: onChangedText,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
