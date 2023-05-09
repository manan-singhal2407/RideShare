import 'dart:async';

import 'package:flutter/material.dart';
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
import '../../../theme/widgets/loading.dart';
import '../rider_rides/arguments/rider_rides_screen_arguments.dart';

class RiderBookingViewModel extends ChangeNotifier {
  final IRiderBookingRepository _riderBookingRepository =
      getIt<IRiderBookingRepository>();

  final BuildContext _context;
  final String _rideId;
  bool _isSharingOn;
  int _tolerance;
  int _amountNeedToSave;
  LatLng _pickupLatLng;
  LatLng _destinationLatLng;

  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  Marker? _sourcePosition, _destinationPosition;

  double _distanceBetweenSourceAndDestination = -100;
  double _timeTakenBetweenSourceAndDestination = -100;
  String _pickupAddress = 'Loading...';
  String _destinationAddress = 'Loading...';

  bool _isLoadingRideInfo = false;
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
    this._rideId,
    this._isSharingOn,
    this._tolerance,
    this._amountNeedToSave,
    this._pickupLatLng,
    this._destinationLatLng,
  ) {
    _getDataFromLocalDatabase();
    _getDataFromDatabase();
    if (_rideId.isNotEmpty) {
      _isLoadingRideInfo = true;
      _showCarBookingLoadingView = true;
      _loadingViewValues[0] = 0;
      _getRideInfoFromRideId();
    } else {
      _isCarPoolingEnabled = _isSharingOn;
      _toleranceTimeController.text = (_tolerance / 60).toString();
      _amountNeedToSaveController.text = _amountNeedToSave.toString();
      _initiateFunction();
    }
  }

  bool get isLoadingRideInfo => _isLoadingRideInfo;

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

  void _getRideInfoFromRideId() async {
    await _riderBookingRepository
        .getRideInfoFromDatabase(_rideId)
        .then((value) {
      if (value.data != null) {
        Rides rides = value.data as Rides;
        _rides = rides;
        _isLoadingRideInfo = false;
        if (rides.driver != null) {
          Navigator.pushReplacementNamed(
            _context,
            '/rider_rides_screen',
            arguments: RiderRidesScreenArguments(
              rides.mergeWithOtherRequest ? rides.mergeRideId : rides.rideId,
            ),
          );
        } else {
          _pickupLatLng = LatLng(
            rides.pickupUser1Latitude,
            rides.pickupUser1Longitude,
          );
          _destinationLatLng = LatLng(
            rides.destinationUser1Latitude,
            rides.destinationUser1Longitude,
          );
          _isSharingOn = rides.isSharingOnByUser1;
          _tolerance = rides.toleranceByUser1.toInt();
          _amountNeedToSave = rides.amountNeedToSaveForUser1.toInt();
          _initiateFunction();
          _createConnectionBetweenDatabase();
        }
      }
    });
  }

  void _initiateFunction() async {
    _sourcePosition = Marker(
      markerId: const MarkerId('source'),
      position: _pickupLatLng,
      icon: BitmapDescriptor.fromBytes(
        await getUint8ListImages(
          'assets/images/ic_marker_pickup.png',
          100,
        ),
      ),
    );
    _destinationPosition = Marker(
      markerId: const MarkerId('destination'),
      position: _destinationLatLng,
      icon: BitmapDescriptor.fromBytes(
        await getUint8ListImages(
          'assets/images/ic_marker_destination.png',
          100,
        ),
      ),
    );
    _getDistanceAndTimeBetweenSourceAndDestination();
    _getPolylinesBetweenSourceAndDestination();
    await getAddressFromLatLng(_pickupLatLng).then((value) {
      _pickupAddress = value;
    });
    await getAddressFromLatLng(_destinationLatLng).then((value) {
      _destinationAddress = value;
    });
  }

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
      _pickupLatLng,
      _destinationLatLng,
    ).then((value) {
      _distanceBetweenSourceAndDestination = value[0];
      _timeTakenBetweenSourceAndDestination = value[1];
      notifyListeners();
    });
  }

  void _getPolylinesBetweenSourceAndDestination() async {
    await getPolylineBetweenTwoPoints(
      _pickupLatLng,
      _destinationLatLng,
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
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
      (_distanceBetweenSourceAndDestination / 50) + 15,
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
      0,
      0,
      'Cash',
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
        _createConnectionBetweenDatabase();
      }
    });
  }

  void _createConnectionBetweenDatabase() {
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
        if (rides1.approvedRide1At != 0 || rides1.mergeRideId.isNotEmpty) {
          Navigator.pushReplacementNamed(
            _context,
            '/rider_rides_screen',
            arguments: RiderRidesScreenArguments(
              rides1.mergeWithOtherRequest ? rides1.mergeRideId : rides1.rideId,
            ),
          );
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

  void _sendRequestToSharedDriver(Rides rides) async {
    await _riderBookingRepository
        .sendRideRequestForSharedDriver(rides)
        .then((value) async {
      _delayedFreeDriverCall = Timer(const Duration(seconds: 5), () {
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
        _delayedCancelButtonOption = Timer(const Duration(seconds: 5), () {
          _showCarBookingCancelButton = true;
          notifyListeners();
        });
      } else {
        _showCarBookingCancelButton = true;
        notifyListeners();
        showScaffoldMessenger(
          _context,
          'Something went wrong',
          errorStateColor,
        );
      }
    }).onError((error, stackTrace) {
      _showCarBookingCancelButton = true;
      notifyListeners();
      showScaffoldMessenger(
        _context,
        'Something went wrong',
        errorStateColor,
      );
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
    }).onError((error, stackTrace) {
      showScaffoldMessenger(
        _context,
        'Something went wrong',
        errorStateColor,
      );
    });
  }

  void disposeScreen() async {
    _streamSubscription?.cancel();
    _streamController.close();
    _delayedFreeDriverCall?.cancel();
    _delayedCancelButtonOption?.cancel();
  }
}
