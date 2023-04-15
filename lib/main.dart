import 'package:btp/presentation/base/injectable.dart';
import 'package:btp/presentation/screen/booking/arguments/booking_screen_arguments.dart';
import 'package:btp/presentation/screen/booking/booking_page.dart';
import 'package:btp/presentation/screen/driver/driver_home/driver_home_page.dart';
import 'package:btp/presentation/screen/driver/driver_ride_request/driver_ride_request_page.dart';
import 'package:btp/presentation/screen/driver/driver_ride_request_detail/arguments/driver_ride_request_detail_screen_arguments.dart';
import 'package:btp/presentation/screen/driver/driver_ride_request_detail/driver_ride_request_detail_page.dart';
import 'package:btp/presentation/screen/driver/driver_settings/driver_settings_page.dart';
import 'package:btp/presentation/screen/home/home_page.dart';
import 'package:btp/presentation/screen/login/login_page.dart';
import 'package:btp/presentation/screen/search/arguments/search_screen_arguments.dart';
import 'package:btp/presentation/screen/search/search_page.dart';
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
      title: 'RideShare',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24.0,
          ),
        ),
      ),
      initialRoute: '/splash_screen',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/splash_screen': (context) => const SplashPage(),
        '/login_screen': (context) => const LoginPage(),
        '/rider/home_screen': (context) => const HomePage(),
        '/driver_home_screen': (context) => const DriverHomePage(),
        '/driver_settings_screen': (context) => const DriverSettingsPage(),
        '/driver_ride_request_screen': (context) => const DriverRideRequestPage(),
        '/driver_my_rides_screen': (context) => const DriverSettingsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/rider/search_screen') {
          final arguments = settings.arguments as SearchScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return SearchPage(
                type: arguments.type,
                latLng: arguments.latLng,
              );
            },
          );
        } else if (settings.name == '/rider/booking_screen') {
          final arguments = settings.arguments as BookingScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return BookingPage(
                pickupLatLng: arguments.pickupLatLng,
                destinationLatLng: arguments.destinationLatLng,
              );
            },
          );
        } else if (settings.name == '/driver_ride_request_detail_screen') {
          final arguments = settings.arguments as DriverRideRequestDetailScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return DriverRideRequestDetailPage(
                address: arguments.address,
                distance: arguments.distance,
                timeTaken: arguments.timeTaken,
                latLng: arguments.latLng,
                rides: arguments.rides,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
