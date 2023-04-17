import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/model/rides.dart';
import '../../../theme/color.dart';
import 'driver_rides_view_model.dart';

class DriverRidesPage extends StatefulWidget {
  final String currentRideId;
  final Rides? rides;

  const DriverRidesPage({
    super.key,
    required this.currentRideId,
    required this.rides,
  });

  @override
  State<DriverRidesPage> createState() => _DriverRidesPageState();
}

class _DriverRidesPageState extends State<DriverRidesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverRidesViewModel>(
      create: (context) => DriverRidesViewModel(
        context,
        widget.currentRideId,
        widget.rides,
      ),
      child: Consumer<DriverRidesViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            body: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: secondaryTextColor,
                    ),
                  )
                : _DriverRidesPageBodyLayout(
                    viewModel: viewModel,
                  ),
          );
        },
      ),
    );
  }
}

class _DriverRidesPageBodyLayout extends StatefulWidget {
  final DriverRidesViewModel viewModel;

  const _DriverRidesPageBodyLayout({
    required this.viewModel,
  });

  @override
  State<_DriverRidesPageBodyLayout> createState() =>
      _DriverRidesPageBodyLayoutState();
}

class _DriverRidesPageBodyLayoutState
    extends State<_DriverRidesPageBodyLayout> {
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
                  target: widget.viewModel.driverLocation,
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  widget.viewModel.controller.complete(controller);
                },
                markers: {
                  if (widget.viewModel.sourcePosition != null)
                    widget.viewModel.sourcePosition!,
                  if (widget.viewModel.destinationPosition != null)
                    widget.viewModel.destinationPosition!,
                },
              ),
            ],
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(20),
        //   child: GestureDetector(
        //     onTap: !widget.viewModel.driverOffline
        //         ? widget.viewModel.onClickNextButton
        //         : null,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           widget.viewModel.driverOffline
        //               ? 'You\'re offline'
        //               : 'You\'re online',
        //           style: GoogleFonts.openSans(
        //             textStyle: const TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //           textAlign: TextAlign.center,
        //           maxLines: 1,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //         if (!widget.viewModel.driverOffline) ...[
        //           const SizedBox(
        //             width: 12,
        //           ),
        //           const Icon(
        //             Icons.navigate_next_rounded,
        //             size: 24,
        //           ),
        //         ],
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
