// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stripeRepoHash() => r'd289a7d625478c894b9b9af96fdc8010853a96a0';

/// See also [stripeRepo].
@ProviderFor(stripeRepo)
final stripeRepoProvider = AutoDisposeProvider<StripeRepo>.internal(
  stripeRepo,
  name: r'stripeRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$stripeRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StripeRepoRef = AutoDisposeProviderRef<StripeRepo>;
String _$createAndAttachPaymentMethodHash() =>
    r'bda3c00f2461056b16301dd331ed12867a440eab';

/// See also [createAndAttachPaymentMethod].
@ProviderFor(createAndAttachPaymentMethod)
final createAndAttachPaymentMethodProvider =
    AutoDisposeFutureProvider<bool>.internal(
  createAndAttachPaymentMethod,
  name: r'createAndAttachPaymentMethodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createAndAttachPaymentMethodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateAndAttachPaymentMethodRef = AutoDisposeFutureProviderRef<bool>;
String _$fetchStripPaymentMethodsHash() =>
    r'7cad008daa9dea5e3b367519131a52a60b69169d';

/// See also [fetchStripPaymentMethods].
@ProviderFor(fetchStripPaymentMethods)
final fetchStripPaymentMethodsProvider =
    AutoDisposeFutureProvider<List<StripePaymentMethod>>.internal(
  fetchStripPaymentMethods,
  name: r'fetchStripPaymentMethodsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchStripPaymentMethodsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchStripPaymentMethodsRef
    = AutoDisposeFutureProviderRef<List<StripePaymentMethod>>;
String _$deletePaymentMethodHash() =>
    r'24ca4bfc597bf86c54e590b33b0359edcc2cbd0f';

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

/// See also [deletePaymentMethod].
@ProviderFor(deletePaymentMethod)
const deletePaymentMethodProvider = DeletePaymentMethodFamily();

/// See also [deletePaymentMethod].
class DeletePaymentMethodFamily extends Family {
  /// See also [deletePaymentMethod].
  const DeletePaymentMethodFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deletePaymentMethodProvider';

  /// See also [deletePaymentMethod].
  DeletePaymentMethodProvider call(
    String paymentMethodId,
  ) {
    return DeletePaymentMethodProvider(
      paymentMethodId,
    );
  }

  @visibleForOverriding
  @override
  DeletePaymentMethodProvider getProviderOverride(
    covariant DeletePaymentMethodProvider provider,
  ) {
    return call(
      provider.paymentMethodId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<bool> Function(DeletePaymentMethodRef ref) create) {
    return _$DeletePaymentMethodFamilyOverride(this, create);
  }
}

class _$DeletePaymentMethodFamilyOverride implements FamilyOverride {
  _$DeletePaymentMethodFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(DeletePaymentMethodRef ref) create;

  @override
  final DeletePaymentMethodFamily overriddenFamily;

  @override
  DeletePaymentMethodProvider getProviderOverride(
    covariant DeletePaymentMethodProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [deletePaymentMethod].
class DeletePaymentMethodProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deletePaymentMethod].
  DeletePaymentMethodProvider(
    String paymentMethodId,
  ) : this._internal(
          (ref) => deletePaymentMethod(
            ref as DeletePaymentMethodRef,
            paymentMethodId,
          ),
          from: deletePaymentMethodProvider,
          name: r'deletePaymentMethodProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deletePaymentMethodHash,
          dependencies: DeletePaymentMethodFamily._dependencies,
          allTransitiveDependencies:
              DeletePaymentMethodFamily._allTransitiveDependencies,
          paymentMethodId: paymentMethodId,
        );

  DeletePaymentMethodProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentMethodId,
  }) : super.internal();

  final String paymentMethodId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeletePaymentMethodRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeletePaymentMethodProvider._internal(
        (ref) => create(ref as DeletePaymentMethodRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentMethodId: paymentMethodId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (paymentMethodId,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeletePaymentMethodProviderElement(this);
  }

  DeletePaymentMethodProvider _copyWith(
    FutureOr<bool> Function(DeletePaymentMethodRef ref) create,
  ) {
    return DeletePaymentMethodProvider._internal(
      (ref) => create(ref as DeletePaymentMethodRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      paymentMethodId: paymentMethodId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeletePaymentMethodProvider &&
        other.paymentMethodId == paymentMethodId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentMethodId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeletePaymentMethodRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `paymentMethodId` of this provider.
  String get paymentMethodId;
}

class _DeletePaymentMethodProviderElement
    extends AutoDisposeFutureProviderElement<bool> with DeletePaymentMethodRef {
  _DeletePaymentMethodProviderElement(super.provider);

  @override
  String get paymentMethodId =>
      (origin as DeletePaymentMethodProvider).paymentMethodId;
}

String _$stripeRequireActionHash() =>
    r'1d98dcdbdb8b06ffa4f979ff13f08c91f531ea9f';

/// See also [stripeRequireAction].
@ProviderFor(stripeRequireAction)
const stripeRequireActionProvider = StripeRequireActionFamily();

/// See also [stripeRequireAction].
class StripeRequireActionFamily extends Family {
  /// See also [stripeRequireAction].
  const StripeRequireActionFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stripeRequireActionProvider';

  /// See also [stripeRequireAction].
  StripeRequireActionProvider call(
    String paymentSecret,
    String paymentMethodId,
  ) {
    return StripeRequireActionProvider(
      paymentSecret,
      paymentMethodId,
    );
  }

  @visibleForOverriding
  @override
  StripeRequireActionProvider getProviderOverride(
    covariant StripeRequireActionProvider provider,
  ) {
    return call(
      provider.paymentSecret,
      provider.paymentMethodId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<PaymentIntent?> Function(StripeRequireActionRef ref) create) {
    return _$StripeRequireActionFamilyOverride(this, create);
  }
}

class _$StripeRequireActionFamilyOverride implements FamilyOverride {
  _$StripeRequireActionFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<PaymentIntent?> Function(StripeRequireActionRef ref) create;

  @override
  final StripeRequireActionFamily overriddenFamily;

  @override
  StripeRequireActionProvider getProviderOverride(
    covariant StripeRequireActionProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [stripeRequireAction].
class StripeRequireActionProvider
    extends AutoDisposeFutureProvider<PaymentIntent?> {
  /// See also [stripeRequireAction].
  StripeRequireActionProvider(
    String paymentSecret,
    String paymentMethodId,
  ) : this._internal(
          (ref) => stripeRequireAction(
            ref as StripeRequireActionRef,
            paymentSecret,
            paymentMethodId,
          ),
          from: stripeRequireActionProvider,
          name: r'stripeRequireActionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stripeRequireActionHash,
          dependencies: StripeRequireActionFamily._dependencies,
          allTransitiveDependencies:
              StripeRequireActionFamily._allTransitiveDependencies,
          paymentSecret: paymentSecret,
          paymentMethodId: paymentMethodId,
        );

  StripeRequireActionProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentSecret,
    required this.paymentMethodId,
  }) : super.internal();

  final String paymentSecret;
  final String paymentMethodId;

  @override
  Override overrideWith(
    FutureOr<PaymentIntent?> Function(StripeRequireActionRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StripeRequireActionProvider._internal(
        (ref) => create(ref as StripeRequireActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentSecret: paymentSecret,
        paymentMethodId: paymentMethodId,
      ),
    );
  }

  @override
  (
    String,
    String,
  ) get argument {
    return (
      paymentSecret,
      paymentMethodId,
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaymentIntent?> createElement() {
    return _StripeRequireActionProviderElement(this);
  }

  StripeRequireActionProvider _copyWith(
    FutureOr<PaymentIntent?> Function(StripeRequireActionRef ref) create,
  ) {
    return StripeRequireActionProvider._internal(
      (ref) => create(ref as StripeRequireActionRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      paymentSecret: paymentSecret,
      paymentMethodId: paymentMethodId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StripeRequireActionProvider &&
        other.paymentSecret == paymentSecret &&
        other.paymentMethodId == paymentMethodId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentSecret.hashCode);
    hash = _SystemHash.combine(hash, paymentMethodId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StripeRequireActionRef on AutoDisposeFutureProviderRef<PaymentIntent?> {
  /// The parameter `paymentSecret` of this provider.
  String get paymentSecret;

  /// The parameter `paymentMethodId` of this provider.
  String get paymentMethodId;
}

class _StripeRequireActionProviderElement
    extends AutoDisposeFutureProviderElement<PaymentIntent?>
    with StripeRequireActionRef {
  _StripeRequireActionProviderElement(super.provider);

  @override
  String get paymentSecret =>
      (origin as StripeRequireActionProvider).paymentSecret;
  @override
  String get paymentMethodId =>
      (origin as StripeRequireActionProvider).paymentMethodId;
}

String _$isNativeAvailableHash() => r'7213d6ece2f9391819e3657cc68d9e61f32fefa2';

/// See also [isNativeAvailable].
@ProviderFor(isNativeAvailable)
final isNativeAvailableProvider = AutoDisposeFutureProvider<bool>.internal(
  isNativeAvailable,
  name: r'isNativeAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isNativeAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsNativeAvailableRef = AutoDisposeFutureProviderRef<bool>;
String _$startNativePayHash() => r'e6cc262aaa00a283c08169f392bf4ce90e9cb885';

/// See also [startNativePay].
@ProviderFor(startNativePay)
const startNativePayProvider = StartNativePayFamily();

/// See also [startNativePay].
class StartNativePayFamily extends Family {
  /// See also [startNativePay].
  const StartNativePayFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'startNativePayProvider';

  /// See also [startNativePay].
  StartNativePayProvider call({
    required String clientSec,
    required String amount,
  }) {
    return StartNativePayProvider(
      clientSec: clientSec,
      amount: amount,
    );
  }

  @visibleForOverriding
  @override
  StartNativePayProvider getProviderOverride(
    covariant StartNativePayProvider provider,
  ) {
    return call(
      clientSec: provider.clientSec,
      amount: provider.amount,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<PaymentIntent?> Function(StartNativePayRef ref) create) {
    return _$StartNativePayFamilyOverride(this, create);
  }
}

class _$StartNativePayFamilyOverride implements FamilyOverride {
  _$StartNativePayFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<PaymentIntent?> Function(StartNativePayRef ref) create;

  @override
  final StartNativePayFamily overriddenFamily;

  @override
  StartNativePayProvider getProviderOverride(
    covariant StartNativePayProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [startNativePay].
class StartNativePayProvider extends AutoDisposeFutureProvider<PaymentIntent?> {
  /// See also [startNativePay].
  StartNativePayProvider({
    required String clientSec,
    required String amount,
  }) : this._internal(
          (ref) => startNativePay(
            ref as StartNativePayRef,
            clientSec: clientSec,
            amount: amount,
          ),
          from: startNativePayProvider,
          name: r'startNativePayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$startNativePayHash,
          dependencies: StartNativePayFamily._dependencies,
          allTransitiveDependencies:
              StartNativePayFamily._allTransitiveDependencies,
          clientSec: clientSec,
          amount: amount,
        );

  StartNativePayProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clientSec,
    required this.amount,
  }) : super.internal();

  final String clientSec;
  final String amount;

  @override
  Override overrideWith(
    FutureOr<PaymentIntent?> Function(StartNativePayRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StartNativePayProvider._internal(
        (ref) => create(ref as StartNativePayRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clientSec: clientSec,
        amount: amount,
      ),
    );
  }

  @override
  ({
    String clientSec,
    String amount,
  }) get argument {
    return (
      clientSec: clientSec,
      amount: amount,
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaymentIntent?> createElement() {
    return _StartNativePayProviderElement(this);
  }

  StartNativePayProvider _copyWith(
    FutureOr<PaymentIntent?> Function(StartNativePayRef ref) create,
  ) {
    return StartNativePayProvider._internal(
      (ref) => create(ref as StartNativePayRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      clientSec: clientSec,
      amount: amount,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StartNativePayProvider &&
        other.clientSec == clientSec &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clientSec.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StartNativePayRef on AutoDisposeFutureProviderRef<PaymentIntent?> {
  /// The parameter `clientSec` of this provider.
  String get clientSec;

  /// The parameter `amount` of this provider.
  String get amount;
}

class _StartNativePayProviderElement
    extends AutoDisposeFutureProviderElement<PaymentIntent?>
    with StartNativePayRef {
  _StartNativePayProviderElement(super.provider);

  @override
  String get clientSec => (origin as StartNativePayProvider).clientSec;
  @override
  String get amount => (origin as StartNativePayProvider).amount;
}

String _$stripePaymentMethodHash() =>
    r'7170798be6cd977858ae45effe4deed5b59f1bf9';

/// See also [stripePaymentMethod].
@ProviderFor(stripePaymentMethod)
const stripePaymentMethodProvider = StripePaymentMethodFamily();

/// See also [stripePaymentMethod].
class StripePaymentMethodFamily extends Family {
  /// See also [stripePaymentMethod].
  const StripePaymentMethodFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stripePaymentMethodProvider';

  /// See also [stripePaymentMethod].
  StripePaymentMethodProvider call(
    String paymentSecret,
  ) {
    return StripePaymentMethodProvider(
      paymentSecret,
    );
  }

  @visibleForOverriding
  @override
  StripePaymentMethodProvider getProviderOverride(
    covariant StripePaymentMethodProvider provider,
  ) {
    return call(
      provider.paymentSecret,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<PaymentSheetPaymentOption?> Function(StripePaymentMethodRef ref)
          create) {
    return _$StripePaymentMethodFamilyOverride(this, create);
  }
}

class _$StripePaymentMethodFamilyOverride implements FamilyOverride {
  _$StripePaymentMethodFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<PaymentSheetPaymentOption?> Function(
      StripePaymentMethodRef ref) create;

  @override
  final StripePaymentMethodFamily overriddenFamily;

  @override
  StripePaymentMethodProvider getProviderOverride(
    covariant StripePaymentMethodProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [stripePaymentMethod].
class StripePaymentMethodProvider
    extends AutoDisposeFutureProvider<PaymentSheetPaymentOption?> {
  /// See also [stripePaymentMethod].
  StripePaymentMethodProvider(
    String paymentSecret,
  ) : this._internal(
          (ref) => stripePaymentMethod(
            ref as StripePaymentMethodRef,
            paymentSecret,
          ),
          from: stripePaymentMethodProvider,
          name: r'stripePaymentMethodProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stripePaymentMethodHash,
          dependencies: StripePaymentMethodFamily._dependencies,
          allTransitiveDependencies:
              StripePaymentMethodFamily._allTransitiveDependencies,
          paymentSecret: paymentSecret,
        );

  StripePaymentMethodProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentSecret,
  }) : super.internal();

  final String paymentSecret;

  @override
  Override overrideWith(
    FutureOr<PaymentSheetPaymentOption?> Function(StripePaymentMethodRef ref)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StripePaymentMethodProvider._internal(
        (ref) => create(ref as StripePaymentMethodRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentSecret: paymentSecret,
      ),
    );
  }

  @override
  (String,) get argument {
    return (paymentSecret,);
  }

  @override
  AutoDisposeFutureProviderElement<PaymentSheetPaymentOption?> createElement() {
    return _StripePaymentMethodProviderElement(this);
  }

  StripePaymentMethodProvider _copyWith(
    FutureOr<PaymentSheetPaymentOption?> Function(StripePaymentMethodRef ref)
        create,
  ) {
    return StripePaymentMethodProvider._internal(
      (ref) => create(ref as StripePaymentMethodRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      paymentSecret: paymentSecret,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StripePaymentMethodProvider &&
        other.paymentSecret == paymentSecret;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentSecret.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StripePaymentMethodRef
    on AutoDisposeFutureProviderRef<PaymentSheetPaymentOption?> {
  /// The parameter `paymentSecret` of this provider.
  String get paymentSecret;
}

class _StripePaymentMethodProviderElement
    extends AutoDisposeFutureProviderElement<PaymentSheetPaymentOption?>
    with StripePaymentMethodRef {
  _StripePaymentMethodProviderElement(super.provider);

  @override
  String get paymentSecret =>
      (origin as StripePaymentMethodProvider).paymentSecret;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
