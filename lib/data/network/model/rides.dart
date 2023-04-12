import 'driver.dart';
import 'users.dart';

class Rides {
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
  late double destinationUser1Latitude;
  late double destinationUser1Longitude;
  late double pickupUser2Latitude;
  late double pickupUser2Longitude;
  late double destinationUser2Latitude;
  late double destinationUser2Longitude;
  late bool isSharingOnByUser1;
  late bool isSharingOnByUser2;
  late bool isSharingOnByDriver;
  late num toleranceByUser1;
  late num toleranceByUser2;
  late num amountNeedToSaveForUser1;
  late num amountNeedToSaveForUser2;
  late bool cancelledByUser;
  late Users? user1;
  late Users? user2;
  late Driver? driver;

  Rides(
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
    this.destinationUser1Latitude,
    this.destinationUser1Longitude,
    this.pickupUser2Latitude,
    this.pickupUser2Longitude,
    this.destinationUser2Latitude,
    this.destinationUser2Longitude,
    this.isSharingOnByUser1,
    this.isSharingOnByUser2,
    this.isSharingOnByDriver,
    this.toleranceByUser1,
    this.toleranceByUser2,
    this.amountNeedToSaveForUser1,
    this.amountNeedToSaveForUser2,
    this.cancelledByUser,
    this.user1,
    this.user2,
    this.driver,
  );

  Rides.fromJson(Map<String, dynamic> map) {
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
    destinationUser1Latitude = map['destinationUser1Latitude'];
    destinationUser1Longitude = map['destinationUser1Longitude'];
    pickupUser2Latitude = map['pickupUser2Latitude'];
    pickupUser2Longitude = map['pickupUser2Longitude'];
    destinationUser2Latitude = map['destinationUser2Latitude'];
    destinationUser2Longitude = map['destinationUser2Longitude'];
    isSharingOnByUser1 = map['isSharingOnByUser1'];
    isSharingOnByUser2 = map['isSharingOnByUser2'];
    isSharingOnByDriver = map['isSharingOnByDriver'];
    toleranceByUser1 = map['toleranceByUser1'];
    toleranceByUser2 = map['toleranceByUser2'];
    amountNeedToSaveForUser1 = map['amountNeedToSaveForUser1'];
    amountNeedToSaveForUser2 = map['amountNeedToSaveForUser2'];
    cancelledByUser = map['cancelledByUser'];
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
      'pickupUser1Latitude': pickupUser1Latitude,
      'driverLatitude': driverLatitude,
      'driverLongitude': driverLongitude,
      'pickupUser1Longitude': pickupUser1Longitude,
      'destinationUser1Latitude': destinationUser1Latitude,
      'destinationUser1Longitude': destinationUser1Longitude,
      'pickupUser2Latitude': pickupUser2Latitude,
      'pickupUser2Longitude': pickupUser2Longitude,
      'destinationUser2Latitude': destinationUser2Latitude,
      'destinationUser2Longitude': destinationUser2Longitude,
      'isSharingOnByUser1': isSharingOnByUser1,
      'isSharingOnByUser2': isSharingOnByUser2,
      'isSharingOnByDriver': isSharingOnByDriver,
      'toleranceByUser1': toleranceByUser1,
      'toleranceByUser2': toleranceByUser2,
      'amountNeedToSaveForUser1': amountNeedToSaveForUser1,
      'amountNeedToSaveForUser2': amountNeedToSaveForUser2,
      'cancelledByUser': cancelledByUser,
      'User1': user1?.toJson(),
      'User2': user2?.toJson(),
      'Driver': driver?.toJson(),
    };
  }
}
