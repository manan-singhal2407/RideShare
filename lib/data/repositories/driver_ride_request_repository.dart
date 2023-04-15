import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_driver_ride_request_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/rides.dart';

@Injectable(as: IDriverRideRequestRepository)
class DriverRideRequestRepository implements IDriverRideRequestRepository {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  void loadDriverRequestedRides(streamController) {
    _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .snapshots()
        .listen((value) async {
      List<Rides> ridesList = [];
      for (int i = 0; i < value.docs.length; i++) {
        String rideId = (value.docs)[i]['request'];
        await _firebaseFirestore
            .collection('Rides')
            .doc(rideId)
            .get()
            .then((value) async {
          ridesList.add(Rides.fromJson(value.data()!));
        });
      }
      streamController.add(DataState.success(ridesList));
    });
  }
}
