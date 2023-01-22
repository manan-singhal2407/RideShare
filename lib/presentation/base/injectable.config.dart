// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:btp/data/network/service/firebase_service.dart' as _i5;
import 'package:btp/domain/di/app_module.dart' as _i6;
import 'package:btp/domain/di/network_module.dart' as _i7;
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final appModule = _$AppModule();
    gh.factory<_i3.FirebaseAuth>(() => networkModule.firebaseAuth);
    gh.factory<_i4.FirebaseFirestore>(() => networkModule.firebaseFirestore);
    await gh.factoryAsync<_i5.FirebaseService>(
      () => appModule.firebaseService,
      preResolve: true,
    );
    return this;
  }
}

class _$AppModule extends _i6.AppModule {}

class _$NetworkModule extends _i7.NetworkModule {}
