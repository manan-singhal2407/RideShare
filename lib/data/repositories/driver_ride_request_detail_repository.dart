import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_driver_ride_request_detail_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/rides.dart';

@Injectable(as: IDriverRideRequestDetailRepository)
class DriverRideRequestDetailRepository
    implements IDriverRideRequestDetailRepository {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> acceptRideRequest(String rideId) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .doc(rideId)
        .delete()
        .then((value) async {
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> removeRejectedRideRequest(String rideId) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .doc(rideId)
        .delete()
        .then((value) async {
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
