import 'package:btp/data/network/service/retrofit_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as route;
import 'package:google_maps_webservice/directions.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String googleMapsApiKey = 'AIzaSyDschydseXpu7lOGtBorLzIzWl-rEr2a24';

Future<route.Route?> getRouteInWaypoints(
  LatLng pickupLatLng,
  LatLng destinationLatLng,
  List<Waypoint> waypoints,
  num? departureTime,
) async {
  GoogleMapsDirections directionsApi = GoogleMapsDirections(
    apiKey: googleMapsApiKey,
  );
  DirectionsResponse response = await directionsApi.directionsWithLocation(
    Location(lat: pickupLatLng.latitude, lng: pickupLatLng.longitude),
    Location(lat: destinationLatLng.latitude, lng: destinationLatLng.longitude),
    travelMode: TravelMode.driving,
    departureTime: departureTime ?? 'now',
    waypoints: waypoints,
  );
  if (response.isOkay) {
    return response.routes[0];
  }
  return null;
}

Future<List<double>> getDistanceAndTimeBetweenSourceAndDestination(
  LatLng pickupLatLng,
  LatLng destinationLatLng,
) async {
  await RestClient(Dio()).getDirectionData(
    '${pickupLatLng.latitude},${pickupLatLng.longitude}',
    '${destinationLatLng.latitude},${destinationLatLng.longitude}',
    googleMapsApiKey,
  ).then((value) {
    return [
      value.routes[0].legs[0].distance.value.toDouble(),
      value.routes[0].legs[0].duration.value.toDouble(),
    ];
  });
  return [100000, 0];
}

void showScaffoldMessenger(
  BuildContext context,
  String text,
  Color backgroundColor,
) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    ),
  );
}

void redirectUserToEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: '2019csb1099@iitrpr.ac.in',
  );
  await launchUrl(emailUri);
}

String getCurrencyFormattedNumber(double value) {
  return NumberFormat.currency(
    symbol: '\u{20B9}',
    locale: 'HI',
    decimalDigits: 0,
  ).format(value);
}

String getNonCurrencyFormattedNumber(double value) {
  return NumberFormat.currency(
    symbol: '',
    locale: 'HI',
    decimalDigits: 0,
  ).format(value);
}

String getMToKmFormattedNumber(double value) {
  return (value / 1000).toStringAsFixed(1);
}

String getSecToTimeFormattedNumber(int seconds) {
  Duration duration = Duration(seconds: seconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  return hours == 0
      ? '$minutes min'
      : hours == 1
          ? '1 hour $minutes min'
          : '$hours hours $minutes min';
}
