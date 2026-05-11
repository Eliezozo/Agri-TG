// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return _Vote.fromJson(json);
}

/// @nodoc
mixin _$Vote {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get amountThreshold => throw _privateConstructorUsedError;
  int get forCount => throw _privateConstructorUsedError;
  int get againstCount => throw _privateConstructorUsedError;
  int get abstainCount => throw _privateConstructorUsedError;
  int get totalMembers => throw _privateConstructorUsedError;
  DateTime get closingDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'open' | 'closed' | 'pending'
  String? get currentMemberVote =>
      throw _privateConstructorUsedError; // null si pas encore voté
  String? get blockchainHash => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VoteCopyWith<Vote> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoteCopyWith<$Res> {
  factory $VoteCopyWith(Vote value, $Res Function(Vote) then) =
      _$VoteCopyWithImpl<$Res, Vote>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      double amountThreshold,
      int forCount,
      int againstCount,
      int abstainCount,
      int totalMembers,
      DateTime closingDate,
      String status,
      String? currentMemberVote,
      String? blockchainHash});
}

/// @nodoc
class _$VoteCopyWithImpl<$Res, $Val extends Vote>
    implements $VoteCopyWith<$Res> {
  _$VoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? amountThreshold = null,
    Object? forCount = null,
    Object? againstCount = null,
    Object? abstainCount = null,
    Object? totalMembers = null,
    Object? closingDate = null,
    Object? status = null,
    Object? currentMemberVote = freezed,
    Object? blockchainHash = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountThreshold: null == amountThreshold
          ? _value.amountThreshold
          : amountThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      forCount: null == forCount
          ? _value.forCount
          : forCount // ignore: cast_nullable_to_non_nullable
              as int,
      againstCount: null == againstCount
          ? _value.againstCount
          : againstCount // ignore: cast_nullable_to_non_nullable
              as int,
      abstainCount: null == abstainCount
          ? _value.abstainCount
          : abstainCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      closingDate: null == closingDate
          ? _value.closingDate
          : closingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentMemberVote: freezed == currentMemberVote
          ? _value.currentMemberVote
          : currentMemberVote // ignore: cast_nullable_to_non_nullable
              as String?,
      blockchainHash: freezed == blockchainHash
          ? _value.blockchainHash
          : blockchainHash // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoteImplCopyWith<$Res> implements $VoteCopyWith<$Res> {
  factory _$$VoteImplCopyWith(
          _$VoteImpl value, $Res Function(_$VoteImpl) then) =
      __$$VoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      double amountThreshold,
      int forCount,
      int againstCount,
      int abstainCount,
      int totalMembers,
      DateTime closingDate,
      String status,
      String? currentMemberVote,
      String? blockchainHash});
}

/// @nodoc
class __$$VoteImplCopyWithImpl<$Res>
    extends _$VoteCopyWithImpl<$Res, _$VoteImpl>
    implements _$$VoteImplCopyWith<$Res> {
  __$$VoteImplCopyWithImpl(_$VoteImpl _value, $Res Function(_$VoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? amountThreshold = null,
    Object? forCount = null,
    Object? againstCount = null,
    Object? abstainCount = null,
    Object? totalMembers = null,
    Object? closingDate = null,
    Object? status = null,
    Object? currentMemberVote = freezed,
    Object? blockchainHash = freezed,
  }) {
    return _then(_$VoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountThreshold: null == amountThreshold
          ? _value.amountThreshold
          : amountThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      forCount: null == forCount
          ? _value.forCount
          : forCount // ignore: cast_nullable_to_non_nullable
              as int,
      againstCount: null == againstCount
          ? _value.againstCount
          : againstCount // ignore: cast_nullable_to_non_nullable
              as int,
      abstainCount: null == abstainCount
          ? _value.abstainCount
          : abstainCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      closingDate: null == closingDate
          ? _value.closingDate
          : closingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentMemberVote: freezed == currentMemberVote
          ? _value.currentMemberVote
          : currentMemberVote // ignore: cast_nullable_to_non_nullable
              as String?,
      blockchainHash: freezed == blockchainHash
          ? _value.blockchainHash
          : blockchainHash // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VoteImpl implements _Vote {
  const _$VoteImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.amountThreshold,
      required this.forCount,
      required this.againstCount,
      required this.abstainCount,
      required this.totalMembers,
      required this.closingDate,
      required this.status,
      this.currentMemberVote,
      this.blockchainHash});

  factory _$VoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double amountThreshold;
  @override
  final int forCount;
  @override
  final int againstCount;
  @override
  final int abstainCount;
  @override
  final int totalMembers;
  @override
  final DateTime closingDate;
  @override
  final String status;
// 'open' | 'closed' | 'pending'
  @override
  final String? currentMemberVote;
// null si pas encore voté
  @override
  final String? blockchainHash;

  @override
  String toString() {
    return 'Vote(id: $id, title: $title, description: $description, amountThreshold: $amountThreshold, forCount: $forCount, againstCount: $againstCount, abstainCount: $abstainCount, totalMembers: $totalMembers, closingDate: $closingDate, status: $status, currentMemberVote: $currentMemberVote, blockchainHash: $blockchainHash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountThreshold, amountThreshold) ||
                other.amountThreshold == amountThreshold) &&
            (identical(other.forCount, forCount) ||
                other.forCount == forCount) &&
            (identical(other.againstCount, againstCount) ||
                other.againstCount == againstCount) &&
            (identical(other.abstainCount, abstainCount) ||
                other.abstainCount == abstainCount) &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.closingDate, closingDate) ||
                other.closingDate == closingDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentMemberVote, currentMemberVote) ||
                other.currentMemberVote == currentMemberVote) &&
            (identical(other.blockchainHash, blockchainHash) ||
                other.blockchainHash == blockchainHash));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      amountThreshold,
      forCount,
      againstCount,
      abstainCount,
      totalMembers,
      closingDate,
      status,
      currentMemberVote,
      blockchainHash);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VoteImplCopyWith<_$VoteImpl> get copyWith =>
      __$$VoteImplCopyWithImpl<_$VoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoteImplToJson(
      this,
    );
  }
}

abstract class _Vote implements Vote {
  const factory _Vote(
      {required final String id,
      required final String title,
      required final String description,
      required final double amountThreshold,
      required final int forCount,
      required final int againstCount,
      required final int abstainCount,
      required final int totalMembers,
      required final DateTime closingDate,
      required final String status,
      final String? currentMemberVote,
      final String? blockchainHash}) = _$VoteImpl;

  factory _Vote.fromJson(Map<String, dynamic> json) = _$VoteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  double get amountThreshold;
  @override
  int get forCount;
  @override
  int get againstCount;
  @override
  int get abstainCount;
  @override
  int get totalMembers;
  @override
  DateTime get closingDate;
  @override
  String get status;
  @override // 'open' | 'closed' | 'pending'
  String? get currentMemberVote;
  @override // null si pas encore voté
  String? get blockchainHash;
  @override
  @JsonKey(ignore: true)
  _$$VoteImplCopyWith<_$VoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
