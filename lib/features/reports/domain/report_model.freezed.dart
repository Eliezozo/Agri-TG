// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) {
  return _MonthlyReport.fromJson(json);
}

/// @nodoc
mixin _$MonthlyReport {
  String get id => throw _privateConstructorUsedError;
  String get month => throw _privateConstructorUsedError; // ex: "2026-04"
  double get totalIn => throw _privateConstructorUsedError;
  double get totalOut => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, double> get byCategory => throw _privateConstructorUsedError;
  String get blockchainHash => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonthlyReportCopyWith<MonthlyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyReportCopyWith<$Res> {
  factory $MonthlyReportCopyWith(
          MonthlyReport value, $Res Function(MonthlyReport) then) =
      _$MonthlyReportCopyWithImpl<$Res, MonthlyReport>;
  @useResult
  $Res call(
      {String id,
      String month,
      double totalIn,
      double totalOut,
      double balance,
      int transactionCount,
      Map<String, double> byCategory,
      String blockchainHash,
      DateTime generatedAt});
}

/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res, $Val extends MonthlyReport>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? month = null,
    Object? totalIn = null,
    Object? totalOut = null,
    Object? balance = null,
    Object? transactionCount = null,
    Object? byCategory = null,
    Object? blockchainHash = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalIn: null == totalIn
          ? _value.totalIn
          : totalIn // ignore: cast_nullable_to_non_nullable
              as double,
      totalOut: null == totalOut
          ? _value.totalOut
          : totalOut // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      byCategory: null == byCategory
          ? _value.byCategory
          : byCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      blockchainHash: null == blockchainHash
          ? _value.blockchainHash
          : blockchainHash // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyReportImplCopyWith<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  factory _$$MonthlyReportImplCopyWith(
          _$MonthlyReportImpl value, $Res Function(_$MonthlyReportImpl) then) =
      __$$MonthlyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String month,
      double totalIn,
      double totalOut,
      double balance,
      int transactionCount,
      Map<String, double> byCategory,
      String blockchainHash,
      DateTime generatedAt});
}

/// @nodoc
class __$$MonthlyReportImplCopyWithImpl<$Res>
    extends _$MonthlyReportCopyWithImpl<$Res, _$MonthlyReportImpl>
    implements _$$MonthlyReportImplCopyWith<$Res> {
  __$$MonthlyReportImplCopyWithImpl(
      _$MonthlyReportImpl _value, $Res Function(_$MonthlyReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? month = null,
    Object? totalIn = null,
    Object? totalOut = null,
    Object? balance = null,
    Object? transactionCount = null,
    Object? byCategory = null,
    Object? blockchainHash = null,
    Object? generatedAt = null,
  }) {
    return _then(_$MonthlyReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      totalIn: null == totalIn
          ? _value.totalIn
          : totalIn // ignore: cast_nullable_to_non_nullable
              as double,
      totalOut: null == totalOut
          ? _value.totalOut
          : totalOut // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      byCategory: null == byCategory
          ? _value._byCategory
          : byCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      blockchainHash: null == blockchainHash
          ? _value.blockchainHash
          : blockchainHash // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyReportImpl implements _MonthlyReport {
  const _$MonthlyReportImpl(
      {required this.id,
      required this.month,
      required this.totalIn,
      required this.totalOut,
      required this.balance,
      required this.transactionCount,
      required final Map<String, double> byCategory,
      required this.blockchainHash,
      required this.generatedAt})
      : _byCategory = byCategory;

  factory _$MonthlyReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyReportImplFromJson(json);

  @override
  final String id;
  @override
  final String month;
// ex: "2026-04"
  @override
  final double totalIn;
  @override
  final double totalOut;
  @override
  final double balance;
  @override
  final int transactionCount;
  final Map<String, double> _byCategory;
  @override
  Map<String, double> get byCategory {
    if (_byCategory is EqualUnmodifiableMapView) return _byCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byCategory);
  }

  @override
  final String blockchainHash;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'MonthlyReport(id: $id, month: $month, totalIn: $totalIn, totalOut: $totalOut, balance: $balance, transactionCount: $transactionCount, byCategory: $byCategory, blockchainHash: $blockchainHash, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalIn, totalIn) || other.totalIn == totalIn) &&
            (identical(other.totalOut, totalOut) ||
                other.totalOut == totalOut) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._byCategory, _byCategory) &&
            (identical(other.blockchainHash, blockchainHash) ||
                other.blockchainHash == blockchainHash) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      month,
      totalIn,
      totalOut,
      balance,
      transactionCount,
      const DeepCollectionEquality().hash(_byCategory),
      blockchainHash,
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyReportImplCopyWith<_$MonthlyReportImpl> get copyWith =>
      __$$MonthlyReportImplCopyWithImpl<_$MonthlyReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyReportImplToJson(
      this,
    );
  }
}

abstract class _MonthlyReport implements MonthlyReport {
  const factory _MonthlyReport(
      {required final String id,
      required final String month,
      required final double totalIn,
      required final double totalOut,
      required final double balance,
      required final int transactionCount,
      required final Map<String, double> byCategory,
      required final String blockchainHash,
      required final DateTime generatedAt}) = _$MonthlyReportImpl;

  factory _MonthlyReport.fromJson(Map<String, dynamic> json) =
      _$MonthlyReportImpl.fromJson;

  @override
  String get id;
  @override
  String get month;
  @override // ex: "2026-04"
  double get totalIn;
  @override
  double get totalOut;
  @override
  double get balance;
  @override
  int get transactionCount;
  @override
  Map<String, double> get byCategory;
  @override
  String get blockchainHash;
  @override
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MonthlyReportImplCopyWith<_$MonthlyReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
