import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/model/rides.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import 'driver_rides_view_model.dart';

class DriverRidesPage extends StatefulWidget {
  final String rideId;

  const DriverRidesPage({
    super.key,
    required this.rideId,
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
        widget.rideId,
      ),
      child: Consumer<DriverRidesViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            body: viewModel.isLoadingData
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

  void _showRideDetailsBottomSheet() {
    Rides rides = widget.viewModel.currentRideInfo;
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Total Fare',
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
            if (rides.fareReceivedByDriver == 0) ...[
              Text(
                getCurrencyFormattedNumber(
                  rides.initialFareReceivedByDriver.toDouble(),
                ),
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: getCurrencyFormattedNumber(
                        rides.initialFareReceivedByDriver.toDouble(),
                      ),
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: secondaryTextColor,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextSpan(
                      text:
                          '  ${getCurrencyFormattedNumber((rides.fareReceivedByDriver.toDouble()))}',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: successStateColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(
              height: 12,
            ),
            Container(
              color: skinnyHighlightColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
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
                    child: rides.user1?.profileUrl == ''
                        ? const Icon(
                            Icons.person_rounded,
                            size: 32,
                          )
                        : Image.network(
                            (rides.user1?.profileUrl)!,
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
                        '${rides.user1?.userName}',
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
                        '${rides.user1?.fullPhoneNumber}',
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
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            if (rides.user2 != null) ...[
              Container(
                color: skinnyHighlightColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
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
                      child: rides.user2?.profileUrl == ''
                          ? const Icon(
                              Icons.person_rounded,
                              size: 32,
                            )
                          : Image.network(
                              (rides.user2?.profileUrl)!,
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
                          '${rides.user2?.userName}',
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
                          '${rides.user2?.fullPhoneNumber}',
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
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
            if (rides.mergePath.isEmpty) ...[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                rides.pickupUser1Address,
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      if (rides.reachedPickupUser1At == 0) ...[
                        GestureDetector(
                          onTap: () {
                            widget.viewModel.updateRidesInfo(
                              'reachedPickupUser1At',
                              false,
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: successStateColor,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.done_rounded,
                              size: 28,
                              color: successStateColor,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Dropoff at',
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                rides.destinationUser1Address,
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      if (rides.reachedPickupUser1At != 0 &&
                          rides.reachedDestinationUser1At == 0) ...[
                        GestureDetector(
                          onTap: () {
                            widget.viewModel.updateRidesInfo(
                              'reachedDestinationUser1At',
                              true,
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: successStateColor,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.done_rounded,
                              size: 28,
                              color: successStateColor,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ] else ...[
              Column(
                children: [
                  if (rides.mergePath[0] == '1') ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Pickup from: (User1)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.pickupUser1Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser1At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedPickupUser1At',
                                false,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Pickup from: (User2)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.pickupUser2Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser1At != 0 &&
                            rides.reachedPickupUser2At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedPickupUser2At',
                                false,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Pickup from: (User2)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.pickupUser2Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser2At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedPickupUser2At',
                                false,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Pickup from: (User1)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.pickupUser1Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser2At != 0 &&
                            rides.reachedPickupUser1At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedPickupUser1At',
                                false,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                  if (rides.mergePath[0] == '3') ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Dropoff at: (User1)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.destinationUser1Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser1At != 0 &&
                            rides.reachedPickupUser2At != 0 &&
                            rides.reachedDestinationUser1At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedDestinationUser1At',
                                false,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Dropoff at: (User2)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.destinationUser2Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser1At != 0 &&
                            rides.reachedPickupUser2At != 0 &&
                            rides.reachedDestinationUser1At != 0 &&
                            rides.reachedDestinationUser2At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedDestinationUser2At',
                                true,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Dropoff at: (User2)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.destinationUser2Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser1At != 0 &&
                            rides.reachedPickupUser2At != 0 &&
                            rides.reachedDestinationUser2At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedDestinationUser2At',
                                false,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Dropoff at: (User1)',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  rides.destinationUser1Address,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        if (rides.reachedPickupUser1At != 0 &&
                            rides.reachedPickupUser2At != 0 &&
                            rides.reachedDestinationUser2At != 0 &&
                            rides.reachedDestinationUser1At == 0) ...[
                          GestureDetector(
                            onTap: () {
                              widget.viewModel.updateRidesInfo(
                                'reachedDestinationUser1At',
                                true,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: successStateColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.done_rounded,
                                size: 28,
                                color: successStateColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ],
        );
      },
    );
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
                  target: defaultLatLng,
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  widget.viewModel.controller.complete(controller);
                },
                markers: Set<Marker>.of(widget.viewModel.showScreenMarker),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: widget.viewModel.sharedRidesDataList.isNotEmpty
              ? MediaQuery.of(context).size.height * 2 / 5
              : 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: GestureDetector(
            onTap: _showRideDetailsBottomSheet,
            child: Column(
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
                if (widget.viewModel.sharedRidesDataList.isNotEmpty) ...[
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.viewModel.sharedRidesDataList.length,
                      itemBuilder: (context, index) {
                        Rides rides = widget
                            .viewModel.sharedRidesDataList[index][0] as Rides;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          rides.pickupUser1Address,
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
                                        height: 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Fare:   ',
                                                style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                    color: primaryTextColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    getCurrencyFormattedNumber(
                                                  rides
                                                      .initialFareReceivedByDriver
                                                      .toDouble(),
                                                ),
                                                style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                    color: secondaryTextColor,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '  ${getCurrencyFormattedNumber((widget.viewModel.sharedRidesDataList[index][2] as double))}',
                                                style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                    color: successStateColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.viewModel.onCancelSharedRide(rides);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: errorStateColor,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 28,
                                      color: errorStateColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.viewModel.onSelectSharedRide(rides);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: successStateColor,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.done_rounded,
                                      size: 28,
                                      color: successStateColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
