import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/widgets/app_button.dart';
import 'auth_view_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(context),
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryAppButton(
                  text: 'Login',
                  onPressed: viewModel.onLoginButtonClicked,
                ),
                const SizedBox(
                  height: 20,
                ),
                PrimaryAppButton(
                  text: 'Register',
                  onPressed: viewModel.onRegisterButtonClicked,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
