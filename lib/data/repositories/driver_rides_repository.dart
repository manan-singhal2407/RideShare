import 'dart:async';

import 'package:btp/data/cache/database/dao/driver_dao.dart';
import 'package:btp/domain/extension/model_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/enums/driver_shared_booking_enum.dart';
import '../../domain/repositories/i_driver_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/driver.dart';
import '../network/model/rides.dart';

// todo remove commented code

@Injectable(as: IDriverRidesRepository)
class DriverRidesRepository implements IDriverRidesRepository {
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> getRidesInfoFromDatabase(String rideId) async {
    Rides? rides;
    await _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .get()
        .then((value) async {
      rides = Rides.fromJson(value.data()!);
    });
    return DataState.success(rides);
  }

  @override
  void createContinuousConnectionWithSharingRide(
    StreamController<DataState<dynamic>> streamController,
  ) {
    _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .where('type', isEqualTo: 'sharing')
        // .where('requestedAt', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch - 300000)
        .orderBy('distance', descending: true)
        .limit(3)
        .snapshots()
        .listen((value) async {
      List<List<Object>> ridesDataList = [];
      for (int i = 0; i < value.docs.length; i++) {
        String rideId = (value.docs)[i]['request'];
        await _firebaseFirestore
            .collection('Rides')
            .doc(rideId)
            .get()
            .then((value1) async {
          ridesDataList.add([
            Rides.fromJson(value1.data()!),
            (value.docs)[i]['distance'],
            ((value.docs)[i]['fareForUser1'] + (value.docs)[i]['fareForUser2'])
          ]);
        });
      }
      streamController.add(DataState.success(ridesDataList));
    });
  }

  @override
  Future<DataState> onSelectSharedRide(
    String rideId,
    String requestRideId,
    String userUid,
  ) async {
    DriverSharedBookingEnum driverSharedBookingEnum =
        DriverSharedBookingEnum.error;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .doc(requestRideId)
        .get()
        .then((value) async {
      int fareForUser1 = ((value.data())!['fareForUser1'] as double).toInt();
      int fareForUser2 = ((value.data())!['fareForUser2'] as double).toInt();
      String mergePath = (value.data())!['mergePath'];
      await _firebaseFirestore
          .collection('Rides')
          .doc(requestRideId)
          .get()
          .then((value) async {
        Rides ridesRequest = Rides.fromJson(value.data()!);
        if (ridesRequest.driver != null) {
          driverSharedBookingEnum = DriverSharedBookingEnum.driverAccepted;
        } else if (ridesRequest.mergeRideId.isNotEmpty) {
          driverSharedBookingEnum = DriverSharedBookingEnum.alreadyMerged;
        } else {
          if (!ridesRequest.cancelledByUser) {
            await _firebaseFirestore
                .collection('Rides')
                .doc(requestRideId)
                .update({
              'mergeRideId': rideId,
              'mergeWithOtherRequest': true,
              'isRideOver': true,
            }).then((value) async {
              await _firebaseFirestore.collection('Rides').doc(rideId).update({
                'User2': ridesRequest.user1?.toJson(),
                'amountNeedToSaveForUser2':
                    ridesRequest.amountNeedToSaveForUser1,
                'approvedRide2At': DateTime.now().millisecondsSinceEpoch,
                'createdRide2At': ridesRequest.createdRide1At,
                'destinationUser2Address': ridesRequest.destinationUser1Address,
                'destinationUser2Latitude':
                    ridesRequest.destinationUser1Latitude,
                'destinationUser2Longitude':
                    ridesRequest.destinationUser1Longitude,
                'farePriceForUser1': fareForUser1,
                'farePriceForUser2': fareForUser2,
                'fareReceivedByDriver': fareForUser1 + fareForUser2,
                'idealTimeToDropUser2': ridesRequest.idealTimeToDropUser1,
                'initialFareForUser2': ridesRequest.initialFareForUser1,
                'isSharingOnByUser2': ridesRequest.isSharingOnByUser1,
                'mergePath': mergePath,
                'pickupUser2Address': ridesRequest.pickupUser1Address,
                'pickupUser2Latitude': ridesRequest.pickupUser1Latitude,
                'pickupUser2Longitude': ridesRequest.pickupUser1Longitude,
                'toleranceByUser2': ridesRequest.toleranceByUser1,
                'modeOfPaymentByUser2': ridesRequest.modeOfPaymentByUser1,
              }).then((value) async {
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
                driverSharedBookingEnum = DriverSharedBookingEnum.success;
              });
            });
          } else {
            driverSharedBookingEnum = DriverSharedBookingEnum.cancelledByUser;
          }
        }
      });
    });
    return DataState.success(driverSharedBookingEnum);
  }

  @override
  Future<DataState> onCancelSharedRide(
    String requestRideId,
    String userUid,
  ) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .doc(requestRideId)
        .delete()
        .then((value) async {
      await _firebaseFirestore
          .collection('Users')
          .doc(userUid)
          .collection('Request')
          .doc(_firebaseAuth.currentUser?.uid)
          .delete()
          .then((value) async {
        onSuccess = true;
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> updateRideInfo(
    String rideId,
    Map<String, Object> updateData,
    int totalFare,
    bool isRideOver,
    bool isRideShared,
  ) async {
    bool onSuccess = false;
    if (isRideOver) {
      updateData['isRideOver'] = true;
    }
    await _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .update(updateData)
        .then((value) async {
      if (isRideOver) {
        await _firebaseFirestore
            .collection('Driver')
            .doc(_firebaseAuth.currentUser?.uid)
            .get()
            .then((value) async {
          Driver driver = Driver.fromJson(value.data()!);
          driver.totalFare += totalFare;
          driver.totalRides += 1;
          driver.sharedRides += isRideShared ? 1 : 0;
          driver.currentRideId = '';
          await _firebaseFirestore
              .collection('Driver')
              .doc(_firebaseAuth.currentUser?.uid)
              .update(driver.toJson())
              .then((value) async {
            await _driverDao.insertDriverEntity(
              convertDriverToDriverEntity(
                driver,
              ),
            );
            onSuccess = true;
          });
        });
      } else {
        onSuccess = true;
      }
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
