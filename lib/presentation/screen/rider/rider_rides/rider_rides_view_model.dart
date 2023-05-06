import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_rider_rides_repository.dart';
import '../../../../domain/state/data_state.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/app_button.dart';

class RiderRidesViewModel extends ChangeNotifier {
  final IRiderRidesRepository _riderRidesRepository =
      getIt<IRiderRidesRepository>();

  final BuildContext _context;
  final String _rideId;

  bool _isLoadingRideInfo = true;
  Rides? _rides;
  StreamSubscription<DataState>? _streamSubscription;
  final StreamController<DataState> _streamController =
      StreamController<DataState>.broadcast();

  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<Marker> _screenMarker = [];

  int _ratingToDriver = 0;

  RiderRidesViewModel(this._context, this._rideId) {
    _createContinuousConnectionWithDatabase();
  }

  bool get isLoadingRideInfo => _isLoadingRideInfo;

  Rides? get rides => _rides;

  Completer<GoogleMapController?> get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  List<Marker> get screenMarker => _screenMarker;

  void _createContinuousConnectionWithDatabase() {
    _riderRidesRepository.createContinuousConnectionWithDatabase(
        _rideId, _streamController);
    _streamSubscription = _streamController.stream.listen((value) async {
      if (value.data != null) {
        _rides = (value.data)[0] as Rides;
        bool isThisAUser1 = (value.data)[1] as bool;
        _isLoadingRideInfo = false;
        _screenMarker.clear();
        _screenMarker.add(Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            (_rides?.driverLatitude)!,
            (_rides?.driverLongitude)!,
          ),
          icon: BitmapDescriptor.fromBytes(
            await getUint8ListImages(
              'assets/images/swift.png',
              100,
            ),
          ),
        ));

        if (_rides?.user2 != null) {
          String mergePath = (_rides?.mergePath)!;
          _screenMarker.add(Marker(
            markerId: const MarkerId('source1'),
            position: LatLng(
              (_rides?.pickupUser1Latitude)!,
              (_rides?.pickupUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[0]}.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination1'),
            position: LatLng(
              (_rides?.pickupUser2Latitude)!,
              (_rides?.pickupUser2Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[1]}.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('source2'),
            position: LatLng(
              (_rides?.destinationUser1Latitude)!,
              (_rides?.destinationUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[2]}.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination2'),
            position: LatLng(
              (_rides?.destinationUser2Latitude)!,
              (_rides?.destinationUser2Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[3]}.png',
                100,
              ),
            ),
          ));
          notifyListeners();
          if (mergePath == '1234') {
            if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedDestinationUser1At == 0) {
              _showPolylineForDestinationUser1();
            } else {
              _showPolylineForDestinationUser2();
            }
          } else if (mergePath == '1243') {
            if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedDestinationUser2At == 0) {
              _showPolylineForDestinationUser2();
            } else {
              _showPolylineForDestinationUser1();
            }
          } else if (mergePath == '2134') {
            if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedDestinationUser1At == 0) {
              _showPolylineForDestinationUser1();
            } else {
              _showPolylineForDestinationUser2();
            }
          } else if (mergePath == '2143') {
            if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedDestinationUser2At == 0) {
              _showPolylineForDestinationUser2();
            } else {
              _showPolylineForDestinationUser1();
            }
          }
        } else {
          _screenMarker.add(Marker(
            markerId: const MarkerId('source'),
            position: LatLng(
              (_rides?.pickupUser1Latitude)!,
              (_rides?.pickupUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/pick.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(
              (_rides?.destinationUser1Latitude)!,
              (_rides?.destinationUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/pick.png',
                100,
              ),
            ),
          ));
          notifyListeners();
          if (_rides?.reachedPickupUser1At == 0) {
            _showPolylineForPickupUser1();
          } else {
            _showPolylineForDestinationUser1();
          }
        }

        if (isThisAUser1) {
          if (_rides?.reachedDestinationUser1At != 0) {
            _showFeedbackBottomSheet();
          }
        } else {
          if (_rides?.reachedDestinationUser2At != 0) {
            _showFeedbackBottomSheet();
          }
        }
        notifyListeners();
      }
    });
  }

  void _showPolylineForPickupUser1() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.pickupUser1Latitude)!,
        (_rides?.pickupUser1Longitude)!,
      ),
    ).then((value) async {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showPolylineForPickupUser2() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.pickupUser2Latitude)!,
        (_rides?.pickupUser2Longitude)!,
      ),
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showPolylineForDestinationUser1() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.destinationUser1Latitude)!,
        (_rides?.destinationUser1Longitude)!,
      ),
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showPolylineForDestinationUser2() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.destinationUser2Latitude)!,
        (_rides?.destinationUser2Longitude)!,
      ),
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showFeedbackBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: _context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SizedBox(
            height: MediaQuery.of(_context).size.height * 2 / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.purple,
                    ),
                    child: _rides?.driver?.profileUrl == ''
                        ? const Icon(
                            Icons.person_rounded,
                            size: 32,
                          )
                        : Image.network(
                            (_rides?.driver?.profileUrl)!,
                            width: 32,
                            height: 32,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Rate your experience with ${_rides?.driver?.driverName}?',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _ratingToDriver = rating.toInt();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SecondaryAppButton(
                    width: 120,
                    text: 'Done',
                    onPressed: () async {
                      _riderRidesRepository
                          .updateRatingAndRemoveCurrentRideId(
                        (_rides?.driver?.driverUid)!,
                        _ratingToDriver,
                      )
                          .then((value) {
                        if (value.data != null) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/rider_home_screen',
                            (r) => false,
                          );
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showRideDetails() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: _context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    'Total Fare',
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
                ),
                Text(
                  'Drop off',
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
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            if (_rides?.user2 != null) ...[
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: DateFormat.Hm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                              (_rides?.idealTimeToDropUser1)!.toInt(),
                            ),
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
                          '  ${getCurrencyFormattedNumber((_rides?.farePriceForUser1)!.toDouble())}',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: getCurrencyFormattedNumber(
                              (_rides?.initialFareForUser1)!.toDouble()),
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
                              '  ${getCurrencyFormattedNumber((_rides?.farePriceForUser1)!.toDouble())}',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      getCurrencyFormattedNumber(
                          (_rides?.farePriceForUser1)!.toDouble()),
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
                  ),
                  Text(
                    DateFormat.Hm().format(
                      DateTime.fromMillisecondsSinceEpoch(
                        (_rides?.idealTimeToDropUser1)!.toInt(),
                      ),
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
                  const SizedBox(
                    width: 16,
                  ),
                ],
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
                          child: _rides?.driver?.profileUrl == ''
                              ? const Icon(
                                  Icons.person_rounded,
                                  size: 32,
                                )
                              : Image.network(
                                  (_rides?.driver?.profileUrl)!,
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
                              '${_rides?.driver?.driverName}',
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
                              '${_rides?.driver?.fullPhoneNumber}',
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
                      '${_rides?.driver?.carNumber}',
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
                    width: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_rides?.user2 != null) ...[
              Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    ' away',
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
            ] else ...[
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${_rides?.pickupUser1Address}',
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
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${_rides?.destinationUser1Address}',
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
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ],
            Row(
              children: [
                const SizedBox(
                  width: 4,
                ),
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  ' away',
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.purple,
                ),
                child: _rides?.driver?.profileUrl == ''
                    ? const Icon(
                        Icons.person_rounded,
                        size: 32,
                      )
                    : Image.network(
                        (_rides?.driver?.profileUrl)!,
                        width: 32,
                        height: 32,
                      ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Rate your experience with ${_rides?.driver?.driverName}?',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 13,
                    color: secondaryTextColor,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _ratingToDriver = rating.toInt();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SecondaryAppButton(
                width: 120,
                text: 'Done',
                onPressed: () async {
                  _riderRidesRepository
                      .updateRatingAndRemoveCurrentRideId(
                    (_rides?.driver?.driverUid)!,
                    _ratingToDriver,
                  )
                      .then((value) {
                    if (value.data != null) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/rider_home_screen',
                        (r) => false,
                      );
                    }
                  });
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        );
      },
    );
  }

  void disposeScreen() async {
    _streamSubscription?.cancel();
    _streamController.close();
  }
}
