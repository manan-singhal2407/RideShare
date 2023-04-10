class Driver {
  late num requestedAt;
  late num approvedAt;
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
  late num totalRides;
  late num totalFare;
  late num sharedRides;
  late bool isSharingOn;
  late bool isDrivingOn;
  // todo add person count or single or double person sitting key-value pair
  late double currentLatitude;
  late double currentLongitude;

  Driver(
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

  Driver.fromJson(Map<String, dynamic> map) {
    requestedAt = map['requestedAt'];
    approvedAt = map['approvedAt'];
    aadharImage = map['aadharImage'];
    panImage = map['panImage'];
    profileUrl = map['profileUrl'];
    phoneNumber = map['phoneNumber'];
    emailId = map['emailId'];
    driverName = map['driverName'];
    driverUid = map['driverUid'];
    status = map['status'];
    carType = map['carType'];
    carNumber = map['carNumber'];
    driverRating = map['driverRating'];
    totalRides = map['totalRides'];
    totalFare = map['totalFare'];
    sharedRides = map['sharedRides'];
    isSharingOn = map['isSharingOn'];
    isDrivingOn = map['isDrivingOn'];
    currentLatitude = map['currentLatitude'];
    currentLongitude = map['currentLongitude'];
  }

  Map<String, dynamic> toJson() {
    return {
      'requestedAt': requestedAt,
      'approvedAt': approvedAt,
      'aadharImage': aadharImage,
      'panImage': panImage,
      'profileUrl': profileUrl,
      'phoneNumber': phoneNumber,
      'emailId': emailId,
      'driverName': driverName,
      'driverUid': driverUid,
      'status': status,
      'carType': carType,
      'carNumber': carNumber,
      'driverRating': driverRating,
      'totalRides': totalRides,
      'totalFare': totalFare,
      'sharedRides': sharedRides,
      'isSharingOn': isSharingOn,
      'isDrivingOn': isDrivingOn,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
    };
  }
}
