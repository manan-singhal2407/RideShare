import 'package:floor/floor.dart';

@entity
class DriverEntity {
  @primaryKey
  late int requestedAt;
  late int approvedAt;
  late String aadharImage;
  late String panImage;
  late String profileUrl;
  late String phoneNumber;
  late String fullPhoneNumber;
  late String emailId;
  late String driverName;
  late String driverUid;
  late String status;
  late String carType;
  late String carNumber;
  late double driverRating;
  late int totalRides;
  late int totalFare;
  late int sharedRides;
  late bool isSharingOn;
  late bool isDrivingOn;
  late bool isSinglePersonInCar;
  late bool isDoublePersonInCar;
  late double currentLatitude;
  late double currentLongitude;
  late String currentRideId;

  DriverEntity(
    this.requestedAt,
    this.approvedAt,
    this.aadharImage,
    this.panImage,
    this.profileUrl,
    this.phoneNumber,
    this.fullPhoneNumber,
    this.emailId,
    this.driverName,
    this.driverUid,
    this.status,
    this.carType,
    this.carNumber,
    this.driverRating,
    this.totalRides,
    this.totalFare,
    this.sharedRides,
    this.isSharingOn,
    this.isDrivingOn,
    this.isSinglePersonInCar,
    this.isDoublePersonInCar,
    this.currentLatitude,
    this.currentLongitude,
    this.currentRideId,
  );
}
