import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/app_bar.dart';
import '../../../theme/widgets/empty_state.dart';
import 'driver_ride_request_view_model.dart';

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
                    ? const EmptyState(
                        primaryText: 'No current rides found',
                        secondaryText: '',
                      )
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 1,
                            height: 4,
                            color: Colors.transparent,
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: successStateColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            margin: const EdgeInsets.only(left: 4.5),
                            color: Colors.grey,
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: errorStateColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 26,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            height: 18,
                            child: Text(
                              '${rides[2]} (${rides[1]} km) away',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 140,
                            height: 20,
                            child: Text(
                              rides[3].toString(),
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            height: 18,
                            child: Text(
                              '${rides[5]} (${rides[4]} km) trip',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 140,
                            height: 20,
                            child: Text(
                              rides[6].toString(),
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
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
