import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/model/rides.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/app_bar.dart';
import '../../../theme/widgets/empty_state.dart';
import 'driver_my_rides_view_model.dart';

class DriverMyRidesPage extends StatefulWidget {
  const DriverMyRidesPage({super.key});

  @override
  State<DriverMyRidesPage> createState() => _DriverMyRidesPageState();
}

class _DriverMyRidesPageState extends State<DriverMyRidesPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverMyRidesViewModel>(
      create: (context) => DriverMyRidesViewModel(context),
      child: Consumer<DriverMyRidesViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: const SecondaryAppBar(
              primaryText: 'Orders',
            ),
            body: viewModel.isLoadingData
                ? const Center(
                    child: CircularProgressIndicator(
                      color: secondaryTextColor,
                    ),
                  )
                : viewModel.ridesList.isEmpty
                    ? const EmptyState(
                        primaryText: 'No previous rides exist',
                        secondaryText: '',
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.ridesList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              _DriverMyRidesItemLayout(
                                rides: viewModel.ridesList[index],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}

class _DriverMyRidesItemLayout extends StatefulWidget {
  final Rides rides;

  const _DriverMyRidesItemLayout({
    required this.rides,
  });

  @override
  State<_DriverMyRidesItemLayout> createState() =>
      _DriverMyRidesItemLayoutState();
}

class _DriverMyRidesItemLayoutState extends State<_DriverMyRidesItemLayout> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: Text(
                          'Dropped',
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: successStateColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 4),
                        child: Text(
                          widget.rides.reachedDestinationUser2At == 0
                              ? getSecToPastTimeFormattedNumber(widget
                                  .rides.reachedDestinationUser1At
                                  .toInt())
                              : getSecToPastTimeFormattedNumber(widget
                                  .rides.reachedDestinationUser2At
                                  .toInt()),
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12, top: 8),
                      child: Text(
                        widget.rides.farePriceForUser2 == 0
                            ? getCurrencyFormattedNumber(widget
                                .rides.initialFareReceivedByDriver
                                .toDouble())
                            : '\u{20B9}${widget.rides.farePriceForUser1} + \u{20B9}${widget.rides.farePriceForUser2}',
                        maxLines: 1,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: primaryTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 4),
                      child: Text(
                        widget.rides.farePriceForUser2 == 0
                            ? widget.rides.modeOfPaymentByUser1
                            : '${widget.rides.modeOfPaymentByUser1} & ${widget.rides.modeOfPaymentByUser2}',
                        maxLines: 1,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.rides.mergePath.isEmpty) ...[
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
                        height: 30,
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
                    ] else ...[
                      if (widget.rides.mergePath[0] == '1') ...[
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
                          child: Center(
                            child: Text(
                              '1',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          margin: const EdgeInsets.only(left: 4.5),
                          color: Colors.grey,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: successStateColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ] else ...[
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
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          margin: const EdgeInsets.only(left: 4.5),
                          color: Colors.grey,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: successStateColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      Container(
                        width: 1,
                        height: 30,
                        margin: const EdgeInsets.only(left: 4.5),
                        color: Colors.grey,
                      ),
                      if (widget.rides.mergePath[0] == '3') ...[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: errorStateColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
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
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 26,
                          color: Colors.transparent,
                        ),
                      ] else ...[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: errorStateColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
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
                          child: Center(
                            child: Text(
                              '1',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 26,
                          color: Colors.transparent,
                        ),
                      ],
                    ],
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.rides.mergePath.isEmpty) ...[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 40,
                        child: Text(
                          widget.rides.pickupUser1Address,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 40,
                        child: Text(
                          widget.rides.destinationUser1Address,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      if (widget.rides.mergePath[0] == '1') ...[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.pickupUser1Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.pickupUser2Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.pickupUser2Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.pickupUser1Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (widget.rides.mergePath[0] == '3') ...[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.destinationUser1Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.destinationUser2Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.destinationUser2Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 40,
                          child: Text(
                            widget.rides.destinationUser1Address,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
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
    );
  }
}
