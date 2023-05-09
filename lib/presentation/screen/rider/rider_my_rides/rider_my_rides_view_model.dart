import 'package:flutter/material.dart';

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_rider_my_rides_repository.dart';
import '../../../base/injectable.dart';

class RiderMyRidesViewModel extends ChangeNotifier {
  final IRiderMyRidesRepository _riderMyRidesRepository =
      getIt<IRiderMyRidesRepository>();

  bool _isLoadingData = true;
  List<List<Object>> _ridesList = [];

  RiderMyRidesViewModel() {
    retrievePreviousRidesFromQuery();
  }

  bool get isLoadingData => _isLoadingData;

  List<List<Object>> get ridesList => _ridesList;

  void retrievePreviousRidesFromQuery() async {
    await _riderMyRidesRepository
        .retrievePreviousRidesFromQuery()
        .then((value) {
      if (value.data != null) {
        _isLoadingData = false;
        _ridesList = value.data as List<List<Object>>;
        notifyListeners();
      }
    });
  }
}
