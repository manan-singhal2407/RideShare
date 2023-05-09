import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_driver_ride_request_detail_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/driver_dao.dart';
import '../network/model/driver.dart';
import '../network/model/rides.dart';

@Injectable(as: IDriverRideRequestDetailRepository)
class DriverRideRequestDetailRepository
    implements IDriverRideRequestDetailRepository {
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> acceptRideRequest(String rideId, String userUid) async {
    Rides? ridesData;
    bool onRideExists = false;
    await _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .get()
        .then((value) async {
      Rides rides = Rides.fromJson(value.data()!);
      if (rides.driver == null && !rides.cancelledByUser) {
        await _firebaseFirestore
            .collection('Driver')
            .doc(_firebaseAuth.currentUser?.uid)
            .update({
          'isSinglePersonInCar': true,
          'currentRideId': rideId,
        }).then((value) async {
          await _firebaseFirestore
              .collection('Driver')
              .doc(_firebaseAuth.currentUser?.uid)
              .get()
              .then((value) async {
            Driver driver = Driver.fromJson(value.data()!);
            await _firebaseFirestore.collection('Rides').doc(rideId).update({
              'Driver': driver.toJson(),
              'approvedRide1At': DateTime.now().millisecondsSinceEpoch,
              'driverLatitude': driver.currentLatitude,
              'driverLongitude': driver.currentLongitude,
              'isSharingOnByDriver': driver.isSharingOn,
            }).then((value) async {
              await _firebaseFirestore
                  .collection('Rides')
                  .doc(rideId)
                  .get()
                  .then((value) async {
                ridesData = Rides.fromJson(value.data()!);
                await _driverDao.insertDriverEntity(
                  convertDriverToDriverEntity(driver),
                );
                await _firebaseFirestore
                    .collection('Users')
                    .doc(userUid)
                    .collection('Request')
                    .get()
                    .then((value) async {
                  for (int i = 0; i < value.docs.length; i++) {
                    String driverUid = (value.docs)[i]['driverUid'];
                    await _firebaseFirestore
                        .collection('Driver')
                        .doc(driverUid)
                        .collection('Request')
                        .doc(rideId)
                        .delete();
                    await _firebaseFirestore
                        .collection('Users')
                        .doc(userUid)
                        .collection('Request')
                        .doc(driverUid)
                        .delete();
                  }
                });
              });
            });
          });
        });
      } else {
        onRideExists = true;
      }
    });
    if (!onRideExists) {
      return DataState.success(ridesData);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> removeRejectedRideRequest(
    String rideId,
    String userUid,
  ) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Users')
        .doc(userUid)
        .collection('Request')
        .doc(_firebaseAuth.currentUser?.uid)
        .delete();
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
