import 'package:flutter/material.dart';

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_driver_my_rides_repository.dart';
import '../../../base/injectable.dart';

class DriverMyRidesViewModel extends ChangeNotifier {
  final IDriverMyRidesRepository _driverMyRidesRepository =
      getIt<IDriverMyRidesRepository>();

  final BuildContext _context;

  bool _isLoadingData = true;
  List<Rides> _ridesList = [];

  DriverMyRidesViewModel(this._context) {
    retrievePreviousRidesFromQuery();
  }

  bool get isLoadingData => _isLoadingData;

  List<Rides> get ridesList => _ridesList;

  void retrievePreviousRidesFromQuery() async {
    await _driverMyRidesRepository
        .retrievePreviousRidesFromQuery()
        .then((value) {
      if (value.data != null) {
        _isLoadingData = false;
        _ridesList = value.data as List<Rides>;
        notifyListeners();
      }
    });
  }
}
