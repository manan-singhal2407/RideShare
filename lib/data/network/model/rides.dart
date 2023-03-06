class Rides {
  late num createdAt;
  late num driverAcceptedAt;
  late String carType;
  late String userId;
  late String phoneNumber;
  late String emailId;
  late String profileUrl;
  late String userName;
  late bool carPooling;
  late num tolerance;
  late num farePrice;
  late double pickupLatitude;
  late double pickupLongitude;
  late double destinationLatitude;
  late double destinationLongitude;

  Rides(
    this.createdAt,
    this.driverAcceptedAt,
    this.carType,
    this.userId,
    this.phoneNumber,
    this.emailId,
    this.profileUrl,
    this.userName,
    this.carPooling,
    this.tolerance,
    this.farePrice,
    this.pickupLatitude,
    this.pickupLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
  );

  Rides.fromJson(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    driverAcceptedAt = map['driverAcceptedAt'];
    carType = map['carType'];
    userId = map['userId'];
    phoneNumber = map['phoneNumber'];
    emailId = map['emailId'];
    profileUrl = map['profileUrl'];
    userName = map['userName'];
    carPooling = map['carPooling'];
    tolerance = map['tolerance'];
    farePrice = map['farePrice'];
    pickupLatitude = map['pickupLatitude'];
    pickupLongitude = map['pickupLongitude'];
    destinationLatitude = map['destinationLatitude'];
    destinationLongitude = map['destinationLongitude'];
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'driverAcceptedAt': driverAcceptedAt,
      'carType': carType,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'emailId': emailId,
      'profileUrl': profileUrl,
      'userName': userName,
      'carPooling': carPooling,
      'tolerance': tolerance,
      'farePrice': farePrice,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
    };
  }
}
