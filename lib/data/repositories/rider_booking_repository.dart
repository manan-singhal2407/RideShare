import 'dart:async';

import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_rider_booking_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
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
  Future<DataState> saveRideToDatabase(Rides rides) async {
    bool onSuccess = false;
    String rideId = '';
    await _firebaseFirestore
        .collection('Rides')
        .add(rides.toJson())
        .then((ridesReference) async {
      await _firebaseFirestore
          .collection('Rides')
          .doc(ridesReference.id)
          .update({'rideId': ridesReference.id}).then(
              (documentReference) async {
        rideId = ridesReference.id;
        onSuccess = true;
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
        .collection('Driver')
        .where('isDrivingOn', isEqualTo: true)
        .where('isSharingOn', isEqualTo: true)
        .where('isSinglePersonInCar', isEqualTo: true)
        .where('isDoublePersonInCar', isEqualTo: false)
        .where('User1.isSharingOn', isEqualTo: true)
        .get()
        .then((value) async {
      List<Driver> driverList = [];
      List<Rides> ridesList = [];
      for (int i = 0; i < value.docs.length; i++) {
        Driver driver = Driver.fromJson(value.docs[i].data());
        driverList.add(driver);
        await _firebaseFirestore
            .collection('Driver')
            .doc(driver.currentRideId)
            .get()
            .then((value) async {
          Rides rides1 = Rides.fromJson(value.data()!);
          ridesList.add(rides1);
          if (rides1.reachedPickupUser1At == 0) {
            List<Location> locations = [
              Location(
                lat: rides.destinationUser1Latitude,
                lng: rides.destinationUser1Longitude,
              ),
              Location(
                lat: rides1.destinationUser1Latitude,
                lng: rides1.destinationUser1Longitude,
              ),
            ];
            List<Waypoint> waypoints = locations
                .map((location) => Waypoint.fromLocation(location))
                .toList();
            await getRouteInWaypoints(
              LatLng(
                rides1.driverLatitude,
                rides1.driverLongitude,
              ),
              LatLng(
                rides.pickupUser1Latitude,
                rides.pickupUser1Longitude,
              ),
              waypoints,
              null,
            ).then((route) {
              if (route != null) {

              }
            });
            // todo need to satisfy the basic waypoints query firstly
            // todo when driver didn't pickup user1
            // todo check for all 4 cases and whichever satisfies take the max overlap path
          } else {
            List<Location> locations = [
              Location(
                lat: rides.destinationUser1Latitude,
                lng: rides.destinationUser1Longitude,
              ),
              Location(
                lat: rides1.destinationUser1Latitude,
                lng: rides1.destinationUser1Longitude,
              ),
            ];
            List<Waypoint> waypoints = locations
                .map((location) => Waypoint.fromLocation(location))
                .toList();
            await getRouteInWaypoints(
              LatLng(
                rides.pickupUser1Latitude,
                rides.pickupUser1Longitude,
              ),
              LatLng(
                rides1.destinationUser1Latitude,
                rides1.destinationUser1Longitude,
              ),
              waypoints,
              null,
            ).then((route) {
              if (route != null) {

              }
            });
            // todo when driver has pickup user1
            // todo go to user 2 pickup location first

            // todo algo -> calculate total path covered by driver
          }
        });
      }

      onSuccess = true;
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
        .get()
        .then((value) async {
      List<Driver> driverList = [];
      List<double> driverDistanceList = [];
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
              .doc(rides.rideId)
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
}
