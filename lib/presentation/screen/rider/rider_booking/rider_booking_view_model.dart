import 'dart:async';

import 'package:btp/presentation/theme/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/cache/database/entities/users_entity.dart';
import '../../../../data/network/model/rides.dart';
import '../../../../data/network/model/users.dart';
import '../../../../domain/extension/model_extension.dart';
import '../../../../domain/repositories/i_rider_booking_repository.dart';
import '../../../../domain/state/data_state.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';

class RiderBookingViewModel extends ChangeNotifier {
  final IRiderBookingRepository _riderBookingRepository =
      getIt<IRiderBookingRepository>();

  final BuildContext _context;
  final bool _isSharingOn;
  final int _tolerance;
  final int _amountNeedToSave;
  final LatLng _pickupLatLng;
  final LatLng _destinationLatLng;

  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();
  Marker? _sourcePosition, _destinationPosition;

  double _distanceBetweenSourceAndDestination = -100;
  double _timeTakenBetweenSourceAndDestination = -100;
  String _pickupAddress = 'Loading...';
  String _destinationAddress = 'Loading...';

  Rides? _rides;
  Users? _users;
  bool _isCarPoolingEnabled = false;
  final TextEditingController _toleranceTimeController =
      TextEditingController();
  final TextEditingController _amountNeedToSaveController =
      TextEditingController();

  StreamSubscription<DataState>? _streamSubscription;
  late StreamController<DataState> _streamController =
      StreamController<DataState>.broadcast();
  Timer? _delayedFreeDriverCall;
  Timer? _delayedCancelButtonOption;

  bool _showCarBookingLoadingView = false;
  bool _showCarBookingCancelButton = false;
  String _loadingViewText = 'Confirming your ride';
  final List<double?> _loadingViewValues = [null, 0, 0, 0];

  RiderBookingViewModel(
    this._context,
    this._isSharingOn,
    this._tolerance,
    this._amountNeedToSave,
    this._pickupLatLng,
    this._destinationLatLng,
  ) {
    _isCarPoolingEnabled = _isSharingOn;
    _toleranceTimeController.text = (_tolerance / 60).toString();
    _amountNeedToSaveController.text = _amountNeedToSave.toString();
    _sourcePosition = Marker(
      markerId: const MarkerId('source'),
      position: _pickupLatLng,
    );
    _destinationPosition = Marker(
      markerId: const MarkerId('destination'),
      position: _destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    _getDataFromLocalDatabase();
    _getDataFromDatabase();
    _getDistanceAndTimeBetweenSourceAndDestination();
    _getPolylinesBetweenSourceAndDestination();
    _getAddressFromPickUpMovement(_pickupLatLng).then((value) {
      _pickupAddress = value;
    });
    _getAddressFromPickUpMovement(_destinationLatLng).then((value) {
      _destinationAddress = value;
    });
  }

  Completer<GoogleMapController?> get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  Marker? get sourcePosition => _sourcePosition;

  Marker? get destinationPosition => _destinationPosition;

  double get distanceBetweenSourceAndDestination =>
      _distanceBetweenSourceAndDestination;

  double get timeTakenBetweenSourceAndDestination =>
      _timeTakenBetweenSourceAndDestination;

  bool get isCarPoolingEnabled => _isCarPoolingEnabled;

  TextEditingController get toleranceTimeController => _toleranceTimeController;

  TextEditingController get amountNeedToSaveController =>
      _amountNeedToSaveController;

  bool get showCarBookingLoadingView => _showCarBookingLoadingView;

  bool get showCarBookingCancelButton => _showCarBookingCancelButton;

  String get loadingViewText => _loadingViewText;

  List<double?> get loadingViewValues => _loadingViewValues;

  void _getDataFromLocalDatabase() async {
    await _riderBookingRepository
        .getUserDataFromLocalDatabase()
        .then((value) async {
      if (value.data != null) {
        UsersEntity usersEntity = value.data as UsersEntity;
        _isCarPoolingEnabled = usersEntity.isSharingOn;
        _toleranceTimeController.text =
            (usersEntity.tolerance ~/ 60).toString();
        _amountNeedToSaveController.text =
            usersEntity.amountNeedToSave.toInt().toString();
        _users = convertUsersEntityToUsers(usersEntity);
        notifyListeners();
      }
    });
  }

  void _getDataFromDatabase() async {
    await _riderBookingRepository.getUserDataFromDatabase().then((value) {
      if (value.data != null) {
        Users users = value.data as Users;
        _isCarPoolingEnabled = users.isSharingOn;
        _toleranceTimeController.text = (users.tolerance ~/ 60).toString();
        _amountNeedToSaveController.text =
            users.amountNeedToSave.toInt().toString();
        _users = users;
        notifyListeners();
      }
    });
  }

  void _getDistanceAndTimeBetweenSourceAndDestination() async {
    await getDistanceAndTimeBetweenSourceAndDestination(
      LatLng(
        _pickupLatLng.latitude,
        _pickupLatLng.longitude,
      ),
      LatLng(
        _destinationLatLng.latitude,
        _destinationLatLng.longitude,
      ),
    ).then((value) {
      _distanceBetweenSourceAndDestination = value[0];
      _timeTakenBetweenSourceAndDestination = value[1];
      notifyListeners();
    });
  }

  void _getPolylinesBetweenSourceAndDestination() async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
      PointLatLng(_destinationLatLng.latitude, _destinationLatLng.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      }
    }

