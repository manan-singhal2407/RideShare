class Users {
  late num createdAt;
  late String emailId;
  late String phoneNumber;
  late String fullPhoneNumber;
  late String profileUrl;
  late String userName;
  late String userUid;
  late String status;
  late String role;
  late num totalRides;
  late num totalFare;
  late num sharedRides;
  late num totalAmountSaved;
  late num tolerance;
  late num amountNeedToSave;
  late bool isSharingOn;

  Users(
    this.createdAt,
    this.emailId,
    this.phoneNumber,
    this.fullPhoneNumber,
    this.profileUrl,
    this.userName,
    this.userUid,
    this.status,
    this.role,
    this.totalRides,
    this.totalFare,
    this.sharedRides,
    this.totalAmountSaved,
    this.tolerance,
    this.amountNeedToSave,
    this.isSharingOn,
  );

  Users.fromJson(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    emailId = map['emailId'];
    phoneNumber = map['phoneNumber'];
    fullPhoneNumber = map['fullPhoneNumber'];
    profileUrl = map['profileUrl'];
    userName = map['userName'];
    userUid = map['userUid'];
    status = map['status'];
    role = map['role'];
    totalRides = map['totalRides'];
    totalFare = map['totalFare'];
    sharedRides = map['sharedRides'];
    totalAmountSaved = map['totalAmountSaved'];
    tolerance = map['tolerance'];
    amountNeedToSave = map['amountNeedToSave'];
    isSharingOn = map['isSharingOn'];
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'emailId': emailId,
      'phoneNumber': phoneNumber,
      'fullPhoneNumber': fullPhoneNumber,
      'profileUrl': profileUrl,
      'userName': userName,
      'userUid': userUid,
      'status': status,
      'role': role,
      'totalRides': totalRides,
      'totalFare': totalFare,
      'sharedRides': sharedRides,
      'totalAmountSaved': totalAmountSaved,
      'tolerance': tolerance,
      'amountNeedToSave': amountNeedToSave,
      'isSharingOn': isSharingOn,
    };
  }
}
