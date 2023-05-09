import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../theme/color.dart';
import '../../theme/widgets/onboarding_button.dart';
import '../../theme/widgets/text_input_field.dart';
import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (context) => LoginViewModel(context),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: 150,
                      bottom: 52,
                      left: 24,
                      right: 24,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hi \u{1f44b}',
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
                              'Join now to start booking affordable\nrides today!',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Text(
                              'Full Name',
                              style: GoogleFonts.redHatDisplay(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: primaryTextColor,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            TextInputField(
                              textEditingController: viewModel.nameController,
                              keyboardType: TextInputType.name,
                              hintText: 'Your Name',
                              errorText: viewModel.showInvalidNameMessage
                                  ? 'Required field'
                                  : '',
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Mobile Number',
                              style: GoogleFonts.redHatDisplay(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: primaryTextColor,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            TextInputField(
                              textEditingController:
                                  viewModel.phoneNumberController,
                              keyboardType: TextInputType.phone,
                              hintText: '9999999999',
                              showCountryCode: true,
                              countryCode: viewModel.countryCode,
                              errorText: viewModel.showInvalidPhoneNumber
                                  ? 'Invalid phone number'
                                  : '',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(
                              height: 20,
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