    PolylineId id = const PolylineId('route');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue.withOpacity(0.8),
      points: polylineCoordinates,
      width: 4,
    );
    _polylines[id] = polyline;
    notifyListeners();
  }

  Future<String> _getAddressFromPickUpMovement(LatLng latLng) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      googleMapApiKey: googleMapsApiKey,
    );
    return data.address;
  }

  void onCarPoolingClicked() async {
    _isCarPoolingEnabled = !_isCarPoolingEnabled;
    notifyListeners();
  }

  void onBookSwiftClicked() async {
    _showCarBookingLoadingView = true;
    notifyListeners();
    _rides = Rides(
      '',
      DateTime.now().millisecondsSinceEpoch,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      _distanceBetweenSourceAndDestination / 50 + 15,
      0,
      _distanceBetweenSourceAndDestination / 50,
      0,
      0,
      0,
      DateTime.now().millisecondsSinceEpoch +
          300000 +
          _timeTakenBetweenSourceAndDestination * 1000,
      0,
      0,
      0,
      _pickupLatLng.latitude,
      _pickupLatLng.longitude,
      _pickupAddress,
      _destinationLatLng.latitude,
      _destinationLatLng.longitude,
      _destinationAddress,
      0,
      0,
      '',
      0,
      0,
      '',
      _isCarPoolingEnabled,
      false,
      false,
      int.parse(_toleranceTimeController.text) * 60000,
      0,
      int.parse(_amountNeedToSaveController.text),
      0,
      false,
      false,
      false,
      '',
      '',
      _users,
      null,
      null,
    );
    await _riderBookingRepository
        .saveRideToDatabase(_rides!)
        .then((value) async {
      if (value.data != null) {
        _rides?.rideId = value.data as String;
        _loadingViewValues[0] = 1;
        _loadingViewValues[1] = null;
        _loadingViewText = 'Connecting with driver';
        notifyListeners();
        _riderBookingRepository.createContinuousConnectionBetweenDatabase(
          (_rides?.rideId)!,
          _streamController,
        );
        _streamSubscription = _streamController.stream.listen((value) async {
          if (value.data != null) {
            Rides rides1 = value.data as Rides;
            if (rides1.approvedRide1At != 0) {
              // todo sent to next screen with ride id and finish()
            }
            if (_loadingViewValues[0] == 1 && _loadingViewValues[2] == 0) {
              _loadingViewValues[1] = 1;
              _loadingViewText = 'Ride requested, locating your driver';
              if (_isCarPoolingEnabled) {
                _loadingViewValues[2] = null;
                notifyListeners();
                _sendRequestToSharedDriver(_rides!);
              } else {
                _loadingViewValues[2] = 1;
                _loadingViewValues[3] = null;
                notifyListeners();
                _sendRequestToFreeDriver(_rides!);
              }
            }
          }
        });
      }
    });
  }

  void _sendRequestToSharedDriver(Rides rides) async {
    await _riderBookingRepository
        .sendRideRequestForSharedDriver(rides)
        .then((value) async {
      _delayedFreeDriverCall = Timer(const Duration(seconds: 30), () {
        _loadingViewValues[2] = 1;
        _loadingViewValues[3] = null;
        notifyListeners();
        _sendRequestToFreeDriver(rides);
      });
    });
  }

  void _sendRequestToFreeDriver(Rides rides) async {
    await _riderBookingRepository
        .sendRideRequestForFreeDriver(rides)
        .then((value) async {
      if (value.data != null) {
        _delayedCancelButtonOption = Timer(const Duration(seconds: 30), () {
          _showCarBookingCancelButton = true;
          notifyListeners();
        });
      } else {
        _showCarBookingCancelButton = true;
        notifyListeners();
      }
    });
  }

  void onCancelRideClicked() async {
    showLoadingDialogBox(_context);
    await _riderBookingRepository
        .cancelRideByUser((_rides?.rideId)!)
        .then((value) async {
      Navigator.pop(_context);
      if (value.data != null) {
        _rides?.rideId = '';
        _streamSubscription?.cancel();
        _streamController.close();
        _streamController = StreamController<DataState>.broadcast();
        _delayedFreeDriverCall?.cancel();
        _delayedCancelButtonOption?.cancel();
        _rides = null;
        _loadingViewText = 'Confirming your ride';
        _loadingViewValues[0] = null;
        _loadingViewValues[1] = 0;
        _loadingViewValues[2] = 0;
        _loadingViewValues[3] = 0;
        _showCarBookingCancelButton = false;
        _showCarBookingLoadingView = false;
        notifyListeners();
      } else {
        showScaffoldMessenger(
          _context,
          'Something went wrong',
          errorStateColor,
        );
      }
    });
  }

  void disposeScreen() async {
    // todo need to call this
    _streamSubscription?.cancel();
    _streamController.close();
    _delayedFreeDriverCall?.cancel();
    _delayedCancelButtonOption?.cancel();
  }
}
