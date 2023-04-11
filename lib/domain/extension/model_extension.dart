import '../../data/cache/database/entities/driver_entity.dart';
import '../../data/cache/database/entities/users_entity.dart';
import '../../data/network/model/driver.dart';
import '../../data/network/model/users.dart';

UsersEntity convertUsersToUsersEntity(Users users) {
  return UsersEntity(
    users.createdAt.toInt(),
    users.emailId,
    users.phoneNumber,
    users.profileUrl,
    users.userName,
    users.userUid,
    users.status,
    users.role,
    users.totalRides.toInt(),
    users.totalFare.toInt(),
    users.sharedRides.toInt(),
    users.totalAmountSaved.toInt(),
    users.tolerance.toInt(),
    users.amountNeedToSave.toInt(),
    users.isSharingOn,
  );
}

Users convertUsersEntityToUsers(UsersEntity usersEntity) {
  return Users(
    usersEntity.createdAt,
    usersEntity.emailId,
    usersEntity.phoneNumber,
    usersEntity.profileUrl,
    usersEntity.userName,
    usersEntity.userUid,
    usersEntity.status,
    usersEntity.role,
    usersEntity.totalRides,
    usersEntity.totalFare,
    usersEntity.sharedRides,
    usersEntity.totalAmountSaved,
    usersEntity.tolerance,
    usersEntity.amountNeedToSave,
    usersEntity.isSharingOn,
  );
}

DriverEntity convertDriverToDriverEntity(Driver driver) {
  return DriverEntity(
    driver.requestedAt.toInt(),
    driver.approvedAt.toInt(),
    driver.aadharImage,
    driver.panImage,
    driver.profileUrl,
    driver.phoneNumber,
    driver.emailId,
    driver.driverName,
    driver.driverUid,
    driver.status,
    driver.carType,
    driver.carNumber,
    driver.driverRating,
    driver.totalRides.toInt(),
    driver.totalFare.toInt(),
    driver.sharedRides.toInt(),
    driver.isSharingOn,
    driver.isDrivingOn,
    driver.isSinglePersonInCar,
    driver.isDoublePersonInCar,
    driver.currentLatitude,
    driver.currentLongitude,
    driver.currentRideId,
  );
}
