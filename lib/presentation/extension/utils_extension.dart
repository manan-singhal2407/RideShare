import 'dart:ui' as ui;

import 'package:btp/domain/enums/account_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as route;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/network/service/retrofit_service.dart';
import '../base/injectable.dart';
import 'google_maps_api_key.dart';

LatLng defaultLatLng = const LatLng(30.7333, 76.7794);

final RestClient _restClient = getIt<RestClient>();

Future<route.Route?> getRouteInWaypoints(
  LatLng pickupLatLng,
  LatLng destinationLatLng,
  List<route.Waypoint> waypoints,
  num? departureTime,
) async {
  route.GoogleMapsDirections directionsApi = route.GoogleMapsDirections(
    apiKey: googleMapsApiKey,
  );
  route.DirectionsResponse response =
      await directionsApi.directionsWithLocation(
    route.Location(lat: pickupLatLng.latitude, lng: pickupLatLng.longitude),
    route.Location(
        lat: destinationLatLng.latitude, lng: destinationLatLng.longitude),
    travelMode: route.TravelMode.driving,
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
  List<double> directionInfo = [1000000, 0];
  await _restClient
      .getDirectionData(
    '${pickupLatLng.latitude},${pickupLatLng.longitude}',
    '${destinationLatLng.latitude},${destinationLatLng.longitude}',
    googleMapsApiKey,
  )
      .then((value) {
    directionInfo[0] = value.routes[0].legs[0].distance.value.toDouble();
    directionInfo[1] = value.routes[0].legs[0].duration.value.toDouble();
  });
  return directionInfo;
}

Future<Polyline> getPolylineBetweenTwoPoints(
  LatLng pickupLatLng,
  LatLng destinationLatLng,
) async {
  List<LatLng> polylineCoordinates = [];
  List<dynamic> points = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleMapsApiKey,
    PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
    PointLatLng(destinationLatLng.latitude, destinationLatLng.longitude),
  );
  if (result.points.isNotEmpty) {
    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      points.add({'lat': point.latitude, 'lng': point.longitude});
    }
  }
  PolylineId id = const PolylineId('route');
  Polyline polyline = Polyline(
    polylineId: id,
    color: Colors.black54.withOpacity(0.7),
    points: polylineCoordinates,
    width: 4,
  );

  return polyline;
}

Future<String> getAddressFromLatLng(LatLng latLng) async {
  GeoData data = await Geocoder2.getDataFromCoordinates(
    latitude: latLng.latitude,
    longitude: latLng.longitude,
    googleMapApiKey: googleMapsApiKey,
  );
  return data.address;
}

Future<Uint8List> getUint8ListImages(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
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

void openHomeScreenAndClearStack(
  BuildContext context,
  AccountTypeEnum accountTypeEnum,
) {
  if (accountTypeEnum == AccountTypeEnum.driver) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/driver_home_screen', (r) => false);
  } else if (accountTypeEnum == AccountTypeEnum.user) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/rider_home_screen', (r) => false);
  }
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

String getSecToPastTimeFormattedNumber(int time) {
  Duration duration =
      Duration(seconds: (DateTime.now().millisecondsSinceEpoch - time) ~/ 1000);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  return hours == 0
      ? '$minutes min'
      : hours == 1
          ? '1 hour $minutes min'
          : '$hours hours $minutes min';
}
