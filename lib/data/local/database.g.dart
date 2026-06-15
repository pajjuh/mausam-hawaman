// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    lat,
    lng,
    isDefault,
    district,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Location> instance, {
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
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final bool isDefault;
  final String? district;
  final String? state;
  const Location({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.isDefault,
    this.district,
    this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      name: Value(name),
      lat: Value(lat),
      lng: Value(lng),
      isDefault: Value(isDefault),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
    );
  }

  factory Location.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      district: serializer.fromJson<String?>(json['district']),
      state: serializer.fromJson<String?>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'isDefault': serializer.toJson<bool>(isDefault),
      'district': serializer.toJson<String?>(district),
      'state': serializer.toJson<String?>(state),
    };
  }

  Location copyWith({
    int? id,
    String? name,
    double? lat,
    double? lng,
    bool? isDefault,
    Value<String?> district = const Value.absent(),
    Value<String?> state = const Value.absent(),
  }) => Location(
    id: id ?? this.id,
    name: name ?? this.name,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    isDefault: isDefault ?? this.isDefault,
    district: district.present ? district.value : this.district,
    state: state.present ? state.value : this.state,
  );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      district: data.district.present ? data.district.value : this.district,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('isDefault: $isDefault, ')
          ..write('district: $district, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, lat, lng, isDefault, district, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.isDefault == this.isDefault &&
          other.district == this.district &&
          other.state == this.state);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lng;
  final Value<bool> isDefault;
  final Value<String?> district;
  final Value<String?> state;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.district = const Value.absent(),
    this.state = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double lat,
    required double lng,
    this.isDefault = const Value.absent(),
    this.district = const Value.absent(),
    this.state = const Value.absent(),
  }) : name = Value(name),
       lat = Value(lat),
       lng = Value(lng);
  static Insertable<Location> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<bool>? isDefault,
    Expression<String>? district,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (isDefault != null) 'is_default': isDefault,
      if (district != null) 'district': district,
      if (state != null) 'state': state,
    });
  }

  LocationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? lat,
    Value<double>? lng,
    Value<bool>? isDefault,
    Value<String?>? district,
    Value<String?>? state,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
      district: district ?? this.district,
      state: state ?? this.state,
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
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('isDefault: $isDefault, ')
          ..write('district: $district, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class $WeatherForecastsTable extends WeatherForecasts
    with TableInfo<$WeatherForecastsTable, WeatherForecast> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherForecastsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open_meteo'),
  );
  static const VerificationMeta _hourlyJsonMeta = const VerificationMeta(
    'hourlyJson',
  );
  @override
  late final GeneratedColumn<String> hourlyJson = GeneratedColumn<String>(
    'hourly_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyJsonMeta = const VerificationMeta(
    'dailyJson',
  );
  @override
  late final GeneratedColumn<String> dailyJson = GeneratedColumn<String>(
    'daily_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    fetchedAt,
    model,
    hourlyJson,
    dailyJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_forecasts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeatherForecast> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('hourly_json')) {
      context.handle(
        _hourlyJsonMeta,
        hourlyJson.isAcceptableOrUnknown(data['hourly_json']!, _hourlyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_hourlyJsonMeta);
    }
    if (data.containsKey('daily_json')) {
      context.handle(
        _dailyJsonMeta,
        dailyJson.isAcceptableOrUnknown(data['daily_json']!, _dailyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dailyJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeatherForecast map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherForecast(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      hourlyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hourly_json'],
      )!,
      dailyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}daily_json'],
      )!,
    );
  }

  @override
  $WeatherForecastsTable createAlias(String alias) {
    return $WeatherForecastsTable(attachedDatabase, alias);
  }
}

