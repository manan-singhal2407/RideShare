import '../../data/network/model/rides.dart';
import '../../domain/state/data_state.dart';

abstract class ISplashRepository {
  Future<DataState> checkIfUserIsADriver();
}
