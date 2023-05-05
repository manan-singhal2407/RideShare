import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../theme/color.dart';
import 'rider_rides_view_model.dart';

class RiderRidesPage extends StatefulWidget {
  final String rideId;

  const RiderRidesPage({
    super.key,
    required this.rideId,
  });

  @override
  State<RiderRidesPage> createState() => _RiderRidesPageState();
}

class _RiderRidesPageState extends State<RiderRidesPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RiderRidesViewModel>(
      create: (context) => RiderRidesViewModel(
        context,
        widget.rideId,
      ),
      child: Consumer<RiderRidesViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: viewModel.isLoadingRideInfo
                ? const Center(
                    child: CircularProgressIndicator(
                      color: secondaryTextColor,
                    ),
                  )
                : _RiderRidesViewLayout(
                    viewModel: viewModel,
                  ),
          );
        },
      ),
    );
  }
}

class _RiderRidesViewLayout extends StatefulWidget {
  final RiderRidesViewModel viewModel;

  const _RiderRidesViewLayout({
    required this.viewModel,
  });

  @override
  State<_RiderRidesViewLayout> createState() => _RiderRidesViewLayoutState();
}

class _RiderRidesViewLayoutState extends State<_RiderRidesViewLayout> {
  @override
  void dispose() {
    widget.viewModel.disposeScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                polylines: Set<Polyline>.of(widget.viewModel.polylines.values),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    (widget.viewModel.rides?.driverLatitude)!,
                    (widget.viewModel.rides?.driverLongitude)!,
                  ),
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  widget.viewModel.controller.complete(controller);
                },
                markers: Set<Marker>.of(widget.viewModel.screenMarker),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: GestureDetector(
            // todo onTap show bottom sheet
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 90 * 3.1415926535897932 / 180,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.purple,
                            ),
                            child:
                                widget.viewModel.rides?.driver?.profileUrl == ''
                                    ? const Icon(
                                        Icons.person_rounded,
                                        size: 32,
                                      )
                                    : Image.network(
                                        (widget.viewModel.rides?.driver
                                            ?.profileUrl)!,
                                        width: 32,
                                        height: 32,
                                      ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.viewModel.rides?.driver?.driverName}',
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${widget.viewModel.rides?.driver?.fullPhoneNumber}',
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.viewModel.rides?.driver?.carNumber}',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
