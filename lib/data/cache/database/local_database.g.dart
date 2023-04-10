// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorLocalDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocalDatabaseBuilder databaseBuilder(String name) =>
      _$LocalDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocalDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$LocalDatabaseBuilder(null);
}

class _$LocalDatabaseBuilder {
  _$LocalDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$LocalDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$LocalDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<LocalDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$LocalDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$LocalDatabase extends LocalDatabase {
  _$LocalDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UsersDao? _usersDaoInstance;

  DriverDao? _driverDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UsersEntity` (`createdAt` INTEGER NOT NULL, `emailId` TEXT NOT NULL, `phoneNumber` TEXT NOT NULL, `profileUrl` TEXT NOT NULL, `userName` TEXT NOT NULL, `userUid` TEXT NOT NULL, `status` TEXT NOT NULL, `role` TEXT NOT NULL, `totalRides` INTEGER NOT NULL, `totalFare` INTEGER NOT NULL, `sharedRides` INTEGER NOT NULL, `totalAmountSaved` INTEGER NOT NULL, `tolerance` INTEGER NOT NULL, `amountNeedToSave` INTEGER NOT NULL, `isSharingOn` INTEGER NOT NULL, PRIMARY KEY (`createdAt`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DriverEntity` (`requestedAt` INTEGER NOT NULL, `approvedAt` INTEGER NOT NULL, `aadharImage` TEXT NOT NULL, `panImage` TEXT NOT NULL, `profileUrl` TEXT NOT NULL, `phoneNumber` TEXT NOT NULL, `emailId` TEXT NOT NULL, `driverName` TEXT NOT NULL, `driverUid` TEXT NOT NULL, `status` TEXT NOT NULL, `carType` TEXT NOT NULL, `carNumber` TEXT NOT NULL, `driverRating` REAL NOT NULL, `totalRides` INTEGER NOT NULL, `totalFare` INTEGER NOT NULL, `sharedRides` INTEGER NOT NULL, `isSharingOn` INTEGER NOT NULL, `isDrivingOn` INTEGER NOT NULL, `currentLatitude` REAL NOT NULL, `currentLongitude` REAL NOT NULL, PRIMARY KEY (`requestedAt`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
  }

  @override
  DriverDao get driverDao {
    return _driverDaoInstance ??= _$DriverDao(database, changeListener);
  }
}

class _$UsersDao extends UsersDao {
  _$UsersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _usersEntityInsertionAdapter = InsertionAdapter(
            database,
            'UsersEntity',
            (UsersEntity item) => <String, Object?>{
                  'createdAt': item.createdAt,
                  'emailId': item.emailId,
                  'phoneNumber': item.phoneNumber,
                  'profileUrl': item.profileUrl,
                  'userName': item.userName,
                  'userUid': item.userUid,
                  'status': item.status,
                  'role': item.role,
                  'totalRides': item.totalRides,
                  'totalFare': item.totalFare,
                  'sharedRides': item.sharedRides,
                  'totalAmountSaved': item.totalAmountSaved,
                  'tolerance': item.tolerance,
                  'amountNeedToSave': item.amountNeedToSave,
                  'isSharingOn': item.isSharingOn ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UsersEntity> _usersEntityInsertionAdapter;

  @override
  Future<List<UsersEntity>> getUsersEntityInfo() async {
    return _queryAdapter.queryList('SELECT * FROM UsersEntity',
        mapper: (Map<String, Object?> row) => UsersEntity(
            row['createdAt'] as int,
            row['emailId'] as String,
            row['phoneNumber'] as String,
            row['profileUrl'] as String,
            row['userName'] as String,
            row['userUid'] as String,
            row['status'] as String,
            row['role'] as String,
            row['totalRides'] as int,
            row['totalFare'] as int,
            row['sharedRides'] as int,
            row['totalAmountSaved'] as int,
            row['tolerance'] as int,
            row['amountNeedToSave'] as int,
            (row['isSharingOn'] as int) != 0));
  }

  @override
  Future<void> clearAllUsersEntity() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UsersEntity');
  }

  @override
  Future<void> insertUsersEntity(UsersEntity usersEntity) async {
    await _usersEntityInsertionAdapter.insert(
        usersEntity, OnConflictStrategy.replace);
  }
}

class _$DriverDao extends DriverDao {
  _$DriverDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _driverEntityInsertionAdapter = InsertionAdapter(
            database,
            'DriverEntity',
            (DriverEntity item) => <String, Object?>{
                  'requestedAt': item.requestedAt,
                  'approvedAt': item.approvedAt,
                  'aadharImage': item.aadharImage,
                  'panImage': item.panImage,
                  'profileUrl': item.profileUrl,
                  'phoneNumber': item.phoneNumber,
                  'emailId': item.emailId,
                  'driverName': item.driverName,
                  'driverUid': item.driverUid,
                  'status': item.status,
                  'carType': item.carType,
                  'carNumber': item.carNumber,
                  'driverRating': item.driverRating,
                  'totalRides': item.totalRides,
                  'totalFare': item.totalFare,
                  'sharedRides': item.sharedRides,
                  'isSharingOn': item.isSharingOn ? 1 : 0,
                  'isDrivingOn': item.isDrivingOn ? 1 : 0,
                  'currentLatitude': item.currentLatitude,
                  'currentLongitude': item.currentLongitude
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DriverEntity> _driverEntityInsertionAdapter;

  @override
  Future<List<DriverEntity>> getDriverEntityInfo() async {
    return _queryAdapter.queryList('SELECT * FROM DriverEntity',
        mapper: (Map<String, Object?> row) => DriverEntity(
            row['requestedAt'] as int,
            row['approvedAt'] as int,
            row['aadharImage'] as String,
            row['panImage'] as String,
            row['profileUrl'] as String,
            row['phoneNumber'] as String,
            row['emailId'] as String,
            row['driverName'] as String,
            row['driverUid'] as String,
            row['status'] as String,
            row['carType'] as String,
            row['carNumber'] as String,
            row['driverRating'] as double,
            row['totalRides'] as int,
            row['totalFare'] as int,
            row['sharedRides'] as int,
            (row['isSharingOn'] as int) != 0,
            (row['isDrivingOn'] as int) != 0,
            row['currentLatitude'] as double,
            row['currentLongitude'] as double));
  }

  @override
  Future<void> clearAllDriverEntity() async {
    await _queryAdapter.queryNoReturn('DELETE FROM DriverEntity');
  }

  @override
  Future<void> insertDriverEntity(DriverEntity driverEntity) async {
    await _driverEntityInsertionAdapter.insert(
        driverEntity, OnConflictStrategy.replace);
  }
}
