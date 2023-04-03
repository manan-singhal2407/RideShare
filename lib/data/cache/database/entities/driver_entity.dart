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
  late double currentLatitude;
  late double currentLongitude;

  DriverEntity(
    this.requestedAt,
    this.approvedAt,
    this.aadharImage,
    this.panImage,
    this.profileUrl,
    this.phoneNumber,
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
    this.currentLatitude,
    this.currentLongitude,
  );
}
