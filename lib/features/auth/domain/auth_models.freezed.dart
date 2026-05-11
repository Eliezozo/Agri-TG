// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoopMember _$CoopMemberFromJson(Map<String, dynamic> json) {
  return _CoopMember.fromJson(json);
}

/// @nodoc
mixin _$CoopMember {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // 'membre' | 'tresorier' | 'president'
  String get cooperativeId => throw _privateConstructorUsedError;
  String get cooperativeName => throw _privateConstructorUsedError;
  DateTime? get joinedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoopMemberCopyWith<CoopMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoopMemberCopyWith<$Res> {
  factory $CoopMemberCopyWith(
          CoopMember value, $Res Function(CoopMember) then) =
      _$CoopMemberCopyWithImpl<$Res, CoopMember>;
  @useResult
  $Res call(
      {String id,
      String fullName,
      String phone,
      String role,
      String cooperativeId,
      String cooperativeName,
      DateTime? joinedAt});
}

/// @nodoc
class _$CoopMemberCopyWithImpl<$Res, $Val extends CoopMember>
    implements $CoopMemberCopyWith<$Res> {
  _$CoopMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? role = null,
    Object? cooperativeId = null,
    Object? cooperativeName = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeId: null == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeName: null == cooperativeName
          ? _value.cooperativeName
          : cooperativeName // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoopMemberImplCopyWith<$Res>
    implements $CoopMemberCopyWith<$Res> {
  factory _$$CoopMemberImplCopyWith(
          _$CoopMemberImpl value, $Res Function(_$CoopMemberImpl) then) =
      __$$CoopMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fullName,
      String phone,
      String role,
      String cooperativeId,
      String cooperativeName,
      DateTime? joinedAt});
}

/// @nodoc
class __$$CoopMemberImplCopyWithImpl<$Res>
    extends _$CoopMemberCopyWithImpl<$Res, _$CoopMemberImpl>
    implements _$$CoopMemberImplCopyWith<$Res> {
  __$$CoopMemberImplCopyWithImpl(
      _$CoopMemberImpl _value, $Res Function(_$CoopMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? role = null,
    Object? cooperativeId = null,
    Object? cooperativeName = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_$CoopMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeId: null == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeName: null == cooperativeName
          ? _value.cooperativeName
          : cooperativeName // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoopMemberImpl implements _CoopMember {
  const _$CoopMemberImpl(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.role,
      required this.cooperativeId,
      required this.cooperativeName,
      this.joinedAt});

  factory _$CoopMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String role;
// 'membre' | 'tresorier' | 'president'
  @override
  final String cooperativeId;
  @override
  final String cooperativeName;
  @override
  final DateTime? joinedAt;

  @override
  String toString() {
    return 'CoopMember(id: $id, fullName: $fullName, phone: $phone, role: $role, cooperativeId: $cooperativeId, cooperativeName: $cooperativeName, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.cooperativeId, cooperativeId) ||
                other.cooperativeId == cooperativeId) &&
            (identical(other.cooperativeName, cooperativeName) ||
                other.cooperativeName == cooperativeName) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, phone, role,
      cooperativeId, cooperativeName, joinedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoopMemberImplCopyWith<_$CoopMemberImpl> get copyWith =>
      __$$CoopMemberImplCopyWithImpl<_$CoopMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoopMemberImplToJson(
      this,
    );
  }
}

abstract class _CoopMember implements CoopMember {
  const factory _CoopMember(
      {required final String id,
      required final String fullName,
      required final String phone,
      required final String role,
      required final String cooperativeId,
      required final String cooperativeName,
      final DateTime? joinedAt}) = _$CoopMemberImpl;

  factory _CoopMember.fromJson(Map<String, dynamic> json) =
      _$CoopMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get role;
  @override // 'membre' | 'tresorier' | 'president'
  String get cooperativeId;
  @override
  String get cooperativeName;
  @override
  DateTime? get joinedAt;
  @override
  @JsonKey(ignore: true)
  _$$CoopMemberImplCopyWith<_$CoopMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
