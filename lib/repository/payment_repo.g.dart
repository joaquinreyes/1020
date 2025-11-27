// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentRepoHash() => r'9fe3844e721b8ce837441831a2b40fe3cd3aa669';

/// See also [paymentRepo].
@ProviderFor(paymentRepo)
final paymentRepoProvider = AutoDisposeProvider<PaymentRepo>.internal(
  paymentRepo,
  name: r'paymentRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$paymentRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaymentRepoRef = AutoDisposeProviderRef<PaymentRepo>;
String _$fetchPaymentDetailsHash() =>
    r'75a398ab4ebbf615875d9697e2c8c107fcc44622';

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

/// See also [fetchPaymentDetails].
@ProviderFor(fetchPaymentDetails)
const fetchPaymentDetailsProvider = FetchPaymentDetailsFamily();

/// See also [fetchPaymentDetails].
class FetchPaymentDetailsFamily extends Family {
  /// See also [fetchPaymentDetails].
  const FetchPaymentDetailsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchPaymentDetailsProvider';

  /// See also [fetchPaymentDetails].
  FetchPaymentDetailsProvider call(
    int locationID,
    PaymentDetailsRequestType type,
    int id,
    bool isOpenMatch,
    DateTime? startDate,
    int? duration, {
    int? courtId,
    int? variantId,
  }) {
    return FetchPaymentDetailsProvider(
      locationID,
      type,
      id,
      isOpenMatch,
      startDate,
      duration,
      courtId: courtId,
      variantId: variantId,
    );
  }

  @visibleForOverriding
  @override
  FetchPaymentDetailsProvider getProviderOverride(
    covariant FetchPaymentDetailsProvider provider,
  ) {
    return call(
      provider.locationID,
      provider.type,
      provider.id,
      provider.isOpenMatch,
      provider.startDate,
      provider.duration,
      courtId: provider.courtId,
      variantId: provider.variantId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<PaymentDetails> Function(FetchPaymentDetailsRef ref) create) {
    return _$FetchPaymentDetailsFamilyOverride(this, create);
  }
}

class _$FetchPaymentDetailsFamilyOverride implements FamilyOverride {
  _$FetchPaymentDetailsFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<PaymentDetails> Function(FetchPaymentDetailsRef ref) create;

  @override
  final FetchPaymentDetailsFamily overriddenFamily;

  @override
  FetchPaymentDetailsProvider getProviderOverride(
    covariant FetchPaymentDetailsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchPaymentDetails].
class FetchPaymentDetailsProvider
    extends AutoDisposeFutureProvider<PaymentDetails> {
  /// See also [fetchPaymentDetails].
  FetchPaymentDetailsProvider(
    int locationID,
    PaymentDetailsRequestType type,
    int id,
    bool isOpenMatch,
    DateTime? startDate,
    int? duration, {
    int? courtId,
    int? variantId,
  }) : this._internal(
          (ref) => fetchPaymentDetails(
            ref as FetchPaymentDetailsRef,
            locationID,
            type,
            id,
            isOpenMatch,
            startDate,
            duration,
            courtId: courtId,
            variantId: variantId,
          ),
          from: fetchPaymentDetailsProvider,
          name: r'fetchPaymentDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPaymentDetailsHash,
          dependencies: FetchPaymentDetailsFamily._dependencies,
          allTransitiveDependencies:
              FetchPaymentDetailsFamily._allTransitiveDependencies,
          locationID: locationID,
          type: type,
          id: id,
          isOpenMatch: isOpenMatch,
          startDate: startDate,
          duration: duration,
          courtId: courtId,
          variantId: variantId,
        );

  FetchPaymentDetailsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationID,
    required this.type,
    required this.id,
    required this.isOpenMatch,
    required this.startDate,
    required this.duration,
    required this.courtId,
    required this.variantId,
  }) : super.internal();

  final int locationID;
  final PaymentDetailsRequestType type;
  final int id;
  final bool isOpenMatch;
  final DateTime? startDate;
  final int? duration;
  final int? courtId;
  final int? variantId;

  @override
  Override overrideWith(
    FutureOr<PaymentDetails> Function(FetchPaymentDetailsRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPaymentDetailsProvider._internal(
        (ref) => create(ref as FetchPaymentDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationID: locationID,
        type: type,
        id: id,
        isOpenMatch: isOpenMatch,
        startDate: startDate,
        duration: duration,
        courtId: courtId,
        variantId: variantId,
      ),
    );
  }

  @override
  (
    int,
    PaymentDetailsRequestType,
    int,
    bool,
    DateTime?,
    int?, {
    int? courtId,
    int? variantId,
  }) get argument {
    return (
      locationID,
      type,
      id,
      isOpenMatch,
      startDate,
      duration,
      courtId: courtId,
      variantId: variantId,
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaymentDetails> createElement() {
    return _FetchPaymentDetailsProviderElement(this);
  }

  FetchPaymentDetailsProvider _copyWith(
    FutureOr<PaymentDetails> Function(FetchPaymentDetailsRef ref) create,
  ) {
    return FetchPaymentDetailsProvider._internal(
      (ref) => create(ref as FetchPaymentDetailsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      locationID: locationID,
      type: type,
      id: id,
      isOpenMatch: isOpenMatch,
      startDate: startDate,
      duration: duration,
      courtId: courtId,
      variantId: variantId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPaymentDetailsProvider &&
        other.locationID == locationID &&
        other.type == type &&
        other.id == id &&
        other.isOpenMatch == isOpenMatch &&
        other.startDate == startDate &&
        other.duration == duration &&
        other.courtId == courtId &&
        other.variantId == variantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationID.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, duration.hashCode);
    hash = _SystemHash.combine(hash, courtId.hashCode);
    hash = _SystemHash.combine(hash, variantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPaymentDetailsRef on AutoDisposeFutureProviderRef<PaymentDetails> {
  /// The parameter `locationID` of this provider.
  int get locationID;

  /// The parameter `type` of this provider.
  PaymentDetailsRequestType get type;

  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `isOpenMatch` of this provider.
  bool get isOpenMatch;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `duration` of this provider.
  int? get duration;

  /// The parameter `courtId` of this provider.
  int? get courtId;

  /// The parameter `variantId` of this provider.
  int? get variantId;
}

class _FetchPaymentDetailsProviderElement
    extends AutoDisposeFutureProviderElement<PaymentDetails>
    with FetchPaymentDetailsRef {
  _FetchPaymentDetailsProviderElement(super.provider);

  @override
  int get locationID => (origin as FetchPaymentDetailsProvider).locationID;
  @override
  PaymentDetailsRequestType get type =>
      (origin as FetchPaymentDetailsProvider).type;
  @override
  int get id => (origin as FetchPaymentDetailsProvider).id;
  @override
  bool get isOpenMatch => (origin as FetchPaymentDetailsProvider).isOpenMatch;
  @override
  DateTime? get startDate => (origin as FetchPaymentDetailsProvider).startDate;
  @override
  int? get duration => (origin as FetchPaymentDetailsProvider).duration;
  @override
  int? get courtId => (origin as FetchPaymentDetailsProvider).courtId;
  @override
  int? get variantId => (origin as FetchPaymentDetailsProvider).variantId;
}

String _$fetchAllPaymentMethodsHash() =>
    r'3598941dd7f3a5a235e570f02a16b0bf44a5b8ce';

/// See also [fetchAllPaymentMethods].
@ProviderFor(fetchAllPaymentMethods)
const fetchAllPaymentMethodsProvider = FetchAllPaymentMethodsFamily();

/// See also [fetchAllPaymentMethods].
class FetchAllPaymentMethodsFamily extends Family {
  /// See also [fetchAllPaymentMethods].
  const FetchAllPaymentMethodsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchAllPaymentMethodsProvider';

  /// See also [fetchAllPaymentMethods].
  FetchAllPaymentMethodsProvider call(
    int locationID,
    int serviceID,
    PaymentDetailsRequestType type,
    DateTime? startDate,
    int? duration, {
    int? courtId,
    int? variantId,
    required bool isOpenMatch,
  }) {
    return FetchAllPaymentMethodsProvider(
      locationID,
      serviceID,
      type,
      startDate,
      duration,
      courtId: courtId,
      variantId: variantId,
      isOpenMatch: isOpenMatch,
    );
  }

  @visibleForOverriding
  @override
  FetchAllPaymentMethodsProvider getProviderOverride(
    covariant FetchAllPaymentMethodsProvider provider,
  ) {
    return call(
      provider.locationID,
      provider.serviceID,
      provider.type,
      provider.startDate,
      provider.duration,
      courtId: provider.courtId,
      variantId: provider.variantId,
      isOpenMatch: provider.isOpenMatch,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<PaymentDetails> Function(FetchAllPaymentMethodsRef ref) create) {
    return _$FetchAllPaymentMethodsFamilyOverride(this, create);
  }
}

class _$FetchAllPaymentMethodsFamilyOverride implements FamilyOverride {
  _$FetchAllPaymentMethodsFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<PaymentDetails> Function(FetchAllPaymentMethodsRef ref) create;

  @override
  final FetchAllPaymentMethodsFamily overriddenFamily;

  @override
  FetchAllPaymentMethodsProvider getProviderOverride(
    covariant FetchAllPaymentMethodsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchAllPaymentMethods].
class FetchAllPaymentMethodsProvider
    extends AutoDisposeFutureProvider<PaymentDetails> {
  /// See also [fetchAllPaymentMethods].
  FetchAllPaymentMethodsProvider(
    int locationID,
    int serviceID,
    PaymentDetailsRequestType type,
    DateTime? startDate,
    int? duration, {
    int? courtId,
    int? variantId,
    required bool isOpenMatch,
  }) : this._internal(
          (ref) => fetchAllPaymentMethods(
            ref as FetchAllPaymentMethodsRef,
            locationID,
            serviceID,
            type,
            startDate,
            duration,
            courtId: courtId,
            variantId: variantId,
            isOpenMatch: isOpenMatch,
          ),
          from: fetchAllPaymentMethodsProvider,
          name: r'fetchAllPaymentMethodsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAllPaymentMethodsHash,
          dependencies: FetchAllPaymentMethodsFamily._dependencies,
          allTransitiveDependencies:
              FetchAllPaymentMethodsFamily._allTransitiveDependencies,
          locationID: locationID,
          serviceID: serviceID,
          type: type,
          startDate: startDate,
          duration: duration,
          courtId: courtId,
          variantId: variantId,
          isOpenMatch: isOpenMatch,
        );

  FetchAllPaymentMethodsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationID,
    required this.serviceID,
    required this.type,
    required this.startDate,
    required this.duration,
    required this.courtId,
    required this.variantId,
    required this.isOpenMatch,
  }) : super.internal();

  final int locationID;
  final int serviceID;
  final PaymentDetailsRequestType type;
  final DateTime? startDate;
  final int? duration;
  final int? courtId;
  final int? variantId;
  final bool isOpenMatch;

  @override
  Override overrideWith(
    FutureOr<PaymentDetails> Function(FetchAllPaymentMethodsRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAllPaymentMethodsProvider._internal(
        (ref) => create(ref as FetchAllPaymentMethodsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationID: locationID,
        serviceID: serviceID,
        type: type,
        startDate: startDate,
        duration: duration,
        courtId: courtId,
        variantId: variantId,
        isOpenMatch: isOpenMatch,
      ),
    );
  }

  @override
  (
    int,
    int,
    PaymentDetailsRequestType,
    DateTime?,
    int?, {
    int? courtId,
    int? variantId,
    bool isOpenMatch,
  }) get argument {
    return (
      locationID,
      serviceID,
      type,
      startDate,
      duration,
      courtId: courtId,
      variantId: variantId,
      isOpenMatch: isOpenMatch,
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaymentDetails> createElement() {
    return _FetchAllPaymentMethodsProviderElement(this);
  }

  FetchAllPaymentMethodsProvider _copyWith(
    FutureOr<PaymentDetails> Function(FetchAllPaymentMethodsRef ref) create,
  ) {
    return FetchAllPaymentMethodsProvider._internal(
      (ref) => create(ref as FetchAllPaymentMethodsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      locationID: locationID,
      serviceID: serviceID,
      type: type,
      startDate: startDate,
      duration: duration,
      courtId: courtId,
      variantId: variantId,
      isOpenMatch: isOpenMatch,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAllPaymentMethodsProvider &&
        other.locationID == locationID &&
        other.serviceID == serviceID &&
        other.type == type &&
        other.startDate == startDate &&
        other.duration == duration &&
        other.courtId == courtId &&
        other.variantId == variantId &&
        other.isOpenMatch == isOpenMatch;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationID.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, duration.hashCode);
    hash = _SystemHash.combine(hash, courtId.hashCode);
    hash = _SystemHash.combine(hash, variantId.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchAllPaymentMethodsRef
    on AutoDisposeFutureProviderRef<PaymentDetails> {
  /// The parameter `locationID` of this provider.
  int get locationID;

  /// The parameter `serviceID` of this provider.
  int get serviceID;

  /// The parameter `type` of this provider.
  PaymentDetailsRequestType get type;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `duration` of this provider.
  int? get duration;

  /// The parameter `courtId` of this provider.
  int? get courtId;

  /// The parameter `variantId` of this provider.
  int? get variantId;

  /// The parameter `isOpenMatch` of this provider.
  bool get isOpenMatch;
}

class _FetchAllPaymentMethodsProviderElement
    extends AutoDisposeFutureProviderElement<PaymentDetails>
    with FetchAllPaymentMethodsRef {
  _FetchAllPaymentMethodsProviderElement(super.provider);

  @override
  int get locationID => (origin as FetchAllPaymentMethodsProvider).locationID;
  @override
  int get serviceID => (origin as FetchAllPaymentMethodsProvider).serviceID;
  @override
  PaymentDetailsRequestType get type =>
      (origin as FetchAllPaymentMethodsProvider).type;
  @override
  DateTime? get startDate =>
      (origin as FetchAllPaymentMethodsProvider).startDate;
  @override
  int? get duration => (origin as FetchAllPaymentMethodsProvider).duration;
  @override
  int? get courtId => (origin as FetchAllPaymentMethodsProvider).courtId;
  @override
  int? get variantId => (origin as FetchAllPaymentMethodsProvider).variantId;
  @override
  bool get isOpenMatch =>
      (origin as FetchAllPaymentMethodsProvider).isOpenMatch;
}

String _$paymentProcessHash() => r'ec470890d66bb669205957fdefb3a132d3945b28';

/// See also [paymentProcess].
@ProviderFor(paymentProcess)
const paymentProcessProvider = PaymentProcessFamily();

/// See also [paymentProcess].
class PaymentProcessFamily extends Family {
  /// See also [paymentProcess].
  const PaymentProcessFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentProcessProvider';

  /// See also [paymentProcess].
  PaymentProcessProvider call({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    List<AppPaymentMethods>? paymentMethod,
    required bool pendingPayment,
    int? serviceID,
    int? locationID,
    bool isJoiningApproval = false,
    bool bookingToOpenMatch = false,
    bool purchaseMembership = false,
    int? couponID,
  }) {
    return PaymentProcessProvider(
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      pendingPayment: pendingPayment,
      serviceID: serviceID,
      locationID: locationID,
      isJoiningApproval: isJoiningApproval,
      bookingToOpenMatch: bookingToOpenMatch,
      purchaseMembership: purchaseMembership,
      couponID: couponID,
    );
  }

  @visibleForOverriding
  @override
  PaymentProcessProvider getProviderOverride(
    covariant PaymentProcessProvider provider,
  ) {
    return call(
      requestType: provider.requestType,
      payLater: provider.payLater,
      totalAmount: provider.totalAmount,
      paymentMethod: provider.paymentMethod,
      pendingPayment: provider.pendingPayment,
      serviceID: provider.serviceID,
      locationID: provider.locationID,
      isJoiningApproval: provider.isJoiningApproval,
      bookingToOpenMatch: provider.bookingToOpenMatch,
      purchaseMembership: provider.purchaseMembership,
      couponID: provider.couponID,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<(int, double?)> Function(PaymentProcessRef ref) create) {
    return _$PaymentProcessFamilyOverride(this, create);
  }
}

class _$PaymentProcessFamilyOverride implements FamilyOverride {
  _$PaymentProcessFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<(int, double?)> Function(PaymentProcessRef ref) create;

  @override
  final PaymentProcessFamily overriddenFamily;

  @override
  PaymentProcessProvider getProviderOverride(
    covariant PaymentProcessProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [paymentProcess].
class PaymentProcessProvider extends AutoDisposeFutureProvider<(int, double?)> {
  /// See also [paymentProcess].
  PaymentProcessProvider({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    List<AppPaymentMethods>? paymentMethod,
    required bool pendingPayment,
    int? serviceID,
    int? locationID,
    bool isJoiningApproval = false,
    bool bookingToOpenMatch = false,
    bool purchaseMembership = false,
    int? couponID,
  }) : this._internal(
          (ref) => paymentProcess(
            ref as PaymentProcessRef,
            requestType: requestType,
            payLater: payLater,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
            pendingPayment: pendingPayment,
            serviceID: serviceID,
            locationID: locationID,
            isJoiningApproval: isJoiningApproval,
            bookingToOpenMatch: bookingToOpenMatch,
            purchaseMembership: purchaseMembership,
            couponID: couponID,
          ),
          from: paymentProcessProvider,
          name: r'paymentProcessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentProcessHash,
          dependencies: PaymentProcessFamily._dependencies,
          allTransitiveDependencies:
              PaymentProcessFamily._allTransitiveDependencies,
          requestType: requestType,
          payLater: payLater,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
          pendingPayment: pendingPayment,
          serviceID: serviceID,
          locationID: locationID,
          isJoiningApproval: isJoiningApproval,
          bookingToOpenMatch: bookingToOpenMatch,
          purchaseMembership: purchaseMembership,
          couponID: couponID,
        );

  PaymentProcessProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestType,
    required this.payLater,
    required this.totalAmount,
    required this.paymentMethod,
    required this.pendingPayment,
    required this.serviceID,
    required this.locationID,
    required this.isJoiningApproval,
    required this.bookingToOpenMatch,
    required this.purchaseMembership,
    required this.couponID,
  }) : super.internal();

  final PaymentProcessRequestType requestType;
  final bool? payLater;
  final double? totalAmount;
  final List<AppPaymentMethods>? paymentMethod;
  final bool pendingPayment;
  final int? serviceID;
  final int? locationID;
  final bool isJoiningApproval;
  final bool bookingToOpenMatch;
  final bool purchaseMembership;
  final int? couponID;

  @override
  Override overrideWith(
    FutureOr<(int, double?)> Function(PaymentProcessRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentProcessProvider._internal(
        (ref) => create(ref as PaymentProcessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestType: requestType,
        payLater: payLater,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        pendingPayment: pendingPayment,
        serviceID: serviceID,
        locationID: locationID,
        isJoiningApproval: isJoiningApproval,
        bookingToOpenMatch: bookingToOpenMatch,
        purchaseMembership: purchaseMembership,
        couponID: couponID,
      ),
    );
  }

  @override
  ({
    PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    List<AppPaymentMethods>? paymentMethod,
    bool pendingPayment,
    int? serviceID,
    int? locationID,
    bool isJoiningApproval,
    bool bookingToOpenMatch,
    bool purchaseMembership,
    int? couponID,
  }) get argument {
    return (
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      pendingPayment: pendingPayment,
      serviceID: serviceID,
      locationID: locationID,
      isJoiningApproval: isJoiningApproval,
      bookingToOpenMatch: bookingToOpenMatch,
      purchaseMembership: purchaseMembership,
      couponID: couponID,
    );
  }

  @override
  AutoDisposeFutureProviderElement<(int, double?)> createElement() {
    return _PaymentProcessProviderElement(this);
  }

  PaymentProcessProvider _copyWith(
    FutureOr<(int, double?)> Function(PaymentProcessRef ref) create,
  ) {
    return PaymentProcessProvider._internal(
      (ref) => create(ref as PaymentProcessRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      pendingPayment: pendingPayment,
      serviceID: serviceID,
      locationID: locationID,
      isJoiningApproval: isJoiningApproval,
      bookingToOpenMatch: bookingToOpenMatch,
      purchaseMembership: purchaseMembership,
      couponID: couponID,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentProcessProvider &&
        other.requestType == requestType &&
        other.payLater == payLater &&
        other.totalAmount == totalAmount &&
        other.paymentMethod == paymentMethod &&
        other.pendingPayment == pendingPayment &&
        other.serviceID == serviceID &&
        other.locationID == locationID &&
        other.isJoiningApproval == isJoiningApproval &&
        other.bookingToOpenMatch == bookingToOpenMatch &&
        other.purchaseMembership == purchaseMembership &&
        other.couponID == couponID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, payLater.hashCode);
    hash = _SystemHash.combine(hash, totalAmount.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);
    hash = _SystemHash.combine(hash, pendingPayment.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, locationID.hashCode);
    hash = _SystemHash.combine(hash, isJoiningApproval.hashCode);
    hash = _SystemHash.combine(hash, bookingToOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, purchaseMembership.hashCode);
    hash = _SystemHash.combine(hash, couponID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentProcessRef on AutoDisposeFutureProviderRef<(int, double?)> {
  /// The parameter `requestType` of this provider.
  PaymentProcessRequestType get requestType;

  /// The parameter `payLater` of this provider.
  bool? get payLater;

  /// The parameter `totalAmount` of this provider.
  double? get totalAmount;

  /// The parameter `paymentMethod` of this provider.
  List<AppPaymentMethods>? get paymentMethod;

  /// The parameter `pendingPayment` of this provider.
  bool get pendingPayment;

  /// The parameter `serviceID` of this provider.
  int? get serviceID;

  /// The parameter `locationID` of this provider.
  int? get locationID;

  /// The parameter `isJoiningApproval` of this provider.
  bool get isJoiningApproval;

  /// The parameter `bookingToOpenMatch` of this provider.
  bool get bookingToOpenMatch;

  /// The parameter `purchaseMembership` of this provider.
  bool get purchaseMembership;

  /// The parameter `couponID` of this provider.
  int? get couponID;
}

class _PaymentProcessProviderElement
    extends AutoDisposeFutureProviderElement<(int, double?)>
    with PaymentProcessRef {
  _PaymentProcessProviderElement(super.provider);

  @override
  PaymentProcessRequestType get requestType =>
      (origin as PaymentProcessProvider).requestType;
  @override
  bool? get payLater => (origin as PaymentProcessProvider).payLater;
  @override
  double? get totalAmount => (origin as PaymentProcessProvider).totalAmount;
  @override
  List<AppPaymentMethods>? get paymentMethod =>
      (origin as PaymentProcessProvider).paymentMethod;
  @override
  bool get pendingPayment => (origin as PaymentProcessProvider).pendingPayment;
  @override
  int? get serviceID => (origin as PaymentProcessProvider).serviceID;
  @override
  int? get locationID => (origin as PaymentProcessProvider).locationID;
  @override
  bool get isJoiningApproval =>
      (origin as PaymentProcessProvider).isJoiningApproval;
  @override
  bool get bookingToOpenMatch =>
      (origin as PaymentProcessProvider).bookingToOpenMatch;
  @override
  bool get purchaseMembership =>
      (origin as PaymentProcessProvider).purchaseMembership;
  @override
  int? get couponID => (origin as PaymentProcessProvider).couponID;
}

String _$verifyCouponHash() => r'd7ca19f1d5ad8c1583b8e86842001de163c1fefa';

/// See also [verifyCoupon].
@ProviderFor(verifyCoupon)
const verifyCouponProvider = VerifyCouponFamily();

/// See also [verifyCoupon].
class VerifyCouponFamily extends Family {
  /// See also [verifyCoupon].
  const VerifyCouponFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'verifyCouponProvider';

  /// See also [verifyCoupon].
  VerifyCouponProvider call({
    required String coupon,
    required double price,
  }) {
    return VerifyCouponProvider(
      coupon: coupon,
      price: price,
    );
  }

  @visibleForOverriding
  @override
  VerifyCouponProvider getProviderOverride(
    covariant VerifyCouponProvider provider,
  ) {
    return call(
      coupon: provider.coupon,
      price: provider.price,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<CouponModel> Function(VerifyCouponRef ref) create) {
    return _$VerifyCouponFamilyOverride(this, create);
  }
}

class _$VerifyCouponFamilyOverride implements FamilyOverride {
  _$VerifyCouponFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<CouponModel> Function(VerifyCouponRef ref) create;

  @override
  final VerifyCouponFamily overriddenFamily;

  @override
  VerifyCouponProvider getProviderOverride(
    covariant VerifyCouponProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [verifyCoupon].
class VerifyCouponProvider extends AutoDisposeFutureProvider<CouponModel> {
  /// See also [verifyCoupon].
  VerifyCouponProvider({
    required String coupon,
    required double price,
  }) : this._internal(
          (ref) => verifyCoupon(
            ref as VerifyCouponRef,
            coupon: coupon,
            price: price,
          ),
          from: verifyCouponProvider,
          name: r'verifyCouponProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$verifyCouponHash,
          dependencies: VerifyCouponFamily._dependencies,
          allTransitiveDependencies:
              VerifyCouponFamily._allTransitiveDependencies,
          coupon: coupon,
          price: price,
        );

  VerifyCouponProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coupon,
    required this.price,
  }) : super.internal();

  final String coupon;
  final double price;

  @override
  Override overrideWith(
    FutureOr<CouponModel> Function(VerifyCouponRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VerifyCouponProvider._internal(
        (ref) => create(ref as VerifyCouponRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coupon: coupon,
        price: price,
      ),
    );
  }

  @override
  ({
    String coupon,
    double price,
  }) get argument {
    return (
      coupon: coupon,
      price: price,
    );
  }

  @override
  AutoDisposeFutureProviderElement<CouponModel> createElement() {
    return _VerifyCouponProviderElement(this);
  }

  VerifyCouponProvider _copyWith(
    FutureOr<CouponModel> Function(VerifyCouponRef ref) create,
  ) {
    return VerifyCouponProvider._internal(
      (ref) => create(ref as VerifyCouponRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      coupon: coupon,
      price: price,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VerifyCouponProvider &&
        other.coupon == coupon &&
        other.price == price;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coupon.hashCode);
    hash = _SystemHash.combine(hash, price.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VerifyCouponRef on AutoDisposeFutureProviderRef<CouponModel> {
  /// The parameter `coupon` of this provider.
  String get coupon;

  /// The parameter `price` of this provider.
  double get price;
}

class _VerifyCouponProviderElement
    extends AutoDisposeFutureProviderElement<CouponModel> with VerifyCouponRef {
  _VerifyCouponProviderElement(super.provider);

  @override
  String get coupon => (origin as VerifyCouponProvider).coupon;
  @override
  double get price => (origin as VerifyCouponProvider).price;
}

String _$multiBookingPaymentProcessHash() =>
    r'19e2b67975aec8dad1bcde9d062f98af4d7efd69';

/// See also [multiBookingPaymentProcess].
@ProviderFor(multiBookingPaymentProcess)
const multiBookingPaymentProcessProvider = MultiBookingPaymentProcessFamily();

/// See also [multiBookingPaymentProcess].
class MultiBookingPaymentProcessFamily extends Family {
  /// See also [multiBookingPaymentProcess].
  const MultiBookingPaymentProcessFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'multiBookingPaymentProcessProvider';

  /// See also [multiBookingPaymentProcess].
  MultiBookingPaymentProcessProvider call({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    AppPaymentMethods? paymentMethod,
    int? serviceID,
    bool isJoiningApproval = false,
    int? couponID,
  }) {
    return MultiBookingPaymentProcessProvider(
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      serviceID: serviceID,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID,
    );
  }

  @visibleForOverriding
  @override
  MultiBookingPaymentProcessProvider getProviderOverride(
    covariant MultiBookingPaymentProcessProvider provider,
  ) {
    return call(
      requestType: provider.requestType,
      payLater: provider.payLater,
      totalAmount: provider.totalAmount,
      paymentMethod: provider.paymentMethod,
      serviceID: provider.serviceID,
      isJoiningApproval: provider.isJoiningApproval,
      couponID: provider.couponID,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<(List<MultipleBookings>?, String?)> Function(
              MultiBookingPaymentProcessRef ref)
          create) {
    return _$MultiBookingPaymentProcessFamilyOverride(this, create);
  }
}

class _$MultiBookingPaymentProcessFamilyOverride implements FamilyOverride {
  _$MultiBookingPaymentProcessFamilyOverride(
      this.overriddenFamily, this.create);

  final FutureOr<(List<MultipleBookings>?, String?)> Function(
      MultiBookingPaymentProcessRef ref) create;

  @override
  final MultiBookingPaymentProcessFamily overriddenFamily;

  @override
  MultiBookingPaymentProcessProvider getProviderOverride(
    covariant MultiBookingPaymentProcessProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [multiBookingPaymentProcess].
class MultiBookingPaymentProcessProvider
    extends AutoDisposeFutureProvider<(List<MultipleBookings>?, String?)> {
  /// See also [multiBookingPaymentProcess].
  MultiBookingPaymentProcessProvider({
    required PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    AppPaymentMethods? paymentMethod,
    int? serviceID,
    bool isJoiningApproval = false,
    int? couponID,
  }) : this._internal(
          (ref) => multiBookingPaymentProcess(
            ref as MultiBookingPaymentProcessRef,
            requestType: requestType,
            payLater: payLater,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
            serviceID: serviceID,
            isJoiningApproval: isJoiningApproval,
            couponID: couponID,
          ),
          from: multiBookingPaymentProcessProvider,
          name: r'multiBookingPaymentProcessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$multiBookingPaymentProcessHash,
          dependencies: MultiBookingPaymentProcessFamily._dependencies,
          allTransitiveDependencies:
              MultiBookingPaymentProcessFamily._allTransitiveDependencies,
          requestType: requestType,
          payLater: payLater,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
          serviceID: serviceID,
          isJoiningApproval: isJoiningApproval,
          couponID: couponID,
        );

  MultiBookingPaymentProcessProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestType,
    required this.payLater,
    required this.totalAmount,
    required this.paymentMethod,
    required this.serviceID,
    required this.isJoiningApproval,
    required this.couponID,
  }) : super.internal();

  final PaymentProcessRequestType requestType;
  final bool? payLater;
  final double? totalAmount;
  final AppPaymentMethods? paymentMethod;
  final int? serviceID;
  final bool isJoiningApproval;
  final int? couponID;

  @override
  Override overrideWith(
    FutureOr<(List<MultipleBookings>?, String?)> Function(
            MultiBookingPaymentProcessRef ref)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MultiBookingPaymentProcessProvider._internal(
        (ref) => create(ref as MultiBookingPaymentProcessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestType: requestType,
        payLater: payLater,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        serviceID: serviceID,
        isJoiningApproval: isJoiningApproval,
        couponID: couponID,
      ),
    );
  }

  @override
  ({
    PaymentProcessRequestType requestType,
    bool? payLater,
    double? totalAmount,
    AppPaymentMethods? paymentMethod,
    int? serviceID,
    bool isJoiningApproval,
    int? couponID,
  }) get argument {
    return (
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      serviceID: serviceID,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID,
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<MultipleBookings>?, String?)>
      createElement() {
    return _MultiBookingPaymentProcessProviderElement(this);
  }

  MultiBookingPaymentProcessProvider _copyWith(
    FutureOr<(List<MultipleBookings>?, String?)> Function(
            MultiBookingPaymentProcessRef ref)
        create,
  ) {
    return MultiBookingPaymentProcessProvider._internal(
      (ref) => create(ref as MultiBookingPaymentProcessRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      requestType: requestType,
      payLater: payLater,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      serviceID: serviceID,
      isJoiningApproval: isJoiningApproval,
      couponID: couponID,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MultiBookingPaymentProcessProvider &&
        other.requestType == requestType &&
        other.payLater == payLater &&
        other.totalAmount == totalAmount &&
        other.paymentMethod == paymentMethod &&
        other.serviceID == serviceID &&
        other.isJoiningApproval == isJoiningApproval &&
        other.couponID == couponID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, payLater.hashCode);
    hash = _SystemHash.combine(hash, totalAmount.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);
    hash = _SystemHash.combine(hash, serviceID.hashCode);
    hash = _SystemHash.combine(hash, isJoiningApproval.hashCode);
    hash = _SystemHash.combine(hash, couponID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MultiBookingPaymentProcessRef
    on AutoDisposeFutureProviderRef<(List<MultipleBookings>?, String?)> {
  /// The parameter `requestType` of this provider.
  PaymentProcessRequestType get requestType;

  /// The parameter `payLater` of this provider.
  bool? get payLater;

  /// The parameter `totalAmount` of this provider.
  double? get totalAmount;

  /// The parameter `paymentMethod` of this provider.
  AppPaymentMethods? get paymentMethod;

  /// The parameter `serviceID` of this provider.
  int? get serviceID;

  /// The parameter `isJoiningApproval` of this provider.
  bool get isJoiningApproval;

  /// The parameter `couponID` of this provider.
  int? get couponID;
}

class _MultiBookingPaymentProcessProviderElement
    extends AutoDisposeFutureProviderElement<(List<MultipleBookings>?, String?)>
    with MultiBookingPaymentProcessRef {
  _MultiBookingPaymentProcessProviderElement(super.provider);

  @override
  PaymentProcessRequestType get requestType =>
      (origin as MultiBookingPaymentProcessProvider).requestType;
  @override
  bool? get payLater => (origin as MultiBookingPaymentProcessProvider).payLater;
  @override
  double? get totalAmount =>
      (origin as MultiBookingPaymentProcessProvider).totalAmount;
  @override
  AppPaymentMethods? get paymentMethod =>
      (origin as MultiBookingPaymentProcessProvider).paymentMethod;
  @override
  int? get serviceID =>
      (origin as MultiBookingPaymentProcessProvider).serviceID;
  @override
  bool get isJoiningApproval =>
      (origin as MultiBookingPaymentProcessProvider).isJoiningApproval;
  @override
  int? get couponID => (origin as MultiBookingPaymentProcessProvider).couponID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
