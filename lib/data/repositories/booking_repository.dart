import 'package:btp/data/network/model/rides.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_booking_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';

@Injectable(as: IBookingRepository)
class BookingRepository implements IBookingRepository {
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> requestedNewRideToDatabase(Rides rides) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Rides')
        .add(rides.toJson())
        .then((documentReference) async {
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
