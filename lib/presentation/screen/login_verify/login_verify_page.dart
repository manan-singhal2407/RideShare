import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

import '../../theme/widgets/app_button.dart';
import 'login_verify_view_model.dart';

class LoginVerifyPage extends StatefulWidget {
  final String phoneNumber;

  const LoginVerifyPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<LoginVerifyPage> createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginVerifyViewModel>(
      create: (context) => LoginVerifyViewModel(context),
      child: Consumer<LoginVerifyViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text('OTP'),
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    const Pinput(
                      length: 6,
                      showCursor: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryAppButton(
                      width: MediaQuery.of(context).size.width - 30,
                      text: 'Verify',
                      onPressed: () {},
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
