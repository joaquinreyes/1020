// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$levelRepoHash() => r'b3e29487fd16a9dc76b3c6b9d9e8e813108792b2';

/// See also [levelRepo].
@ProviderFor(levelRepo)
final levelRepoProvider = AutoDisposeProvider<LevelRepo>.internal(
  levelRepo,
  name: r'levelRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$levelRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LevelRepoRef = AutoDisposeProviderRef<LevelRepo>;
String _$levelQuestionsHash() => r'd707490b294169135d461c7d81d06063fdf1520f';

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

/// See also [levelQuestions].
@ProviderFor(levelQuestions)
const levelQuestionsProvider = LevelQuestionsFamily();

/// See also [levelQuestions].
class LevelQuestionsFamily extends Family {
  /// See also [levelQuestions].
  const LevelQuestionsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'levelQuestionsProvider';

  /// See also [levelQuestions].
  LevelQuestionsProvider call({
    String? sport,
  }) {
    return LevelQuestionsProvider(
      sport: sport,
    );
  }

  @visibleForOverriding
  @override
  LevelQuestionsProvider getProviderOverride(
    covariant LevelQuestionsProvider provider,
  ) {
    return call(
      sport: provider.sport,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<LevelQuestion>> Function(LevelQuestionsRef ref) create) {
    return _$LevelQuestionsFamilyOverride(this, create);
  }
}

class _$LevelQuestionsFamilyOverride implements FamilyOverride {
  _$LevelQuestionsFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<LevelQuestion>> Function(LevelQuestionsRef ref) create;

  @override
  final LevelQuestionsFamily overriddenFamily;

  @override
  LevelQuestionsProvider getProviderOverride(
    covariant LevelQuestionsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [levelQuestions].
class LevelQuestionsProvider
    extends AutoDisposeFutureProvider<List<LevelQuestion>> {
  /// See also [levelQuestions].
  LevelQuestionsProvider({
    String? sport,
  }) : this._internal(
          (ref) => levelQuestions(
            ref as LevelQuestionsRef,
            sport: sport,
          ),
          from: levelQuestionsProvider,
          name: r'levelQuestionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$levelQuestionsHash,
          dependencies: LevelQuestionsFamily._dependencies,
          allTransitiveDependencies:
              LevelQuestionsFamily._allTransitiveDependencies,
          sport: sport,
        );

  LevelQuestionsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sport,
  }) : super.internal();

  final String? sport;

  @override
  Override overrideWith(
    FutureOr<List<LevelQuestion>> Function(LevelQuestionsRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LevelQuestionsProvider._internal(
        (ref) => create(ref as LevelQuestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sport: sport,
      ),
    );
  }

  @override
  ({
    String? sport,
  }) get argument {
    return (sport: sport,);
  }

  @override
  AutoDisposeFutureProviderElement<List<LevelQuestion>> createElement() {
    return _LevelQuestionsProviderElement(this);
  }

  LevelQuestionsProvider _copyWith(
    FutureOr<List<LevelQuestion>> Function(LevelQuestionsRef ref) create,
  ) {
    return LevelQuestionsProvider._internal(
      (ref) => create(ref as LevelQuestionsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      sport: sport,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LevelQuestionsProvider && other.sport == sport;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sport.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LevelQuestionsRef on AutoDisposeFutureProviderRef<List<LevelQuestion>> {
  /// The parameter `sport` of this provider.
  String? get sport;
}

class _LevelQuestionsProviderElement
    extends AutoDisposeFutureProviderElement<List<LevelQuestion>>
    with LevelQuestionsRef {
  _LevelQuestionsProviderElement(super.provider);

  @override
  String? get sport => (origin as LevelQuestionsProvider).sport;
}

String _$calculateLevelHash() => r'fa0b93f3069d655ede138ca013f7b52ff2bac28d';

/// See also [calculateLevel].
@ProviderFor(calculateLevel)
const calculateLevelProvider = CalculateLevelFamily();

/// See also [calculateLevel].
class CalculateLevelFamily extends Family {
  /// See also [calculateLevel].
  const CalculateLevelFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calculateLevelProvider';

  /// See also [calculateLevel].
  CalculateLevelProvider call({
    required List<double?> answers,
    required bool allowClub,
    required String sportsName,
  }) {
    return CalculateLevelProvider(
      answers: answers,
      allowClub: allowClub,
      sportsName: sportsName,
    );
  }

  @visibleForOverriding
  @override
  CalculateLevelProvider getProviderOverride(
    covariant CalculateLevelProvider provider,
  ) {
    return call(
      answers: provider.answers,
      allowClub: provider.allowClub,
      sportsName: provider.sportsName,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<CalculatedLevelData> Function(CalculateLevelRef ref) create) {
    return _$CalculateLevelFamilyOverride(this, create);
  }
}

class _$CalculateLevelFamilyOverride implements FamilyOverride {
  _$CalculateLevelFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<CalculatedLevelData> Function(CalculateLevelRef ref) create;

  @override
  final CalculateLevelFamily overriddenFamily;

  @override
  CalculateLevelProvider getProviderOverride(
    covariant CalculateLevelProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [calculateLevel].
class CalculateLevelProvider
    extends AutoDisposeFutureProvider<CalculatedLevelData> {
  /// See also [calculateLevel].
  CalculateLevelProvider({
    required List<double?> answers,
    required bool allowClub,
    required String sportsName,
  }) : this._internal(
          (ref) => calculateLevel(
            ref as CalculateLevelRef,
            answers: answers,
            allowClub: allowClub,
            sportsName: sportsName,
          ),
          from: calculateLevelProvider,
          name: r'calculateLevelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calculateLevelHash,
          dependencies: CalculateLevelFamily._dependencies,
          allTransitiveDependencies:
              CalculateLevelFamily._allTransitiveDependencies,
          answers: answers,
          allowClub: allowClub,
          sportsName: sportsName,
        );

  CalculateLevelProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.answers,
    required this.allowClub,
    required this.sportsName,
  }) : super.internal();

  final List<double?> answers;
  final bool allowClub;
  final String sportsName;

  @override
  Override overrideWith(
    FutureOr<CalculatedLevelData> Function(CalculateLevelRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalculateLevelProvider._internal(
        (ref) => create(ref as CalculateLevelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        answers: answers,
        allowClub: allowClub,
        sportsName: sportsName,
      ),
    );
  }

  @override
  ({
    List<double?> answers,
    bool allowClub,
    String sportsName,
  }) get argument {
    return (
      answers: answers,
      allowClub: allowClub,
      sportsName: sportsName,
    );
  }

  @override
  AutoDisposeFutureProviderElement<CalculatedLevelData> createElement() {
    return _CalculateLevelProviderElement(this);
  }

  CalculateLevelProvider _copyWith(
    FutureOr<CalculatedLevelData> Function(CalculateLevelRef ref) create,
  ) {
    return CalculateLevelProvider._internal(
      (ref) => create(ref as CalculateLevelRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      answers: answers,
      allowClub: allowClub,
      sportsName: sportsName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateLevelProvider &&
        other.answers == answers &&
        other.allowClub == allowClub &&
        other.sportsName == sportsName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, answers.hashCode);
    hash = _SystemHash.combine(hash, allowClub.hashCode);
    hash = _SystemHash.combine(hash, sportsName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CalculateLevelRef on AutoDisposeFutureProviderRef<CalculatedLevelData> {
  /// The parameter `answers` of this provider.
  List<double?> get answers;

  /// The parameter `allowClub` of this provider.
  bool get allowClub;

  /// The parameter `sportsName` of this provider.
  String get sportsName;
}

class _CalculateLevelProviderElement
    extends AutoDisposeFutureProviderElement<CalculatedLevelData>
    with CalculateLevelRef {
  _CalculateLevelProviderElement(super.provider);

  @override
  List<double?> get answers => (origin as CalculateLevelProvider).answers;
  @override
  bool get allowClub => (origin as CalculateLevelProvider).allowClub;
  @override
  String get sportsName => (origin as CalculateLevelProvider).sportsName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
