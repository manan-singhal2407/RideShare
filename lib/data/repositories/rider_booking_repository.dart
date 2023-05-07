import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_rider_booking_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../../presentation/extension/utils_extension.dart';
import '../cache/database/dao/users_dao.dart';
import '../cache/database/entities/users_entity.dart';
import '../network/model/driver.dart';
import '../network/model/rides.dart';
import '../network/model/users.dart';

@Injectable(as: IRiderBookingRepository)
class RiderBookingRepository implements IRiderBookingRepository {
  final UsersDao _usersDao = getIt<UsersDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> getUserDataFromLocalDatabase() async {
    UsersEntity? usersEntity;
    await _usersDao.getUsersEntityInfo().then((value) {
      if (value.isNotEmpty) {
        usersEntity = value[0];
      }
    });
    return DataState.success(usersEntity);
  }

  @override
  Future<DataState> getUserDataFromDatabase() async {
    Users? users;
    await _firebaseFirestore
        .collection('Users')
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((value) async {
      users = Users.fromJson(value.data()!);
      await _usersDao.insertUsersEntity(convertUsersToUsersEntity(users!));
    });
    return DataState.success(users);
  }

  @override
  Future<DataState> getRideInfoFromDatabase(String rideId) async {
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
  Future<DataState> saveRideToDatabase(Rides rides) async {
    bool onSuccess = false;
    String rideId = '';
    await _firebaseFirestore
        .collection('Rides')
        .add(rides.toJson())
        .then((ridesReference) async {
      rideId = ridesReference.id;
      await _firebaseFirestore
          .collection('Rides')
          .doc(rideId)
          .update({'rideId': rideId}).then((documentReference) async {
        await _firebaseFirestore
            .collection('Users')
            .doc(_firebaseAuth.currentUser?.uid)
            .update({'currentRideId': rideId}).then((documentReference) async {
          await _firebaseFirestore
              .collection('Users')
              .doc(_firebaseAuth.currentUser?.uid)
              .get()
              .then((value) async {
            await _usersDao.insertUsersEntity(
              convertUsersToUsersEntity(
                Users.fromJson(value.data()!),
              ),
            );
            onSuccess = true;
          });
        });
      });
    });
    if (onSuccess) {
      return DataState.success(rideId);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  void createContinuousConnectionBetweenDatabase(
    String rideId,
    StreamController<DataState<dynamic>> streamController,
  ) {
    _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .snapshots()
        .listen((value) async {
      streamController.add(DataState.success(Rides.fromJson(value.data()!)));
    });
  }

  @override
  Future<DataState> sendRideRequestForSharedDriver(Rides rides) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Rides')
        .where('isSharingOnByDriver', isEqualTo: true)
        .where('isSharingOnByUser1', isEqualTo: true)
        .where('isSharingOnByUser2', isEqualTo: false)
        .where('cancelledByUser', isEqualTo: false)
        .where('isRideOver', isEqualTo: false)
        .get()
        .then((value) async {
      List<Rides> ridesList = [];
      for (int i = 0; i < value.docs.length; i++) {
        Rides rides1 = Rides.fromJson(value.docs[i].data());
        ridesList.add(rides1);
        if (rides1.reachedPickupUser1At == 0) {
          await _checkIfRequestSendToDriverCase1(
            rides1,
            rides,
          ).then((value) async {
            if (value.data != null) {
              onSuccess = true;
            }
          });
        } else {
          await _checkIfRequestSendToDriverCase2(
            rides1,
            rides,
          ).then((value) async {
            if (value.data != null) {
              onSuccess = true;
            }
          });
        }
      }
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  Future<DataState> _checkIfRequestSendToDriverCase1(
    Rides ongoingRide,
    Rides rides,
  ) async {
    String mergePath = '';
    bool onSuccess = false;
    await getDistanceAndTimeBetweenSourceAndDestination(
      LatLng(
        ongoingRide.driverLatitude,
        ongoingRide.driverLongitude,
      ),
      LatLng(
        ongoingRide.pickupUser1Latitude,
        ongoingRide.pickupUser1Longitude,
      ),
    ).then((value1) async {
      await getDistanceAndTimeBetweenSourceAndDestination(
        LatLng(
          ongoingRide.driverLatitude,
          ongoingRide.driverLongitude,
        ),
        LatLng(
          rides.pickupUser1Latitude,
          rides.pickupUser1Longitude,
        ),
      ).then((value2) async {
        await getDistanceAndTimeBetweenSourceAndDestination(
          LatLng(
            ongoingRide.pickupUser1Latitude,
            ongoingRide.pickupUser1Longitude,
          ),
          LatLng(
            rides.pickupUser1Latitude,
            rides.pickupUser1Longitude,
          ),
        ).then((value3) async {
          await getDistanceAndTimeBetweenSourceAndDestination(
            LatLng(
              ongoingRide.pickupUser1Latitude,
              ongoingRide.pickupUser1Longitude,
            ),
            LatLng(
              ongoingRide.destinationUser1Latitude,
              ongoingRide.destinationUser1Longitude,
            ),
          ).then((value4) async {
            await getDistanceAndTimeBetweenSourceAndDestination(
              LatLng(
                ongoingRide.destinationUser1Latitude,
                ongoingRide.destinationUser1Longitude,
              ),
              LatLng(
                rides.destinationUser1Latitude,
                rides.destinationUser1Longitude,
              ),
            ).then((value5) async {
              await getDistanceAndTimeBetweenSourceAndDestination(
                LatLng(
                  ongoingRide.pickupUser1Latitude,
                  ongoingRide.pickupUser1Longitude,
                ),
                LatLng(
                  rides.destinationUser1Latitude,
                  rides.destinationUser1Longitude,
                ),
              ).then((value6) async {
                await getDistanceAndTimeBetweenSourceAndDestination(
                  LatLng(
                    rides.pickupUser1Latitude,
                    rides.pickupUser1Longitude,
                  ),
                  LatLng(
                    ongoingRide.destinationUser1Latitude,
                    ongoingRide.destinationUser1Longitude,
                  ),
                ).then((value7) async {
                  await getDistanceAndTimeBetweenSourceAndDestination(
                    LatLng(
                      rides.pickupUser1Latitude,
                      rides.pickupUser1Longitude,
                    ),
                    LatLng(
                      rides.destinationUser1Latitude,
                      rides.destinationUser1Longitude,
                    ),
                  ).then((value8) async {
                    double newFarePriceForUser1Case1 =
                        (value3[0] * 0.014) + (value7[0] * 0.014);
                    double newFarePriceForUser2Case1 = (value3[0] * 0.006) +
                        (value7[0] * 0.014) +
                        (value5[0] * 0.02);
                    double newFarePriceForUser1Case2 =
                        (value3[0] * 0.006) + (value4[0] * 0.014);
                    double newFarePriceForUser2Case2 = (value3[0] * 0.014) +
                        (value4[0] * 0.014) +
                        (value5[0] * 0.02);
                    double newFarePriceForUser1Case3 = (value3[0] * 0.014) +
                        (value8[0] * 0.014) +
                        (value5[0] * 0.02);
                    double newFarePriceForUser2Case3 =
                        (value3[0] * 0.006) + (value8[0] * 0.014);
                    double newFarePriceForUser1Case4 = (value3[0] * 0.006) +
                        (value6[0] * 0.014) +
                        (value5[0] * 0.02);
                    double newFarePriceForUser2Case4 =
                        (value3[0] * 0.014) + (value6[0] * 0.014);
                    bool toleranceConditionSatisfyForUser1Case1 =
                        ongoingRide.idealTimeToDropUser1 +
                                ongoingRide.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value1[1] * 1000) +
                                (value3[1] * 1000) +
                                (value7[1] * 1000);
                    bool toleranceConditionSatisfyForUser2Case1 =
                        rides.idealTimeToDropUser1 + rides.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value1[1] * 1000) +
                                (value3[1] * 1000) +
                                (value5[1] * 1000) +
                                (value7[1] * 1000);
                    bool toleranceConditionSatisfyForUser1Case2 =
                        ongoingRide.idealTimeToDropUser1 +
                                ongoingRide.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value2[1] * 1000) +
                                (value3[1] * 1000) +
                                (value4[1] * 1000);
                    bool toleranceConditionSatisfyForUser2Case2 =
                        rides.idealTimeToDropUser1 + rides.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value2[1] * 1000) +
                                (value3[1] * 1000) +
                                (value4[1] * 1000) +
                                (value5[1] * 1000);
                    bool toleranceConditionSatisfyForUser1Case3 =
                        ongoingRide.idealTimeToDropUser1 +
                                ongoingRide.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value1[1] * 1000) +
                                (value3[1] * 1000) +
                                (value5[1] * 1000) +
                                (value8[1] * 1000);
                    bool toleranceConditionSatisfyForUser2Case3 =
                        rides.idealTimeToDropUser1 + rides.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value1[1] * 1000) +
                                (value3[1] * 1000) +
                                (value8[1] * 1000);
                    bool toleranceConditionSatisfyForUser1Case4 =
                        ongoingRide.idealTimeToDropUser1 +
                                ongoingRide.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value2[1] * 1000) +
                                (value3[1] * 1000) +
                                (value5[1] * 1000) +
                                (value6[1] * 1000);
                    bool toleranceConditionSatisfyForUser2Case4 =
                        rides.idealTimeToDropUser1 + rides.toleranceByUser1 >
                            DateTime.now().millisecondsSinceEpoch +
                                (value2[1] * 1000) +
                                (value3[1] * 1000) +
                                (value6[1] * 1000);
                    bool amountConditionSatisfyForUser1Case1 =
                        ongoingRide.initialFareForUser1 -
                                newFarePriceForUser1Case1 >
                            ongoingRide.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser2Case1 =
                        rides.initialFareForUser1 - newFarePriceForUser2Case1 >
                            rides.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser1Case2 =
                        ongoingRide.initialFareForUser1 -
                                newFarePriceForUser1Case2 >
                            ongoingRide.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser2Case2 =
                        rides.initialFareForUser1 - newFarePriceForUser2Case2 >
                            rides.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser1Case3 =
                        ongoingRide.initialFareForUser1 -
                                newFarePriceForUser1Case3 >
                            ongoingRide.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser2Case3 =
                        rides.initialFareForUser1 - newFarePriceForUser2Case3 >
                            rides.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser1Case4 =
                        ongoingRide.initialFareForUser1 -
                                newFarePriceForUser1Case4 >
                            ongoingRide.amountNeedToSaveForUser1;
                    bool amountConditionSatisfyForUser2Case4 =
                        rides.initialFareForUser1 - newFarePriceForUser2Case4 >
                            rides.amountNeedToSaveForUser1;
                    int minIndex = -1;
                    double minValue = 10000000;
                    if (toleranceConditionSatisfyForUser1Case1 &&
                        toleranceConditionSatisfyForUser2Case1 &&
                        amountConditionSatisfyForUser1Case1 &&
                        amountConditionSatisfyForUser2Case1) {
                      if (newFarePriceForUser1Case1 +
                              newFarePriceForUser2Case1 <=
                          minValue) {
                        minIndex = 0;
                        minValue = newFarePriceForUser1Case1 +
                            newFarePriceForUser2Case1;
                        mergePath = '1234';
                      }
                    }
                    if (toleranceConditionSatisfyForUser1Case2 &&
                        toleranceConditionSatisfyForUser2Case2 &&
                        amountConditionSatisfyForUser1Case2 &&
                        amountConditionSatisfyForUser2Case2) {
                      if (newFarePriceForUser1Case2 +
                              newFarePriceForUser2Case2 <=
                          minValue) {
                        minIndex = 1;
                        minValue = newFarePriceForUser1Case2 +
                            newFarePriceForUser2Case2;
                        mergePath = '2134';
                      }
                    }
                    if (toleranceConditionSatisfyForUser1Case3 &&
                        toleranceConditionSatisfyForUser2Case3 &&
                        amountConditionSatisfyForUser1Case3 &&
                        amountConditionSatisfyForUser2Case3) {
                      if (newFarePriceForUser1Case3 +
                              newFarePriceForUser2Case3 <=
                          minValue) {
                        minIndex = 2;
                        minValue = newFarePriceForUser1Case3 +
                            newFarePriceForUser2Case3;
                        mergePath = '1243';
                      }
                    }
                    if (toleranceConditionSatisfyForUser1Case4 &&
                        toleranceConditionSatisfyForUser2Case4 &&
                        amountConditionSatisfyForUser1Case4 &&
                        amountConditionSatisfyForUser2Case4) {
                      if (newFarePriceForUser1Case4 +
                              newFarePriceForUser2Case4 <=
                          minValue) {
                        minIndex = 3;
                        minValue = newFarePriceForUser1Case4 +
                            newFarePriceForUser2Case4;
                        mergePath = '2143';
                      }
                    }
                    if (minIndex != -1) {
                      await _firebaseFirestore
                          .collection('Users')
                          .doc(_firebaseAuth.currentUser?.uid)
                          .collection('Request')
                          .doc(ongoingRide.driver?.driverUid)
                          .set({
                        'driverUid': ongoingRide.driver?.driverUid,
                        'type': 'sharing',
                        'requestedAt': DateTime.now().millisecondsSinceEpoch,
                      });
                      await _firebaseFirestore
                          .collection('Driver')
                          .doc(ongoingRide.driver?.driverUid)
                          .collection('Request')
                          .doc(rides.rideId)
                          .set({
                        'request': rides.rideId,
                        'type': 'sharing',
                        'distance': minIndex == 0
                            ? value7[0] ~/ 1000
                            : minIndex == 1
                            ? value4[0] ~/ 1000
                            : minIndex == 2
                            ? value8[0] ~/ 1000
                            : value6[0] ~/ 1000,
                        'requestedAt': DateTime.now().millisecondsSinceEpoch,
                        'fareForUser1': minIndex == 0
                            ? newFarePriceForUser1Case1
                            : minIndex == 1
                            ? newFarePriceForUser1Case2
                            : minIndex == 2
                            ? newFarePriceForUser1Case3
                            : newFarePriceForUser1Case4,
                        'fareForUser2': minIndex == 0
                            ? newFarePriceForUser2Case1
                            : minIndex == 1
                            ? newFarePriceForUser2Case2
                            : minIndex == 2
                            ? newFarePriceForUser2Case3
                            : newFarePriceForUser2Case4,
                        'mergePath': mergePath,
                      }).then((value) {
                        onSuccess = true;
                      });
                    }
                  });
                });
              });
            });
          });
        });
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  Future<DataState> _checkIfRequestSendToDriverCase2(
    Rides ongoingRide,
    Rides rides,
  ) async {
    List<double> newFarePrice = [0, 0];
    bool onSuccess = false;
    await getDistanceAndTimeBetweenSourceAndDestination(
      LatLng(
        ongoingRide.pickupUser1Latitude,
        ongoingRide.pickupUser1Longitude,
      ),
      LatLng(
        ongoingRide.driverLatitude,
        ongoingRide.driverLongitude,
      ),
    ).then((value1) async {
      await getDistanceAndTimeBetweenSourceAndDestination(
        LatLng(
          ongoingRide.driverLatitude,
          ongoingRide.driverLongitude,
        ),
        LatLng(
          rides.pickupUser1Latitude,
          rides.pickupUser1Longitude,
        ),
      ).then((value2) async {
        await getDistanceAndTimeBetweenSourceAndDestination(
          LatLng(
            rides.pickupUser1Latitude,
            rides.pickupUser1Longitude,
          ),
          LatLng(
            ongoingRide.destinationUser1Latitude,
            ongoingRide.destinationUser1Longitude,
          ),
        ).then((value3) async {
          await getDistanceAndTimeBetweenSourceAndDestination(
            LatLng(
              ongoingRide.destinationUser1Latitude,
              ongoingRide.destinationUser1Longitude,
            ),
            LatLng(
              rides.destinationUser1Latitude,
              rides.destinationUser1Longitude,
            ),
          ).then((value4) async {
            bool toleranceConditionSatisfyForUser1 =
                ongoingRide.idealTimeToDropUser1 +
                        ongoingRide.toleranceByUser1 >
                    DateTime.now().millisecondsSinceEpoch +
                        (value2[1] * 1000) +
                        (value3[1] * 1000);
            bool toleranceConditionSatisfyForUser2 =
                rides.idealTimeToDropUser1 + rides.toleranceByUser1 >
                    DateTime.now().millisecondsSinceEpoch +
                        (value2[1] * 1000) +
                        (value3[1] * 1000) +
                        (value4[1] * 1000);
            double newFarePriceForUser1 =
                (value1[0] * 0.02) + ((value2[0] + value3[0]) * 0.014);
            double newFarePriceForUser2 =
                (value2[0] * 0.006) + (value3[0] * 0.014) + (value4[0] * 0.02);
            bool amountConditionSatisfyForUser1 =
                ongoingRide.initialFareForUser1 - newFarePriceForUser1 >
                    ongoingRide.amountNeedToSaveForUser1;
            bool amountConditionSatisfyForUser2 =
                rides.initialFareForUser1 - newFarePriceForUser2 >
                    rides.amountNeedToSaveForUser1;
            if (toleranceConditionSatisfyForUser1 &&
                toleranceConditionSatisfyForUser2 &&
                amountConditionSatisfyForUser1 &&
                amountConditionSatisfyForUser2) {
              newFarePrice[0] = newFarePriceForUser1;
              newFarePrice[1] = newFarePriceForUser2;
              await _firebaseFirestore
                  .collection('Users')
                  .doc(_firebaseAuth.currentUser?.uid)
                  .collection('Request')
                  .doc(ongoingRide.driver?.driverUid)
                  .set({
                'driverUid': ongoingRide.driver?.driverUid,
                'type': 'sharing',
                'requestedAt': DateTime.now().millisecondsSinceEpoch,
              });
              await _firebaseFirestore
                  .collection('Driver')
                  .doc(ongoingRide.driver?.driverUid)
                  .collection('Request')
                  .doc(rides.rideId)
                  .set({
                'request': rides.rideId,
                'type': 'sharing',
                'distance': value3[0] ~/ 1000,
                'requestedAt': DateTime.now().millisecondsSinceEpoch,
                'fareForUser1': newFarePrice[0],
                'fareForUser2': newFarePrice[1],
                'mergePath': '34',
              }).then((value) {
                onSuccess = true;
              });
            } else {
              await getDistanceAndTimeBetweenSourceAndDestination(
                LatLng(
                  rides.pickupUser1Latitude,
                  rides.pickupUser1Longitude,
                ),
                LatLng(
                  rides.destinationUser1Latitude,
                  rides.destinationUser1Longitude,
                ),
              ).then((value3) async {
                await getDistanceAndTimeBetweenSourceAndDestination(
                  LatLng(
                    rides.destinationUser1Latitude,
                    rides.destinationUser1Longitude,
                  ),
                  LatLng(
                    ongoingRide.destinationUser1Latitude,
                    ongoingRide.destinationUser1Longitude,
                  ),
                ).then((value4) async {
                  bool toleranceConditionSatisfyForUser1 =
                      ongoingRide.idealTimeToDropUser1 +
                              ongoingRide.toleranceByUser1 >
                          DateTime.now().millisecondsSinceEpoch +
                              (value2[1] * 1000) +
                              (value3[1] * 1000) +
                              (value4[1] * 1000);
                  bool toleranceConditionSatisfyForUser2 =
                      rides.idealTimeToDropUser1 + rides.toleranceByUser1 >
                          DateTime.now().millisecondsSinceEpoch +
                              (value2[1] * 1000) +
                              (value3[1] * 1000);
                  double newFarePriceForUser1 = (value1[0] * 0.02) +
                      ((value2[0] + value3[0]) * 0.014) +
                      (value4[0] * 0.02);
                  double newFarePriceForUser2 =
                      (value2[0] * 0.006) + (value3[0] * 0.014);
                  bool amountConditionSatisfyForUser1 =
                      ongoingRide.initialFareForUser1 - newFarePriceForUser1 >
                          ongoingRide.amountNeedToSaveForUser1;
                  bool amountConditionSatisfyForUser2 =
                      rides.initialFareForUser1 - newFarePriceForUser2 >
                          rides.amountNeedToSaveForUser1;
                  if (toleranceConditionSatisfyForUser1 &&
                      toleranceConditionSatisfyForUser2 &&
                      amountConditionSatisfyForUser1 &&
                      amountConditionSatisfyForUser2) {
                    newFarePrice[0] = newFarePriceForUser1;
                    newFarePrice[1] = newFarePriceForUser2;
                    await _firebaseFirestore
                        .collection('Users')
                        .doc(_firebaseAuth.currentUser?.uid)
                        .collection('Request')
                        .doc(ongoingRide.driver?.driverUid)
                        .set({
                      'driverUid': ongoingRide.driver?.driverUid,
                      'type': 'sharing',
                      'requestedAt': DateTime.now().millisecondsSinceEpoch,
                    });
                    await _firebaseFirestore
                        .collection('Driver')
                        .doc(ongoingRide.driver?.driverUid)
                        .collection('Request')
                        .doc(rides.rideId)
                        .set({
                      'request': rides.rideId,
                      'type': 'sharing',
                      'distance': value3[0] ~/ 1000,
                      'requestedAt': DateTime.now().millisecondsSinceEpoch,
                      'fareForUser1': newFarePrice[0],
                      'fareForUser2': newFarePrice[1],
                      'mergePath': '43',
                    }).then((value) {
                      onSuccess = true;
                    });
                  }
                });
              });
            }
          });
        });
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> sendRideRequestForFreeDriver(Rides rides) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .where('isDrivingOn', isEqualTo: true)
        .where('isSinglePersonInCar', isEqualTo: false)
        .where('cancelledByUser', isEqualTo: false)
        .get()
        .then((value) async {
      List<Driver> driverList = [];
      List<double> driverDistanceList = [];
      if (value.docs.isEmpty) {
        onSuccess = true;
      }
      for (int i = 0; i < value.docs.length; i++) {
        driverList.add(Driver.fromJson(value.docs[i].data()));
        await getDistanceAndTimeBetweenSourceAndDestination(
          LatLng(
            driverList[i].currentLatitude,
            driverList[i].currentLongitude,
          ),
          LatLng(
            rides.pickupUser1Latitude,
            rides.pickupUser1Longitude,
          ),
        ).then((value) {
          driverDistanceList.add(value[0]);
        });
      }

      List<MapEntry<int, double>> sortedList = driverDistanceList
          .asMap()
          .entries
          .toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      List<MapEntry<int, double>> top10MinValues = sortedList.take(5).toList();
      for (int i = 0; i < top10MinValues.length; i++) {
        if (top10MinValues[i].value < 3000) {
          await _firebaseFirestore
              .collection('Users')
              .doc(_firebaseAuth.currentUser?.uid)
              .collection('Request')
              .doc(driverList[top10MinValues[i].key].driverUid)
              .set({
            'driverUid': driverList[top10MinValues[i].key].driverUid,
            'type': 'single',
            'requestedAt': DateTime.now().millisecondsSinceEpoch,
          });
          await _firebaseFirestore
              .collection('Driver')
              .doc(driverList[top10MinValues[i].key].driverUid)
              .collection('Request')
              .doc(rides.rideId)
              .set({
            'request': rides.rideId,
            'type': 'single',
            'distance': top10MinValues[i].value,
            'requestedAt': DateTime.now().millisecondsSinceEpoch,
            'fareForUser1': 0,
            'fareForUser2': 0,
            'mergePath': '',
          }).then((value) {
            onSuccess = true;
          });
        }
      }
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> cancelRideByUser(String rideId) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .update({'cancelledByUser': true}).then((value) async {
      await _firebaseFirestore
          .collection('Users')
          .doc(_firebaseAuth.currentUser?.uid)
          .collection('Request')
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          onSuccess = true;
        }
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
              .doc(_firebaseAuth.currentUser?.uid)
              .collection('Request')
              .doc(driverUid)
              .delete()
              .then((value) {
            onSuccess = true;
          });
        }
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
