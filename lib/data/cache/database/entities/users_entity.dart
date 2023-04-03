import 'package:floor/floor.dart';

@entity
class UsersEntity {
  @primaryKey
  late int createdAt;
  late String emailId;
  late String phoneNumber;
  late String profileUrl;
  late String userName;
  late String userUid;
  late String status;
  late String role;
  late int totalRides;
  late int totalFare;
  late int sharedRides;
  late int totalAmountSaved;
  late int tolerance;
  late int amountNeedToSave;
  late bool isSharingOn;

  UsersEntity(
    this.createdAt,
    this.emailId,
    this.phoneNumber,
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
}
