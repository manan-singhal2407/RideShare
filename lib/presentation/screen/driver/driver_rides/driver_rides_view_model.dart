import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../../../../data/network/model/rides.dart';
import '../../../../domain/enums/driver_shared_booking_enum.dart';
import '../../../../domain/repositories/i_driver_rides_repository.dart';
import '../../../../domain/state/data_state.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/loading.dart';

class DriverRidesViewModel extends ChangeNotifier {
  final IDriverRidesRepository _driverRidesRepository =
      getIt<IDriverRidesRepository>();

  final BuildContext _context;
  final String _rideId;

  bool _isLoadingData = true;
  late Rides _currentRideInfo;

  StreamSubscription<DataState>? _streamSubscription;
  final StreamController<DataState> _streamController =
      StreamController<DataState>.broadcast();
  List<List<Object>> _sharedRidesDataList = [];

  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();

  final Map<PolylineId, Polyline> _polylines = {};
  LatLng _destinationPolylineLatLng = defaultLatLng;
  final List<Marker> _screenMarker = [];
  final List<Marker> _showScreenMarker = [];
  late Timer _currentLocationTimer;

  DriverRidesViewModel(this._context, this._rideId) {
    _getRidesInfoFromDatabase();
  }

  bool get isLoadingData => _isLoadingData;

  Rides get currentRideInfo => _currentRideInfo;

  List<List<Object>> get sharedRidesDataList => _sharedRidesDataList;

  Map<PolylineId, Polyline> get polylines => _polylines;

  List<Marker> get showScreenMarker => _showScreenMarker;

  Completer<GoogleMapController?> get controller => _controller;

