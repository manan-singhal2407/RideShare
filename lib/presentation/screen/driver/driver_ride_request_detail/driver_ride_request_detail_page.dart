import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/model/rides.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/app_button.dart';
import 'driver_ride_request_detail_view_model.dart';

class DriverRideRequestDetailPage extends StatefulWidget {
  final String address;
  final String distance;
  final String timeTaken;
  final LatLng latLng;
  final Rides rides;

  const DriverRideRequestDetailPage({
    super.key,
    required this.address,
    required this.distance,
    required this.timeTaken,
    required this.latLng,
    required this.rides,
  });

  @override
  State<DriverRideRequestDetailPage> createState() =>
      _DriverRideRequestDetailPageState();
}

class _DriverRideRequestDetailPageState
    extends State<DriverRideRequestDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverRideRequestDetailViewModel>(
      create: (context) => DriverRideRequestDetailViewModel(
        context,
        widget.latLng,
        widget.rides,
      ),
      child: Consumer<DriverRideRequestDetailViewModel>(
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
                          target: widget.latLng,
                          zoom: 12,
                        ),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.purple,
                          ),
                          child: widget.rides.user1?.profileUrl == ''
                              ? const Icon(
                                  Icons.person_rounded,
                                  size: 32,
                                )
                              : Image.network(
                                  widget.rides.user1?.userName ?? '',
                                  width: 32,
                                  height: 32,
                                ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.rides.user1?.userName ?? '',
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${widget.distance} km away | ${widget.timeTaken}',
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '--',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Pickup from',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: primaryTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.address,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: PrimaryAppButton(
                              text: 'ACCEPT',
                              buttonColor: successStateColor,
                              onPressed: viewModel.onAcceptRequest,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: PrimaryAppButton(
                              text: 'REJECT',
                              buttonColor: errorStateColor,
                              onPressed: viewModel.onRejectRequest,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