class WeatherForecast extends DataClass implements Insertable<WeatherForecast> {
  final int id;
  final int locationId;
  final DateTime fetchedAt;
  final String model;
  final String hourlyJson;
  final String dailyJson;
  const WeatherForecast({
    required this.id,
    required this.locationId,
    required this.fetchedAt,
    required this.model,
    required this.hourlyJson,
    required this.dailyJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_id'] = Variable<int>(locationId);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['model'] = Variable<String>(model);
    map['hourly_json'] = Variable<String>(hourlyJson);
    map['daily_json'] = Variable<String>(dailyJson);
    return map;
  }

  WeatherForecastsCompanion toCompanion(bool nullToAbsent) {
    return WeatherForecastsCompanion(
      id: Value(id),
      locationId: Value(locationId),
      fetchedAt: Value(fetchedAt),
      model: Value(model),
      hourlyJson: Value(hourlyJson),
      dailyJson: Value(dailyJson),
    );
  }

  factory WeatherForecast.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherForecast(
      id: serializer.fromJson<int>(json['id']),
      locationId: serializer.fromJson<int>(json['locationId']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      model: serializer.fromJson<String>(json['model']),
      hourlyJson: serializer.fromJson<String>(json['hourlyJson']),
      dailyJson: serializer.fromJson<String>(json['dailyJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationId': serializer.toJson<int>(locationId),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'model': serializer.toJson<String>(model),
      'hourlyJson': serializer.toJson<String>(hourlyJson),
      'dailyJson': serializer.toJson<String>(dailyJson),
    };
  }

  WeatherForecast copyWith({
    int? id,
    int? locationId,
    DateTime? fetchedAt,
    String? model,
    String? hourlyJson,
    String? dailyJson,
  }) => WeatherForecast(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    model: model ?? this.model,
    hourlyJson: hourlyJson ?? this.hourlyJson,
    dailyJson: dailyJson ?? this.dailyJson,
  );
  WeatherForecast copyWithCompanion(WeatherForecastsCompanion data) {
    return WeatherForecast(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      model: data.model.present ? data.model.value : this.model,
      hourlyJson: data.hourlyJson.present
          ? data.hourlyJson.value
          : this.hourlyJson,
      dailyJson: data.dailyJson.present ? data.dailyJson.value : this.dailyJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherForecast(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('model: $model, ')
          ..write('hourlyJson: $hourlyJson, ')
          ..write('dailyJson: $dailyJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, locationId, fetchedAt, model, hourlyJson, dailyJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherForecast &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.fetchedAt == this.fetchedAt &&
          other.model == this.model &&
          other.hourlyJson == this.hourlyJson &&
          other.dailyJson == this.dailyJson);
}

class WeatherForecastsCompanion extends UpdateCompanion<WeatherForecast> {
  final Value<int> id;
  final Value<int> locationId;
  final Value<DateTime> fetchedAt;
  final Value<String> model;
  final Value<String> hourlyJson;
  final Value<String> dailyJson;
  const WeatherForecastsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.model = const Value.absent(),
    this.hourlyJson = const Value.absent(),
    this.dailyJson = const Value.absent(),
  });
  WeatherForecastsCompanion.insert({
    this.id = const Value.absent(),
    required int locationId,
    required DateTime fetchedAt,
    this.model = const Value.absent(),
    required String hourlyJson,
    required String dailyJson,
  }) : locationId = Value(locationId),
       fetchedAt = Value(fetchedAt),
       hourlyJson = Value(hourlyJson),
       dailyJson = Value(dailyJson);
  static Insertable<WeatherForecast> custom({
    Expression<int>? id,
    Expression<int>? locationId,
    Expression<DateTime>? fetchedAt,
    Expression<String>? model,
    Expression<String>? hourlyJson,
    Expression<String>? dailyJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (model != null) 'model': model,
      if (hourlyJson != null) 'hourly_json': hourlyJson,
      if (dailyJson != null) 'daily_json': dailyJson,
    });
  }

  WeatherForecastsCompanion copyWith({
    Value<int>? id,
    Value<int>? locationId,
    Value<DateTime>? fetchedAt,
    Value<String>? model,
    Value<String>? hourlyJson,
    Value<String>? dailyJson,
  }) {
    return WeatherForecastsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      model: model ?? this.model,
      hourlyJson: hourlyJson ?? this.hourlyJson,
      dailyJson: dailyJson ?? this.dailyJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (hourlyJson.present) {
      map['hourly_json'] = Variable<String>(hourlyJson.value);
    }
    if (dailyJson.present) {
      map['daily_json'] = Variable<String>(dailyJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherForecastsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('model: $model, ')
          ..write('hourlyJson: $hourlyJson, ')
          ..write('dailyJson: $dailyJson')
          ..write(')'))
        .toString();
  }
}

class $AqiRecordsTable extends AqiRecords
    with TableInfo<$AqiRecordsTable, AqiRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AqiRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aqiMeta = const VerificationMeta('aqi');
  @override
  late final GeneratedColumn<int> aqi = GeneratedColumn<int>(
    'aqi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pm25Meta = const VerificationMeta('pm25');
  @override
  late final GeneratedColumn<double> pm25 = GeneratedColumn<double>(
    'pm25',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pm10Meta = const VerificationMeta('pm10');
  @override
  late final GeneratedColumn<double> pm10 = GeneratedColumn<double>(
    'pm10',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uvIndexMeta = const VerificationMeta(
    'uvIndex',
  );
  @override
  late final GeneratedColumn<double> uvIndex = GeneratedColumn<double>(
    'uv_index',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    fetchedAt,
    aqi,
    pm25,
    pm10,
    uvIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aqi_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AqiRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('aqi')) {
      context.handle(
        _aqiMeta,
        aqi.isAcceptableOrUnknown(data['aqi']!, _aqiMeta),
      );
    } else if (isInserting) {
      context.missing(_aqiMeta);
    }
    if (data.containsKey('pm25')) {
      context.handle(
        _pm25Meta,
        pm25.isAcceptableOrUnknown(data['pm25']!, _pm25Meta),
      );
    } else if (isInserting) {
      context.missing(_pm25Meta);
    }
    if (data.containsKey('pm10')) {
      context.handle(
        _pm10Meta,
        pm10.isAcceptableOrUnknown(data['pm10']!, _pm10Meta),
      );
    } else if (isInserting) {
      context.missing(_pm10Meta);
    }
    if (data.containsKey('uv_index')) {
      context.handle(
        _uvIndexMeta,
        uvIndex.isAcceptableOrUnknown(data['uv_index']!, _uvIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_uvIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AqiRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AqiRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      aqi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aqi'],
      )!,
      pm25: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pm25'],
      )!,
      pm10: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pm10'],
      )!,
      uvIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}uv_index'],
      )!,
    );
  }

  @override
  $AqiRecordsTable createAlias(String alias) {
    return $AqiRecordsTable(attachedDatabase, alias);
  }
}

class AqiRecord extends DataClass implements Insertable<AqiRecord> {
  final int id;
  final int locationId;
  final DateTime fetchedAt;
  final int aqi;
  final double pm25;
  final double pm10;
  final double uvIndex;
  const AqiRecord({
    required this.id,
    required this.locationId,
    required this.fetchedAt,
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.uvIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_id'] = Variable<int>(locationId);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['aqi'] = Variable<int>(aqi);
    map['pm25'] = Variable<double>(pm25);
    map['pm10'] = Variable<double>(pm10);
    map['uv_index'] = Variable<double>(uvIndex);
    return map;
  }

  AqiRecordsCompanion toCompanion(bool nullToAbsent) {
    return AqiRecordsCompanion(
      id: Value(id),
      locationId: Value(locationId),
      fetchedAt: Value(fetchedAt),
      aqi: Value(aqi),
      pm25: Value(pm25),
      pm10: Value(pm10),
      uvIndex: Value(uvIndex),
    );
  }

  factory AqiRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AqiRecord(
      id: serializer.fromJson<int>(json['id']),
      locationId: serializer.fromJson<int>(json['locationId']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      aqi: serializer.fromJson<int>(json['aqi']),
      pm25: serializer.fromJson<double>(json['pm25']),
      pm10: serializer.fromJson<double>(json['pm10']),
      uvIndex: serializer.fromJson<double>(json['uvIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationId': serializer.toJson<int>(locationId),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'aqi': serializer.toJson<int>(aqi),
      'pm25': serializer.toJson<double>(pm25),
      'pm10': serializer.toJson<double>(pm10),
      'uvIndex': serializer.toJson<double>(uvIndex),
    };
  }

  AqiRecord copyWith({
    int? id,
    int? locationId,
    DateTime? fetchedAt,
    int? aqi,
    double? pm25,
    double? pm10,
    double? uvIndex,
  }) => AqiRecord(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    aqi: aqi ?? this.aqi,
    pm25: pm25 ?? this.pm25,
    pm10: pm10 ?? this.pm10,
    uvIndex: uvIndex ?? this.uvIndex,
  );
  AqiRecord copyWithCompanion(AqiRecordsCompanion data) {
    return AqiRecord(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      aqi: data.aqi.present ? data.aqi.value : this.aqi,
      pm25: data.pm25.present ? data.pm25.value : this.pm25,
      pm10: data.pm10.present ? data.pm10.value : this.pm10,
      uvIndex: data.uvIndex.present ? data.uvIndex.value : this.uvIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AqiRecord(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('aqi: $aqi, ')
          ..write('pm25: $pm25, ')
          ..write('pm10: $pm10, ')
          ..write('uvIndex: $uvIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, locationId, fetchedAt, aqi, pm25, pm10, uvIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AqiRecord &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.fetchedAt == this.fetchedAt &&
          other.aqi == this.aqi &&
          other.pm25 == this.pm25 &&
          other.pm10 == this.pm10 &&
          other.uvIndex == this.uvIndex);
}

class AqiRecordsCompanion extends UpdateCompanion<AqiRecord> {
  final Value<int> id;
  final Value<int> locationId;
  final Value<DateTime> fetchedAt;
  final Value<int> aqi;
  final Value<double> pm25;
  final Value<double> pm10;
  final Value<double> uvIndex;
  const AqiRecordsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.aqi = const Value.absent(),
    this.pm25 = const Value.absent(),
    this.pm10 = const Value.absent(),
    this.uvIndex = const Value.absent(),
  });
  AqiRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int locationId,
    required DateTime fetchedAt,
    required int aqi,
    required double pm25,
    required double pm10,
    required double uvIndex,
  }) : locationId = Value(locationId),
       fetchedAt = Value(fetchedAt),
       aqi = Value(aqi),
       pm25 = Value(pm25),
       pm10 = Value(pm10),
       uvIndex = Value(uvIndex);
  static Insertable<AqiRecord> custom({
    Expression<int>? id,
    Expression<int>? locationId,
    Expression<DateTime>? fetchedAt,
    Expression<int>? aqi,
    Expression<double>? pm25,
    Expression<double>? pm10,
    Expression<double>? uvIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (aqi != null) 'aqi': aqi,
      if (pm25 != null) 'pm25': pm25,
      if (pm10 != null) 'pm10': pm10,
      if (uvIndex != null) 'uv_index': uvIndex,
    });
  }

  AqiRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? locationId,
    Value<DateTime>? fetchedAt,
    Value<int>? aqi,
    Value<double>? pm25,
    Value<double>? pm10,
    Value<double>? uvIndex,
  }) {
    return AqiRecordsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      aqi: aqi ?? this.aqi,
      pm25: pm25 ?? this.pm25,
      pm10: pm10 ?? this.pm10,
      uvIndex: uvIndex ?? this.uvIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (aqi.present) {
      map['aqi'] = Variable<int>(aqi.value);
    }
    if (pm25.present) {
      map['pm25'] = Variable<double>(pm25.value);
    }
    if (pm10.present) {
      map['pm10'] = Variable<double>(pm10.value);
    }
    if (uvIndex.present) {
      map['uv_index'] = Variable<double>(uvIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AqiRecordsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('aqi: $aqi, ')
          ..write('pm25: $pm25, ')
          ..write('pm10: $pm10, ')
          ..write('uvIndex: $uvIndex')
          ..write(')'))
        .toString();
  }
}

class $FarmingLogsTable extends FarmingLogs
    with TableInfo<$FarmingLogsTable, FarmingLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmingLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sprayWindowsJsonMeta = const VerificationMeta(
    'sprayWindowsJson',
  );
  @override
  late final GeneratedColumn<String> sprayWindowsJson = GeneratedColumn<String>(
    'spray_windows_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soilMoistureMeta = const VerificationMeta(
    'soilMoisture',
  );
  @override
  late final GeneratedColumn<double> soilMoisture = GeneratedColumn<double>(
    'soil_moisture',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    date,
    sprayWindowsJson,
    soilMoisture,
    crop,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farming_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmingLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('spray_windows_json')) {
      context.handle(
        _sprayWindowsJsonMeta,
        sprayWindowsJson.isAcceptableOrUnknown(
          data['spray_windows_json']!,
          _sprayWindowsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sprayWindowsJsonMeta);
    }
    if (data.containsKey('soil_moisture')) {
      context.handle(
        _soilMoistureMeta,
        soilMoisture.isAcceptableOrUnknown(
          data['soil_moisture']!,
          _soilMoistureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_soilMoistureMeta);
    }
    if (data.containsKey('crop')) {
      context.handle(
        _cropMeta,
        crop.isAcceptableOrUnknown(data['crop']!, _cropMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmingLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmingLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      sprayWindowsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spray_windows_json'],
      )!,
      soilMoisture: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}soil_moisture'],
      )!,
      crop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop'],
      ),
    );
  }

