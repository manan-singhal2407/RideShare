import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/app_bar.dart';
import 'driver_ride_request_view_model.dart';

// todo empty layout

class DriverRideRequestPage extends StatefulWidget {
  const DriverRideRequestPage({super.key});

  @override
  State<DriverRideRequestPage> createState() => _DriverRideRequestPageState();
}

class _DriverRideRequestPageState extends State<DriverRideRequestPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverRideRequestViewModel>(
      create: (context) => DriverRideRequestViewModel(context),
      child: Consumer<DriverRideRequestViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: const SecondaryAppBar(
              primaryText: 'Ride Request',
            ),
            body: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: secondaryTextColor,
                    ),
                  )
                : viewModel.ridesRequestData.isEmpty
                    ? Text('')
                    : _DriverRideRequestViewLayout(viewModel: viewModel),
          );
        },
      ),
    );
  }
}

class _DriverRideRequestViewLayout extends StatefulWidget {
  final DriverRideRequestViewModel viewModel;

  const _DriverRideRequestViewLayout({
    required this.viewModel,
  });

  @override
  State<_DriverRideRequestViewLayout> createState() =>
      _DriverRideRequestViewLayoutState();
}

class _DriverRideRequestViewLayoutState
    extends State<_DriverRideRequestViewLayout> {
  @override
  void dispose() {
    widget.viewModel.disposeScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.viewModel.ridesRequestData.length,
      itemBuilder: (context, index) {
        final ridesModel = widget.viewModel.ridesList[index];
        final rides = widget.viewModel.ridesRequestData[index];
        return GestureDetector(
          onTap: () {
            widget.viewModel.onSelectRide(
              rides[3].toString(),
              rides[1].toString(),
              rides[2].toString(),
              ridesModel,
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    getCurrencyFormattedNumber(rides[0] as double),
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.location_on_sharp,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${rides[2]} (${rides[1]} km) away',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 36,
                      ),
                      Text(
                        rides[3].toString(),
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
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.location_on_sharp,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${rides[5]} (${rides[4]} km) trip',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 36,
                      ),
                      Text(
                        rides[6].toString(),
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
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
