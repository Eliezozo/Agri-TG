// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportsHash() => r'a1a4eed77878373a5f252fc39990820a901e308f';

/// See also [reports].
@ProviderFor(reports)
final reportsProvider = AutoDisposeFutureProvider<List<MonthlyReport>>.internal(
  reports,
  name: r'reportsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$reportsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReportsRef = AutoDisposeFutureProviderRef<List<MonthlyReport>>;
String _$reportDetailHash() => r'8d4a34e9cc5557c5f8b7ca6120525b8f4553d28c';

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

/// See also [reportDetail].
@ProviderFor(reportDetail)
const reportDetailProvider = ReportDetailFamily();

/// See also [reportDetail].
class ReportDetailFamily extends Family<AsyncValue<MonthlyReport>> {
  /// See also [reportDetail].
  const ReportDetailFamily();

  /// See also [reportDetail].
  ReportDetailProvider call(
    String month,
  ) {
    return ReportDetailProvider(
      month,
    );
  }

  @override
  ReportDetailProvider getProviderOverride(
    covariant ReportDetailProvider provider,
  ) {
    return call(
      provider.month,
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
  String? get name => r'reportDetailProvider';
}

/// See also [reportDetail].
class ReportDetailProvider extends AutoDisposeFutureProvider<MonthlyReport> {
  /// See also [reportDetail].
  ReportDetailProvider(
    String month,
  ) : this._internal(
          (ref) => reportDetail(
            ref as ReportDetailRef,
            month,
          ),
          from: reportDetailProvider,
          name: r'reportDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportDetailHash,
          dependencies: ReportDetailFamily._dependencies,
          allTransitiveDependencies:
              ReportDetailFamily._allTransitiveDependencies,
          month: month,
        );

  ReportDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.month,
  }) : super.internal();

  final String month;

  @override
  Override overrideWith(
    FutureOr<MonthlyReport> Function(ReportDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportDetailProvider._internal(
        (ref) => create(ref as ReportDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyReport> createElement() {
    return _ReportDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDetailProvider && other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportDetailRef on AutoDisposeFutureProviderRef<MonthlyReport> {
  /// The parameter `month` of this provider.
  String get month;
}

class _ReportDetailProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyReport>
    with ReportDetailRef {
  _ReportDetailProviderElement(super.provider);

  @override
  String get month => (origin as ReportDetailProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
