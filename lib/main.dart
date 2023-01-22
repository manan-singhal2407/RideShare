import 'package:btp/presentation/base/injectable.dart';
import 'package:btp/presentation/screen/auth/auth_page.dart';
import 'package:btp/presentation/screen/login/login_page.dart';
import 'package:btp/presentation/screen/login_verify/login_verify_page.dart';
import 'package:btp/presentation/screen/register/register_page.dart';
import 'package:btp/presentation/screen/splash/splash_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Sharing',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24.0,
          ),
        ),
      ),
      initialRoute: '/splash_screen',
      routes: <String, WidgetBuilder>{
        '/splash_screen': (context) => const SplashPage(),
        '/auth_screen': (context) => const AuthPage(),
        '/login_screen': (context) => const LoginPage(),
        '/register_screen': (context) => const RegisterPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/login_verify_screen') {
          final arguments = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return LoginVerifyPage(phoneNumber: arguments);
            },
          );
        }
        return null;
      },
    );
  }
}
