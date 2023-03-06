import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'booking_view_model.dart';

class BookingPage extends StatefulWidget {
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;

  const BookingPage({
    super.key,
    required this.pickupLatLng,
    required this.destinationLatLng,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingViewModel>(
      create: (context) => BookingViewModel(
        context,
        widget.pickupLatLng,
        widget.destinationLatLng,
      ),
      child: Consumer<BookingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        polylines: Set<Polyline>.of(viewModel.polylines.values),
                        initialCameraPosition: CameraPosition(
                          target: widget.pickupLatLng,
                          zoom: 12,
                        ),
                        onCameraMove: (CameraPosition? position) {},
                        onMapCreated: (GoogleMapController controller) {
                          viewModel.controller.complete(controller);
                        },
                        markers: {
                          if (viewModel.sourcePosition != null)
                            viewModel.sourcePosition!,
                          if (viewModel.destinationPosition != null)
                            viewModel.destinationPosition!,
                        },
                      ),
                      Positioned(
                        top: 40,
                        right: 20,
                        left: 20,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 28,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Text(
                          'Enter drop location',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
