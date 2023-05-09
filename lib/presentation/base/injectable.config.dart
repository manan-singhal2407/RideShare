// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:btp/data/cache/database/dao/driver_dao.dart' as _i38;
import 'package:btp/data/cache/database/dao/users_dao.dart' as _i37;
import 'package:btp/data/cache/database/local_database.dart' as _i35;
import 'package:btp/data/network/service/firebase_service.dart' as _i6;
import 'package:btp/data/network/service/retrofit_service.dart' as _i36;
import 'package:btp/data/repositories/booking_repository.dart' as _i8;
import 'package:btp/data/repositories/driver_home_repository.dart' as _i10;
import 'package:btp/data/repositories/driver_my_rides_repository.dart' as _i12;
import 'package:btp/data/repositories/driver_ride_request_detail_repository.dart'
    as _i14;
import 'package:btp/data/repositories/driver_ride_request_repository.dart'
    as _i16;
import 'package:btp/data/repositories/driver_rides_repository.dart' as _i18;
import 'package:btp/data/repositories/driver_settings_repository.dart' as _i20;
import 'package:btp/data/repositories/login_repository.dart' as _i22;
import 'package:btp/data/repositories/phone_otp_repository.dart' as _i24;
import 'package:btp/data/repositories/rider_booking_repository.dart' as _i26;
import 'package:btp/data/repositories/rider_home_repository.dart' as _i28;
import 'package:btp/data/repositories/rider_my_rides_repository.dart' as _i30;
import 'package:btp/data/repositories/rider_rides_repository.dart' as _i32;
import 'package:btp/data/repositories/splash_repository.dart' as _i34;
import 'package:btp/domain/di/app_module.dart' as _i39;
import 'package:btp/domain/di/cache_module.dart' as _i40;
import 'package:btp/domain/di/network_module.dart' as _i41;
import 'package:btp/domain/repositories/i_booking_repository.dart' as _i7;
import 'package:btp/domain/repositories/i_driver_home_repository.dart' as _i9;
import 'package:btp/domain/repositories/i_driver_my_rides_repository.dart'
    as _i11;
import 'package:btp/domain/repositories/i_driver_ride_request_detail_repository.dart'
    as _i13;
import 'package:btp/domain/repositories/i_driver_ride_request_repository.dart'
    as _i15;
import 'package:btp/domain/repositories/i_driver_rides_repository.dart' as _i17;
import 'package:btp/domain/repositories/i_driver_settings_repository.dart'
    as _i19;
import 'package:btp/domain/repositories/i_login_repository.dart' as _i21;
import 'package:btp/domain/repositories/i_phone_otp_repository.dart' as _i23;
import 'package:btp/domain/repositories/i_rider_booking_repository.dart'
    as _i25;
import 'package:btp/domain/repositories/i_rider_home_repository.dart' as _i27;
import 'package:btp/domain/repositories/i_rider_my_rides_repository.dart'
    as _i29;
import 'package:btp/domain/repositories/i_rider_rides_repository.dart' as _i31;
import 'package:btp/domain/repositories/i_splash_repository.dart' as _i33;
import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:dio/dio.dart' as _i3;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
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
    final cacheModule = _$CacheModule();
    gh.factory<_i3.Dio>(() => networkModule.dio);
    gh.factory<_i4.FirebaseAuth>(() => networkModule.firebaseAuth);
    gh.factory<_i5.FirebaseFirestore>(() => networkModule.firebaseFirestore);
    await gh.factoryAsync<_i6.FirebaseService>(
      () => appModule.firebaseService,
      preResolve: true,
    );
    gh.factory<_i7.IBookingRepository>(() => _i8.BookingRepository());
    gh.factory<_i9.IDriverHomeRepository>(() => _i10.DriverHomeRepository());
    gh.factory<_i11.IDriverMyRidesRepository>(
        () => _i12.DriverMyRidesRepository());
    gh.factory<_i13.IDriverRideRequestDetailRepository>(
        () => _i14.DriverRideRequestDetailRepository());
    gh.factory<_i15.IDriverRideRequestRepository>(
        () => _i16.DriverRideRequestRepository());
    gh.factory<_i17.IDriverRidesRepository>(() => _i18.DriverRidesRepository());
    gh.factory<_i19.IDriverSettingsRepository>(
        () => _i20.DriverSettingsRepository());
    gh.factory<_i21.ILoginRepository>(() => _i22.LoginRepository());
    gh.factory<_i23.IPhoneOtpRepository>(() => _i24.PhoneOtpRepository());
    gh.factory<_i25.IRiderBookingRepository>(
        () => _i26.RiderBookingRepository());
    gh.factory<_i27.IRiderHomeRepository>(() => _i28.RiderHomeRepository());
    gh.factory<_i29.IRiderMyRidesRepository>(
        () => _i30.RiderMyRidesRepository());
    gh.factory<_i31.IRiderRidesRepository>(() => _i32.RiderRidesRepository());
    gh.factory<_i33.ISplashRepository>(() => _i34.SplashRepository());
    await gh.factoryAsync<_i35.LocalDatabase>(
      () => cacheModule.localDatabase,
      preResolve: true,
    );
    gh.factory<_i36.RestClient>(() => networkModule.restClient);
    gh.factory<_i37.UsersDao>(
        () => cacheModule.usersDao(gh<_i35.LocalDatabase>()));
    gh.factory<_i38.DriverDao>(
        () => cacheModule.adsRulesDao(gh<_i35.LocalDatabase>()));
    return this;
  }
}

class _$AppModule extends _i39.AppModule {}

class _$CacheModule extends _i40.CacheModule {}

class _$NetworkModule extends _i41.NetworkModule {}
