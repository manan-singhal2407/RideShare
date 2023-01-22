import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'splash_view_model.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
      create: (context) => SplashViewModel(context),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 200,
              height: 200,
            ),
          );
        },
      ),
    );
  }
}
