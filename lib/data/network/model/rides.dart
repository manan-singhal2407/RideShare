import 'driver.dart';
import 'users.dart';

class Rides {
  late String rideId;
  late num createdRide1At;
  late num createdRide2At;
  late num approvedRide1At;
  late num approvedRide2At;
  late num reachedPickupUser1At;
  late num reachedPickupUser2At;
  late num reachedDestinationUser1At;
  late num reachedDestinationUser2At;
  late num farePriceForUser1;
  late num farePriceForUser2;
  late num fareReceivedByDriver;
  late double driverLatitude;
  late double driverLongitude;
  late double pickupUser1Latitude;
  late double pickupUser1Longitude;
  late String pickupUser1Address;
  late double destinationUser1Latitude;
  late double destinationUser1Longitude;
  late String destinationUser1Address;
  late double pickupUser2Latitude;
  late double pickupUser2Longitude;
  late String pickupUser2Address;
  late double destinationUser2Latitude;
  late double destinationUser2Longitude;
  late String destinationUser2Address;
  late bool isSharingOnByUser1;
  late bool isSharingOnByUser2;
  late bool isSharingOnByDriver;
  late num toleranceByUser1;
  late num toleranceByUser2;
  late num amountNeedToSaveForUser1;
  late num amountNeedToSaveForUser2;
  late bool cancelledByUser;
  late bool mergeWithOtherRequest;
  late String mergeRideId;
  late Users? user1;
  late Users? user2;
  late Driver? driver;

  Rides(
    this.rideId,
    this.createdRide1At,
    this.createdRide2At,
    this.approvedRide1At,
    this.approvedRide2At,
    this.reachedPickupUser1At,
    this.reachedPickupUser2At,
    this.reachedDestinationUser1At,
    this.reachedDestinationUser2At,
    this.farePriceForUser1,
    this.farePriceForUser2,
    this.fareReceivedByDriver,
    this.driverLatitude,
    this.driverLongitude,
    this.pickupUser1Latitude,
    this.pickupUser1Longitude,
    this.pickupUser1Address,
    this.destinationUser1Latitude,
    this.destinationUser1Longitude,
    this.destinationUser1Address,
    this.pickupUser2Latitude,
    this.pickupUser2Longitude,
    this.pickupUser2Address,
    this.destinationUser2Latitude,
    this.destinationUser2Longitude,
    this.destinationUser2Address,
    this.isSharingOnByUser1,
    this.isSharingOnByUser2,
    this.isSharingOnByDriver,
    this.toleranceByUser1,
    this.toleranceByUser2,
    this.amountNeedToSaveForUser1,
    this.amountNeedToSaveForUser2,
    this.cancelledByUser,
    this.mergeWithOtherRequest,
    this.mergeRideId,
    this.user1,
    this.user2,
    this.driver,
  );

  Rides.fromJson(Map<String, dynamic> map) {
    rideId = map['rideId'];
    createdRide1At = map['createdRide1At'];
    createdRide2At = map['createdRide2At'];
    approvedRide1At = map['approvedRide1At'];
    approvedRide2At = map['approvedRide2At'];
    reachedPickupUser1At = map['reachedPickupUser1At'];
    reachedPickupUser2At = map['reachedPickupUser2At'];
    reachedDestinationUser1At = map['reachedDestinationUser1At'];
    reachedDestinationUser2At = map['reachedDestinationUser2At'];
    farePriceForUser1 = map['farePriceForUser1'];
    farePriceForUser2 = map['farePriceForUser2'];
    fareReceivedByDriver = map['fareReceivedByDriver'];
    driverLatitude = map['driverLatitude'];
    driverLongitude = map['driverLongitude'];
    pickupUser1Latitude = map['pickupUser1Latitude'];
    pickupUser1Longitude = map['pickupUser1Longitude'];
    pickupUser1Address = map['pickupUser1Address'];
    destinationUser1Latitude = map['destinationUser1Latitude'];
    destinationUser1Longitude = map['destinationUser1Longitude'];
    destinationUser1Address = map['destinationUser1Address'];
    pickupUser2Latitude = map['pickupUser2Latitude'];
    pickupUser2Longitude = map['pickupUser2Longitude'];
    pickupUser2Address = map['pickupUser2Address'];
    destinationUser2Latitude = map['destinationUser2Latitude'];
    destinationUser2Longitude = map['destinationUser2Longitude'];
    destinationUser2Address = map['destinationUser2Address'];
    isSharingOnByUser1 = map['isSharingOnByUser1'];
    isSharingOnByUser2 = map['isSharingOnByUser2'];
    isSharingOnByDriver = map['isSharingOnByDriver'];
    toleranceByUser1 = map['toleranceByUser1'];
    toleranceByUser2 = map['toleranceByUser2'];
    amountNeedToSaveForUser1 = map['amountNeedToSaveForUser1'];
    amountNeedToSaveForUser2 = map['amountNeedToSaveForUser2'];
    cancelledByUser = map['cancelledByUser'];
    mergeWithOtherRequest = map['mergeWithOtherRequest'];
    mergeRideId = map['mergeRideId'];
    user1 = Users.fromJson(map['User1'] as Map<String, dynamic>);
    user2 = map['User2'] != null
        ? Users.fromJson(map['User2'] as Map<String, dynamic>)
        : null;
    driver = map['Driver'] != null
        ? Driver.fromJson(map['Driver'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'createdRide1At': createdRide1At,
      'createdRide2At': createdRide2At,
      'approvedRide1At': approvedRide1At,
      'approvedRide2At': approvedRide2At,
      'reachedPickupUser1At': reachedPickupUser1At,
      'reachedPickupUser2At': reachedPickupUser2At,
      'reachedDestinationUser1At': reachedDestinationUser1At,
      'reachedDestinationUser2At': reachedDestinationUser2At,
      'farePriceForUser1': farePriceForUser1,
      'farePriceForUser2': farePriceForUser2,
      'fareReceivedByDriver': fareReceivedByDriver,
      'driverLatitude': driverLatitude,
      'driverLongitude': driverLongitude,
      'pickupUser1Latitude': pickupUser1Latitude,
      'pickupUser1Longitude': pickupUser1Longitude,
      'pickupUser1Address': pickupUser1Address,
      'destinationUser1Latitude': destinationUser1Latitude,
      'destinationUser1Longitude': destinationUser1Longitude,
      'destinationUser1Address': destinationUser1Address,
      'pickupUser2Latitude': pickupUser2Latitude,
      'pickupUser2Longitude': pickupUser2Longitude,
      'pickupUser2Address': pickupUser2Address,
      'destinationUser2Latitude': destinationUser2Latitude,
      'destinationUser2Longitude': destinationUser2Longitude,
      'destinationUser2Address': destinationUser2Address,
      'isSharingOnByUser1': isSharingOnByUser1,
      'isSharingOnByUser2': isSharingOnByUser2,
      'isSharingOnByDriver': isSharingOnByDriver,
      'toleranceByUser1': toleranceByUser1,
      'toleranceByUser2': toleranceByUser2,
      'amountNeedToSaveForUser1': amountNeedToSaveForUser1,
      'amountNeedToSaveForUser2': amountNeedToSaveForUser2,
      'cancelledByUser': cancelledByUser,
      'mergeWithOtherRequest': mergeWithOtherRequest,
      'mergeRideId': mergeRideId,
      'User1': user1?.toJson(),
      'User2': user2?.toJson(),
      'Driver': driver?.toJson(),
    };
  }
}
