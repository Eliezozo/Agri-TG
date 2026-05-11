// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$votesHash() => r'b05996b25f11b5fa65c0f7b3d812f60a37cfadd8';

/// Provider de la liste des votes avec cache Hive
///
/// Copied from [votes].
@ProviderFor(votes)
final votesProvider = AutoDisposeFutureProvider<List<Vote>>.internal(
  votes,
  name: r'votesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$votesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VotesRef = AutoDisposeFutureProviderRef<List<Vote>>;
String _$voteDetailHash() => r'd3b5a797d1a7f169e21d8e268ea61e6ec6af178d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider du détail d'un vote
///
/// Copied from [voteDetail].
@ProviderFor(voteDetail)
const voteDetailProvider = VoteDetailFamily();

/// Provider du détail d'un vote
///
/// Copied from [voteDetail].
class VoteDetailFamily extends Family<AsyncValue<Vote>> {
  /// Provider du détail d'un vote
  ///
  /// Copied from [voteDetail].
  const VoteDetailFamily();

  /// Provider du détail d'un vote
  ///
  /// Copied from [voteDetail].
  VoteDetailProvider call(
    String voteId,
  ) {
    return VoteDetailProvider(
      voteId,
    );
  }

  @override
  VoteDetailProvider getProviderOverride(
    covariant VoteDetailProvider provider,
  ) {
    return call(
      provider.voteId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'voteDetailProvider';
}

/// Provider du détail d'un vote
///
/// Copied from [voteDetail].
class VoteDetailProvider extends AutoDisposeFutureProvider<Vote> {
  /// Provider du détail d'un vote
  ///
  /// Copied from [voteDetail].
  VoteDetailProvider(
    String voteId,
  ) : this._internal(
          (ref) => voteDetail(
            ref as VoteDetailRef,
            voteId,
          ),
          from: voteDetailProvider,
          name: r'voteDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$voteDetailHash,
          dependencies: VoteDetailFamily._dependencies,
          allTransitiveDependencies:
              VoteDetailFamily._allTransitiveDependencies,
          voteId: voteId,
        );

  VoteDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.voteId,
  }) : super.internal();

  final String voteId;

  @override
  Override overrideWith(
    FutureOr<Vote> Function(VoteDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VoteDetailProvider._internal(
        (ref) => create(ref as VoteDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        voteId: voteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Vote> createElement() {
    return _VoteDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VoteDetailProvider && other.voteId == voteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, voteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VoteDetailRef on AutoDisposeFutureProviderRef<Vote> {
  /// The parameter `voteId` of this provider.
  String get voteId;
}

class _VoteDetailProviderElement extends AutoDisposeFutureProviderElement<Vote>
    with VoteDetailRef {
  _VoteDetailProviderElement(super.provider);

  @override
  String get voteId => (origin as VoteDetailProvider).voteId;
}

String _$voteCasterHash() => r'0133d01376b72d8c70ca522edaf8d9cc913f3bb1';

/// Notifier gérant la soumission d'un vote
/// Retourne un VoteCastResult avec le txHash pour affichage dans la UI
///
/// Copied from [VoteCaster].
@ProviderFor(VoteCaster)
final voteCasterProvider = AutoDisposeNotifierProvider<VoteCaster,
    AsyncValue<VoteCastResult?>>.internal(
  VoteCaster.new,
  name: r'voteCasterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$voteCasterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VoteCaster = AutoDisposeNotifier<AsyncValue<VoteCastResult?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
