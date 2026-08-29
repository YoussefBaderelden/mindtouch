import 'package:drift/drift.dart';

class CalibrationProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get profileJson => text()();
  DateTimeColumn get calibratedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
}

class PairedDevices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get platform => text().nullable()();
  DateTimeColumn get lastSeen => dateTime().nullable()();
}

class Caregivers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get scopesJson => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get scheduleCron => text()();
  DateTimeColumn get lastConfirmed => dateTime().nullable()();
  IntColumn get escalateAfterMin => integer().withDefault(const Constant(30))();
}

class SessionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationSec => integer()();
  IntColumn get intentCount => integer()();
  RealColumn get avgSignalQuality => real()();
  TextColumn get summaryJson => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

class OfflineQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get endpoint => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
