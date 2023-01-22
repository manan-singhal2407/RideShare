import 'package:injectable/injectable.dart';

import '../../data/network/service/firebase_service.dart';

@module
abstract class AppModule {

  @preResolve
  Future<FirebaseService> get firebaseService => FirebaseService.init();
}