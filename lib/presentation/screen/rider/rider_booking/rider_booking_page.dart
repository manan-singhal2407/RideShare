import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/app_button.dart';
import 'rider_booking_view_model.dart';

class RiderBookingPage extends StatefulWidget {
  final bool isSharingOn;
  final int tolerance;
  final int amountNeedToSave;
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;

  const RiderBookingPage({
    super.key,
    required this.isSharingOn,
    required this.tolerance,
    required this.amountNeedToSave,
    required this.pickupLatLng,
    required this.destinationLatLng,
  });

  @override
  State<RiderBookingPage> createState() => _RiderBookingPageState();
}

class _RiderBookingPageState extends State<RiderBookingPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RiderBookingViewModel>(
      create: (context) => RiderBookingViewModel(
        context,
        widget.isSharingOn,
        widget.tolerance,
        widget.amountNeedToSave,
        widget.pickupLatLng,
        widget.destinationLatLng,
      ),
      child: Consumer<RiderBookingViewModel>(
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
                            if (viewModel.distanceBetweenSourceAndDestination !=
                                -100) ...[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${getMToKmFormattedNumber(viewModel.distanceBetweenSourceAndDestination)} km',
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
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (viewModel.showCarBookingLoadingView) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          viewModel.loadingViewText,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 16,
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
                      const Divider(
                        height: 1,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: LinearProgressIndicator(
                                value: viewModel.loadingViewValues[0],
                                color: primaryTextColor,
                                backgroundColor: secondaryTextColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: LinearProgressIndicator(
                                value: viewModel.loadingViewValues[1],
                                color: primaryTextColor,
                                backgroundColor: secondaryTextColor,
                              ),
                            ),
                          ),
                          if (viewModel.isCarPoolingEnabled) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: LinearProgressIndicator(
                                  value: viewModel.loadingViewValues[2],
                                  color: primaryTextColor,
                                  backgroundColor: secondaryTextColor,
                                ),
                              ),
                            ),
                          ],
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: LinearProgressIndicator(
                                value: viewModel.loadingViewValues[3],
                                color: primaryTextColor,
                                backgroundColor: secondaryTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.lightBlue.shade300,
                          ),
                          child: Image.asset(
                            'assets/images/swift.png',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (viewModel.showCarBookingCancelButton) ...[
                        Center(
                          child: SecondaryAppButton(
                            width: 120,
                            text: 'Cancel ride',
                            onPressed: viewModel.onCancelRideClicked,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ],
                  ),
                ] else ...[
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: Colors.orange.shade100,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.yellow.shade500,
                                      ),
                                      child: Image.asset(
                                        'assets/images/swift.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Cab',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      viewModel.timeTakenBetweenSourceAndDestination !=
                                              -100
                                          ? getSecToTimeFormattedNumber(viewModel
                                              .timeTakenBetweenSourceAndDestination
                                              .toInt())
                                          : '-',
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
                              Text(
                                viewModel.distanceBetweenSourceAndDestination !=
                                        -100
                                    ? getCurrencyFormattedNumber((viewModel
                                                .distanceBetweenSourceAndDestination ~/
                                            50)
                                        .toDouble())
                                    : '-',
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
                        ),
                      ),
                      GestureDetector(
                        onTap: viewModel.onCarPoolingClicked,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Car Sharing',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: viewModel.isCarPoolingEnabled,
                                onChanged: (value) {
                                  viewModel.onCarPoolingClicked();
                                },
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (viewModel.isCarPoolingEnabled) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Tolerance',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 56,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: viewModel.toleranceTimeController,
                                  decoration: InputDecoration(
                                    hintText: '15',
                                    hintStyle: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    labelStyle: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
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
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Savings Goal Amount',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 56,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller:
                                      viewModel.amountNeedToSaveController,
                                  decoration: InputDecoration(
                                    hintText: '15',
                                    hintStyle: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    labelStyle: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
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
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: PrimaryAppButton(
                          width: MediaQuery.of(context).size.width,
                          text: 'Book Cab',
                          onPressed: viewModel.onBookSwiftClicked,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
