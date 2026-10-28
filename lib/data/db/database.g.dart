// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, CardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bankCodeMeta = const VerificationMeta(
    'bankCode',
  );
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
    'bank_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EGP'),
  );
  static const VerificationMeta _creditLimitMinorMeta = const VerificationMeta(
    'creditLimitMinor',
  );
  @override
  late final GeneratedColumn<int> creditLimitMinor = GeneratedColumn<int>(
    'credit_limit_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statementDayMeta = const VerificationMeta(
    'statementDay',
  );
  @override
  late final GeneratedColumn<int> statementDay = GeneratedColumn<int>(
    'statement_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAvailableMinorMeta =
      const VerificationMeta('lastAvailableMinor');
  @override
  late final GeneratedColumn<int> lastAvailableMinor = GeneratedColumn<int>(
    'last_available_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAvailableCurrencyMeta =
      const VerificationMeta('lastAvailableCurrency');
  @override
  late final GeneratedColumn<String> lastAvailableCurrency =
      GeneratedColumn<String>(
        'last_available_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastAvailableAtMeta = const VerificationMeta(
    'lastAvailableAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAvailableAt =
      GeneratedColumn<DateTime>(
        'last_available_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankCode,
    last4,
    nickname,
    currency,
    creditLimitMinor,
    statementDay,
    dueDay,
    lastAvailableMinor,
    lastAvailableCurrency,
    lastAvailableAt,
    archived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_code')) {
      context.handle(
        _bankCodeMeta,
        bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_bankCodeMeta);
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    } else if (isInserting) {
      context.missing(_last4Meta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('credit_limit_minor')) {
      context.handle(
        _creditLimitMinorMeta,
        creditLimitMinor.isAcceptableOrUnknown(
          data['credit_limit_minor']!,
          _creditLimitMinorMeta,
        ),
      );
    }
    if (data.containsKey('statement_day')) {
      context.handle(
        _statementDayMeta,
        statementDay.isAcceptableOrUnknown(
          data['statement_day']!,
          _statementDayMeta,
        ),
      );
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    }
    if (data.containsKey('last_available_minor')) {
      context.handle(
        _lastAvailableMinorMeta,
        lastAvailableMinor.isAcceptableOrUnknown(
          data['last_available_minor']!,
          _lastAvailableMinorMeta,
        ),
      );
    }
    if (data.containsKey('last_available_currency')) {
      context.handle(
        _lastAvailableCurrencyMeta,
        lastAvailableCurrency.isAcceptableOrUnknown(
          data['last_available_currency']!,
          _lastAvailableCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('last_available_at')) {
      context.handle(
        _lastAvailableAtMeta,
        lastAvailableAt.isAcceptableOrUnknown(
          data['last_available_at']!,
          _lastAvailableAtMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bankCode, last4},
  ];
  @override
  CardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bankCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_code'],
      )!,
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      creditLimitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit_minor'],
      ),
      statementDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}statement_day'],
      ),
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      ),
      lastAvailableMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_available_minor'],
      ),
      lastAvailableCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_available_currency'],
      ),
      lastAvailableAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_available_at'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardRow extends DataClass implements Insertable<CardRow> {
  final int id;
  final String bankCode;
  final String last4;
  final String? nickname;
  final String currency;
  final int? creditLimitMinor;
  final int? statementDay;
  final int? dueDay;
  final int? lastAvailableMinor;
  final String? lastAvailableCurrency;
  final DateTime? lastAvailableAt;
  final bool archived;
  final DateTime createdAt;
  const CardRow({
    required this.id,
    required this.bankCode,
    required this.last4,
    this.nickname,
    required this.currency,
    this.creditLimitMinor,
    this.statementDay,
    this.dueDay,
    this.lastAvailableMinor,
    this.lastAvailableCurrency,
    this.lastAvailableAt,
    required this.archived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_code'] = Variable<String>(bankCode);
    map['last4'] = Variable<String>(last4);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || creditLimitMinor != null) {
      map['credit_limit_minor'] = Variable<int>(creditLimitMinor);
    }
    if (!nullToAbsent || statementDay != null) {
      map['statement_day'] = Variable<int>(statementDay);
    }
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    if (!nullToAbsent || lastAvailableMinor != null) {
      map['last_available_minor'] = Variable<int>(lastAvailableMinor);
    }
    if (!nullToAbsent || lastAvailableCurrency != null) {
      map['last_available_currency'] = Variable<String>(lastAvailableCurrency);
    }
    if (!nullToAbsent || lastAvailableAt != null) {
      map['last_available_at'] = Variable<DateTime>(lastAvailableAt);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      bankCode: Value(bankCode),
      last4: Value(last4),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      currency: Value(currency),
      creditLimitMinor: creditLimitMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimitMinor),
      statementDay: statementDay == null && nullToAbsent
          ? const Value.absent()
          : Value(statementDay),
      dueDay: dueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDay),
      lastAvailableMinor: lastAvailableMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAvailableMinor),
      lastAvailableCurrency: lastAvailableCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAvailableCurrency),
      lastAvailableAt: lastAvailableAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAvailableAt),
      archived: Value(archived),
      createdAt: Value(createdAt),
    );
  }

  factory CardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardRow(
      id: serializer.fromJson<int>(json['id']),
      bankCode: serializer.fromJson<String>(json['bankCode']),
      last4: serializer.fromJson<String>(json['last4']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      currency: serializer.fromJson<String>(json['currency']),
      creditLimitMinor: serializer.fromJson<int?>(json['creditLimitMinor']),
      statementDay: serializer.fromJson<int?>(json['statementDay']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      lastAvailableMinor: serializer.fromJson<int?>(json['lastAvailableMinor']),
      lastAvailableCurrency: serializer.fromJson<String?>(
        json['lastAvailableCurrency'],
      ),
      lastAvailableAt: serializer.fromJson<DateTime?>(json['lastAvailableAt']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankCode': serializer.toJson<String>(bankCode),
      'last4': serializer.toJson<String>(last4),
      'nickname': serializer.toJson<String?>(nickname),
      'currency': serializer.toJson<String>(currency),
      'creditLimitMinor': serializer.toJson<int?>(creditLimitMinor),
      'statementDay': serializer.toJson<int?>(statementDay),
      'dueDay': serializer.toJson<int?>(dueDay),
      'lastAvailableMinor': serializer.toJson<int?>(lastAvailableMinor),
      'lastAvailableCurrency': serializer.toJson<String?>(
        lastAvailableCurrency,
      ),
      'lastAvailableAt': serializer.toJson<DateTime?>(lastAvailableAt),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CardRow copyWith({
    int? id,
    String? bankCode,
    String? last4,
    Value<String?> nickname = const Value.absent(),
    String? currency,
    Value<int?> creditLimitMinor = const Value.absent(),
    Value<int?> statementDay = const Value.absent(),
    Value<int?> dueDay = const Value.absent(),
    Value<int?> lastAvailableMinor = const Value.absent(),
    Value<String?> lastAvailableCurrency = const Value.absent(),
    Value<DateTime?> lastAvailableAt = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
  }) => CardRow(
    id: id ?? this.id,
    bankCode: bankCode ?? this.bankCode,
    last4: last4 ?? this.last4,
    nickname: nickname.present ? nickname.value : this.nickname,
    currency: currency ?? this.currency,
    creditLimitMinor: creditLimitMinor.present
        ? creditLimitMinor.value
        : this.creditLimitMinor,
    statementDay: statementDay.present ? statementDay.value : this.statementDay,
    dueDay: dueDay.present ? dueDay.value : this.dueDay,
    lastAvailableMinor: lastAvailableMinor.present
        ? lastAvailableMinor.value
        : this.lastAvailableMinor,
    lastAvailableCurrency: lastAvailableCurrency.present
        ? lastAvailableCurrency.value
        : this.lastAvailableCurrency,
    lastAvailableAt: lastAvailableAt.present
        ? lastAvailableAt.value
        : this.lastAvailableAt,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
  );
  CardRow copyWithCompanion(CardsCompanion data) {
    return CardRow(
      id: data.id.present ? data.id.value : this.id,
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      last4: data.last4.present ? data.last4.value : this.last4,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      currency: data.currency.present ? data.currency.value : this.currency,
      creditLimitMinor: data.creditLimitMinor.present
          ? data.creditLimitMinor.value
          : this.creditLimitMinor,
      statementDay: data.statementDay.present
          ? data.statementDay.value
          : this.statementDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      lastAvailableMinor: data.lastAvailableMinor.present
          ? data.lastAvailableMinor.value
          : this.lastAvailableMinor,
      lastAvailableCurrency: data.lastAvailableCurrency.present
          ? data.lastAvailableCurrency.value
          : this.lastAvailableCurrency,
      lastAvailableAt: data.lastAvailableAt.present
          ? data.lastAvailableAt.value
          : this.lastAvailableAt,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardRow(')
          ..write('id: $id, ')
          ..write('bankCode: $bankCode, ')
          ..write('last4: $last4, ')
          ..write('nickname: $nickname, ')
          ..write('currency: $currency, ')
          ..write('creditLimitMinor: $creditLimitMinor, ')
          ..write('statementDay: $statementDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('lastAvailableMinor: $lastAvailableMinor, ')
          ..write('lastAvailableCurrency: $lastAvailableCurrency, ')
          ..write('lastAvailableAt: $lastAvailableAt, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankCode,
    last4,
    nickname,
    currency,
    creditLimitMinor,
    statementDay,
    dueDay,
    lastAvailableMinor,
    lastAvailableCurrency,
    lastAvailableAt,
    archived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardRow &&
          other.id == this.id &&
          other.bankCode == this.bankCode &&
          other.last4 == this.last4 &&
          other.nickname == this.nickname &&
          other.currency == this.currency &&
          other.creditLimitMinor == this.creditLimitMinor &&
          other.statementDay == this.statementDay &&
          other.dueDay == this.dueDay &&
          other.lastAvailableMinor == this.lastAvailableMinor &&
          other.lastAvailableCurrency == this.lastAvailableCurrency &&
          other.lastAvailableAt == this.lastAvailableAt &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt);
}

class CardsCompanion extends UpdateCompanion<CardRow> {
  final Value<int> id;
  final Value<String> bankCode;
  final Value<String> last4;
  final Value<String?> nickname;
  final Value<String> currency;
  final Value<int?> creditLimitMinor;
  final Value<int?> statementDay;
  final Value<int?> dueDay;
  final Value<int?> lastAvailableMinor;
  final Value<String?> lastAvailableCurrency;
  final Value<DateTime?> lastAvailableAt;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.bankCode = const Value.absent(),
    this.last4 = const Value.absent(),
    this.nickname = const Value.absent(),
    this.currency = const Value.absent(),
    this.creditLimitMinor = const Value.absent(),
    this.statementDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.lastAvailableMinor = const Value.absent(),
    this.lastAvailableCurrency = const Value.absent(),
    this.lastAvailableAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String bankCode,
    required String last4,
    this.nickname = const Value.absent(),
    this.currency = const Value.absent(),
    this.creditLimitMinor = const Value.absent(),
    this.statementDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.lastAvailableMinor = const Value.absent(),
    this.lastAvailableCurrency = const Value.absent(),
    this.lastAvailableAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : bankCode = Value(bankCode),
       last4 = Value(last4);
  static Insertable<CardRow> custom({
    Expression<int>? id,
    Expression<String>? bankCode,
    Expression<String>? last4,
    Expression<String>? nickname,
    Expression<String>? currency,
    Expression<int>? creditLimitMinor,
    Expression<int>? statementDay,
    Expression<int>? dueDay,
    Expression<int>? lastAvailableMinor,
    Expression<String>? lastAvailableCurrency,
    Expression<DateTime>? lastAvailableAt,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankCode != null) 'bank_code': bankCode,
      if (last4 != null) 'last4': last4,
      if (nickname != null) 'nickname': nickname,
      if (currency != null) 'currency': currency,
      if (creditLimitMinor != null) 'credit_limit_minor': creditLimitMinor,
      if (statementDay != null) 'statement_day': statementDay,
      if (dueDay != null) 'due_day': dueDay,
      if (lastAvailableMinor != null)
        'last_available_minor': lastAvailableMinor,
      if (lastAvailableCurrency != null)
        'last_available_currency': lastAvailableCurrency,
      if (lastAvailableAt != null) 'last_available_at': lastAvailableAt,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CardsCompanion copyWith({
    Value<int>? id,
    Value<String>? bankCode,
    Value<String>? last4,
    Value<String?>? nickname,
    Value<String>? currency,
    Value<int?>? creditLimitMinor,
    Value<int?>? statementDay,
    Value<int?>? dueDay,
    Value<int?>? lastAvailableMinor,
    Value<String?>? lastAvailableCurrency,
    Value<DateTime?>? lastAvailableAt,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      bankCode: bankCode ?? this.bankCode,
      last4: last4 ?? this.last4,
      nickname: nickname ?? this.nickname,
      currency: currency ?? this.currency,
      creditLimitMinor: creditLimitMinor ?? this.creditLimitMinor,
      statementDay: statementDay ?? this.statementDay,
      dueDay: dueDay ?? this.dueDay,
      lastAvailableMinor: lastAvailableMinor ?? this.lastAvailableMinor,
      lastAvailableCurrency:
          lastAvailableCurrency ?? this.lastAvailableCurrency,
      lastAvailableAt: lastAvailableAt ?? this.lastAvailableAt,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (creditLimitMinor.present) {
      map['credit_limit_minor'] = Variable<int>(creditLimitMinor.value);
    }
    if (statementDay.present) {
      map['statement_day'] = Variable<int>(statementDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (lastAvailableMinor.present) {
      map['last_available_minor'] = Variable<int>(lastAvailableMinor.value);
    }
    if (lastAvailableCurrency.present) {
      map['last_available_currency'] = Variable<String>(
        lastAvailableCurrency.value,
      );
    }
    if (lastAvailableAt.present) {
      map['last_available_at'] = Variable<DateTime>(lastAvailableAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('bankCode: $bankCode, ')
          ..write('last4: $last4, ')
          ..write('nickname: $nickname, ')
          ..write('currency: $currency, ')
          ..write('creditLimitMinor: $creditLimitMinor, ')
          ..write('statementDay: $statementDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('lastAvailableMinor: $lastAvailableMinor, ')
          ..write('lastAvailableCurrency: $lastAvailableCurrency, ')
          ..write('lastAvailableAt: $lastAvailableAt, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtinMeta = const VerificationMeta(
    'builtin',
  );
  @override
  late final GeneratedColumn<bool> builtin = GeneratedColumn<bool>(
    'builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    nameEn,
    nameAr,
    icon,
    color,
    builtin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('builtin')) {
      context.handle(
        _builtinMeta,
        builtin.isAcceptableOrUnknown(data['builtin']!, _builtinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      builtin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}builtin'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String key;
  final String nameEn;
  final String nameAr;
  final int icon;
  final int color;
  final bool builtin;
  const CategoryRow({
    required this.id,
    required this.key,
    required this.nameEn,
    required this.nameAr,
    required this.icon,
    required this.color,
    required this.builtin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    map['icon'] = Variable<int>(icon);
    map['color'] = Variable<int>(color);
    map['builtin'] = Variable<bool>(builtin);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      key: Value(key),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      icon: Value(icon),
      color: Value(color),
      builtin: Value(builtin),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      icon: serializer.fromJson<int>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      builtin: serializer.fromJson<bool>(json['builtin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'icon': serializer.toJson<int>(icon),
      'color': serializer.toJson<int>(color),
      'builtin': serializer.toJson<bool>(builtin),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? key,
    String? nameEn,
    String? nameAr,
    int? icon,
    int? color,
    bool? builtin,
  }) => CategoryRow(
    id: id ?? this.id,
    key: key ?? this.key,
    nameEn: nameEn ?? this.nameEn,
    nameAr: nameAr ?? this.nameAr,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    builtin: builtin ?? this.builtin,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      builtin: data.builtin.present ? data.builtin.value : this.builtin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('builtin: $builtin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, key, nameEn, nameAr, icon, color, builtin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.key == this.key &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.builtin == this.builtin);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<int> icon;
  final Value<int> color;
  final Value<bool> builtin;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.builtin = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String nameEn,
    required String nameAr,
    required int icon,
    required int color,
    this.builtin = const Value.absent(),
  }) : key = Value(key),
       nameEn = Value(nameEn),
       nameAr = Value(nameAr),
       icon = Value(icon),
       color = Value(color);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<int>? icon,
    Expression<int>? color,
    Expression<bool>? builtin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (builtin != null) 'builtin': builtin,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? nameEn,
    Value<String>? nameAr,
    Value<int>? icon,
    Value<int>? color,
    Value<bool>? builtin,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      builtin: builtin ?? this.builtin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (builtin.present) {
      map['builtin'] = Variable<bool>(builtin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('builtin: $builtin')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TxnRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalAmountMinorMeta =
      const VerificationMeta('originalAmountMinor');
  @override
  late final GeneratedColumn<int> originalAmountMinor = GeneratedColumn<int>(
    'original_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalCurrencyMeta = const VerificationMeta(
    'originalCurrency',
  );
  @override
  late final GeneratedColumn<String> originalCurrency = GeneratedColumn<String>(
    'original_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availableLimitMinorMeta =
      const VerificationMeta('availableLimitMinor');
  @override
  late final GeneratedColumn<int> availableLimitMinor = GeneratedColumn<int>(
    'available_limit_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceHashMeta = const VerificationMeta(
    'sourceHash',
  );
  @override
  late final GeneratedColumn<String> sourceHash = GeneratedColumn<String>(
    'source_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _parserIdMeta = const VerificationMeta(
    'parserId',
  );
  @override
  late final GeneratedColumn<String> parserId = GeneratedColumn<String>(
    'parser_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parserVersionMeta = const VerificationMeta(
    'parserVersion',
  );
  @override
  late final GeneratedColumn<int> parserVersion = GeneratedColumn<int>(
    'parser_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    type,
    amountMinor,
    currency,
    originalAmountMinor,
    originalCurrency,
    merchant,
    categoryId,
    occurredAt,
    availableLimitMinor,
    sourceType,
    sourceHash,
    parserId,
    parserVersion,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TxnRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('original_amount_minor')) {
      context.handle(
        _originalAmountMinorMeta,
        originalAmountMinor.isAcceptableOrUnknown(
          data['original_amount_minor']!,
          _originalAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('original_currency')) {
      context.handle(
        _originalCurrencyMeta,
        originalCurrency.isAcceptableOrUnknown(
          data['original_currency']!,
          _originalCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('available_limit_minor')) {
      context.handle(
        _availableLimitMinorMeta,
        availableLimitMinor.isAcceptableOrUnknown(
          data['available_limit_minor']!,
          _availableLimitMinorMeta,
        ),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_hash')) {
      context.handle(
        _sourceHashMeta,
        sourceHash.isAcceptableOrUnknown(data['source_hash']!, _sourceHashMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceHashMeta);
    }
    if (data.containsKey('parser_id')) {
      context.handle(
        _parserIdMeta,
        parserId.isAcceptableOrUnknown(data['parser_id']!, _parserIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parserIdMeta);
    }
    if (data.containsKey('parser_version')) {
      context.handle(
        _parserVersionMeta,
        parserVersion.isAcceptableOrUnknown(
          data['parser_version']!,
          _parserVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parserVersionMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TxnRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TxnRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      originalAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_amount_minor'],
      ),
      originalCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_currency'],
      ),
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      availableLimitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_limit_minor'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      parserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_id'],
      )!,
      parserVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parser_version'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TxnRow extends DataClass implements Insertable<TxnRow> {
  final int id;
  final int cardId;
  final String type;
  final int amountMinor;
  final String currency;
  final int? originalAmountMinor;
  final String? originalCurrency;
  final String merchant;
  final int? categoryId;
  final DateTime occurredAt;
  final int? availableLimitMinor;
  final String sourceType;
  final String sourceHash;
  final String parserId;
  final int parserVersion;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TxnRow({
    required this.id,
    required this.cardId,
    required this.type,
    required this.amountMinor,
    required this.currency,
    this.originalAmountMinor,
    this.originalCurrency,
    required this.merchant,
    this.categoryId,
    required this.occurredAt,
    this.availableLimitMinor,
    required this.sourceType,
    required this.sourceHash,
    required this.parserId,
    required this.parserVersion,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['type'] = Variable<String>(type);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || originalAmountMinor != null) {
      map['original_amount_minor'] = Variable<int>(originalAmountMinor);
    }
    if (!nullToAbsent || originalCurrency != null) {
      map['original_currency'] = Variable<String>(originalCurrency);
    }
    map['merchant'] = Variable<String>(merchant);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || availableLimitMinor != null) {
      map['available_limit_minor'] = Variable<int>(availableLimitMinor);
    }
    map['source_type'] = Variable<String>(sourceType);
    map['source_hash'] = Variable<String>(sourceHash);
    map['parser_id'] = Variable<String>(parserId);
    map['parser_version'] = Variable<int>(parserVersion);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      type: Value(type),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      originalAmountMinor: originalAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(originalAmountMinor),
      originalCurrency: originalCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(originalCurrency),
      merchant: Value(merchant),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      occurredAt: Value(occurredAt),
      availableLimitMinor: availableLimitMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(availableLimitMinor),
      sourceType: Value(sourceType),
      sourceHash: Value(sourceHash),
      parserId: Value(parserId),
      parserVersion: Value(parserVersion),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TxnRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TxnRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      type: serializer.fromJson<String>(json['type']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      originalAmountMinor: serializer.fromJson<int?>(
        json['originalAmountMinor'],
      ),
      originalCurrency: serializer.fromJson<String?>(json['originalCurrency']),
      merchant: serializer.fromJson<String>(json['merchant']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      availableLimitMinor: serializer.fromJson<int?>(
        json['availableLimitMinor'],
      ),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      parserId: serializer.fromJson<String>(json['parserId']),
      parserVersion: serializer.fromJson<int>(json['parserVersion']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'type': serializer.toJson<String>(type),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'originalAmountMinor': serializer.toJson<int?>(originalAmountMinor),
      'originalCurrency': serializer.toJson<String?>(originalCurrency),
      'merchant': serializer.toJson<String>(merchant),
      'categoryId': serializer.toJson<int?>(categoryId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'availableLimitMinor': serializer.toJson<int?>(availableLimitMinor),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'parserId': serializer.toJson<String>(parserId),
      'parserVersion': serializer.toJson<int>(parserVersion),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TxnRow copyWith({
    int? id,
    int? cardId,
    String? type,
    int? amountMinor,
    String? currency,
    Value<int?> originalAmountMinor = const Value.absent(),
    Value<String?> originalCurrency = const Value.absent(),
    String? merchant,
    Value<int?> categoryId = const Value.absent(),
    DateTime? occurredAt,
    Value<int?> availableLimitMinor = const Value.absent(),
    String? sourceType,
    String? sourceHash,
    String? parserId,
    int? parserVersion,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TxnRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    type: type ?? this.type,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    originalAmountMinor: originalAmountMinor.present
        ? originalAmountMinor.value
        : this.originalAmountMinor,
    originalCurrency: originalCurrency.present
        ? originalCurrency.value
        : this.originalCurrency,
    merchant: merchant ?? this.merchant,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    occurredAt: occurredAt ?? this.occurredAt,
    availableLimitMinor: availableLimitMinor.present
        ? availableLimitMinor.value
        : this.availableLimitMinor,
    sourceType: sourceType ?? this.sourceType,
    sourceHash: sourceHash ?? this.sourceHash,
    parserId: parserId ?? this.parserId,
    parserVersion: parserVersion ?? this.parserVersion,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TxnRow copyWithCompanion(TransactionsCompanion data) {
    return TxnRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      type: data.type.present ? data.type.value : this.type,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      originalAmountMinor: data.originalAmountMinor.present
          ? data.originalAmountMinor.value
          : this.originalAmountMinor,
      originalCurrency: data.originalCurrency.present
          ? data.originalCurrency.value
          : this.originalCurrency,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      availableLimitMinor: data.availableLimitMinor.present
          ? data.availableLimitMinor.value
          : this.availableLimitMinor,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      parserId: data.parserId.present ? data.parserId.value : this.parserId,
      parserVersion: data.parserVersion.present
          ? data.parserVersion.value
          : this.parserVersion,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TxnRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('originalAmountMinor: $originalAmountMinor, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('merchant: $merchant, ')
          ..write('categoryId: $categoryId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('availableLimitMinor: $availableLimitMinor, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('parserId: $parserId, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    type,
    amountMinor,
    currency,
    originalAmountMinor,
    originalCurrency,
    merchant,
    categoryId,
    occurredAt,
    availableLimitMinor,
    sourceType,
    sourceHash,
    parserId,
    parserVersion,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TxnRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.type == this.type &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.originalAmountMinor == this.originalAmountMinor &&
          other.originalCurrency == this.originalCurrency &&
          other.merchant == this.merchant &&
          other.categoryId == this.categoryId &&
          other.occurredAt == this.occurredAt &&
          other.availableLimitMinor == this.availableLimitMinor &&
          other.sourceType == this.sourceType &&
          other.sourceHash == this.sourceHash &&
          other.parserId == this.parserId &&
          other.parserVersion == this.parserVersion &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TxnRow> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> type;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<int?> originalAmountMinor;
  final Value<String?> originalCurrency;
  final Value<String> merchant;
  final Value<int?> categoryId;
  final Value<DateTime> occurredAt;
  final Value<int?> availableLimitMinor;
  final Value<String> sourceType;
  final Value<String> sourceHash;
  final Value<String> parserId;
  final Value<int> parserVersion;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.originalAmountMinor = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    this.merchant = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.availableLimitMinor = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.parserId = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String type,
    required int amountMinor,
    required String currency,
    this.originalAmountMinor = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    required String merchant,
    this.categoryId = const Value.absent(),
    required DateTime occurredAt,
    this.availableLimitMinor = const Value.absent(),
    required String sourceType,
    required String sourceHash,
    required String parserId,
    required int parserVersion,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : cardId = Value(cardId),
       type = Value(type),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       merchant = Value(merchant),
       occurredAt = Value(occurredAt),
       sourceType = Value(sourceType),
       sourceHash = Value(sourceHash),
       parserId = Value(parserId),
       parserVersion = Value(parserVersion);
  static Insertable<TxnRow> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? type,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<int>? originalAmountMinor,
    Expression<String>? originalCurrency,
    Expression<String>? merchant,
    Expression<int>? categoryId,
    Expression<DateTime>? occurredAt,
    Expression<int>? availableLimitMinor,
    Expression<String>? sourceType,
    Expression<String>? sourceHash,
    Expression<String>? parserId,
    Expression<int>? parserVersion,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (type != null) 'type': type,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (originalAmountMinor != null)
        'original_amount_minor': originalAmountMinor,
      if (originalCurrency != null) 'original_currency': originalCurrency,
      if (merchant != null) 'merchant': merchant,
      if (categoryId != null) 'category_id': categoryId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (availableLimitMinor != null)
        'available_limit_minor': availableLimitMinor,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (parserId != null) 'parser_id': parserId,
      if (parserVersion != null) 'parser_version': parserVersion,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<String>? type,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<int?>? originalAmountMinor,
    Value<String?>? originalCurrency,
    Value<String>? merchant,
    Value<int?>? categoryId,
    Value<DateTime>? occurredAt,
    Value<int?>? availableLimitMinor,
    Value<String>? sourceType,
    Value<String>? sourceHash,
    Value<String>? parserId,
    Value<int>? parserVersion,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      type: type ?? this.type,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      originalAmountMinor: originalAmountMinor ?? this.originalAmountMinor,
      originalCurrency: originalCurrency ?? this.originalCurrency,
      merchant: merchant ?? this.merchant,
      categoryId: categoryId ?? this.categoryId,
      occurredAt: occurredAt ?? this.occurredAt,
      availableLimitMinor: availableLimitMinor ?? this.availableLimitMinor,
      sourceType: sourceType ?? this.sourceType,
      sourceHash: sourceHash ?? this.sourceHash,
      parserId: parserId ?? this.parserId,
      parserVersion: parserVersion ?? this.parserVersion,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (originalAmountMinor.present) {
      map['original_amount_minor'] = Variable<int>(originalAmountMinor.value);
    }
    if (originalCurrency.present) {
      map['original_currency'] = Variable<String>(originalCurrency.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (availableLimitMinor.present) {
      map['available_limit_minor'] = Variable<int>(availableLimitMinor.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (parserId.present) {
      map['parser_id'] = Variable<String>(parserId.value);
    }
    if (parserVersion.present) {
      map['parser_version'] = Variable<int>(parserVersion.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('originalAmountMinor: $originalAmountMinor, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('merchant: $merchant, ')
          ..write('categoryId: $categoryId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('availableLimitMinor: $availableLimitMinor, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('parserId: $parserId, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RawMessagesTable extends RawMessages
    with TableInfo<$RawMessagesTable, RawRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawMessagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankCodeMeta = const VerificationMeta(
    'bankCode',
  );
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
    'bank_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawHashMeta = const VerificationMeta(
    'rawHash',
  );
  @override
  late final GeneratedColumn<String> rawHash = GeneratedColumn<String>(
    'raw_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    sender,
    body,
    receivedAt,
    status,
    bankCode,
    rawHash,
    transactionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('bank_code')) {
      context.handle(
        _bankCodeMeta,
        bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta),
      );
    }
    if (data.containsKey('raw_hash')) {
      context.handle(
        _rawHashMeta,
        rawHash.isAcceptableOrUnknown(data['raw_hash']!, _rawHashMeta),
      );
    } else if (isInserting) {
      context.missing(_rawHashMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bankCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_code'],
      ),
      rawHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_hash'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RawMessagesTable createAlias(String alias) {
    return $RawMessagesTable(attachedDatabase, alias);
  }
}

class RawRow extends DataClass implements Insertable<RawRow> {
  final int id;
  final String sourceType;
  final String? sender;
  final String body;
  final DateTime receivedAt;

  /// pending (waiting for the user), parsed, failed (no parser matched), ignored.
  final String status;
  final String? bankCode;
  final String rawHash;
  final int? transactionId;
  final DateTime createdAt;
  const RawRow({
    required this.id,
    required this.sourceType,
    this.sender,
    required this.body,
    required this.receivedAt,
    required this.status,
    this.bankCode,
    required this.rawHash,
    this.transactionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sender != null) {
      map['sender'] = Variable<String>(sender);
    }
    map['body'] = Variable<String>(body);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || bankCode != null) {
      map['bank_code'] = Variable<String>(bankCode);
    }
    map['raw_hash'] = Variable<String>(rawHash);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawMessagesCompanion toCompanion(bool nullToAbsent) {
    return RawMessagesCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      sender: sender == null && nullToAbsent
          ? const Value.absent()
          : Value(sender),
      body: Value(body),
      receivedAt: Value(receivedAt),
      status: Value(status),
      bankCode: bankCode == null && nullToAbsent
          ? const Value.absent()
          : Value(bankCode),
      rawHash: Value(rawHash),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      createdAt: Value(createdAt),
    );
  }

  factory RawRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawRow(
      id: serializer.fromJson<int>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sender: serializer.fromJson<String?>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      status: serializer.fromJson<String>(json['status']),
      bankCode: serializer.fromJson<String?>(json['bankCode']),
      rawHash: serializer.fromJson<String>(json['rawHash']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'sender': serializer.toJson<String?>(sender),
      'body': serializer.toJson<String>(body),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'status': serializer.toJson<String>(status),
      'bankCode': serializer.toJson<String?>(bankCode),
      'rawHash': serializer.toJson<String>(rawHash),
      'transactionId': serializer.toJson<int?>(transactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawRow copyWith({
    int? id,
    String? sourceType,
    Value<String?> sender = const Value.absent(),
    String? body,
    DateTime? receivedAt,
    String? status,
    Value<String?> bankCode = const Value.absent(),
    String? rawHash,
    Value<int?> transactionId = const Value.absent(),
    DateTime? createdAt,
  }) => RawRow(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    sender: sender.present ? sender.value : this.sender,
    body: body ?? this.body,
    receivedAt: receivedAt ?? this.receivedAt,
    status: status ?? this.status,
    bankCode: bankCode.present ? bankCode.value : this.bankCode,
    rawHash: rawHash ?? this.rawHash,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    createdAt: createdAt ?? this.createdAt,
  );
  RawRow copyWithCompanion(RawMessagesCompanion data) {
    return RawRow(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      status: data.status.present ? data.status.value : this.status,
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      rawHash: data.rawHash.present ? data.rawHash.value : this.rawHash,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawRow(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('status: $status, ')
          ..write('bankCode: $bankCode, ')
          ..write('rawHash: $rawHash, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    sender,
    body,
    receivedAt,
    status,
    bankCode,
    rawHash,
    transactionId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawRow &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.sender == this.sender &&
          other.body == this.body &&
          other.receivedAt == this.receivedAt &&
          other.status == this.status &&
          other.bankCode == this.bankCode &&
          other.rawHash == this.rawHash &&
          other.transactionId == this.transactionId &&
          other.createdAt == this.createdAt);
}

class RawMessagesCompanion extends UpdateCompanion<RawRow> {
  final Value<int> id;
  final Value<String> sourceType;
  final Value<String?> sender;
  final Value<String> body;
  final Value<DateTime> receivedAt;
  final Value<String> status;
  final Value<String?> bankCode;
  final Value<String> rawHash;
  final Value<int?> transactionId;
  final Value<DateTime> createdAt;
  const RawMessagesCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.bankCode = const Value.absent(),
    this.rawHash = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RawMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String sourceType,
    this.sender = const Value.absent(),
    required String body,
    required DateTime receivedAt,
    required String status,
    this.bankCode = const Value.absent(),
    required String rawHash,
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sourceType = Value(sourceType),
       body = Value(body),
       receivedAt = Value(receivedAt),
       status = Value(status),
       rawHash = Value(rawHash);
  static Insertable<RawRow> custom({
    Expression<int>? id,
    Expression<String>? sourceType,
    Expression<String>? sender,
    Expression<String>? body,
    Expression<DateTime>? receivedAt,
    Expression<String>? status,
    Expression<String>? bankCode,
    Expression<String>? rawHash,
    Expression<int>? transactionId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
      if (receivedAt != null) 'received_at': receivedAt,
      if (status != null) 'status': status,
      if (bankCode != null) 'bank_code': bankCode,
      if (rawHash != null) 'raw_hash': rawHash,
      if (transactionId != null) 'transaction_id': transactionId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RawMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? sourceType,
    Value<String?>? sender,
    Value<String>? body,
    Value<DateTime>? receivedAt,
    Value<String>? status,
    Value<String?>? bankCode,
    Value<String>? rawHash,
    Value<int?>? transactionId,
    Value<DateTime>? createdAt,
  }) {
    return RawMessagesCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      status: status ?? this.status,
      bankCode: bankCode ?? this.bankCode,
      rawHash: rawHash ?? this.rawHash,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (rawHash.present) {
      map['raw_hash'] = Variable<String>(rawHash.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawMessagesCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('status: $status, ')
          ..write('bankCode: $bankCode, ')
          ..write('rawHash: $rawHash, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SendersTable extends Senders with TableInfo<$SendersTable, SenderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SendersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bankCodeMeta = const VerificationMeta(
    'bankCode',
  );
  @override
  late final GeneratedColumn<String> bankCode = GeneratedColumn<String>(
    'bank_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _mustContainMeta = const VerificationMeta(
    'mustContain',
  );
  @override
  late final GeneratedColumn<String> mustContain = GeneratedColumn<String>(
    'must_contain',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    address,
    bankCode,
    enabled,
    mode,
    mustContain,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'senders';
  @override
  VerificationContext validateIntegrity(
    Insertable<SenderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('bank_code')) {
      context.handle(
        _bankCodeMeta,
        bankCode.isAcceptableOrUnknown(data['bank_code']!, _bankCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_bankCodeMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('must_contain')) {
      context.handle(
        _mustContainMeta,
        mustContain.isAcceptableOrUnknown(
          data['must_contain']!,
          _mustContainMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SenderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SenderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      bankCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_code'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      mustContain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}must_contain'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SendersTable createAlias(String alias) {
    return $SendersTable(attachedDatabase, alias);
  }
}

class SenderRow extends DataClass implements Insertable<SenderRow> {
  final int id;
  final String address;
  final String bankCode;
  final bool enabled;
  final String mode;
  final String? mustContain;
  final DateTime createdAt;
  const SenderRow({
    required this.id,
    required this.address,
    required this.bankCode,
    required this.enabled,
    required this.mode,
    this.mustContain,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['address'] = Variable<String>(address);
    map['bank_code'] = Variable<String>(bankCode);
    map['enabled'] = Variable<bool>(enabled);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || mustContain != null) {
      map['must_contain'] = Variable<String>(mustContain);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SendersCompanion toCompanion(bool nullToAbsent) {
    return SendersCompanion(
      id: Value(id),
      address: Value(address),
      bankCode: Value(bankCode),
      enabled: Value(enabled),
      mode: Value(mode),
      mustContain: mustContain == null && nullToAbsent
          ? const Value.absent()
          : Value(mustContain),
      createdAt: Value(createdAt),
    );
  }

  factory SenderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SenderRow(
      id: serializer.fromJson<int>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      bankCode: serializer.fromJson<String>(json['bankCode']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      mode: serializer.fromJson<String>(json['mode']),
      mustContain: serializer.fromJson<String?>(json['mustContain']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address': serializer.toJson<String>(address),
      'bankCode': serializer.toJson<String>(bankCode),
      'enabled': serializer.toJson<bool>(enabled),
      'mode': serializer.toJson<String>(mode),
      'mustContain': serializer.toJson<String?>(mustContain),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SenderRow copyWith({
    int? id,
    String? address,
    String? bankCode,
    bool? enabled,
    String? mode,
    Value<String?> mustContain = const Value.absent(),
    DateTime? createdAt,
  }) => SenderRow(
    id: id ?? this.id,
    address: address ?? this.address,
    bankCode: bankCode ?? this.bankCode,
    enabled: enabled ?? this.enabled,
    mode: mode ?? this.mode,
    mustContain: mustContain.present ? mustContain.value : this.mustContain,
    createdAt: createdAt ?? this.createdAt,
  );
  SenderRow copyWithCompanion(SendersCompanion data) {
    return SenderRow(
      id: data.id.present ? data.id.value : this.id,
      address: data.address.present ? data.address.value : this.address,
      bankCode: data.bankCode.present ? data.bankCode.value : this.bankCode,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      mode: data.mode.present ? data.mode.value : this.mode,
      mustContain: data.mustContain.present
          ? data.mustContain.value
          : this.mustContain,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SenderRow(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('bankCode: $bankCode, ')
          ..write('enabled: $enabled, ')
          ..write('mode: $mode, ')
          ..write('mustContain: $mustContain, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, address, bankCode, enabled, mode, mustContain, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SenderRow &&
          other.id == this.id &&
          other.address == this.address &&
          other.bankCode == this.bankCode &&
          other.enabled == this.enabled &&
          other.mode == this.mode &&
          other.mustContain == this.mustContain &&
          other.createdAt == this.createdAt);
}

class SendersCompanion extends UpdateCompanion<SenderRow> {
  final Value<int> id;
  final Value<String> address;
  final Value<String> bankCode;
  final Value<bool> enabled;
  final Value<String> mode;
  final Value<String?> mustContain;
  final Value<DateTime> createdAt;
  const SendersCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.bankCode = const Value.absent(),
    this.enabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.mustContain = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SendersCompanion.insert({
    this.id = const Value.absent(),
    required String address,
    required String bankCode,
    this.enabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.mustContain = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : address = Value(address),
       bankCode = Value(bankCode);
  static Insertable<SenderRow> custom({
    Expression<int>? id,
    Expression<String>? address,
    Expression<String>? bankCode,
    Expression<bool>? enabled,
    Expression<String>? mode,
    Expression<String>? mustContain,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (bankCode != null) 'bank_code': bankCode,
      if (enabled != null) 'enabled': enabled,
      if (mode != null) 'mode': mode,
      if (mustContain != null) 'must_contain': mustContain,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SendersCompanion copyWith({
    Value<int>? id,
    Value<String>? address,
    Value<String>? bankCode,
    Value<bool>? enabled,
    Value<String>? mode,
    Value<String?>? mustContain,
    Value<DateTime>? createdAt,
  }) {
    return SendersCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      bankCode: bankCode ?? this.bankCode,
      enabled: enabled ?? this.enabled,
      mode: mode ?? this.mode,
      mustContain: mustContain ?? this.mustContain,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (bankCode.present) {
      map['bank_code'] = Variable<String>(bankCode.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (mustContain.present) {
      map['must_contain'] = Variable<String>(mustContain.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SendersCompanion(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('bankCode: $bankCode, ')
          ..write('enabled: $enabled, ')
          ..write('mode: $mode, ')
          ..write('mustContain: $mustContain, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MerchantRulesTable extends MerchantRules
    with TableInfo<$MerchantRulesTable, MerchantRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantRulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, pattern, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $MerchantRulesTable createAlias(String alias) {
    return $MerchantRulesTable(attachedDatabase, alias);
  }
}

class MerchantRuleRow extends DataClass implements Insertable<MerchantRuleRow> {
  final int id;
  final String pattern;
  final int categoryId;
  const MerchantRuleRow({
    required this.id,
    required this.pattern,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern'] = Variable<String>(pattern);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  MerchantRulesCompanion toCompanion(bool nullToAbsent) {
    return MerchantRulesCompanion(
      id: Value(id),
      pattern: Value(pattern),
      categoryId: Value(categoryId),
    );
  }

  factory MerchantRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantRuleRow(
      id: serializer.fromJson<int>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pattern': serializer.toJson<String>(pattern),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  MerchantRuleRow copyWith({int? id, String? pattern, int? categoryId}) =>
      MerchantRuleRow(
        id: id ?? this.id,
        pattern: pattern ?? this.pattern,
        categoryId: categoryId ?? this.categoryId,
      );
  MerchantRuleRow copyWithCompanion(MerchantRulesCompanion data) {
    return MerchantRuleRow(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantRuleRow(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pattern, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantRuleRow &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.categoryId == this.categoryId);
}

class MerchantRulesCompanion extends UpdateCompanion<MerchantRuleRow> {
  final Value<int> id;
  final Value<String> pattern;
  final Value<int> categoryId;
  const MerchantRulesCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  MerchantRulesCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    required int categoryId,
  }) : pattern = Value(pattern),
       categoryId = Value(categoryId);
  static Insertable<MerchantRuleRow> custom({
    Expression<int>? id,
    Expression<String>? pattern,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  MerchantRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? pattern,
    Value<int>? categoryId,
  }) {
    return MerchantRulesCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantRulesCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $StatementsTable extends Statements
    with TableInfo<$StatementsTable, StatementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDueMinorMeta = const VerificationMeta(
    'totalDueMinor',
  );
  @override
  late final GeneratedColumn<int> totalDueMinor = GeneratedColumn<int>(
    'total_due_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumDueMinorMeta = const VerificationMeta(
    'minimumDueMinor',
  );
  @override
  late final GeneratedColumn<int> minimumDueMinor = GeneratedColumn<int>(
    'minimum_due_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid = GeneratedColumn<bool>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    periodEnd,
    dueDate,
    totalDueMinor,
    minimumDueMinor,
    currency,
    paid,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'statements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StatementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('total_due_minor')) {
      context.handle(
        _totalDueMinorMeta,
        totalDueMinor.isAcceptableOrUnknown(
          data['total_due_minor']!,
          _totalDueMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDueMinorMeta);
    }
    if (data.containsKey('minimum_due_minor')) {
      context.handle(
        _minimumDueMinorMeta,
        minimumDueMinor.isAcceptableOrUnknown(
          data['minimum_due_minor']!,
          _minimumDueMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      totalDueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_due_minor'],
      )!,
      minimumDueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_due_minor'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StatementsTable createAlias(String alias) {
    return $StatementsTable(attachedDatabase, alias);
  }
}

class StatementRow extends DataClass implements Insertable<StatementRow> {
  final int id;
  final int cardId;
  final DateTime periodEnd;
  final DateTime dueDate;
  final int totalDueMinor;
  final int? minimumDueMinor;
  final String currency;
  final bool paid;
  final DateTime createdAt;
  const StatementRow({
    required this.id,
    required this.cardId,
    required this.periodEnd,
    required this.dueDate,
    required this.totalDueMinor,
    this.minimumDueMinor,
    required this.currency,
    required this.paid,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['total_due_minor'] = Variable<int>(totalDueMinor);
    if (!nullToAbsent || minimumDueMinor != null) {
      map['minimum_due_minor'] = Variable<int>(minimumDueMinor);
    }
    map['currency'] = Variable<String>(currency);
    map['paid'] = Variable<bool>(paid);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StatementsCompanion toCompanion(bool nullToAbsent) {
    return StatementsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      periodEnd: Value(periodEnd),
      dueDate: Value(dueDate),
      totalDueMinor: Value(totalDueMinor),
      minimumDueMinor: minimumDueMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumDueMinor),
      currency: Value(currency),
      paid: Value(paid),
      createdAt: Value(createdAt),
    );
  }

  factory StatementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatementRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      totalDueMinor: serializer.fromJson<int>(json['totalDueMinor']),
      minimumDueMinor: serializer.fromJson<int?>(json['minimumDueMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      paid: serializer.fromJson<bool>(json['paid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'totalDueMinor': serializer.toJson<int>(totalDueMinor),
      'minimumDueMinor': serializer.toJson<int?>(minimumDueMinor),
      'currency': serializer.toJson<String>(currency),
      'paid': serializer.toJson<bool>(paid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StatementRow copyWith({
    int? id,
    int? cardId,
    DateTime? periodEnd,
    DateTime? dueDate,
    int? totalDueMinor,
    Value<int?> minimumDueMinor = const Value.absent(),
    String? currency,
    bool? paid,
    DateTime? createdAt,
  }) => StatementRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    periodEnd: periodEnd ?? this.periodEnd,
    dueDate: dueDate ?? this.dueDate,
    totalDueMinor: totalDueMinor ?? this.totalDueMinor,
    minimumDueMinor: minimumDueMinor.present
        ? minimumDueMinor.value
        : this.minimumDueMinor,
    currency: currency ?? this.currency,
    paid: paid ?? this.paid,
    createdAt: createdAt ?? this.createdAt,
  );
  StatementRow copyWithCompanion(StatementsCompanion data) {
    return StatementRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      totalDueMinor: data.totalDueMinor.present
          ? data.totalDueMinor.value
          : this.totalDueMinor,
      minimumDueMinor: data.minimumDueMinor.present
          ? data.minimumDueMinor.value
          : this.minimumDueMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      paid: data.paid.present ? data.paid.value : this.paid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatementRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('dueDate: $dueDate, ')
          ..write('totalDueMinor: $totalDueMinor, ')
          ..write('minimumDueMinor: $minimumDueMinor, ')
          ..write('currency: $currency, ')
          ..write('paid: $paid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    periodEnd,
    dueDate,
    totalDueMinor,
    minimumDueMinor,
    currency,
    paid,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatementRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.periodEnd == this.periodEnd &&
          other.dueDate == this.dueDate &&
          other.totalDueMinor == this.totalDueMinor &&
          other.minimumDueMinor == this.minimumDueMinor &&
          other.currency == this.currency &&
          other.paid == this.paid &&
          other.createdAt == this.createdAt);
}

class StatementsCompanion extends UpdateCompanion<StatementRow> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<DateTime> periodEnd;
  final Value<DateTime> dueDate;
  final Value<int> totalDueMinor;
  final Value<int?> minimumDueMinor;
  final Value<String> currency;
  final Value<bool> paid;
  final Value<DateTime> createdAt;
  const StatementsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.totalDueMinor = const Value.absent(),
    this.minimumDueMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.paid = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StatementsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required DateTime periodEnd,
    required DateTime dueDate,
    required int totalDueMinor,
    this.minimumDueMinor = const Value.absent(),
    required String currency,
    this.paid = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cardId = Value(cardId),
       periodEnd = Value(periodEnd),
       dueDate = Value(dueDate),
       totalDueMinor = Value(totalDueMinor),
       currency = Value(currency);
  static Insertable<StatementRow> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<DateTime>? periodEnd,
    Expression<DateTime>? dueDate,
    Expression<int>? totalDueMinor,
    Expression<int>? minimumDueMinor,
    Expression<String>? currency,
    Expression<bool>? paid,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (periodEnd != null) 'period_end': periodEnd,
      if (dueDate != null) 'due_date': dueDate,
      if (totalDueMinor != null) 'total_due_minor': totalDueMinor,
      if (minimumDueMinor != null) 'minimum_due_minor': minimumDueMinor,
      if (currency != null) 'currency': currency,
      if (paid != null) 'paid': paid,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StatementsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<DateTime>? periodEnd,
    Value<DateTime>? dueDate,
    Value<int>? totalDueMinor,
    Value<int?>? minimumDueMinor,
    Value<String>? currency,
    Value<bool>? paid,
    Value<DateTime>? createdAt,
  }) {
    return StatementsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      periodEnd: periodEnd ?? this.periodEnd,
      dueDate: dueDate ?? this.dueDate,
      totalDueMinor: totalDueMinor ?? this.totalDueMinor,
      minimumDueMinor: minimumDueMinor ?? this.minimumDueMinor,
      currency: currency ?? this.currency,
      paid: paid ?? this.paid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (totalDueMinor.present) {
      map['total_due_minor'] = Variable<int>(totalDueMinor.value);
    }
    if (minimumDueMinor.present) {
      map['minimum_due_minor'] = Variable<int>(minimumDueMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatementsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('dueDate: $dueDate, ')
          ..write('totalDueMinor: $totalDueMinor, ')
          ..write('minimumDueMinor: $minimumDueMinor, ')
          ..write('currency: $currency, ')
          ..write('paid: $paid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InstallmentsTable extends Installments
    with TableInfo<$InstallmentsTable, InstallmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyMinorMeta = const VerificationMeta(
    'monthlyMinor',
  );
  @override
  late final GeneratedColumn<int> monthlyMinor = GeneratedColumn<int>(
    'monthly_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthsMeta = const VerificationMeta('months');
  @override
  late final GeneratedColumn<int> months = GeneratedColumn<int>(
    'months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    merchant,
    totalMinor,
    monthlyMinor,
    currency,
    months,
    startDate,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installments';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstallmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    if (data.containsKey('monthly_minor')) {
      context.handle(
        _monthlyMinorMeta,
        monthlyMinor.isAcceptableOrUnknown(
          data['monthly_minor']!,
          _monthlyMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('months')) {
      context.handle(
        _monthsMeta,
        months.isAcceptableOrUnknown(data['months']!, _monthsMeta),
      );
    } else if (isInserting) {
      context.missing(_monthsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      monthlyMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      months: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}months'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InstallmentsTable createAlias(String alias) {
    return $InstallmentsTable(attachedDatabase, alias);
  }
}

class InstallmentRow extends DataClass implements Insertable<InstallmentRow> {
  final int id;
  final int cardId;
  final String merchant;
  final int totalMinor;
  final int monthlyMinor;
  final String currency;
  final int months;
  final DateTime startDate;
  final String? note;
  final DateTime createdAt;
  const InstallmentRow({
    required this.id,
    required this.cardId,
    required this.merchant,
    required this.totalMinor,
    required this.monthlyMinor,
    required this.currency,
    required this.months,
    required this.startDate,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['merchant'] = Variable<String>(merchant);
    map['total_minor'] = Variable<int>(totalMinor);
    map['monthly_minor'] = Variable<int>(monthlyMinor);
    map['currency'] = Variable<String>(currency);
    map['months'] = Variable<int>(months);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InstallmentsCompanion toCompanion(bool nullToAbsent) {
    return InstallmentsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      merchant: Value(merchant),
      totalMinor: Value(totalMinor),
      monthlyMinor: Value(monthlyMinor),
      currency: Value(currency),
      months: Value(months),
      startDate: Value(startDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory InstallmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallmentRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      merchant: serializer.fromJson<String>(json['merchant']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      monthlyMinor: serializer.fromJson<int>(json['monthlyMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      months: serializer.fromJson<int>(json['months']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'merchant': serializer.toJson<String>(merchant),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'monthlyMinor': serializer.toJson<int>(monthlyMinor),
      'currency': serializer.toJson<String>(currency),
      'months': serializer.toJson<int>(months),
      'startDate': serializer.toJson<DateTime>(startDate),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InstallmentRow copyWith({
    int? id,
    int? cardId,
    String? merchant,
    int? totalMinor,
    int? monthlyMinor,
    String? currency,
    int? months,
    DateTime? startDate,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => InstallmentRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    merchant: merchant ?? this.merchant,
    totalMinor: totalMinor ?? this.totalMinor,
    monthlyMinor: monthlyMinor ?? this.monthlyMinor,
    currency: currency ?? this.currency,
    months: months ?? this.months,
    startDate: startDate ?? this.startDate,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  InstallmentRow copyWithCompanion(InstallmentsCompanion data) {
    return InstallmentRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      monthlyMinor: data.monthlyMinor.present
          ? data.monthlyMinor.value
          : this.monthlyMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      months: data.months.present ? data.months.value : this.months,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('merchant: $merchant, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('monthlyMinor: $monthlyMinor, ')
          ..write('currency: $currency, ')
          ..write('months: $months, ')
          ..write('startDate: $startDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    merchant,
    totalMinor,
    monthlyMinor,
    currency,
    months,
    startDate,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallmentRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.merchant == this.merchant &&
          other.totalMinor == this.totalMinor &&
          other.monthlyMinor == this.monthlyMinor &&
          other.currency == this.currency &&
          other.months == this.months &&
          other.startDate == this.startDate &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class InstallmentsCompanion extends UpdateCompanion<InstallmentRow> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> merchant;
  final Value<int> totalMinor;
  final Value<int> monthlyMinor;
  final Value<String> currency;
  final Value<int> months;
  final Value<DateTime> startDate;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const InstallmentsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.merchant = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.monthlyMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.months = const Value.absent(),
    this.startDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InstallmentsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String merchant,
    required int totalMinor,
    required int monthlyMinor,
    required String currency,
    required int months,
    required DateTime startDate,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cardId = Value(cardId),
       merchant = Value(merchant),
       totalMinor = Value(totalMinor),
       monthlyMinor = Value(monthlyMinor),
       currency = Value(currency),
       months = Value(months),
       startDate = Value(startDate);
  static Insertable<InstallmentRow> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? merchant,
    Expression<int>? totalMinor,
    Expression<int>? monthlyMinor,
    Expression<String>? currency,
    Expression<int>? months,
    Expression<DateTime>? startDate,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (merchant != null) 'merchant': merchant,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (monthlyMinor != null) 'monthly_minor': monthlyMinor,
      if (currency != null) 'currency': currency,
      if (months != null) 'months': months,
      if (startDate != null) 'start_date': startDate,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InstallmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<String>? merchant,
    Value<int>? totalMinor,
    Value<int>? monthlyMinor,
    Value<String>? currency,
    Value<int>? months,
    Value<DateTime>? startDate,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return InstallmentsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      merchant: merchant ?? this.merchant,
      totalMinor: totalMinor ?? this.totalMinor,
      monthlyMinor: monthlyMinor ?? this.monthlyMinor,
      currency: currency ?? this.currency,
      months: months ?? this.months,
      startDate: startDate ?? this.startDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (monthlyMinor.present) {
      map['monthly_minor'] = Variable<int>(monthlyMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (months.present) {
      map['months'] = Variable<int>(months.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('merchant: $merchant, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('monthlyMinor: $monthlyMinor, ')
          ..write('currency: $currency, ')
          ..write('months: $months, ')
          ..write('startDate: $startDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog with TableInfo<$AuditLogTable, AuditRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventMeta = const VerificationMeta('event');
  @override
  late final GeneratedColumn<String> event = GeneratedColumn<String>(
    'event',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, event, details, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event')) {
      context.handle(
        _eventMeta,
        event.isAcceptableOrUnknown(data['event']!, _eventMeta),
      );
    } else if (isInserting) {
      context.missing(_eventMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      event: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditRow extends DataClass implements Insertable<AuditRow> {
  final int id;
  final String event;
  final String? details;
  final DateTime at;
  const AuditRow({
    required this.id,
    required this.event,
    this.details,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event'] = Variable<String>(event);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      event: Value(event),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      at: Value(at),
    );
  }

  factory AuditRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditRow(
      id: serializer.fromJson<int>(json['id']),
      event: serializer.fromJson<String>(json['event']),
      details: serializer.fromJson<String?>(json['details']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'event': serializer.toJson<String>(event),
      'details': serializer.toJson<String?>(details),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  AuditRow copyWith({
    int? id,
    String? event,
    Value<String?> details = const Value.absent(),
    DateTime? at,
  }) => AuditRow(
    id: id ?? this.id,
    event: event ?? this.event,
    details: details.present ? details.value : this.details,
    at: at ?? this.at,
  );
  AuditRow copyWithCompanion(AuditLogCompanion data) {
    return AuditRow(
      id: data.id.present ? data.id.value : this.id,
      event: data.event.present ? data.event.value : this.event,
      details: data.details.present ? data.details.value : this.details,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditRow(')
          ..write('id: $id, ')
          ..write('event: $event, ')
          ..write('details: $details, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, event, details, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditRow &&
          other.id == this.id &&
          other.event == this.event &&
          other.details == this.details &&
          other.at == this.at);
}

class AuditLogCompanion extends UpdateCompanion<AuditRow> {
  final Value<int> id;
  final Value<String> event;
  final Value<String?> details;
  final Value<DateTime> at;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.event = const Value.absent(),
    this.details = const Value.absent(),
    this.at = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    required String event,
    this.details = const Value.absent(),
    this.at = const Value.absent(),
  }) : event = Value(event);
  static Insertable<AuditRow> custom({
    Expression<int>? id,
    Expression<String>? event,
    Expression<String>? details,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (event != null) 'event': event,
      if (details != null) 'details': details,
      if (at != null) 'at': at,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? id,
    Value<String>? event,
    Value<String?>? details,
    Value<DateTime>? at,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      event: event ?? this.event,
      details: details ?? this.details,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (event.present) {
      map['event'] = Variable<String>(event.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('event: $event, ')
          ..write('details: $details, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $RawMessagesTable rawMessages = $RawMessagesTable(this);
  late final $SendersTable senders = $SendersTable(this);
  late final $MerchantRulesTable merchantRules = $MerchantRulesTable(this);
  late final $StatementsTable statements = $StatementsTable(this);
  late final $InstallmentsTable installments = $InstallmentsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cards,
    categories,
    transactions,
    rawMessages,
    senders,
    merchantRules,
    statements,
    installments,
    settings,
    auditLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('merchant_rules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('statements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('installments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required String bankCode,
  required String last4,
  Value<String?> nickname,
  Value<String> currency,
  Value<int?> creditLimitMinor,
  Value<int?> statementDay,
  Value<int?> dueDay,
  Value<int?> lastAvailableMinor,
  Value<String?> lastAvailableCurrency,
  Value<DateTime?> lastAvailableAt,
  Value<bool> archived,
  Value<DateTime> createdAt,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<String> bankCode,
  Value<String> last4,
  Value<String?> nickname,
  Value<String> currency,
  Value<int?> creditLimitMinor,
  Value<int?> statementDay,
  Value<int?> dueDay,
  Value<int?> lastAvailableMinor,
  Value<String?> lastAvailableCurrency,
  Value<DateTime?> lastAvailableAt,
  Value<bool> archived,
  Value<DateTime> createdAt,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, CardRow> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TxnRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'cards__id__transactions__card_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StatementsTable, List<StatementRow>>
  _statementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.statements,
    aliasName: 'cards__id__statements__card_id',
  );

  $$StatementsTableProcessedTableManager get statementsRefs {
    final manager = $$StatementsTableTableManager(
      $_db,
      $_db.statements,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_statementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InstallmentsTable, List<InstallmentRow>>
  _installmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.installments,
    aliasName: 'cards__id__installments__card_id',
  );

  $$InstallmentsTableProcessedTableManager get installmentsRefs {
    final manager = $$InstallmentsTableTableManager(
      $_db,
      $_db.installments,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_installmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
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

  ColumnFilters<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statementDay => $composableBuilder(
    column: $table.statementDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastAvailableMinor => $composableBuilder(
    column: $table.lastAvailableMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastAvailableCurrency => $composableBuilder(
    column: $table.lastAvailableCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAvailableAt => $composableBuilder(
    column: $table.lastAvailableAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> statementsRefs(
    Expression<bool> Function($$StatementsTableFilterComposer f) f,
  ) {
    final $$StatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableFilterComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> installmentsRefs(
    Expression<bool> Function($$InstallmentsTableFilterComposer f) f,
  ) {
    final $$InstallmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installments,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentsTableFilterComposer(
            $db: $db,
            $table: $db.installments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
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

  ColumnOrderings<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statementDay => $composableBuilder(
    column: $table.statementDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastAvailableMinor => $composableBuilder(
    column: $table.lastAvailableMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastAvailableCurrency => $composableBuilder(
    column: $table.lastAvailableCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAvailableAt => $composableBuilder(
    column: $table.lastAvailableAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statementDay => $composableBuilder(
    column: $table.statementDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<int> get lastAvailableMinor => $composableBuilder(
    column: $table.lastAvailableMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastAvailableCurrency => $composableBuilder(
    column: $table.lastAvailableCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAvailableAt => $composableBuilder(
    column: $table.lastAvailableAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> statementsRefs<T extends Object>(
    Expression<T> Function($$StatementsTableAnnotationComposer a) f,
  ) {
    final $$StatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> installmentsRefs<T extends Object>(
    Expression<T> Function($$InstallmentsTableAnnotationComposer a) f,
  ) {
    final $$InstallmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installments,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.installments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          CardRow,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (CardRow, $$CardsTableReferences),
          CardRow,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool statementsRefs,
            bool installmentsRefs,
          })
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bankCode = const Value.absent(),
                Value<String> last4 = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> creditLimitMinor = const Value.absent(),
                Value<int?> statementDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<int?> lastAvailableMinor = const Value.absent(),
                Value<String?> lastAvailableCurrency = const Value.absent(),
                Value<DateTime?> lastAvailableAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                bankCode: bankCode,
                last4: last4,
                nickname: nickname,
                currency: currency,
                creditLimitMinor: creditLimitMinor,
                statementDay: statementDay,
                dueDay: dueDay,
                lastAvailableMinor: lastAvailableMinor,
                lastAvailableCurrency: lastAvailableCurrency,
                lastAvailableAt: lastAvailableAt,
                archived: archived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bankCode,
                required String last4,
                Value<String?> nickname = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> creditLimitMinor = const Value.absent(),
                Value<int?> statementDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<int?> lastAvailableMinor = const Value.absent(),
                Value<String?> lastAvailableCurrency = const Value.absent(),
                Value<DateTime?> lastAvailableAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                bankCode: bankCode,
                last4: last4,
                nickname: nickname,
                currency: currency,
                creditLimitMinor: creditLimitMinor,
                statementDay: statementDay,
                dueDay: dueDay,
                lastAvailableMinor: lastAvailableMinor,
                lastAvailableCurrency: lastAvailableCurrency,
                lastAvailableAt: lastAvailableAt,
                archived: archived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardsTable, CardRow>(table),
                  $$CardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                statementsRefs = false,
                installmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (statementsRefs) db.statements,
                    if (installmentsRefs) db.installments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CardRow,
                          $CardsTable,
                          TxnRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                      if (statementsRefs)
                        await $_getPrefetchedDataByColumns<
                          CardRow,
                          $CardsTable,
                          StatementRow,
                          $StatementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._statementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).statementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                      if (installmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          CardRow,
                          $CardsTable,
                          InstallmentRow,
                          $InstallmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._installmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).installmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      CardRow,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (CardRow, $$CardsTableReferences),
      CardRow,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool statementsRefs,
        bool installmentsRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String key,
  required String nameEn,
  required String nameAr,
  required int icon,
  required int color,
  Value<bool> builtin,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> key,
  Value<String> nameEn,
  Value<String> nameAr,
  Value<int> icon,
  Value<int> color,
  Value<bool> builtin,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TxnRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MerchantRulesTable, List<MerchantRuleRow>>
  _merchantRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.merchantRules,
    aliasName: 'categories__id__merchant_rules__category_id',
  );

  $$MerchantRulesTableProcessedTableManager get merchantRulesRefs {
    final manager = $$MerchantRulesTableTableManager(
      $_db,
      $_db.merchantRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_merchantRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> merchantRulesRefs(
    Expression<bool> Function($$MerchantRulesTableFilterComposer f) f,
  ) {
    final $$MerchantRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.merchantRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MerchantRulesTableFilterComposer(
            $db: $db,
            $table: $db.merchantRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get builtin => $composableBuilder(
    column: $table.builtin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<int> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get builtin =>
      $composableBuilder(column: $table.builtin, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> merchantRulesRefs<T extends Object>(
    Expression<T> Function($$MerchantRulesTableAnnotationComposer a) f,
  ) {
    final $$MerchantRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.merchantRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MerchantRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.merchantRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool merchantRulesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<int> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> builtin = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                key: key,
                nameEn: nameEn,
                nameAr: nameAr,
                icon: icon,
                color: color,
                builtin: builtin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String nameEn,
                required String nameAr,
                required int icon,
                required int color,
                Value<bool> builtin = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                key: key,
                nameEn: nameEn,
                nameAr: nameAr,
                icon: icon,
                color: color,
                builtin: builtin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionsRefs = false, merchantRulesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (merchantRulesRefs) db.merchantRules,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          TxnRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (merchantRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          MerchantRuleRow,
                          $MerchantRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._merchantRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).merchantRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool transactionsRefs, bool merchantRulesRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int cardId,
      required String type,
      required int amountMinor,
      required String currency,
      Value<int?> originalAmountMinor,
      Value<String?> originalCurrency,
      required String merchant,
      Value<int?> categoryId,
      required DateTime occurredAt,
      Value<int?> availableLimitMinor,
      required String sourceType,
      required String sourceHash,
      required String parserId,
      required int parserVersion,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> cardId,
      Value<String> type,
      Value<int> amountMinor,
      Value<String> currency,
      Value<int?> originalAmountMinor,
      Value<String?> originalCurrency,
      Value<String> merchant,
      Value<int?> categoryId,
      Value<DateTime> occurredAt,
      Value<int?> availableLimitMinor,
      Value<String> sourceType,
      Value<String> sourceHash,
      Value<String> parserId,
      Value<int> parserVersion,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, TxnRow> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('transactions__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalAmountMinor => $composableBuilder(
    column: $table.originalAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get availableLimitMinor => $composableBuilder(
    column: $table.availableLimitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserId => $composableBuilder(
    column: $table.parserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalAmountMinor => $composableBuilder(
    column: $table.originalAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get availableLimitMinor => $composableBuilder(
    column: $table.availableLimitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserId => $composableBuilder(
    column: $table.parserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get originalAmountMinor => $composableBuilder(
    column: $table.originalAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get availableLimitMinor => $composableBuilder(
    column: $table.availableLimitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parserId =>
      $composableBuilder(column: $table.parserId, builder: (column) => column);

  GeneratedColumn<int> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TxnRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TxnRow, $$TransactionsTableReferences),
          TxnRow,
          PrefetchHooks Function({bool cardId, bool categoryId})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> originalAmountMinor = const Value.absent(),
                Value<String?> originalCurrency = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int?> availableLimitMinor = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<String> parserId = const Value.absent(),
                Value<int> parserVersion = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                cardId: cardId,
                type: type,
                amountMinor: amountMinor,
                currency: currency,
                originalAmountMinor: originalAmountMinor,
                originalCurrency: originalCurrency,
                merchant: merchant,
                categoryId: categoryId,
                occurredAt: occurredAt,
                availableLimitMinor: availableLimitMinor,
                sourceType: sourceType,
                sourceHash: sourceHash,
                parserId: parserId,
                parserVersion: parserVersion,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required String type,
                required int amountMinor,
                required String currency,
                Value<int?> originalAmountMinor = const Value.absent(),
                Value<String?> originalCurrency = const Value.absent(),
                required String merchant,
                Value<int?> categoryId = const Value.absent(),
                required DateTime occurredAt,
                Value<int?> availableLimitMinor = const Value.absent(),
                required String sourceType,
                required String sourceHash,
                required String parserId,
                required int parserVersion,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                cardId: cardId,
                type: type,
                amountMinor: amountMinor,
                currency: currency,
                originalAmountMinor: originalAmountMinor,
                originalCurrency: originalCurrency,
                merchant: merchant,
                categoryId: categoryId,
                occurredAt: occurredAt,
                availableLimitMinor: availableLimitMinor,
                sourceType: sourceType,
                sourceHash: sourceHash,
                parserId: parserId,
                parserVersion: parserVersion,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TxnRow>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false, categoryId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$TransactionsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$TransactionsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$TransactionsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$TransactionsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
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

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TxnRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TxnRow, $$TransactionsTableReferences),
      TxnRow,
      PrefetchHooks Function({bool cardId, bool categoryId})
    >;
typedef $$RawMessagesTableCreateCompanionBuilder =
    RawMessagesCompanion Function({
      Value<int> id,
      required String sourceType,
      Value<String?> sender,
      required String body,
      required DateTime receivedAt,
      required String status,
      Value<String?> bankCode,
      required String rawHash,
      Value<int?> transactionId,
      Value<DateTime> createdAt,
    });
typedef $$RawMessagesTableUpdateCompanionBuilder =
    RawMessagesCompanion Function({
      Value<int> id,
      Value<String> sourceType,
      Value<String?> sender,
      Value<String> body,
      Value<DateTime> receivedAt,
      Value<String> status,
      Value<String?> bankCode,
      Value<String> rawHash,
      Value<int?> transactionId,
      Value<DateTime> createdAt,
    });

class $$RawMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $RawMessagesTable> {
  $$RawMessagesTableFilterComposer({
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

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawHash => $composableBuilder(
    column: $table.rawHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RawMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $RawMessagesTable> {
  $$RawMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawHash => $composableBuilder(
    column: $table.rawHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RawMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawMessagesTable> {
  $$RawMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<String> get rawHash =>
      $composableBuilder(column: $table.rawHash, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RawMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RawMessagesTable,
          RawRow,
          $$RawMessagesTableFilterComposer,
          $$RawMessagesTableOrderingComposer,
          $$RawMessagesTableAnnotationComposer,
          $$RawMessagesTableCreateCompanionBuilder,
          $$RawMessagesTableUpdateCompanionBuilder,
          (RawRow, BaseReferences<_$AppDatabase, $RawMessagesTable, RawRow>),
          RawRow,
          PrefetchHooks Function()
        > {
  $$RawMessagesTableTableManager(_$AppDatabase db, $RawMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> bankCode = const Value.absent(),
                Value<String> rawHash = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RawMessagesCompanion(
                id: id,
                sourceType: sourceType,
                sender: sender,
                body: body,
                receivedAt: receivedAt,
                status: status,
                bankCode: bankCode,
                rawHash: rawHash,
                transactionId: transactionId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sourceType,
                Value<String?> sender = const Value.absent(),
                required String body,
                required DateTime receivedAt,
                required String status,
                Value<String?> bankCode = const Value.absent(),
                required String rawHash,
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RawMessagesCompanion.insert(
                id: id,
                sourceType: sourceType,
                sender: sender,
                body: body,
                receivedAt: receivedAt,
                status: status,
                bankCode: bankCode,
                rawHash: rawHash,
                transactionId: transactionId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RawMessagesTable, RawRow>(table),
                  BaseReferences<_$AppDatabase, $RawMessagesTable, RawRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RawMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RawMessagesTable,
      RawRow,
      $$RawMessagesTableFilterComposer,
      $$RawMessagesTableOrderingComposer,
      $$RawMessagesTableAnnotationComposer,
      $$RawMessagesTableCreateCompanionBuilder,
      $$RawMessagesTableUpdateCompanionBuilder,
      (RawRow, BaseReferences<_$AppDatabase, $RawMessagesTable, RawRow>),
      RawRow,
      PrefetchHooks Function()
    >;
typedef $$SendersTableCreateCompanionBuilder = SendersCompanion Function({
  Value<int> id,
  required String address,
  required String bankCode,
  Value<bool> enabled,
  Value<String> mode,
  Value<String?> mustContain,
  Value<DateTime> createdAt,
});
typedef $$SendersTableUpdateCompanionBuilder = SendersCompanion Function({
  Value<int> id,
  Value<String> address,
  Value<String> bankCode,
  Value<bool> enabled,
  Value<String> mode,
  Value<String?> mustContain,
  Value<DateTime> createdAt,
});

class $$SendersTableFilterComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableFilterComposer({
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

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mustContain => $composableBuilder(
    column: $table.mustContain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SendersTableOrderingComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableOrderingComposer({
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

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankCode => $composableBuilder(
    column: $table.bankCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mustContain => $composableBuilder(
    column: $table.mustContain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SendersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get bankCode =>
      $composableBuilder(column: $table.bankCode, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get mustContain => $composableBuilder(
    column: $table.mustContain,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SendersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SendersTable,
          SenderRow,
          $$SendersTableFilterComposer,
          $$SendersTableOrderingComposer,
          $$SendersTableAnnotationComposer,
          $$SendersTableCreateCompanionBuilder,
          $$SendersTableUpdateCompanionBuilder,
          (SenderRow, BaseReferences<_$AppDatabase, $SendersTable, SenderRow>),
          SenderRow,
          PrefetchHooks Function()
        > {
  $$SendersTableTableManager(_$AppDatabase db, $SendersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SendersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SendersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SendersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> bankCode = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> mustContain = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SendersCompanion(
                id: id,
                address: address,
                bankCode: bankCode,
                enabled: enabled,
                mode: mode,
                mustContain: mustContain,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String address,
                required String bankCode,
                Value<bool> enabled = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> mustContain = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SendersCompanion.insert(
                id: id,
                address: address,
                bankCode: bankCode,
                enabled: enabled,
                mode: mode,
                mustContain: mustContain,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SendersTable, SenderRow>(table),
                  BaseReferences<_$AppDatabase, $SendersTable, SenderRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SendersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SendersTable,
      SenderRow,
      $$SendersTableFilterComposer,
      $$SendersTableOrderingComposer,
      $$SendersTableAnnotationComposer,
      $$SendersTableCreateCompanionBuilder,
      $$SendersTableUpdateCompanionBuilder,
      (SenderRow, BaseReferences<_$AppDatabase, $SendersTable, SenderRow>),
      SenderRow,
      PrefetchHooks Function()
    >;
typedef $$MerchantRulesTableCreateCompanionBuilder =
    MerchantRulesCompanion Function({
      Value<int> id,
      required String pattern,
      required int categoryId,
    });
typedef $$MerchantRulesTableUpdateCompanionBuilder =
    MerchantRulesCompanion Function({
      Value<int> id,
      Value<String> pattern,
      Value<int> categoryId,
    });

final class $$MerchantRulesTableReferences
    extends
        BaseReferences<_$AppDatabase, $MerchantRulesTable, MerchantRuleRow> {
  $$MerchantRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('merchant_rules__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MerchantRulesTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantRulesTable> {
  $$MerchantRulesTableFilterComposer({
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

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantRulesTable> {
  $$MerchantRulesTableOrderingComposer({
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

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantRulesTable> {
  $$MerchantRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantRulesTable,
          MerchantRuleRow,
          $$MerchantRulesTableFilterComposer,
          $$MerchantRulesTableOrderingComposer,
          $$MerchantRulesTableAnnotationComposer,
          $$MerchantRulesTableCreateCompanionBuilder,
          $$MerchantRulesTableUpdateCompanionBuilder,
          (MerchantRuleRow, $$MerchantRulesTableReferences),
          MerchantRuleRow,
          PrefetchHooks Function({bool categoryId})
        > {
  $$MerchantRulesTableTableManager(_$AppDatabase db, $MerchantRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
              }) => MerchantRulesCompanion(
                id: id,
                pattern: pattern,
                categoryId: categoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pattern,
                required int categoryId,
              }) => MerchantRulesCompanion.insert(
                id: id,
                pattern: pattern,
                categoryId: categoryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MerchantRulesTable, MerchantRuleRow>(table),
                  $$MerchantRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
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
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$MerchantRulesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$MerchantRulesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MerchantRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantRulesTable,
      MerchantRuleRow,
      $$MerchantRulesTableFilterComposer,
      $$MerchantRulesTableOrderingComposer,
      $$MerchantRulesTableAnnotationComposer,
      $$MerchantRulesTableCreateCompanionBuilder,
      $$MerchantRulesTableUpdateCompanionBuilder,
      (MerchantRuleRow, $$MerchantRulesTableReferences),
      MerchantRuleRow,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$StatementsTableCreateCompanionBuilder = StatementsCompanion Function({
  Value<int> id,
  required int cardId,
  required DateTime periodEnd,
  required DateTime dueDate,
  required int totalDueMinor,
  Value<int?> minimumDueMinor,
  required String currency,
  Value<bool> paid,
  Value<DateTime> createdAt,
});
typedef $$StatementsTableUpdateCompanionBuilder = StatementsCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<DateTime> periodEnd,
  Value<DateTime> dueDate,
  Value<int> totalDueMinor,
  Value<int?> minimumDueMinor,
  Value<String> currency,
  Value<bool> paid,
  Value<DateTime> createdAt,
});

final class $$StatementsTableReferences
    extends BaseReferences<_$AppDatabase, $StatementsTable, StatementRow> {
  $$StatementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('statements__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StatementsTableFilterComposer
    extends Composer<_$AppDatabase, $StatementsTable> {
  $$StatementsTableFilterComposer({
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

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDueMinor => $composableBuilder(
    column: $table.totalDueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumDueMinor => $composableBuilder(
    column: $table.minimumDueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StatementsTable> {
  $$StatementsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDueMinor => $composableBuilder(
    column: $table.totalDueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumDueMinor => $composableBuilder(
    column: $table.minimumDueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatementsTable> {
  $$StatementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get totalDueMinor => $composableBuilder(
    column: $table.totalDueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumDueMinor => $composableBuilder(
    column: $table.minimumDueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StatementsTable,
          StatementRow,
          $$StatementsTableFilterComposer,
          $$StatementsTableOrderingComposer,
          $$StatementsTableAnnotationComposer,
          $$StatementsTableCreateCompanionBuilder,
          $$StatementsTableUpdateCompanionBuilder,
          (StatementRow, $$StatementsTableReferences),
          StatementRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$StatementsTableTableManager(_$AppDatabase db, $StatementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<DateTime> periodEnd = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> totalDueMinor = const Value.absent(),
                Value<int?> minimumDueMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> paid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StatementsCompanion(
                id: id,
                cardId: cardId,
                periodEnd: periodEnd,
                dueDate: dueDate,
                totalDueMinor: totalDueMinor,
                minimumDueMinor: minimumDueMinor,
                currency: currency,
                paid: paid,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required DateTime periodEnd,
                required DateTime dueDate,
                required int totalDueMinor,
                Value<int?> minimumDueMinor = const Value.absent(),
                required String currency,
                Value<bool> paid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StatementsCompanion.insert(
                id: id,
                cardId: cardId,
                periodEnd: periodEnd,
                dueDate: dueDate,
                totalDueMinor: totalDueMinor,
                minimumDueMinor: minimumDueMinor,
                currency: currency,
                paid: paid,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StatementsTable, StatementRow>(table),
                  $$StatementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$StatementsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$StatementsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$StatementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StatementsTable,
      StatementRow,
      $$StatementsTableFilterComposer,
      $$StatementsTableOrderingComposer,
      $$StatementsTableAnnotationComposer,
      $$StatementsTableCreateCompanionBuilder,
      $$StatementsTableUpdateCompanionBuilder,
      (StatementRow, $$StatementsTableReferences),
      StatementRow,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$InstallmentsTableCreateCompanionBuilder =
    InstallmentsCompanion Function({
      Value<int> id,
      required int cardId,
      required String merchant,
      required int totalMinor,
      required int monthlyMinor,
      required String currency,
      required int months,
      required DateTime startDate,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$InstallmentsTableUpdateCompanionBuilder =
    InstallmentsCompanion Function({
      Value<int> id,
      Value<int> cardId,
      Value<String> merchant,
      Value<int> totalMinor,
      Value<int> monthlyMinor,
      Value<String> currency,
      Value<int> months,
      Value<DateTime> startDate,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$InstallmentsTableReferences
    extends BaseReferences<_$AppDatabase, $InstallmentsTable, InstallmentRow> {
  $$InstallmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('installments__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InstallmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentsTable> {
  $$InstallmentsTableFilterComposer({
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

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyMinor => $composableBuilder(
    column: $table.monthlyMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get months => $composableBuilder(
    column: $table.months,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InstallmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentsTable> {
  $$InstallmentsTableOrderingComposer({
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

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyMinor => $composableBuilder(
    column: $table.monthlyMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get months => $composableBuilder(
    column: $table.months,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InstallmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentsTable> {
  $$InstallmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyMinor => $composableBuilder(
    column: $table.monthlyMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get months =>
      $composableBuilder(column: $table.months, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InstallmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstallmentsTable,
          InstallmentRow,
          $$InstallmentsTableFilterComposer,
          $$InstallmentsTableOrderingComposer,
          $$InstallmentsTableAnnotationComposer,
          $$InstallmentsTableCreateCompanionBuilder,
          $$InstallmentsTableUpdateCompanionBuilder,
          (InstallmentRow, $$InstallmentsTableReferences),
          InstallmentRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$InstallmentsTableTableManager(_$AppDatabase db, $InstallmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstallmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<int> monthlyMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> months = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InstallmentsCompanion(
                id: id,
                cardId: cardId,
                merchant: merchant,
                totalMinor: totalMinor,
                monthlyMinor: monthlyMinor,
                currency: currency,
                months: months,
                startDate: startDate,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required String merchant,
                required int totalMinor,
                required int monthlyMinor,
                required String currency,
                required int months,
                required DateTime startDate,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InstallmentsCompanion.insert(
                id: id,
                cardId: cardId,
                merchant: merchant,
                totalMinor: totalMinor,
                monthlyMinor: monthlyMinor,
                currency: currency,
                months: months,
                startDate: startDate,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InstallmentsTable, InstallmentRow>(table),
                  $$InstallmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$InstallmentsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$InstallmentsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$InstallmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstallmentsTable,
      InstallmentRow,
      $$InstallmentsTableFilterComposer,
      $$InstallmentsTableOrderingComposer,
      $$InstallmentsTableAnnotationComposer,
      $$InstallmentsTableCreateCompanionBuilder,
      $$InstallmentsTableUpdateCompanionBuilder,
      (InstallmentRow, $$InstallmentsTableReferences),
      InstallmentRow,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  required String event,
  Value<String?> details,
  Value<DateTime> at,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  Value<String> event,
  Value<String?> details,
  Value<DateTime> at,
});

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
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

  ColumnFilters<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
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

  ColumnOrderings<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditRow,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (AuditRow, BaseReferences<_$AppDatabase, $AuditLogTable, AuditRow>),
          AuditRow,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> event = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                event: event,
                details: details,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String event,
                Value<String?> details = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                event: event,
                details: details,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditLogTable, AuditRow>(table),
                  BaseReferences<_$AppDatabase, $AuditLogTable, AuditRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditRow,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditRow, BaseReferences<_$AppDatabase, $AuditLogTable, AuditRow>),
      AuditRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$RawMessagesTableTableManager get rawMessages =>
      $$RawMessagesTableTableManager(_db, _db.rawMessages);
  $$SendersTableTableManager get senders =>
      $$SendersTableTableManager(_db, _db.senders);
  $$MerchantRulesTableTableManager get merchantRules =>
      $$MerchantRulesTableTableManager(_db, _db.merchantRules);
  $$StatementsTableTableManager get statements =>
      $$StatementsTableTableManager(_db, _db.statements);
  $$InstallmentsTableTableManager get installments =>
      $$InstallmentsTableTableManager(_db, _db.installments);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
}
