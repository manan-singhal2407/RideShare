import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/widgets/app_button.dart';
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
            appBar: AppBar(
              title: const Text(
                'Remove App Bar',
              ),
            ),
            body: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Phone Verification",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "We need to register your phone without getting started!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: viewModel.nameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: viewModel.countryController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 33, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: viewModel.phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    if (viewModel.showOtpField) ...[
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: viewModel.otpCodeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "OTP",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                    PrimaryAppButton(
                      width: MediaQuery.of(context).size.width - 30,
                      text: viewModel.showOtpField ? 'Verify' : 'Next',
                      onPressed: viewModel.onClickNextButton,
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