  @override
  $FarmingLogsTable createAlias(String alias) {
    return $FarmingLogsTable(attachedDatabase, alias);
  }
}

class FarmingLog extends DataClass implements Insertable<FarmingLog> {
  final int id;
  final int locationId;
  final DateTime date;
  final String sprayWindowsJson;
  final double soilMoisture;
  final String? crop;
  const FarmingLog({
    required this.id,
    required this.locationId,
    required this.date,
    required this.sprayWindowsJson,
    required this.soilMoisture,
    this.crop,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_id'] = Variable<int>(locationId);
    map['date'] = Variable<DateTime>(date);
    map['spray_windows_json'] = Variable<String>(sprayWindowsJson);
    map['soil_moisture'] = Variable<double>(soilMoisture);
    if (!nullToAbsent || crop != null) {
      map['crop'] = Variable<String>(crop);
    }
    return map;
  }

  FarmingLogsCompanion toCompanion(bool nullToAbsent) {
    return FarmingLogsCompanion(
      id: Value(id),
      locationId: Value(locationId),
      date: Value(date),
      sprayWindowsJson: Value(sprayWindowsJson),
      soilMoisture: Value(soilMoisture),
      crop: crop == null && nullToAbsent ? const Value.absent() : Value(crop),
    );
  }

  factory FarmingLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmingLog(
      id: serializer.fromJson<int>(json['id']),
      locationId: serializer.fromJson<int>(json['locationId']),
      date: serializer.fromJson<DateTime>(json['date']),
      sprayWindowsJson: serializer.fromJson<String>(json['sprayWindowsJson']),
      soilMoisture: serializer.fromJson<double>(json['soilMoisture']),
      crop: serializer.fromJson<String?>(json['crop']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationId': serializer.toJson<int>(locationId),
      'date': serializer.toJson<DateTime>(date),
      'sprayWindowsJson': serializer.toJson<String>(sprayWindowsJson),
      'soilMoisture': serializer.toJson<double>(soilMoisture),
      'crop': serializer.toJson<String?>(crop),
    };
  }

  FarmingLog copyWith({
    int? id,
    int? locationId,
    DateTime? date,
    String? sprayWindowsJson,
    double? soilMoisture,
    Value<String?> crop = const Value.absent(),
  }) => FarmingLog(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    date: date ?? this.date,
    sprayWindowsJson: sprayWindowsJson ?? this.sprayWindowsJson,
    soilMoisture: soilMoisture ?? this.soilMoisture,
    crop: crop.present ? crop.value : this.crop,
  );
  FarmingLog copyWithCompanion(FarmingLogsCompanion data) {
    return FarmingLog(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      date: data.date.present ? data.date.value : this.date,
      sprayWindowsJson: data.sprayWindowsJson.present
          ? data.sprayWindowsJson.value
          : this.sprayWindowsJson,
      soilMoisture: data.soilMoisture.present
          ? data.soilMoisture.value
          : this.soilMoisture,
      crop: data.crop.present ? data.crop.value : this.crop,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmingLog(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('date: $date, ')
          ..write('sprayWindowsJson: $sprayWindowsJson, ')
          ..write('soilMoisture: $soilMoisture, ')
          ..write('crop: $crop')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, locationId, date, sprayWindowsJson, soilMoisture, crop);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmingLog &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.date == this.date &&
          other.sprayWindowsJson == this.sprayWindowsJson &&
          other.soilMoisture == this.soilMoisture &&
          other.crop == this.crop);
}

class FarmingLogsCompanion extends UpdateCompanion<FarmingLog> {
  final Value<int> id;
  final Value<int> locationId;
  final Value<DateTime> date;
  final Value<String> sprayWindowsJson;
  final Value<double> soilMoisture;
  final Value<String?> crop;
  const FarmingLogsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.date = const Value.absent(),
    this.sprayWindowsJson = const Value.absent(),
    this.soilMoisture = const Value.absent(),
    this.crop = const Value.absent(),
  });
  FarmingLogsCompanion.insert({
    this.id = const Value.absent(),
    required int locationId,
    required DateTime date,
    required String sprayWindowsJson,
    required double soilMoisture,
    this.crop = const Value.absent(),
  }) : locationId = Value(locationId),
       date = Value(date),
       sprayWindowsJson = Value(sprayWindowsJson),
       soilMoisture = Value(soilMoisture);
  static Insertable<FarmingLog> custom({
    Expression<int>? id,
    Expression<int>? locationId,
    Expression<DateTime>? date,
    Expression<String>? sprayWindowsJson,
    Expression<double>? soilMoisture,
    Expression<String>? crop,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (date != null) 'date': date,
      if (sprayWindowsJson != null) 'spray_windows_json': sprayWindowsJson,
      if (soilMoisture != null) 'soil_moisture': soilMoisture,
      if (crop != null) 'crop': crop,
    });
  }

  FarmingLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? locationId,
    Value<DateTime>? date,
    Value<String>? sprayWindowsJson,
    Value<double>? soilMoisture,
    Value<String?>? crop,
  }) {
    return FarmingLogsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      date: date ?? this.date,
      sprayWindowsJson: sprayWindowsJson ?? this.sprayWindowsJson,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      crop: crop ?? this.crop,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (sprayWindowsJson.present) {
      map['spray_windows_json'] = Variable<String>(sprayWindowsJson.value);
    }
    if (soilMoisture.present) {
      map['soil_moisture'] = Variable<double>(soilMoisture.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmingLogsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('date: $date, ')
          ..write('sprayWindowsJson: $sprayWindowsJson, ')
          ..write('soilMoisture: $soilMoisture, ')
          ..write('crop: $crop')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $WeatherForecastsTable weatherForecasts = $WeatherForecastsTable(
    this,
  );
  late final $AqiRecordsTable aqiRecords = $AqiRecordsTable(this);
  late final $FarmingLogsTable farmingLogs = $FarmingLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    locations,
    weatherForecasts,
    aqiRecords,
    farmingLogs,
  ];
}

typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      Value<int> id,
      required String name,
      required double lat,
      required double lng,
      Value<bool> isDefault,
      Value<String?> district,
      Value<String?> state,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> lat,
      Value<double> lng,
      Value<bool> isDefault,
      Value<String?> district,
      Value<String?> state,
    });