  void _getRidesInfoFromDatabase() async {
    await _driverRidesRepository
        .getRidesInfoFromDatabase(_rideId)
        .then((value) async {
      if (value.data != null) {
        _isLoadingData = false;
        _currentRideInfo = value.data[0] as Rides;
        if (_currentRideInfo.driver?.driverUid != value.data[1]) {
          showScaffoldMessenger(
            _context,
            'Something went wrong',
            errorStateColor,
          );
          Navigator.pop(_context);
        }
        _sharedRidesDataList.clear();

        if (_currentRideInfo.isSharingOnByDriver) {
          if (_currentRideInfo.user2 == null) {
            _destinationPolylineLatLng = LatLng(
              _currentRideInfo.destinationUser1Latitude,
              _currentRideInfo.destinationUser1Longitude,
            );
            if (_currentRideInfo.reachedPickupUser1At == 0) {
              _destinationPolylineLatLng = LatLng(
                _currentRideInfo.pickupUser1Latitude,
                _currentRideInfo.pickupUser1Longitude,
              );
              _screenMarker.add(Marker(
                markerId: const MarkerId('source'),
                position: LatLng(
                  _currentRideInfo.pickupUser1Latitude,
                  _currentRideInfo.pickupUser1Longitude,
                ),
                icon: BitmapDescriptor.fromBytes(
                  await getUint8ListImages(
                    'assets/images/ic_marker_pickup.png',
                    50,
                  ),
                ),
              ));
            }
            _screenMarker.add(Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(
                _currentRideInfo.destinationUser1Latitude,
                _currentRideInfo.destinationUser1Longitude,
              ),
              icon: BitmapDescriptor.fromBytes(
                await getUint8ListImages(
                  'assets/images/ic_marker_destination.png',
                  50,
                ),
              ),
            ));
            _driverRidesRepository.createContinuousConnectionWithSharingRide(
              _streamController,
            );
            _streamSubscription =
                _streamController.stream.listen((value) async {
              if (value.data != null) {
                _sharedRidesDataList = value.data as List<List<Object>>;
                notifyListeners();
              }
            });
          } else {
            _screenMarker.add(Marker(
              markerId: const MarkerId('source1'),
              position: LatLng(
                _currentRideInfo.pickupUser1Latitude,
                _currentRideInfo.pickupUser1Longitude,
              ),
              icon: BitmapDescriptor.fromBytes(
                await getUint8ListImages(
                  'assets/images/ic_marker_position${_currentRideInfo.mergePath[0]}.png',
                  50,
                ),
              ),
            ));
            _screenMarker.add(Marker(
              markerId: const MarkerId('source2'),
              position: LatLng(
                _currentRideInfo.pickupUser2Latitude,
                _currentRideInfo.pickupUser2Longitude,
              ),
              icon: BitmapDescriptor.fromBytes(
                await getUint8ListImages(
                  'assets/images/ic_marker_position${_currentRideInfo.mergePath[1]}.png',
                  50,
                ),
              ),
            ));
            _screenMarker.add(Marker(
              markerId: const MarkerId('destination1'),
              position: LatLng(
                _currentRideInfo.destinationUser1Latitude,
                _currentRideInfo.destinationUser1Longitude,
              ),
              icon: BitmapDescriptor.fromBytes(
                await getUint8ListImages(
                  'assets/images/ic_marker_position${_currentRideInfo.mergePath[2]}.png',
                  50,
                ),
              ),
            ));
            _screenMarker.add(Marker(
              markerId: const MarkerId('destination2'),
              position: LatLng(
                _currentRideInfo.destinationUser2Latitude,
                _currentRideInfo.destinationUser2Longitude,
              ),
              icon: BitmapDescriptor.fromBytes(
                await getUint8ListImages(
                  'assets/images/ic_marker_position${_currentRideInfo.mergePath[3]}.png',
                  50,
                ),
              ),
            ));
            if (_currentRideInfo.mergePath == '1234') {
              if (_currentRideInfo.reachedPickupUser1At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser1Latitude,
                  _currentRideInfo.pickupUser1Longitude,
                );
              } else if (_currentRideInfo.reachedPickupUser2At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser2Latitude,
                  _currentRideInfo.pickupUser2Longitude,
                );
              } else if (_currentRideInfo.reachedDestinationUser1At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser1Latitude,
                  _currentRideInfo.destinationUser1Longitude,
                );
              } else {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser2Latitude,
                  _currentRideInfo.destinationUser2Longitude,
                );
              }
            } else if (_currentRideInfo.mergePath == '1243') {
              if (_currentRideInfo.reachedPickupUser1At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser1Latitude,
                  _currentRideInfo.pickupUser1Longitude,
                );
              } else if (_currentRideInfo.reachedPickupUser2At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser2Latitude,
                  _currentRideInfo.pickupUser2Longitude,
                );
              } else if (_currentRideInfo.reachedDestinationUser2At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser2Latitude,
                  _currentRideInfo.destinationUser2Longitude,
                );
              } else {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser1Latitude,
                  _currentRideInfo.destinationUser1Longitude,
                );
              }
            } else if (_currentRideInfo.mergePath == '2134') {
              if (_currentRideInfo.reachedPickupUser2At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser2Latitude,
                  _currentRideInfo.pickupUser2Longitude,
                );
              } else if (_currentRideInfo.reachedPickupUser1At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser1Latitude,
                  _currentRideInfo.pickupUser1Longitude,
                );
              } else if (_currentRideInfo.reachedDestinationUser1At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser1Latitude,
                  _currentRideInfo.destinationUser1Longitude,
                );
              } else {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser2Latitude,
                  _currentRideInfo.destinationUser2Longitude,
                );
              }
            } else if (_currentRideInfo.mergePath == '2143') {
              if (_currentRideInfo.reachedPickupUser2At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser2Latitude,
                  _currentRideInfo.pickupUser2Longitude,
                );
              } else if (_currentRideInfo.reachedPickupUser1At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.pickupUser1Latitude,
                  _currentRideInfo.pickupUser1Longitude,
                );
              } else if (_currentRideInfo.reachedDestinationUser2At == 0) {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser2Latitude,
                  _currentRideInfo.destinationUser2Longitude,
                );
              } else {
                _destinationPolylineLatLng = LatLng(
                  _currentRideInfo.destinationUser1Latitude,
                  _currentRideInfo.destinationUser1Longitude,
                );
              }
            }
            if (_currentRideInfo.mergePath.isNotEmpty) {
              _showPolylineForDriver();
            }
          }
        } else {
          _destinationPolylineLatLng = LatLng(
            _currentRideInfo.destinationUser1Latitude,
            _currentRideInfo.destinationUser1Longitude,
          );
          if (_currentRideInfo.reachedPickupUser1At == 0) {
            _destinationPolylineLatLng = LatLng(
              _currentRideInfo.pickupUser1Latitude,
              _currentRideInfo.pickupUser1Longitude,
            );
            _screenMarker.add(Marker(
              markerId: const MarkerId('source'),
              position: LatLng(
                _currentRideInfo.pickupUser1Latitude,
                _currentRideInfo.pickupUser1Longitude,
              ),
              icon: BitmapDescriptor.fromBytes(
                await getUint8ListImages(
                  'assets/images/ic_marker_pickup.png',
                  50,
                ),
              ),
            ));
          }
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(
              _currentRideInfo.destinationUser1Latitude,
              _currentRideInfo.destinationUser1Longitude,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_destination.png',
                50,
              ),
            ),
          ));
        }

        notifyListeners();
        _getCurrentLocation();
        _currentLocationTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) {
          _getCurrentLocation();
        });
      }
    });
  }

  void _showPolylineForDriver() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        _currentRideInfo.driverLatitude,
        _currentRideInfo.driverLongitude,
      ),
      _destinationPolylineLatLng,
    ).then((value) async {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _getCurrentLocation() async {
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _currentPosition = await location.getLocation();
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
      zoom: 16,
    )));
    _currentRideInfo.driverLatitude = _currentPosition!.latitude!;
    _currentRideInfo.driverLongitude = _currentPosition!.longitude!;
    _showScreenMarker.clear();
    _showScreenMarker.addAll(_screenMarker);
    _showScreenMarker.add(Marker(
      markerId: const MarkerId('driver'),
      position: LatLng(
        _currentRideInfo.driverLatitude,
        _currentRideInfo.driverLongitude,
      ),
      icon: BitmapDescriptor.fromBytes(
        await getUint8ListImages(
          'assets/images/ic_marker_driver.png',
          100,
        ),
      ),
    ));
    _showPolylineForDriver();
  }

  void onSelectSharedRide(Rides requestRide) async {
    showLoadingDialogBox(_context);
    await _driverRidesRepository
        .onSelectSharedRide(_currentRideInfo.rideId, requestRide.rideId,
            (requestRide.user1?.userUid)!)
        .then((value) {
      Navigator.pop(_context);
      DriverSharedBookingEnum status = value.data as DriverSharedBookingEnum;
      if (status == DriverSharedBookingEnum.success) {
        disposeScreen();
        _getRidesInfoFromDatabase();
      } else if (status == DriverSharedBookingEnum.error) {
        showScaffoldMessenger(
          _context,
          'Something went wrong',
          errorStateColor,
        );
      } else if (status == DriverSharedBookingEnum.driverAccepted) {
        showScaffoldMessenger(
          _context,
          'Ride already started',
          errorStateColor,
        );
      } else if (status == DriverSharedBookingEnum.cancelledByUser) {
        showScaffoldMessenger(
          _context,
          'Cancelled ride by user',
          errorStateColor,
        );
      } else if (status == DriverSharedBookingEnum.alreadyMerged) {
        showScaffoldMessenger(
          _context,
          'Already merged with other driver',
          errorStateColor,
        );
      }
    });
  }

  void onCancelSharedRide(Rides requestRide) async {
    for (int i = 0; i < _sharedRidesDataList.length; i++) {
      Rides rides = _sharedRidesDataList[i][0] as Rides;
      if (rides.rideId == requestRide.rideId) {
        _sharedRidesDataList.removeAt(i);
      }
    }
    notifyListeners();
    await _driverRidesRepository.onCancelSharedRide(
      requestRide.rideId,
      (requestRide.user1?.userUid)!,
    );
  }

  void updateRidesInfo(String databaseKey, bool isRideOver) async {
    showLoadingDialogBox(_context);
    await _driverRidesRepository
        .updateRideInfo(
      _currentRideInfo.rideId,
      {databaseKey: DateTime.now().millisecondsSinceEpoch},
      currentRideInfo.fareReceivedByDriver == 0
          ? currentRideInfo.initialFareReceivedByDriver.toInt()
          : currentRideInfo.fareReceivedByDriver.toInt(),
      isRideOver,
      currentRideInfo.user2 != null,
    )
        .then((value) {
      Navigator.pop(_context);
      Navigator.pop(_context);
      if (value.data != null) {
        disposeScreen();
        _getRidesInfoFromDatabase();
        if (isRideOver) {
          Navigator.pushNamedAndRemoveUntil(
            _context,
            '/driver_home_screen',
            (r) => false,
          );
        }
      }
    });
  }

  void disposeScreen() async {
    _streamSubscription?.cancel();
    _streamController.close();
    _currentLocationTimer.cancel();
  }
}
