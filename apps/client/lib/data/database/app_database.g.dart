// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CalibrationProfilesTable extends CalibrationProfiles
    with TableInfo<$CalibrationProfilesTable, CalibrationProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileJsonMeta = const VerificationMeta(
    'profileJson',
  );
  @override
  late final GeneratedColumn<String> profileJson = GeneratedColumn<String>(
    'profile_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calibratedAtMeta = const VerificationMeta(
    'calibratedAt',
  );
  @override
  late final GeneratedColumn<DateTime> calibratedAt = GeneratedColumn<DateTime>(
    'calibrated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    profileJson,
    calibratedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibration_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalibrationProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('profile_json')) {
      context.handle(
        _profileJsonMeta,
        profileJson.isAcceptableOrUnknown(
          data['profile_json']!,
          _profileJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileJsonMeta);
    }
    if (data.containsKey('calibrated_at')) {
      context.handle(
        _calibratedAtMeta,
        calibratedAt.isAcceptableOrUnknown(
          data['calibrated_at']!,
          _calibratedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calibratedAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalibrationProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalibrationProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      profileJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_json'],
      )!,
      calibratedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}calibrated_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CalibrationProfilesTable createAlias(String alias) {
    return $CalibrationProfilesTable(attachedDatabase, alias);
  }
}

class CalibrationProfile extends DataClass
    implements Insertable<CalibrationProfile> {
  final int id;
  final String name;
  final String profileJson;
  final DateTime calibratedAt;
  final bool isActive;
  const CalibrationProfile({
    required this.id,
    required this.name,
    required this.profileJson,
    required this.calibratedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['profile_json'] = Variable<String>(profileJson);
    map['calibrated_at'] = Variable<DateTime>(calibratedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CalibrationProfilesCompanion toCompanion(bool nullToAbsent) {
    return CalibrationProfilesCompanion(
      id: Value(id),
      name: Value(name),
      profileJson: Value(profileJson),
      calibratedAt: Value(calibratedAt),
      isActive: Value(isActive),
    );
  }

  factory CalibrationProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalibrationProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      profileJson: serializer.fromJson<String>(json['profileJson']),
      calibratedAt: serializer.fromJson<DateTime>(json['calibratedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'profileJson': serializer.toJson<String>(profileJson),
      'calibratedAt': serializer.toJson<DateTime>(calibratedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CalibrationProfile copyWith({
    int? id,
    String? name,
    String? profileJson,
    DateTime? calibratedAt,
    bool? isActive,
  }) => CalibrationProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    profileJson: profileJson ?? this.profileJson,
    calibratedAt: calibratedAt ?? this.calibratedAt,
    isActive: isActive ?? this.isActive,
  );
  CalibrationProfile copyWithCompanion(CalibrationProfilesCompanion data) {
    return CalibrationProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      profileJson: data.profileJson.present
          ? data.profileJson.value
          : this.profileJson,
      calibratedAt: data.calibratedAt.present
          ? data.calibratedAt.value
          : this.calibratedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileJson: $profileJson, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, profileJson, calibratedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalibrationProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.profileJson == this.profileJson &&
          other.calibratedAt == this.calibratedAt &&
          other.isActive == this.isActive);
}

class CalibrationProfilesCompanion extends UpdateCompanion<CalibrationProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> profileJson;
  final Value<DateTime> calibratedAt;
  final Value<bool> isActive;
  const CalibrationProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.profileJson = const Value.absent(),
    this.calibratedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CalibrationProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String profileJson,
    required DateTime calibratedAt,
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       profileJson = Value(profileJson),
       calibratedAt = Value(calibratedAt);
  static Insertable<CalibrationProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? profileJson,
    Expression<DateTime>? calibratedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (profileJson != null) 'profile_json': profileJson,
      if (calibratedAt != null) 'calibrated_at': calibratedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CalibrationProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? profileJson,
    Value<DateTime>? calibratedAt,
    Value<bool>? isActive,
  }) {
    return CalibrationProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      profileJson: profileJson ?? this.profileJson,
      calibratedAt: calibratedAt ?? this.calibratedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (profileJson.present) {
      map['profile_json'] = Variable<String>(profileJson.value);
    }
    if (calibratedAt.present) {
      map['calibrated_at'] = Variable<DateTime>(calibratedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileJson: $profileJson, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $PairedDevicesTable extends PairedDevices
    with TableInfo<$PairedDevicesTable, PairedDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PairedDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    type,
    name,
    platform,
    lastSeen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paired_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<PairedDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PairedDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PairedDevice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      ),
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      ),
    );
  }

  @override
  $PairedDevicesTable createAlias(String alias) {
    return $PairedDevicesTable(attachedDatabase, alias);
  }
}

class PairedDevice extends DataClass implements Insertable<PairedDevice> {
  final int id;
  final String deviceId;
  final String type;
  final String name;
  final String? platform;
  final DateTime? lastSeen;
  const PairedDevice({
    required this.id,
    required this.deviceId,
    required this.type,
    required this.name,
    this.platform,
    this.lastSeen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(platform);
    }
    if (!nullToAbsent || lastSeen != null) {
      map['last_seen'] = Variable<DateTime>(lastSeen);
    }
    return map;
  }

  PairedDevicesCompanion toCompanion(bool nullToAbsent) {
    return PairedDevicesCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      type: Value(type),
      name: Value(name),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      lastSeen: lastSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeen),
    );
  }

  factory PairedDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PairedDevice(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      platform: serializer.fromJson<String?>(json['platform']),
      lastSeen: serializer.fromJson<DateTime?>(json['lastSeen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'platform': serializer.toJson<String?>(platform),
      'lastSeen': serializer.toJson<DateTime?>(lastSeen),
    };
  }

  PairedDevice copyWith({
    int? id,
    String? deviceId,
    String? type,
    String? name,
    Value<String?> platform = const Value.absent(),
    Value<DateTime?> lastSeen = const Value.absent(),
  }) => PairedDevice(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    type: type ?? this.type,
    name: name ?? this.name,
    platform: platform.present ? platform.value : this.platform,
    lastSeen: lastSeen.present ? lastSeen.value : this.lastSeen,
  );
  PairedDevice copyWithCompanion(PairedDevicesCompanion data) {
    return PairedDevice(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      platform: data.platform.present ? data.platform.value : this.platform,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PairedDevice(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('platform: $platform, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, type, name, platform, lastSeen);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PairedDevice &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.type == this.type &&
          other.name == this.name &&
          other.platform == this.platform &&
          other.lastSeen == this.lastSeen);
}

class PairedDevicesCompanion extends UpdateCompanion<PairedDevice> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> platform;
  final Value<DateTime?> lastSeen;
  const PairedDevicesCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.platform = const Value.absent(),
    this.lastSeen = const Value.absent(),
  });
  PairedDevicesCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String type,
    required String name,
    this.platform = const Value.absent(),
    this.lastSeen = const Value.absent(),
  }) : deviceId = Value(deviceId),
       type = Value(type),
       name = Value(name);
  static Insertable<PairedDevice> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? platform,
    Expression<DateTime>? lastSeen,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (platform != null) 'platform': platform,
      if (lastSeen != null) 'last_seen': lastSeen,
    });
  }

  PairedDevicesCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String>? type,
    Value<String>? name,
    Value<String?>? platform,
    Value<DateTime?>? lastSeen,
  }) {
    return PairedDevicesCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PairedDevicesCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('platform: $platform, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }
}

class $CaregiversTable extends Caregivers
    with TableInfo<$CaregiversTable, Caregiver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaregiversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scopesJsonMeta = const VerificationMeta(
    'scopesJson',
  );
  @override
  late final GeneratedColumn<String> scopesJson = GeneratedColumn<String>(
    'scopes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    email,
    scopesJson,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caregivers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Caregiver> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('scopes_json')) {
      context.handle(
        _scopesJsonMeta,
        scopesJson.isAcceptableOrUnknown(data['scopes_json']!, _scopesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_scopesJsonMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Caregiver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Caregiver(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      scopesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scopes_json'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CaregiversTable createAlias(String alias) {
    return $CaregiversTable(attachedDatabase, alias);
  }
}

class Caregiver extends DataClass implements Insertable<Caregiver> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String scopesJson;
  final bool isActive;
  const Caregiver({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.scopesJson,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['scopes_json'] = Variable<String>(scopesJson);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CaregiversCompanion toCompanion(bool nullToAbsent) {
    return CaregiversCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      scopesJson: Value(scopesJson),
      isActive: Value(isActive),
    );
  }

  factory Caregiver.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Caregiver(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      scopesJson: serializer.fromJson<String>(json['scopesJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'scopesJson': serializer.toJson<String>(scopesJson),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Caregiver copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    String? scopesJson,
    bool? isActive,
  }) => Caregiver(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    scopesJson: scopesJson ?? this.scopesJson,
    isActive: isActive ?? this.isActive,
  );
  Caregiver copyWithCompanion(CaregiversCompanion data) {
    return Caregiver(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      scopesJson: data.scopesJson.present
          ? data.scopesJson.value
          : this.scopesJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Caregiver(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('scopesJson: $scopesJson, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, scopesJson, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Caregiver &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.scopesJson == this.scopesJson &&
          other.isActive == this.isActive);
}

class CaregiversCompanion extends UpdateCompanion<Caregiver> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String> scopesJson;
  final Value<bool> isActive;
  const CaregiversCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.scopesJson = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CaregiversCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required String scopesJson,
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       scopesJson = Value(scopesJson);
  static Insertable<Caregiver> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? scopesJson,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (scopesJson != null) 'scopes_json': scopesJson,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CaregiversCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String>? scopesJson,
    Value<bool>? isActive,
  }) {
    return CaregiversCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      scopesJson: scopesJson ?? this.scopesJson,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (scopesJson.present) {
      map['scopes_json'] = Variable<String>(scopesJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaregiversCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('scopesJson: $scopesJson, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleCronMeta = const VerificationMeta(
    'scheduleCron',
  );
  @override
  late final GeneratedColumn<String> scheduleCron = GeneratedColumn<String>(
    'schedule_cron',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastConfirmedMeta = const VerificationMeta(
    'lastConfirmed',
  );
  @override
  late final GeneratedColumn<DateTime> lastConfirmed =
      GeneratedColumn<DateTime>(
        'last_confirmed',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _escalateAfterMinMeta = const VerificationMeta(
    'escalateAfterMin',
  );
  @override
  late final GeneratedColumn<int> escalateAfterMin = GeneratedColumn<int>(
    'escalate_after_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    scheduleCron,
    lastConfirmed,
    escalateAfterMin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('schedule_cron')) {
      context.handle(
        _scheduleCronMeta,
        scheduleCron.isAcceptableOrUnknown(
          data['schedule_cron']!,
          _scheduleCronMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduleCronMeta);
    }
    if (data.containsKey('last_confirmed')) {
      context.handle(
        _lastConfirmedMeta,
        lastConfirmed.isAcceptableOrUnknown(
          data['last_confirmed']!,
          _lastConfirmedMeta,
        ),
      );
    }
    if (data.containsKey('escalate_after_min')) {
      context.handle(
        _escalateAfterMinMeta,
        escalateAfterMin.isAcceptableOrUnknown(
          data['escalate_after_min']!,
          _escalateAfterMinMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      scheduleCron: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_cron'],
      )!,
      lastConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_confirmed'],
      ),
      escalateAfterMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escalate_after_min'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final String title;
  final String scheduleCron;
  final DateTime? lastConfirmed;
  final int escalateAfterMin;
  const Reminder({
    required this.id,
    required this.title,
    required this.scheduleCron,
    this.lastConfirmed,
    required this.escalateAfterMin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['schedule_cron'] = Variable<String>(scheduleCron);
    if (!nullToAbsent || lastConfirmed != null) {
      map['last_confirmed'] = Variable<DateTime>(lastConfirmed);
    }
    map['escalate_after_min'] = Variable<int>(escalateAfterMin);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      scheduleCron: Value(scheduleCron),
      lastConfirmed: lastConfirmed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConfirmed),
      escalateAfterMin: Value(escalateAfterMin),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      scheduleCron: serializer.fromJson<String>(json['scheduleCron']),
      lastConfirmed: serializer.fromJson<DateTime?>(json['lastConfirmed']),
      escalateAfterMin: serializer.fromJson<int>(json['escalateAfterMin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'scheduleCron': serializer.toJson<String>(scheduleCron),
      'lastConfirmed': serializer.toJson<DateTime?>(lastConfirmed),
      'escalateAfterMin': serializer.toJson<int>(escalateAfterMin),
    };
  }

  Reminder copyWith({
    int? id,
    String? title,
    String? scheduleCron,
    Value<DateTime?> lastConfirmed = const Value.absent(),
    int? escalateAfterMin,
  }) => Reminder(
    id: id ?? this.id,
    title: title ?? this.title,
    scheduleCron: scheduleCron ?? this.scheduleCron,
    lastConfirmed: lastConfirmed.present
        ? lastConfirmed.value
        : this.lastConfirmed,
    escalateAfterMin: escalateAfterMin ?? this.escalateAfterMin,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      scheduleCron: data.scheduleCron.present
          ? data.scheduleCron.value
          : this.scheduleCron,
      lastConfirmed: data.lastConfirmed.present
          ? data.lastConfirmed.value
          : this.lastConfirmed,
      escalateAfterMin: data.escalateAfterMin.present
          ? data.escalateAfterMin.value
          : this.escalateAfterMin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('scheduleCron: $scheduleCron, ')
          ..write('lastConfirmed: $lastConfirmed, ')
          ..write('escalateAfterMin: $escalateAfterMin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, scheduleCron, lastConfirmed, escalateAfterMin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.title == this.title &&
          other.scheduleCron == this.scheduleCron &&
          other.lastConfirmed == this.lastConfirmed &&
          other.escalateAfterMin == this.escalateAfterMin);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> scheduleCron;
  final Value<DateTime?> lastConfirmed;
  final Value<int> escalateAfterMin;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.scheduleCron = const Value.absent(),
    this.lastConfirmed = const Value.absent(),
    this.escalateAfterMin = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String scheduleCron,
    this.lastConfirmed = const Value.absent(),
    this.escalateAfterMin = const Value.absent(),
  }) : title = Value(title),
       scheduleCron = Value(scheduleCron);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? scheduleCron,
    Expression<DateTime>? lastConfirmed,
    Expression<int>? escalateAfterMin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (scheduleCron != null) 'schedule_cron': scheduleCron,
      if (lastConfirmed != null) 'last_confirmed': lastConfirmed,
      if (escalateAfterMin != null) 'escalate_after_min': escalateAfterMin,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? scheduleCron,
    Value<DateTime?>? lastConfirmed,
    Value<int>? escalateAfterMin,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      scheduleCron: scheduleCron ?? this.scheduleCron,
      lastConfirmed: lastConfirmed ?? this.lastConfirmed,
      escalateAfterMin: escalateAfterMin ?? this.escalateAfterMin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (scheduleCron.present) {
      map['schedule_cron'] = Variable<String>(scheduleCron.value);
    }
    if (lastConfirmed.present) {
      map['last_confirmed'] = Variable<DateTime>(lastConfirmed.value);
    }
    if (escalateAfterMin.present) {
      map['escalate_after_min'] = Variable<int>(escalateAfterMin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('scheduleCron: $scheduleCron, ')
          ..write('lastConfirmed: $lastConfirmed, ')
          ..write('escalateAfterMin: $escalateAfterMin')
          ..write(')'))
        .toString();
  }
}

class $SessionLogsTable extends SessionLogs
    with TableInfo<$SessionLogsTable, SessionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentCountMeta = const VerificationMeta(
    'intentCount',
  );
  @override
  late final GeneratedColumn<int> intentCount = GeneratedColumn<int>(
    'intent_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgSignalQualityMeta = const VerificationMeta(
    'avgSignalQuality',
  );
  @override
  late final GeneratedColumn<double> avgSignalQuality = GeneratedColumn<double>(
    'avg_signal_quality',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    durationSec,
    intentCount,
    avgSignalQuality,
    summaryJson,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecMeta);
    }
    if (data.containsKey('intent_count')) {
      context.handle(
        _intentCountMeta,
        intentCount.isAcceptableOrUnknown(
          data['intent_count']!,
          _intentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intentCountMeta);
    }
    if (data.containsKey('avg_signal_quality')) {
      context.handle(
        _avgSignalQualityMeta,
        avgSignalQuality.isAcceptableOrUnknown(
          data['avg_signal_quality']!,
          _avgSignalQualityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgSignalQualityMeta);
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      intentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intent_count'],
      )!,
      avgSignalQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_signal_quality'],
      )!,
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $SessionLogsTable createAlias(String alias) {
    return $SessionLogsTable(attachedDatabase, alias);
  }
}

class SessionLog extends DataClass implements Insertable<SessionLog> {
  final int id;
  final DateTime startedAt;
  final int durationSec;
  final int intentCount;
  final double avgSignalQuality;
  final String? summaryJson;
  final bool synced;
  const SessionLog({
    required this.id,
    required this.startedAt,
    required this.durationSec,
    required this.intentCount,
    required this.avgSignalQuality,
    this.summaryJson,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_sec'] = Variable<int>(durationSec);
    map['intent_count'] = Variable<int>(intentCount);
    map['avg_signal_quality'] = Variable<double>(avgSignalQuality);
    if (!nullToAbsent || summaryJson != null) {
      map['summary_json'] = Variable<String>(summaryJson);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SessionLogsCompanion toCompanion(bool nullToAbsent) {
    return SessionLogsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      durationSec: Value(durationSec),
      intentCount: Value(intentCount),
      avgSignalQuality: Value(avgSignalQuality),
      summaryJson: summaryJson == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryJson),
      synced: Value(synced),
    );
  }

  factory SessionLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionLog(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      intentCount: serializer.fromJson<int>(json['intentCount']),
      avgSignalQuality: serializer.fromJson<double>(json['avgSignalQuality']),
      summaryJson: serializer.fromJson<String?>(json['summaryJson']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationSec': serializer.toJson<int>(durationSec),
      'intentCount': serializer.toJson<int>(intentCount),
      'avgSignalQuality': serializer.toJson<double>(avgSignalQuality),
      'summaryJson': serializer.toJson<String?>(summaryJson),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SessionLog copyWith({
    int? id,
    DateTime? startedAt,
    int? durationSec,
    int? intentCount,
    double? avgSignalQuality,
    Value<String?> summaryJson = const Value.absent(),
    bool? synced,
  }) => SessionLog(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    durationSec: durationSec ?? this.durationSec,
    intentCount: intentCount ?? this.intentCount,
    avgSignalQuality: avgSignalQuality ?? this.avgSignalQuality,
    summaryJson: summaryJson.present ? summaryJson.value : this.summaryJson,
    synced: synced ?? this.synced,
  );
  SessionLog copyWithCompanion(SessionLogsCompanion data) {
    return SessionLog(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      intentCount: data.intentCount.present
          ? data.intentCount.value
          : this.intentCount,
      avgSignalQuality: data.avgSignalQuality.present
          ? data.avgSignalQuality.value
          : this.avgSignalQuality,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionLog(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('intentCount: $intentCount, ')
          ..write('avgSignalQuality: $avgSignalQuality, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    durationSec,
    intentCount,
    avgSignalQuality,
    summaryJson,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionLog &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.durationSec == this.durationSec &&
          other.intentCount == this.intentCount &&
          other.avgSignalQuality == this.avgSignalQuality &&
          other.summaryJson == this.summaryJson &&
          other.synced == this.synced);
}

class SessionLogsCompanion extends UpdateCompanion<SessionLog> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<int> durationSec;
  final Value<int> intentCount;
  final Value<double> avgSignalQuality;
  final Value<String?> summaryJson;
  final Value<bool> synced;
  const SessionLogsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.intentCount = const Value.absent(),
    this.avgSignalQuality = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.synced = const Value.absent(),
  });
  SessionLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    required int durationSec,
    required int intentCount,
    required double avgSignalQuality,
    this.summaryJson = const Value.absent(),
    this.synced = const Value.absent(),
  }) : startedAt = Value(startedAt),
       durationSec = Value(durationSec),
       intentCount = Value(intentCount),
       avgSignalQuality = Value(avgSignalQuality);
  static Insertable<SessionLog> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<int>? durationSec,
    Expression<int>? intentCount,
    Expression<double>? avgSignalQuality,
    Expression<String>? summaryJson,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (durationSec != null) 'duration_sec': durationSec,
      if (intentCount != null) 'intent_count': intentCount,
      if (avgSignalQuality != null) 'avg_signal_quality': avgSignalQuality,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (synced != null) 'synced': synced,
    });
  }

  SessionLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<int>? durationSec,
    Value<int>? intentCount,
    Value<double>? avgSignalQuality,
    Value<String?>? summaryJson,
    Value<bool>? synced,
  }) {
    return SessionLogsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      durationSec: durationSec ?? this.durationSec,
      intentCount: intentCount ?? this.intentCount,
      avgSignalQuality: avgSignalQuality ?? this.avgSignalQuality,
      summaryJson: summaryJson ?? this.summaryJson,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (intentCount.present) {
      map['intent_count'] = Variable<int>(intentCount.value);
    }
    if (avgSignalQuality.present) {
      map['avg_signal_quality'] = Variable<double>(avgSignalQuality.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionLogsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('intentCount: $intentCount, ')
          ..write('avgSignalQuality: $avgSignalQuality, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $OfflineQueueTable extends OfflineQueue
    with TableInfo<$OfflineQueueTable, OfflineQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _endpointMeta = const VerificationMeta(
    'endpoint',
  );
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
    'endpoint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    endpoint,
    payloadJson,
    createdAt,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('endpoint')) {
      context.handle(
        _endpointMeta,
        endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta),
      );
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      endpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endpoint'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $OfflineQueueTable createAlias(String alias) {
    return $OfflineQueueTable(attachedDatabase, alias);
  }
}

class OfflineQueueData extends DataClass
    implements Insertable<OfflineQueueData> {
  final int id;
  final String endpoint;
  final String payloadJson;
  final DateTime createdAt;
  final int retryCount;
  const OfflineQueueData({
    required this.id,
    required this.endpoint,
    required this.payloadJson,
    required this.createdAt,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['endpoint'] = Variable<String>(endpoint);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  OfflineQueueCompanion toCompanion(bool nullToAbsent) {
    return OfflineQueueCompanion(
      id: Value(id),
      endpoint: Value(endpoint),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
    );
  }

  factory OfflineQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineQueueData(
      id: serializer.fromJson<int>(json['id']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'endpoint': serializer.toJson<String>(endpoint),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  OfflineQueueData copyWith({
    int? id,
    String? endpoint,
    String? payloadJson,
    DateTime? createdAt,
    int? retryCount,
  }) => OfflineQueueData(
    id: id ?? this.id,
    endpoint: endpoint ?? this.endpoint,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
  );
  OfflineQueueData copyWithCompanion(OfflineQueueCompanion data) {
    return OfflineQueueData(
      id: data.id.present ? data.id.value : this.id,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueData(')
          ..write('id: $id, ')
          ..write('endpoint: $endpoint, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, endpoint, payloadJson, createdAt, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineQueueData &&
          other.id == this.id &&
          other.endpoint == this.endpoint &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount);
}

class OfflineQueueCompanion extends UpdateCompanion<OfflineQueueData> {
  final Value<int> id;
  final Value<String> endpoint;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  const OfflineQueueCompanion({
    this.id = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  OfflineQueueCompanion.insert({
    this.id = const Value.absent(),
    required String endpoint,
    required String payloadJson,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
  }) : endpoint = Value(endpoint),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<OfflineQueueData> custom({
    Expression<int>? id,
    Expression<String>? endpoint,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (endpoint != null) 'endpoint': endpoint,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  OfflineQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? endpoint,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
  }) {
    return OfflineQueueCompanion(
      id: id ?? this.id,
      endpoint: endpoint ?? this.endpoint,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueCompanion(')
          ..write('id: $id, ')
          ..write('endpoint: $endpoint, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CalibrationProfilesTable calibrationProfiles =
      $CalibrationProfilesTable(this);
  late final $PairedDevicesTable pairedDevices = $PairedDevicesTable(this);
  late final $CaregiversTable caregivers = $CaregiversTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $SessionLogsTable sessionLogs = $SessionLogsTable(this);
  late final $OfflineQueueTable offlineQueue = $OfflineQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    calibrationProfiles,
    pairedDevices,
    caregivers,
    reminders,
    sessionLogs,
    offlineQueue,
  ];
}

typedef $$CalibrationProfilesTableCreateCompanionBuilder =
    CalibrationProfilesCompanion Function({
      Value<int> id,
      required String name,
      required String profileJson,
      required DateTime calibratedAt,
      Value<bool> isActive,
    });
typedef $$CalibrationProfilesTableUpdateCompanionBuilder =
    CalibrationProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> profileJson,
      Value<DateTime> calibratedAt,
      Value<bool> isActive,
    });

class $$CalibrationProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CalibrationProfilesTable> {
  $$CalibrationProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileJson => $composableBuilder(
    column: $table.profileJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get calibratedAt => $composableBuilder(
    column: $table.calibratedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalibrationProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalibrationProfilesTable> {
  $$CalibrationProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileJson => $composableBuilder(
    column: $table.profileJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get calibratedAt => $composableBuilder(
    column: $table.calibratedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalibrationProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalibrationProfilesTable> {
  $$CalibrationProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get profileJson => $composableBuilder(
    column: $table.profileJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get calibratedAt => $composableBuilder(
    column: $table.calibratedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$CalibrationProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalibrationProfilesTable,
          CalibrationProfile,
          $$CalibrationProfilesTableFilterComposer,
          $$CalibrationProfilesTableOrderingComposer,
          $$CalibrationProfilesTableAnnotationComposer,
          $$CalibrationProfilesTableCreateCompanionBuilder,
          $$CalibrationProfilesTableUpdateCompanionBuilder,
          (
            CalibrationProfile,
            BaseReferences<
              _$AppDatabase,
              $CalibrationProfilesTable,
              CalibrationProfile
            >,
          ),
          CalibrationProfile,
          PrefetchHooks Function()
        > {
  $$CalibrationProfilesTableTableManager(
    _$AppDatabase db,
    $CalibrationProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalibrationProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalibrationProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalibrationProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> profileJson = const Value.absent(),
                Value<DateTime> calibratedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => CalibrationProfilesCompanion(
                id: id,
                name: name,
                profileJson: profileJson,
                calibratedAt: calibratedAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String profileJson,
                required DateTime calibratedAt,
                Value<bool> isActive = const Value.absent(),
              }) => CalibrationProfilesCompanion.insert(
                id: id,
                name: name,
                profileJson: profileJson,
                calibratedAt: calibratedAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalibrationProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalibrationProfilesTable,
      CalibrationProfile,
      $$CalibrationProfilesTableFilterComposer,
      $$CalibrationProfilesTableOrderingComposer,
      $$CalibrationProfilesTableAnnotationComposer,
      $$CalibrationProfilesTableCreateCompanionBuilder,
      $$CalibrationProfilesTableUpdateCompanionBuilder,
      (
        CalibrationProfile,
        BaseReferences<
          _$AppDatabase,
          $CalibrationProfilesTable,
          CalibrationProfile
        >,
      ),
      CalibrationProfile,
      PrefetchHooks Function()
    >;
typedef $$PairedDevicesTableCreateCompanionBuilder =
    PairedDevicesCompanion Function({
      Value<int> id,
      required String deviceId,
      required String type,
      required String name,
      Value<String?> platform,
      Value<DateTime?> lastSeen,
    });
typedef $$PairedDevicesTableUpdateCompanionBuilder =
    PairedDevicesCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String> type,
      Value<String> name,
      Value<String?> platform,
      Value<DateTime?> lastSeen,
    });

class $$PairedDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $PairedDevicesTable> {
  $$PairedDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PairedDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PairedDevicesTable> {
  $$PairedDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PairedDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PairedDevicesTable> {
  $$PairedDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);
}

class $$PairedDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PairedDevicesTable,
          PairedDevice,
          $$PairedDevicesTableFilterComposer,
          $$PairedDevicesTableOrderingComposer,
          $$PairedDevicesTableAnnotationComposer,
          $$PairedDevicesTableCreateCompanionBuilder,
          $$PairedDevicesTableUpdateCompanionBuilder,
          (
            PairedDevice,
            BaseReferences<_$AppDatabase, $PairedDevicesTable, PairedDevice>,
          ),
          PairedDevice,
          PrefetchHooks Function()
        > {
  $$PairedDevicesTableTableManager(_$AppDatabase db, $PairedDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PairedDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PairedDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PairedDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
              }) => PairedDevicesCompanion(
                id: id,
                deviceId: deviceId,
                type: type,
                name: name,
                platform: platform,
                lastSeen: lastSeen,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required String type,
                required String name,
                Value<String?> platform = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
              }) => PairedDevicesCompanion.insert(
                id: id,
                deviceId: deviceId,
                type: type,
                name: name,
                platform: platform,
                lastSeen: lastSeen,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PairedDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PairedDevicesTable,
      PairedDevice,
      $$PairedDevicesTableFilterComposer,
      $$PairedDevicesTableOrderingComposer,
      $$PairedDevicesTableAnnotationComposer,
      $$PairedDevicesTableCreateCompanionBuilder,
      $$PairedDevicesTableUpdateCompanionBuilder,
      (
        PairedDevice,
        BaseReferences<_$AppDatabase, $PairedDevicesTable, PairedDevice>,
      ),
      PairedDevice,
      PrefetchHooks Function()
    >;
typedef $$CaregiversTableCreateCompanionBuilder =
    CaregiversCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> email,
      required String scopesJson,
      Value<bool> isActive,
    });
typedef $$CaregiversTableUpdateCompanionBuilder =
    CaregiversCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> email,
      Value<String> scopesJson,
      Value<bool> isActive,
    });

class $$CaregiversTableFilterComposer
    extends Composer<_$AppDatabase, $CaregiversTable> {
  $$CaregiversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopesJson => $composableBuilder(
    column: $table.scopesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaregiversTableOrderingComposer
    extends Composer<_$AppDatabase, $CaregiversTable> {
  $$CaregiversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopesJson => $composableBuilder(
    column: $table.scopesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaregiversTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaregiversTable> {
  $$CaregiversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get scopesJson => $composableBuilder(
    column: $table.scopesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$CaregiversTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaregiversTable,
          Caregiver,
          $$CaregiversTableFilterComposer,
          $$CaregiversTableOrderingComposer,
          $$CaregiversTableAnnotationComposer,
          $$CaregiversTableCreateCompanionBuilder,
          $$CaregiversTableUpdateCompanionBuilder,
          (
            Caregiver,
            BaseReferences<_$AppDatabase, $CaregiversTable, Caregiver>,
          ),
          Caregiver,
          PrefetchHooks Function()
        > {
  $$CaregiversTableTableManager(_$AppDatabase db, $CaregiversTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaregiversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaregiversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaregiversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> scopesJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => CaregiversCompanion(
                id: id,
                name: name,
                phone: phone,
                email: email,
                scopesJson: scopesJson,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required String scopesJson,
                Value<bool> isActive = const Value.absent(),
              }) => CaregiversCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                email: email,
                scopesJson: scopesJson,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaregiversTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaregiversTable,
      Caregiver,
      $$CaregiversTableFilterComposer,
      $$CaregiversTableOrderingComposer,
      $$CaregiversTableAnnotationComposer,
      $$CaregiversTableCreateCompanionBuilder,
      $$CaregiversTableUpdateCompanionBuilder,
      (Caregiver, BaseReferences<_$AppDatabase, $CaregiversTable, Caregiver>),
      Caregiver,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required String title,
      required String scheduleCron,
      Value<DateTime?> lastConfirmed,
      Value<int> escalateAfterMin,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> scheduleCron,
      Value<DateTime?> lastConfirmed,
      Value<int> escalateAfterMin,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleCron => $composableBuilder(
    column: $table.scheduleCron,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastConfirmed => $composableBuilder(
    column: $table.lastConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get escalateAfterMin => $composableBuilder(
    column: $table.escalateAfterMin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleCron => $composableBuilder(
    column: $table.scheduleCron,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastConfirmed => $composableBuilder(
    column: $table.lastConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get escalateAfterMin => $composableBuilder(
    column: $table.escalateAfterMin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get scheduleCron => $composableBuilder(
    column: $table.scheduleCron,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastConfirmed => $composableBuilder(
    column: $table.lastConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get escalateAfterMin => $composableBuilder(
    column: $table.escalateAfterMin,
    builder: (column) => column,
  );
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> scheduleCron = const Value.absent(),
                Value<DateTime?> lastConfirmed = const Value.absent(),
                Value<int> escalateAfterMin = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                title: title,
                scheduleCron: scheduleCron,
                lastConfirmed: lastConfirmed,
                escalateAfterMin: escalateAfterMin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String scheduleCron,
                Value<DateTime?> lastConfirmed = const Value.absent(),
                Value<int> escalateAfterMin = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                title: title,
                scheduleCron: scheduleCron,
                lastConfirmed: lastConfirmed,
                escalateAfterMin: escalateAfterMin,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$SessionLogsTableCreateCompanionBuilder =
    SessionLogsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      required int durationSec,
      required int intentCount,
      required double avgSignalQuality,
      Value<String?> summaryJson,
      Value<bool> synced,
    });
typedef $$SessionLogsTableUpdateCompanionBuilder =
    SessionLogsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<int> durationSec,
      Value<int> intentCount,
      Value<double> avgSignalQuality,
      Value<String?> summaryJson,
      Value<bool> synced,
    });

class $$SessionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intentCount => $composableBuilder(
    column: $table.intentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSignalQuality => $composableBuilder(
    column: $table.avgSignalQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intentCount => $composableBuilder(
    column: $table.intentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSignalQuality => $composableBuilder(
    column: $table.avgSignalQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intentCount => $composableBuilder(
    column: $table.intentCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgSignalQuality => $composableBuilder(
    column: $table.avgSignalQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$SessionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionLogsTable,
          SessionLog,
          $$SessionLogsTableFilterComposer,
          $$SessionLogsTableOrderingComposer,
          $$SessionLogsTableAnnotationComposer,
          $$SessionLogsTableCreateCompanionBuilder,
          $$SessionLogsTableUpdateCompanionBuilder,
          (
            SessionLog,
            BaseReferences<_$AppDatabase, $SessionLogsTable, SessionLog>,
          ),
          SessionLog,
          PrefetchHooks Function()
        > {
  $$SessionLogsTableTableManager(_$AppDatabase db, $SessionLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<int> intentCount = const Value.absent(),
                Value<double> avgSignalQuality = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SessionLogsCompanion(
                id: id,
                startedAt: startedAt,
                durationSec: durationSec,
                intentCount: intentCount,
                avgSignalQuality: avgSignalQuality,
                summaryJson: summaryJson,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                required int durationSec,
                required int intentCount,
                required double avgSignalQuality,
                Value<String?> summaryJson = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SessionLogsCompanion.insert(
                id: id,
                startedAt: startedAt,
                durationSec: durationSec,
                intentCount: intentCount,
                avgSignalQuality: avgSignalQuality,
                summaryJson: summaryJson,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionLogsTable,
      SessionLog,
      $$SessionLogsTableFilterComposer,
      $$SessionLogsTableOrderingComposer,
      $$SessionLogsTableAnnotationComposer,
      $$SessionLogsTableCreateCompanionBuilder,
      $$SessionLogsTableUpdateCompanionBuilder,
      (
        SessionLog,
        BaseReferences<_$AppDatabase, $SessionLogsTable, SessionLog>,
      ),
      SessionLog,
      PrefetchHooks Function()
    >;
typedef $$OfflineQueueTableCreateCompanionBuilder =
    OfflineQueueCompanion Function({
      Value<int> id,
      required String endpoint,
      required String payloadJson,
      required DateTime createdAt,
      Value<int> retryCount,
    });
typedef $$OfflineQueueTableUpdateCompanionBuilder =
    OfflineQueueCompanion Function({
      Value<int> id,
      Value<String> endpoint,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> retryCount,
    });

class $$OfflineQueueTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$OfflineQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineQueueTable,
          OfflineQueueData,
          $$OfflineQueueTableFilterComposer,
          $$OfflineQueueTableOrderingComposer,
          $$OfflineQueueTableAnnotationComposer,
          $$OfflineQueueTableCreateCompanionBuilder,
          $$OfflineQueueTableUpdateCompanionBuilder,
          (
            OfflineQueueData,
            BaseReferences<_$AppDatabase, $OfflineQueueTable, OfflineQueueData>,
          ),
          OfflineQueueData,
          PrefetchHooks Function()
        > {
  $$OfflineQueueTableTableManager(_$AppDatabase db, $OfflineQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> endpoint = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => OfflineQueueCompanion(
                id: id,
                endpoint: endpoint,
                payloadJson: payloadJson,
                createdAt: createdAt,
                retryCount: retryCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String endpoint,
                required String payloadJson,
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
              }) => OfflineQueueCompanion.insert(
                id: id,
                endpoint: endpoint,
                payloadJson: payloadJson,
                createdAt: createdAt,
                retryCount: retryCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineQueueTable,
      OfflineQueueData,
      $$OfflineQueueTableFilterComposer,
      $$OfflineQueueTableOrderingComposer,
      $$OfflineQueueTableAnnotationComposer,
      $$OfflineQueueTableCreateCompanionBuilder,
      $$OfflineQueueTableUpdateCompanionBuilder,
      (
        OfflineQueueData,
        BaseReferences<_$AppDatabase, $OfflineQueueTable, OfflineQueueData>,
      ),
      OfflineQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CalibrationProfilesTableTableManager get calibrationProfiles =>
      $$CalibrationProfilesTableTableManager(_db, _db.calibrationProfiles);
  $$PairedDevicesTableTableManager get pairedDevices =>
      $$PairedDevicesTableTableManager(_db, _db.pairedDevices);
  $$CaregiversTableTableManager get caregivers =>
      $$CaregiversTableTableManager(_db, _db.caregivers);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$SessionLogsTableTableManager get sessionLogs =>
      $$SessionLogsTableTableManager(_db, _db.sessionLogs);
  $$OfflineQueueTableTableManager get offlineQueue =>
      $$OfflineQueueTableTableManager(_db, _db.offlineQueue);
}
