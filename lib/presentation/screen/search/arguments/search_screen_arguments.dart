import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchScreenArguments {
  final String type;
  final LatLng latLng;

  SearchScreenArguments(
      this.type,
      this.latLng,
  );
}
