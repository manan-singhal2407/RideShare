import 'package:flutter/material.dart';

import '../../../../data/cache/database/entities/driver_entity.dart';
import '../../../../data/network/model/driver.dart';
import '../../../../domain/repositories/i_driver_settings_repository.dart';
import '../../../base/injectable.dart';
import '../../../theme/widgets/loading.dart';

class DriverSettingsViewModel extends ChangeNotifier {
  final IDriverSettingsRepository _driverSettingsRepository =
      getIt<IDriverSettingsRepository>();

  final BuildContext _context;

  bool _isSharingOnByDriver = false;

  DriverSettingsViewModel(this._context) {
    _getDataFromLocalDatabase();
    _getDataFromDatabase();
  }

  bool get isSharingOnByDriver => _isSharingOnByDriver;

  void _getDataFromLocalDatabase() async {
    await _driverSettingsRepository
        .getDriverStatusFromLocalDatabase()
        .then((value) {
      if (value.data != null) {
        DriverEntity driverEntity = value.data as DriverEntity;
        _isSharingOnByDriver = driverEntity.isSharingOn;
        notifyListeners();
      }
    });
  }

  void _getDataFromDatabase() async {
    await _driverSettingsRepository.getDriverStatusFromDatabase().then((value) {
      if (value.data != null) {
        Driver driver = value.data as Driver;
        _isSharingOnByDriver = driver.isSharingOn;
        notifyListeners();
      }
    });
  }

  void onSwitchClick() async {
    _isSharingOnByDriver = !_isSharingOnByDriver;
    notifyListeners();
  }

  void saveDataToDatabase() async {
    showLoadingDialogBox(_context);
    await _driverSettingsRepository
        .saveDriverStatusToDatabase(_isSharingOnByDriver)
        .then((value) {
      if (value.data != null) {
        Navigator.pop(_context);
      }
    });
  }
}
