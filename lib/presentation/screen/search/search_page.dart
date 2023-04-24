import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:btp/presentation/screen/booking/arguments/booking_screen_arguments.dart';
import 'package:btp/presentation/screen/rider/rider_booking/arguments/rider_booking_screen_arguments.dart';
import 'package:btp/presentation/screen/rider/rider_booking/rider_booking_page.dart';
import 'package:btp/presentation/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import 'search_view_model.dart';

class SearchPage extends StatefulWidget {
  final String type;
  final LatLng latLng;

  const SearchPage({
    super.key,
    required this.type,
    required this.latLng,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (context) => SearchViewModel(context),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: shimmerHighlightColor,
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: TextField(
                controller: viewModel.searchQueryController,
                decoration: InputDecoration(
                  hintText: 'Search ${widget.type} location',
                  hintStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  labelStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  fillColor: shimmerHighlightColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                cursorColor: Colors.black,
              ),
            ),
            body: viewModel.searchQueryController.text.isEmpty
                ? Container()
                : viewModel.searchQueryController.text.length < 3
                    ? Container(
                        margin: const EdgeInsets.all(8),
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Please enter minimum 3 letters to search',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.searchedPredictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(viewModel
                                .searchedPredictions[index].description
                                .toString()),
                            onTap: () async {
                              if (widget.type == 'destination') {
                                GoogleMapsPlaces googleMapsPlaces =
                                GoogleMapsPlaces(
                                  apiKey: googleMapsApiKey,
                                );
                                PlacesDetailsResponse details =
                                    await googleMapsPlaces
                                    .getDetailsByPlaceId(
                                      viewModel.searchedPredictions[index].placeId!,
                                );
                                LatLng latLng = LatLng(
                                  (details
                                      .result.geometry?.location.lat)!,
                                  (details
                                      .result.geometry?.location.lng)!,
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/rider_booking_screen',
                                  arguments: RiderBookingScreenArguments(
                                    true,
                                    900,
                                    50,
                                    widget.latLng,
                                    latLng,
                                  ),
                                );
                              } else {
                                Navigator.pop(
                                  context,
                                  viewModel.searchedPredictions[index],
                                );
                              }
                            },
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
