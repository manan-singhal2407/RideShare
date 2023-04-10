import 'package:btp/data/network/model/rides.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_booking_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/users_dao.dart';

@Injectable(as: IBookingRepository)
class BookingRepository implements IBookingRepository {
  final UsersDao _usersDao = getIt<UsersDao>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> requestedNewRideToDatabase(Rides rides) async {
    bool onSuccess = false;
    await _usersDao.getUsersEntityInfo().then((value) async {
      if (value.isNotEmpty) {
        // todo set user info accordingly
        rides.user1 = convertUsersEntityToUsers(value[0]);
        await _firebaseFirestore
            .collection('Rides')
            .add(rides.toJson())
            .then((documentReference) async {
          await _firebaseFirestore
              .collection('Driver')
              .doc('GJwrqF05CsUOcoUCeceoFpQFM6o2')
              .collection('Request')
              .doc(documentReference.id)
              .set({'request': true})
              .then((value) {
            onSuccess = true;
          });
        });
      }
    });

    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