final class $$LocationsTableReferences
    extends BaseReferences<_$AppDatabase, $LocationsTable, Location> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WeatherForecastsTable, List<WeatherForecast>>
  _weatherForecastsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weatherForecasts,
    aliasName: $_aliasNameGenerator(
      db.locations.id,
      db.weatherForecasts.locationId,
    ),
  );

  $$WeatherForecastsTableProcessedTableManager get weatherForecastsRefs {
    final manager = $$WeatherForecastsTableTableManager(
      $_db,
      $_db.weatherForecasts,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weatherForecastsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AqiRecordsTable, List<AqiRecord>>
  _aqiRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.aqiRecords,
    aliasName: $_aliasNameGenerator(db.locations.id, db.aqiRecords.locationId),
  );

  $$AqiRecordsTableProcessedTableManager get aqiRecordsRefs {
    final manager = $$AqiRecordsTableTableManager(
      $_db,
      $_db.aqiRecords,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_aqiRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FarmingLogsTable, List<FarmingLog>>
  _farmingLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.farmingLogs,
    aliasName: $_aliasNameGenerator(db.locations.id, db.farmingLogs.locationId),
  );

  $$FarmingLogsTableProcessedTableManager get farmingLogsRefs {
    final manager = $$FarmingLogsTableTableManager(
      $_db,
      $_db.farmingLogs,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_farmingLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
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

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weatherForecastsRefs(
    Expression<bool> Function($$WeatherForecastsTableFilterComposer f) f,
  ) {
    final $$WeatherForecastsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weatherForecasts,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeatherForecastsTableFilterComposer(
            $db: $db,
            $table: $db.weatherForecasts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> aqiRecordsRefs(
    Expression<bool> Function($$AqiRecordsTableFilterComposer f) f,
  ) {
    final $$AqiRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aqiRecords,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AqiRecordsTableFilterComposer(
            $db: $db,
            $table: $db.aqiRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> farmingLogsRefs(
    Expression<bool> Function($$FarmingLogsTableFilterComposer f) f,
  ) {
    final $$FarmingLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.farmingLogs,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmingLogsTableFilterComposer(
            $db: $db,
            $table: $db.farmingLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
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

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
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

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  Expression<T> weatherForecastsRefs<T extends Object>(
    Expression<T> Function($$WeatherForecastsTableAnnotationComposer a) f,
  ) {
    final $$WeatherForecastsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weatherForecasts,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeatherForecastsTableAnnotationComposer(
            $db: $db,
            $table: $db.weatherForecasts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> aqiRecordsRefs<T extends Object>(
    Expression<T> Function($$AqiRecordsTableAnnotationComposer a) f,
  ) {
    final $$AqiRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aqiRecords,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AqiRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.aqiRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> farmingLogsRefs<T extends Object>(
    Expression<T> Function($$FarmingLogsTableAnnotationComposer a) f,
  ) {
    final $$FarmingLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.farmingLogs,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FarmingLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.farmingLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          Location,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (Location, $$LocationsTableReferences),
          Location,
          PrefetchHooks Function({
            bool weatherForecastsRefs,
            bool aqiRecordsRefs,
            bool farmingLogsRefs,
          })
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> state = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                name: name,
                lat: lat,
                lng: lng,
                isDefault: isDefault,
                district: district,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double lat,
                required double lng,
                Value<bool> isDefault = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> state = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                name: name,
                lat: lat,
                lng: lng,
                isDefault: isDefault,
                district: district,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                weatherForecastsRefs = false,
                aqiRecordsRefs = false,
                farmingLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weatherForecastsRefs) db.weatherForecasts,
                    if (aqiRecordsRefs) db.aqiRecords,
                    if (farmingLogsRefs) db.farmingLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weatherForecastsRefs)
                        await $_getPrefetchedData<
                          Location,
                          $LocationsTable,
                          WeatherForecast
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._weatherForecastsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).weatherForecastsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.locationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (aqiRecordsRefs)
                        await $_getPrefetchedData<
                          Location,
                          $LocationsTable,
                          AqiRecord
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._aqiRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).aqiRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.locationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (farmingLogsRefs)
                        await $_getPrefetchedData<
                          Location,
                          $LocationsTable,
                          FarmingLog
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._farmingLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).farmingLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.locationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      Location,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (Location, $$LocationsTableReferences),
      Location,
      PrefetchHooks Function({
        bool weatherForecastsRefs,
        bool aqiRecordsRefs,
        bool farmingLogsRefs,
      })
    >;
typedef $$WeatherForecastsTableCreateCompanionBuilder =
    WeatherForecastsCompanion Function({
      Value<int> id,
      required int locationId,
      required DateTime fetchedAt,
      Value<String> model,
      required String hourlyJson,
      required String dailyJson,
    });
typedef $$WeatherForecastsTableUpdateCompanionBuilder =
    WeatherForecastsCompanion Function({
      Value<int> id,
      Value<int> locationId,
      Value<DateTime> fetchedAt,
      Value<String> model,
      Value<String> hourlyJson,
      Value<String> dailyJson,
    });

final class $$WeatherForecastsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WeatherForecastsTable, WeatherForecast> {
  $$WeatherForecastsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocationsTable _locationIdTable(_$AppDatabase db) =>
      db.locations.createAlias(
        $_aliasNameGenerator(db.weatherForecasts.locationId, db.locations.id),
      );

  $$LocationsTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<int>('location_id')!;

    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeatherForecastsTableFilterComposer
    extends Composer<_$AppDatabase, $WeatherForecastsTable> {
  $$WeatherForecastsTableFilterComposer({
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

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hourlyJson => $composableBuilder(
    column: $table.hourlyJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dailyJson => $composableBuilder(
    column: $table.dailyJson,
    builder: (column) => ColumnFilters(column),
  );

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeatherForecastsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeatherForecastsTable> {
  $$WeatherForecastsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hourlyJson => $composableBuilder(
    column: $table.hourlyJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyJson => $composableBuilder(
    column: $table.dailyJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeatherForecastsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeatherForecastsTable> {
  $$WeatherForecastsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get hourlyJson => $composableBuilder(
    column: $table.hourlyJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dailyJson =>
      $composableBuilder(column: $table.dailyJson, builder: (column) => column);

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeatherForecastsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeatherForecastsTable,
          WeatherForecast,
          $$WeatherForecastsTableFilterComposer,
          $$WeatherForecastsTableOrderingComposer,
          $$WeatherForecastsTableAnnotationComposer,
          $$WeatherForecastsTableCreateCompanionBuilder,
          $$WeatherForecastsTableUpdateCompanionBuilder,
          (WeatherForecast, $$WeatherForecastsTableReferences),
          WeatherForecast,
          PrefetchHooks Function({bool locationId})
        > {
  $$WeatherForecastsTableTableManager(
    _$AppDatabase db,
    $WeatherForecastsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherForecastsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherForecastsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherForecastsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> locationId = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> hourlyJson = const Value.absent(),
                Value<String> dailyJson = const Value.absent(),
              }) => WeatherForecastsCompanion(
                id: id,
                locationId: locationId,
                fetchedAt: fetchedAt,
                model: model,
                hourlyJson: hourlyJson,
                dailyJson: dailyJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int locationId,
                required DateTime fetchedAt,
                Value<String> model = const Value.absent(),
                required String hourlyJson,
                required String dailyJson,
              }) => WeatherForecastsCompanion.insert(
                id: id,
                locationId: locationId,
                fetchedAt: fetchedAt,
                model: model,
                hourlyJson: hourlyJson,
                dailyJson: dailyJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeatherForecastsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({locationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (locationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.locationId,
                                referencedTable:
                                    $$WeatherForecastsTableReferences
                                        ._locationIdTable(db),
                                referencedColumn:
                                    $$WeatherForecastsTableReferences
                                        ._locationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeatherForecastsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeatherForecastsTable,
      WeatherForecast,
      $$WeatherForecastsTableFilterComposer,
      $$WeatherForecastsTableOrderingComposer,
      $$WeatherForecastsTableAnnotationComposer,
      $$WeatherForecastsTableCreateCompanionBuilder,
      $$WeatherForecastsTableUpdateCompanionBuilder,
      (WeatherForecast, $$WeatherForecastsTableReferences),
      WeatherForecast,
      PrefetchHooks Function({bool locationId})
    >;
typedef $$AqiRecordsTableCreateCompanionBuilder =
    AqiRecordsCompanion Function({
      Value<int> id,
      required int locationId,
      required DateTime fetchedAt,
      required int aqi,
      required double pm25,
      required double pm10,
      required double uvIndex,
    });
typedef $$AqiRecordsTableUpdateCompanionBuilder =
    AqiRecordsCompanion Function({
      Value<int> id,
      Value<int> locationId,
      Value<DateTime> fetchedAt,
      Value<int> aqi,
      Value<double> pm25,
      Value<double> pm10,
      Value<double> uvIndex,
    });

final class $$AqiRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $AqiRecordsTable, AqiRecord> {
  $$AqiRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocationsTable _locationIdTable(_$AppDatabase db) =>
      db.locations.createAlias(
        $_aliasNameGenerator(db.aqiRecords.locationId, db.locations.id),
      );

  $$LocationsTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<int>('location_id')!;

    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AqiRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AqiRecordsTable> {
  $$AqiRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aqi => $composableBuilder(
    column: $table.aqi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pm25 => $composableBuilder(
    column: $table.pm25,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pm10 => $composableBuilder(
    column: $table.pm10,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get uvIndex => $composableBuilder(
    column: $table.uvIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AqiRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AqiRecordsTable> {
  $$AqiRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aqi => $composableBuilder(
    column: $table.aqi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pm25 => $composableBuilder(
    column: $table.pm25,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pm10 => $composableBuilder(
    column: $table.pm10,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get uvIndex => $composableBuilder(
    column: $table.uvIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AqiRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AqiRecordsTable> {
  $$AqiRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<int> get aqi =>
      $composableBuilder(column: $table.aqi, builder: (column) => column);

  GeneratedColumn<double> get pm25 =>
      $composableBuilder(column: $table.pm25, builder: (column) => column);

  GeneratedColumn<double> get pm10 =>
      $composableBuilder(column: $table.pm10, builder: (column) => column);

  GeneratedColumn<double> get uvIndex =>
      $composableBuilder(column: $table.uvIndex, builder: (column) => column);

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AqiRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AqiRecordsTable,
          AqiRecord,
          $$AqiRecordsTableFilterComposer,
          $$AqiRecordsTableOrderingComposer,
          $$AqiRecordsTableAnnotationComposer,
          $$AqiRecordsTableCreateCompanionBuilder,
          $$AqiRecordsTableUpdateCompanionBuilder,
          (AqiRecord, $$AqiRecordsTableReferences),
          AqiRecord,
          PrefetchHooks Function({bool locationId})
        > {
  $$AqiRecordsTableTableManager(_$AppDatabase db, $AqiRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AqiRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AqiRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AqiRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> locationId = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> aqi = const Value.absent(),
                Value<double> pm25 = const Value.absent(),
                Value<double> pm10 = const Value.absent(),
                Value<double> uvIndex = const Value.absent(),
              }) => AqiRecordsCompanion(
                id: id,
                locationId: locationId,
                fetchedAt: fetchedAt,
                aqi: aqi,
                pm25: pm25,
                pm10: pm10,
                uvIndex: uvIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int locationId,
                required DateTime fetchedAt,
                required int aqi,
                required double pm25,
                required double pm10,
                required double uvIndex,
              }) => AqiRecordsCompanion.insert(
                id: id,
                locationId: locationId,
                fetchedAt: fetchedAt,
                aqi: aqi,
                pm25: pm25,
                pm10: pm10,
                uvIndex: uvIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AqiRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({locationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (locationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.locationId,
                                referencedTable: $$AqiRecordsTableReferences
                                    ._locationIdTable(db),
                                referencedColumn: $$AqiRecordsTableReferences
                                    ._locationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AqiRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AqiRecordsTable,
      AqiRecord,
      $$AqiRecordsTableFilterComposer,
      $$AqiRecordsTableOrderingComposer,
      $$AqiRecordsTableAnnotationComposer,
      $$AqiRecordsTableCreateCompanionBuilder,
      $$AqiRecordsTableUpdateCompanionBuilder,
      (AqiRecord, $$AqiRecordsTableReferences),
      AqiRecord,
      PrefetchHooks Function({bool locationId})
    >;
typedef $$FarmingLogsTableCreateCompanionBuilder =
    FarmingLogsCompanion Function({
      Value<int> id,
      required int locationId,
      required DateTime date,
      required String sprayWindowsJson,
      required double soilMoisture,
      Value<String?> crop,
    });
typedef $$FarmingLogsTableUpdateCompanionBuilder =
    FarmingLogsCompanion Function({
      Value<int> id,
      Value<int> locationId,
      Value<DateTime> date,
      Value<String> sprayWindowsJson,
      Value<double> soilMoisture,
      Value<String?> crop,
    });

final class $$FarmingLogsTableReferences
    extends BaseReferences<_$AppDatabase, $FarmingLogsTable, FarmingLog> {
  $$FarmingLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocationsTable _locationIdTable(_$AppDatabase db) =>
      db.locations.createAlias(
        $_aliasNameGenerator(db.farmingLogs.locationId, db.locations.id),
      );

  $$LocationsTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<int>('location_id')!;

    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FarmingLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FarmingLogsTable> {
  $$FarmingLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sprayWindowsJson => $composableBuilder(
    column: $table.sprayWindowsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get soilMoisture => $composableBuilder(
    column: $table.soilMoisture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnFilters(column),
  );

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FarmingLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmingLogsTable> {
  $$FarmingLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sprayWindowsJson => $composableBuilder(
    column: $table.sprayWindowsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get soilMoisture => $composableBuilder(
    column: $table.soilMoisture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FarmingLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmingLogsTable> {
  $$FarmingLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get sprayWindowsJson => $composableBuilder(
    column: $table.sprayWindowsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get soilMoisture => $composableBuilder(
    column: $table.soilMoisture,
    builder: (column) => column,
  );

  GeneratedColumn<String> get crop =>
      $composableBuilder(column: $table.crop, builder: (column) => column);

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FarmingLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FarmingLogsTable,
          FarmingLog,
          $$FarmingLogsTableFilterComposer,
          $$FarmingLogsTableOrderingComposer,
          $$FarmingLogsTableAnnotationComposer,
          $$FarmingLogsTableCreateCompanionBuilder,
          $$FarmingLogsTableUpdateCompanionBuilder,
          (FarmingLog, $$FarmingLogsTableReferences),
          FarmingLog,
          PrefetchHooks Function({bool locationId})
        > {
  $$FarmingLogsTableTableManager(_$AppDatabase db, $FarmingLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmingLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmingLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmingLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> locationId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> sprayWindowsJson = const Value.absent(),
                Value<double> soilMoisture = const Value.absent(),
                Value<String?> crop = const Value.absent(),
              }) => FarmingLogsCompanion(
                id: id,
                locationId: locationId,
                date: date,
                sprayWindowsJson: sprayWindowsJson,
                soilMoisture: soilMoisture,
                crop: crop,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int locationId,
                required DateTime date,
                required String sprayWindowsJson,
                required double soilMoisture,
                Value<String?> crop = const Value.absent(),
              }) => FarmingLogsCompanion.insert(
                id: id,
                locationId: locationId,
                date: date,
                sprayWindowsJson: sprayWindowsJson,
                soilMoisture: soilMoisture,
                crop: crop,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FarmingLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({locationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (locationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.locationId,
                                referencedTable: $$FarmingLogsTableReferences
                                    ._locationIdTable(db),
                                referencedColumn: $$FarmingLogsTableReferences
                                    ._locationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FarmingLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FarmingLogsTable,
      FarmingLog,
      $$FarmingLogsTableFilterComposer,
      $$FarmingLogsTableOrderingComposer,
      $$FarmingLogsTableAnnotationComposer,
      $$FarmingLogsTableCreateCompanionBuilder,
      $$FarmingLogsTableUpdateCompanionBuilder,
      (FarmingLog, $$FarmingLogsTableReferences),
      FarmingLog,
      PrefetchHooks Function({bool locationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$WeatherForecastsTableTableManager get weatherForecasts =>
      $$WeatherForecastsTableTableManager(_db, _db.weatherForecasts);
  $$AqiRecordsTableTableManager get aqiRecords =>
      $$AqiRecordsTableTableManager(_db, _db.aqiRecords);
  $$FarmingLogsTableTableManager get farmingLogs =>
      $$FarmingLogsTableTableManager(_db, _db.farmingLogs);
}
