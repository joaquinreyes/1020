// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepoHash() => r'247f998882c3accb492988e04b8a179afe6a0184';

/// See also [bookingRepo].
@ProviderFor(bookingRepo)
final bookingRepoProvider = AutoDisposeProvider<BookingRepo>.internal(
  bookingRepo,
  name: r'bookingRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookingRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingRepoRef = AutoDisposeProviderRef<BookingRepo>;
String _$bookCourtHash() => r'8de11b4373295bcb3c0538ee2afa8c818587e1ff';

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

/// See also [bookCourt].
@ProviderFor(bookCourt)
const bookCourtProvider = BookCourtFamily();

/// See also [bookCourt].
class BookCourtFamily extends Family {
  /// See also [bookCourt].
  const BookCourtFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookCourtProvider';

  /// See also [bookCourt].
  BookCourtProvider call({
    required Bookings booking,
    required int courtID,
    required DateTime dateTime,
    required bool isOpenMatch,
    required bool payMyShare,
    required int reservedPlayers,
    required BookingRequestType requestType,
    String? organizerNote,
    bool? isPrivateMatch,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
    List<BookingPlayerBase>? customerPlayers,
  }) {
    return BookCourtProvider(
      booking: booking,
      courtID: courtID,
      dateTime: dateTime,
      isOpenMatch: isOpenMatch,
      payMyShare: payMyShare,
      reservedPlayers: reservedPlayers,
      requestType: requestType,
      organizerNote: organizerNote,
      isPrivateMatch: isPrivateMatch,
      isFriendlyMatch: isFriendlyMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
      customerPlayers: customerPlayers,
    );
  }

  @visibleForOverriding
  @override
  BookCourtProvider getProviderOverride(
    covariant BookCourtProvider provider,
  ) {
    return call(
      booking: provider.booking,
      courtID: provider.courtID,
      dateTime: provider.dateTime,
      isOpenMatch: provider.isOpenMatch,
      payMyShare: provider.payMyShare,
      reservedPlayers: provider.reservedPlayers,
      requestType: provider.requestType,
      organizerNote: provider.organizerNote,
      isPrivateMatch: provider.isPrivateMatch,
      isFriendlyMatch: provider.isFriendlyMatch,
      openMatchMinLevel: provider.openMatchMinLevel,
      openMatchMaxLevel: provider.openMatchMaxLevel,
      approvalNeeded: provider.approvalNeeded,
      customerPlayers: provider.customerPlayers,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<double?> Function(BookCourtRef ref) create) {
    return _$BookCourtFamilyOverride(this, create);
  }
}

class _$BookCourtFamilyOverride implements FamilyOverride {
  _$BookCourtFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<double?> Function(BookCourtRef ref) create;

  @override
  final BookCourtFamily overriddenFamily;

  @override
  BookCourtProvider getProviderOverride(
    covariant BookCourtProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [bookCourt].
class BookCourtProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [bookCourt].
  BookCourtProvider({
    required Bookings booking,
    required int courtID,
    required DateTime dateTime,
    required bool isOpenMatch,
    required bool payMyShare,
    required int reservedPlayers,
    required BookingRequestType requestType,
    String? organizerNote,
    bool? isPrivateMatch,
    bool? isFriendlyMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
    List<BookingPlayerBase>? customerPlayers,
  }) : this._internal(
          (ref) => bookCourt(
            ref as BookCourtRef,
            booking: booking,
            courtID: courtID,
            dateTime: dateTime,
            isOpenMatch: isOpenMatch,
            payMyShare: payMyShare,
            reservedPlayers: reservedPlayers,
            requestType: requestType,
            organizerNote: organizerNote,
            isPrivateMatch: isPrivateMatch,
            isFriendlyMatch: isFriendlyMatch,
            openMatchMinLevel: openMatchMinLevel,
            openMatchMaxLevel: openMatchMaxLevel,
            approvalNeeded: approvalNeeded,
            customerPlayers: customerPlayers,
          ),
          from: bookCourtProvider,
          name: r'bookCourtProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookCourtHash,
          dependencies: BookCourtFamily._dependencies,
          allTransitiveDependencies: BookCourtFamily._allTransitiveDependencies,
          booking: booking,
          courtID: courtID,
          dateTime: dateTime,
          isOpenMatch: isOpenMatch,
          payMyShare: payMyShare,
          reservedPlayers: reservedPlayers,
          requestType: requestType,
          organizerNote: organizerNote,
          isPrivateMatch: isPrivateMatch,
          isFriendlyMatch: isFriendlyMatch,
          openMatchMinLevel: openMatchMinLevel,
          openMatchMaxLevel: openMatchMaxLevel,
          approvalNeeded: approvalNeeded,
          customerPlayers: customerPlayers,
        );

  BookCourtProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.booking,
    required this.courtID,
    required this.dateTime,
    required this.isOpenMatch,
    required this.payMyShare,
    required this.reservedPlayers,
    required this.requestType,
    required this.organizerNote,
    required this.isPrivateMatch,
    required this.isFriendlyMatch,
    required this.openMatchMinLevel,
    required this.openMatchMaxLevel,
    required this.approvalNeeded,
    required this.customerPlayers,
  }) : super.internal();

  final Bookings booking;
  final int courtID;
  final DateTime dateTime;
  final bool isOpenMatch;
  final bool payMyShare;
  final int reservedPlayers;
  final BookingRequestType requestType;
  final String? organizerNote;
  final bool? isPrivateMatch;
  final bool? isFriendlyMatch;
  final double? openMatchMinLevel;
  final double? openMatchMaxLevel;
  final bool? approvalNeeded;
  final List<BookingPlayerBase>? customerPlayers;

  @override
  Override overrideWith(
    FutureOr<double?> Function(BookCourtRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookCourtProvider._internal(
        (ref) => create(ref as BookCourtRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        booking: booking,
        courtID: courtID,
        dateTime: dateTime,
        isOpenMatch: isOpenMatch,
        payMyShare: payMyShare,
        reservedPlayers: reservedPlayers,
        requestType: requestType,
        organizerNote: organizerNote,
        isPrivateMatch: isPrivateMatch,
        isFriendlyMatch: isFriendlyMatch,
        openMatchMinLevel: openMatchMinLevel,
        openMatchMaxLevel: openMatchMaxLevel,
        approvalNeeded: approvalNeeded,
        customerPlayers: customerPlayers,
      ),
    );
  }

  @override
  ({
    Bookings booking,
    int courtID,
    DateTime dateTime,
    bool isOpenMatch,
    bool payMyShare,
    int reservedPlayers,
    BookingRequestType requestType,
    String? organizerNote,
    bool? isPrivateMatch,
    bool? isFriendlyMatch,
    double? openMatchMinLevel,
    double? openMatchMaxLevel,
    bool? approvalNeeded,
    List<BookingPlayerBase>? customerPlayers,
  }) get argument {
    return (
      booking: booking,
      courtID: courtID,
      dateTime: dateTime,
      isOpenMatch: isOpenMatch,
      payMyShare: payMyShare,
      reservedPlayers: reservedPlayers,
      requestType: requestType,
      organizerNote: organizerNote,
      isPrivateMatch: isPrivateMatch,
      isFriendlyMatch: isFriendlyMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
      customerPlayers: customerPlayers,
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _BookCourtProviderElement(this);
  }

  BookCourtProvider _copyWith(
    FutureOr<double?> Function(BookCourtRef ref) create,
  ) {
    return BookCourtProvider._internal(
      (ref) => create(ref as BookCourtRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      booking: booking,
      courtID: courtID,
      dateTime: dateTime,
      isOpenMatch: isOpenMatch,
      payMyShare: payMyShare,
      reservedPlayers: reservedPlayers,
      requestType: requestType,
      organizerNote: organizerNote,
      isPrivateMatch: isPrivateMatch,
      isFriendlyMatch: isFriendlyMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
      customerPlayers: customerPlayers,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookCourtProvider &&
        other.booking == booking &&
        other.courtID == courtID &&
        other.dateTime == dateTime &&
        other.isOpenMatch == isOpenMatch &&
        other.payMyShare == payMyShare &&
        other.reservedPlayers == reservedPlayers &&
        other.requestType == requestType &&
        other.organizerNote == organizerNote &&
        other.isPrivateMatch == isPrivateMatch &&
        other.isFriendlyMatch == isFriendlyMatch &&
        other.openMatchMinLevel == openMatchMinLevel &&
        other.openMatchMaxLevel == openMatchMaxLevel &&
        other.approvalNeeded == approvalNeeded &&
        other.customerPlayers == customerPlayers;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, booking.hashCode);
    hash = _SystemHash.combine(hash, courtID.hashCode);
    hash = _SystemHash.combine(hash, dateTime.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, payMyShare.hashCode);
    hash = _SystemHash.combine(hash, reservedPlayers.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, organizerNote.hashCode);
    hash = _SystemHash.combine(hash, isPrivateMatch.hashCode);
    hash = _SystemHash.combine(hash, isFriendlyMatch.hashCode);
    hash = _SystemHash.combine(hash, openMatchMinLevel.hashCode);
    hash = _SystemHash.combine(hash, openMatchMaxLevel.hashCode);
    hash = _SystemHash.combine(hash, approvalNeeded.hashCode);
    hash = _SystemHash.combine(hash, customerPlayers.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookCourtRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `booking` of this provider.
  Bookings get booking;

  /// The parameter `courtID` of this provider.
  int get courtID;

  /// The parameter `dateTime` of this provider.
  DateTime get dateTime;

  /// The parameter `isOpenMatch` of this provider.
  bool get isOpenMatch;

  /// The parameter `payMyShare` of this provider.
  bool get payMyShare;

  /// The parameter `reservedPlayers` of this provider.
  int get reservedPlayers;

  /// The parameter `requestType` of this provider.
  BookingRequestType get requestType;

  /// The parameter `organizerNote` of this provider.
  String? get organizerNote;

  /// The parameter `isPrivateMatch` of this provider.
  bool? get isPrivateMatch;

  /// The parameter `isFriendlyMatch` of this provider.
  bool? get isFriendlyMatch;

  /// The parameter `openMatchMinLevel` of this provider.
  double? get openMatchMinLevel;

  /// The parameter `openMatchMaxLevel` of this provider.
  double? get openMatchMaxLevel;

  /// The parameter `approvalNeeded` of this provider.
  bool? get approvalNeeded;

  /// The parameter `customerPlayers` of this provider.
  List<BookingPlayerBase>? get customerPlayers;
}

class _BookCourtProviderElement
    extends AutoDisposeFutureProviderElement<double?> with BookCourtRef {
  _BookCourtProviderElement(super.provider);

  @override
  Bookings get booking => (origin as BookCourtProvider).booking;
  @override
  int get courtID => (origin as BookCourtProvider).courtID;
  @override
  DateTime get dateTime => (origin as BookCourtProvider).dateTime;
  @override
  bool get isOpenMatch => (origin as BookCourtProvider).isOpenMatch;
  @override
  bool get payMyShare => (origin as BookCourtProvider).payMyShare;
  @override
  int get reservedPlayers => (origin as BookCourtProvider).reservedPlayers;
  @override
  BookingRequestType get requestType =>
      (origin as BookCourtProvider).requestType;
  @override
  String? get organizerNote => (origin as BookCourtProvider).organizerNote;
  @override
  bool? get isPrivateMatch => (origin as BookCourtProvider).isPrivateMatch;
  @override
  bool? get isFriendlyMatch => (origin as BookCourtProvider).isFriendlyMatch;
  @override
  double? get openMatchMinLevel =>
      (origin as BookCourtProvider).openMatchMinLevel;
  @override
  double? get openMatchMaxLevel =>
      (origin as BookCourtProvider).openMatchMaxLevel;
  @override
  bool? get approvalNeeded => (origin as BookCourtProvider).approvalNeeded;
  @override
  List<BookingPlayerBase>? get customerPlayers =>
      (origin as BookCourtProvider).customerPlayers;
}

String _$fetchUserBookingHash() => r'b0a69cce66a73843c33103d839f8f608885b630e';

/// See also [fetchUserBooking].
@ProviderFor(fetchUserBooking)
final fetchUserBookingProvider =
    AutoDisposeFutureProvider<List<UserBookings>>.internal(
  fetchUserBooking,
  name: r'fetchUserBookingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserBookingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchUserBookingRef = AutoDisposeFutureProviderRef<List<UserBookings>>;
String _$fetchUserBookingWaitingListHash() =>
    r'43d18a355c2fb71b457cc3c91f56a6b7de188193';

/// See also [fetchUserBookingWaitingList].
@ProviderFor(fetchUserBookingWaitingList)
final fetchUserBookingWaitingListProvider =
    AutoDisposeFutureProvider<List<UserBookings>>.internal(
  fetchUserBookingWaitingList,
  name: r'fetchUserBookingWaitingListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserBookingWaitingListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchUserBookingWaitingListRef
    = AutoDisposeFutureProviderRef<List<UserBookings>>;
String _$fetchUserAllBookingsHash() =>
    r'389fa06b4091f95baecba70aef5aed4de4230ebb';

/// See also [fetchUserAllBookings].
@ProviderFor(fetchUserAllBookings)
final fetchUserAllBookingsProvider =
    AutoDisposeFutureProvider<List<UserBookings>>.internal(
  fetchUserAllBookings,
  name: r'fetchUserAllBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserAllBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchUserAllBookingsRef
    = AutoDisposeFutureProviderRef<List<UserBookings>>;
String _$addToCalendarHash() => r'64a254810c4801ab505e0babb496fd935dc108dc';

/// See also [addToCalendar].
@ProviderFor(addToCalendar)
const addToCalendarProvider = AddToCalendarFamily();

/// See also [addToCalendar].
class AddToCalendarFamily extends Family {
  /// See also [addToCalendar].
  const AddToCalendarFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addToCalendarProvider';

  /// See also [addToCalendar].
  AddToCalendarProvider call({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return AddToCalendarProvider(
      title: title,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @visibleForOverriding
  @override
  AddToCalendarProvider getProviderOverride(
    covariant AddToCalendarProvider provider,
  ) {
    return call(
      title: provider.title,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(AddToCalendarRef ref) create) {
    return _$AddToCalendarFamilyOverride(this, create);
  }
}

class _$AddToCalendarFamilyOverride implements FamilyOverride {
  _$AddToCalendarFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(AddToCalendarRef ref) create;

  @override
  final AddToCalendarFamily overriddenFamily;

  @override
  AddToCalendarProvider getProviderOverride(
    covariant AddToCalendarProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [addToCalendar].
class AddToCalendarProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [addToCalendar].
  AddToCalendarProvider({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => addToCalendar(
            ref as AddToCalendarRef,
            title: title,
            startDate: startDate,
            endDate: endDate,
          ),
          from: addToCalendarProvider,
          name: r'addToCalendarProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addToCalendarHash,
          dependencies: AddToCalendarFamily._dependencies,
          allTransitiveDependencies:
              AddToCalendarFamily._allTransitiveDependencies,
          title: title,
          startDate: startDate,
          endDate: endDate,
        );

  AddToCalendarProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String title;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<bool> Function(AddToCalendarRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddToCalendarProvider._internal(
        (ref) => create(ref as AddToCalendarRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  ({
    String title,
    DateTime startDate,
    DateTime endDate,
  }) get argument {
    return (
      title: title,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _AddToCalendarProviderElement(this);
  }

  AddToCalendarProvider _copyWith(
    FutureOr<bool> Function(AddToCalendarRef ref) create,
  ) {
    return AddToCalendarProvider._internal(
      (ref) => create(ref as AddToCalendarRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      title: title,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddToCalendarProvider &&
        other.title == title &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddToCalendarRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _AddToCalendarProviderElement
    extends AutoDisposeFutureProviderElement<bool> with AddToCalendarRef {
  _AddToCalendarProviderElement(super.provider);

  @override
  String get title => (origin as AddToCalendarProvider).title;
  @override
  DateTime get startDate => (origin as AddToCalendarProvider).startDate;
  @override
  DateTime get endDate => (origin as AddToCalendarProvider).endDate;
}

String _$fetchCourtPriceHash() => r'7c3f146db96a762d9654c2df2414afa6d0d3a072';

/// See also [fetchCourtPrice].
@ProviderFor(fetchCourtPrice)
const fetchCourtPriceProvider = FetchCourtPriceFamily();

/// See also [fetchCourtPrice].
class FetchCourtPriceFamily extends Family {
  /// See also [fetchCourtPrice].
  const FetchCourtPriceFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchCourtPriceProvider';

  /// See also [fetchCourtPrice].
  FetchCourtPriceProvider call({
    required int serviceId,
    required CourtPriceRequestType requestType,
    required DateTime dateTime,
    required List courtId,
    bool isOpenMatch = false,
    bool pendingPayment = false,
    int reserveCounter = 0,
    LessonVariants? lessonVariant,
    required int durationInMin,
    required int? coachId,
  }) {
    return FetchCourtPriceProvider(
      serviceId: serviceId,
      requestType: requestType,
      dateTime: dateTime,
      courtId: courtId,
      isOpenMatch: isOpenMatch,
      pendingPayment: pendingPayment,
      reserveCounter: reserveCounter,
      lessonVariant: lessonVariant,
      durationInMin: durationInMin,
      coachId: coachId,
    );
  }

  @visibleForOverriding
  @override
  FetchCourtPriceProvider getProviderOverride(
    covariant FetchCourtPriceProvider provider,
  ) {
    return call(
      serviceId: provider.serviceId,
      requestType: provider.requestType,
      dateTime: provider.dateTime,
      courtId: provider.courtId,
      isOpenMatch: provider.isOpenMatch,
      pendingPayment: provider.pendingPayment,
      reserveCounter: provider.reserveCounter,
      lessonVariant: provider.lessonVariant,
      durationInMin: provider.durationInMin,
      coachId: provider.coachId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<dynamic> Function(FetchCourtPriceRef ref) create) {
    return _$FetchCourtPriceFamilyOverride(this, create);
  }
}

class _$FetchCourtPriceFamilyOverride implements FamilyOverride {
  _$FetchCourtPriceFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<dynamic> Function(FetchCourtPriceRef ref) create;

  @override
  final FetchCourtPriceFamily overriddenFamily;

  @override
  FetchCourtPriceProvider getProviderOverride(
    covariant FetchCourtPriceProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchCourtPrice].
class FetchCourtPriceProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [fetchCourtPrice].
  FetchCourtPriceProvider({
    required int serviceId,
    required CourtPriceRequestType requestType,
    required DateTime dateTime,
    required List courtId,
    bool isOpenMatch = false,
    bool pendingPayment = false,
    int reserveCounter = 0,
    LessonVariants? lessonVariant,
    required int durationInMin,
    required int? coachId,
  }) : this._internal(
          (ref) => fetchCourtPrice(
            ref as FetchCourtPriceRef,
            serviceId: serviceId,
            requestType: requestType,
            dateTime: dateTime,
            courtId: courtId,
            isOpenMatch: isOpenMatch,
            pendingPayment: pendingPayment,
            reserveCounter: reserveCounter,
            lessonVariant: lessonVariant,
            durationInMin: durationInMin,
            coachId: coachId,
          ),
          from: fetchCourtPriceProvider,
          name: r'fetchCourtPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchCourtPriceHash,
          dependencies: FetchCourtPriceFamily._dependencies,
          allTransitiveDependencies:
              FetchCourtPriceFamily._allTransitiveDependencies,
          serviceId: serviceId,
          requestType: requestType,
          dateTime: dateTime,
          courtId: courtId,
          isOpenMatch: isOpenMatch,
          pendingPayment: pendingPayment,
          reserveCounter: reserveCounter,
          lessonVariant: lessonVariant,
          durationInMin: durationInMin,
          coachId: coachId,
        );

  FetchCourtPriceProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
    required this.requestType,
    required this.dateTime,
    required this.courtId,
    required this.isOpenMatch,
    required this.pendingPayment,
    required this.reserveCounter,
    required this.lessonVariant,
    required this.durationInMin,
    required this.coachId,
  }) : super.internal();

  final int serviceId;
  final CourtPriceRequestType requestType;
  final DateTime dateTime;
  final List courtId;
  final bool isOpenMatch;
  final bool pendingPayment;
  final int reserveCounter;
  final LessonVariants? lessonVariant;
  final int durationInMin;
  final int? coachId;

  @override
  Override overrideWith(
    FutureOr<dynamic> Function(FetchCourtPriceRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchCourtPriceProvider._internal(
        (ref) => create(ref as FetchCourtPriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
        requestType: requestType,
        dateTime: dateTime,
        courtId: courtId,
        isOpenMatch: isOpenMatch,
        pendingPayment: pendingPayment,
        reserveCounter: reserveCounter,
        lessonVariant: lessonVariant,
        durationInMin: durationInMin,
        coachId: coachId,
      ),
    );
  }

  @override
  ({
    int serviceId,
    CourtPriceRequestType requestType,
    DateTime dateTime,
    List courtId,
    bool isOpenMatch,
    bool pendingPayment,
    int reserveCounter,
    LessonVariants? lessonVariant,
    int durationInMin,
    int? coachId,
  }) get argument {
    return (
      serviceId: serviceId,
      requestType: requestType,
      dateTime: dateTime,
      courtId: courtId,
      isOpenMatch: isOpenMatch,
      pendingPayment: pendingPayment,
      reserveCounter: reserveCounter,
      lessonVariant: lessonVariant,
      durationInMin: durationInMin,
      coachId: coachId,
    );
  }

  @override
  AutoDisposeFutureProviderElement<dynamic> createElement() {
    return _FetchCourtPriceProviderElement(this);
  }

  FetchCourtPriceProvider _copyWith(
    FutureOr<dynamic> Function(FetchCourtPriceRef ref) create,
  ) {
    return FetchCourtPriceProvider._internal(
      (ref) => create(ref as FetchCourtPriceRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      serviceId: serviceId,
      requestType: requestType,
      dateTime: dateTime,
      courtId: courtId,
      isOpenMatch: isOpenMatch,
      pendingPayment: pendingPayment,
      reserveCounter: reserveCounter,
      lessonVariant: lessonVariant,
      durationInMin: durationInMin,
      coachId: coachId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCourtPriceProvider &&
        other.serviceId == serviceId &&
        other.requestType == requestType &&
        other.dateTime == dateTime &&
        other.courtId == courtId &&
        other.isOpenMatch == isOpenMatch &&
        other.pendingPayment == pendingPayment &&
        other.reserveCounter == reserveCounter &&
        other.lessonVariant == lessonVariant &&
        other.durationInMin == durationInMin &&
        other.coachId == coachId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);
    hash = _SystemHash.combine(hash, requestType.hashCode);
    hash = _SystemHash.combine(hash, dateTime.hashCode);
    hash = _SystemHash.combine(hash, courtId.hashCode);
    hash = _SystemHash.combine(hash, isOpenMatch.hashCode);
    hash = _SystemHash.combine(hash, pendingPayment.hashCode);
    hash = _SystemHash.combine(hash, reserveCounter.hashCode);
    hash = _SystemHash.combine(hash, lessonVariant.hashCode);
    hash = _SystemHash.combine(hash, durationInMin.hashCode);
    hash = _SystemHash.combine(hash, coachId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchCourtPriceRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `serviceId` of this provider.
  int get serviceId;

  /// The parameter `requestType` of this provider.
  CourtPriceRequestType get requestType;

  /// The parameter `dateTime` of this provider.
  DateTime get dateTime;

  /// The parameter `courtId` of this provider.
  List get courtId;

  /// The parameter `isOpenMatch` of this provider.
  bool get isOpenMatch;

  /// The parameter `pendingPayment` of this provider.
  bool get pendingPayment;

  /// The parameter `reserveCounter` of this provider.
  int get reserveCounter;

  /// The parameter `lessonVariant` of this provider.
  LessonVariants? get lessonVariant;

  /// The parameter `durationInMin` of this provider.
  int get durationInMin;

  /// The parameter `coachId` of this provider.
  int? get coachId;
}

class _FetchCourtPriceProviderElement
    extends AutoDisposeFutureProviderElement<dynamic> with FetchCourtPriceRef {
  _FetchCourtPriceProviderElement(super.provider);

  @override
  int get serviceId => (origin as FetchCourtPriceProvider).serviceId;
  @override
  CourtPriceRequestType get requestType =>
      (origin as FetchCourtPriceProvider).requestType;
  @override
  DateTime get dateTime => (origin as FetchCourtPriceProvider).dateTime;
  @override
  List get courtId => (origin as FetchCourtPriceProvider).courtId;
  @override
  bool get isOpenMatch => (origin as FetchCourtPriceProvider).isOpenMatch;
  @override
  bool get pendingPayment => (origin as FetchCourtPriceProvider).pendingPayment;
  @override
  int get reserveCounter => (origin as FetchCourtPriceProvider).reserveCounter;
  @override
  LessonVariants? get lessonVariant =>
      (origin as FetchCourtPriceProvider).lessonVariant;
  @override
  int get durationInMin => (origin as FetchCourtPriceProvider).durationInMin;
  @override
  int? get coachId => (origin as FetchCourtPriceProvider).coachId;
}

String _$fetchBookingCartListHash() =>
    r'bb1ab4b33c6c609151cabdd566d9023a343018b6';

/// See also [fetchBookingCartList].
@ProviderFor(fetchBookingCartList)
final fetchBookingCartListProvider =
    AutoDisposeFutureProvider<List<MultipleBookings>>.internal(
  fetchBookingCartList,
  name: r'fetchBookingCartListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchBookingCartListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchBookingCartListRef
    = AutoDisposeFutureProviderRef<List<MultipleBookings>>;
String _$deleteCartHash() => r'270f5242597dce0c128f744b8e6be5f53d636b46';

/// See also [deleteCart].
@ProviderFor(deleteCart)
const deleteCartProvider = DeleteCartFamily();

/// See also [deleteCart].
class DeleteCartFamily extends Family {
  /// See also [deleteCart].
  const DeleteCartFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteCartProvider';

  /// See also [deleteCart].
  DeleteCartProvider call(
    String bookingId,
  ) {
    return DeleteCartProvider(
      bookingId,
    );
  }

  @visibleForOverriding
  @override
  DeleteCartProvider getProviderOverride(
    covariant DeleteCartProvider provider,
  ) {
    return call(
      provider.bookingId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(DeleteCartRef ref) create) {
    return _$DeleteCartFamilyOverride(this, create);
  }
}

class _$DeleteCartFamilyOverride implements FamilyOverride {
  _$DeleteCartFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(DeleteCartRef ref) create;

  @override
  final DeleteCartFamily overriddenFamily;

  @override
  DeleteCartProvider getProviderOverride(
    covariant DeleteCartProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [deleteCart].
class DeleteCartProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteCart].
  DeleteCartProvider(
    String bookingId,
  ) : this._internal(
          (ref) => deleteCart(
            ref as DeleteCartRef,
            bookingId,
          ),
          from: deleteCartProvider,
          name: r'deleteCartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteCartHash,
          dependencies: DeleteCartFamily._dependencies,
          allTransitiveDependencies:
              DeleteCartFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  DeleteCartProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteCartRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteCartProvider._internal(
        (ref) => create(ref as DeleteCartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (bookingId,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteCartProviderElement(this);
  }

  DeleteCartProvider _copyWith(
    FutureOr<bool> Function(DeleteCartRef ref) create,
  ) {
    return DeleteCartProvider._internal(
      (ref) => create(ref as DeleteCartRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      bookingId: bookingId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteCartProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteCartRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _DeleteCartProviderElement extends AutoDisposeFutureProviderElement<bool>
    with DeleteCartRef {
  _DeleteCartProviderElement(super.provider);

  @override
  String get bookingId => (origin as DeleteCartProvider).bookingId;
}

String _$upgradeBookingToOpenHash() =>
    r'd917061d564941227097fa62727b35492541449a';

/// See also [upgradeBookingToOpen].
@ProviderFor(upgradeBookingToOpen)
const upgradeBookingToOpenProvider = UpgradeBookingToOpenFamily();

/// See also [upgradeBookingToOpen].
class UpgradeBookingToOpenFamily extends Family {
  /// See also [upgradeBookingToOpen].
  const UpgradeBookingToOpenFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'upgradeBookingToOpenProvider';

  /// See also [upgradeBookingToOpen].
  UpgradeBookingToOpenProvider call({
    required Bookings booking,
    required int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    bool? isPrivateMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) {
    return UpgradeBookingToOpenProvider(
      booking: booking,
      reservedPlayers: reservedPlayers,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      isPrivateMatch: isPrivateMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
    );
  }

  @visibleForOverriding
  @override
  UpgradeBookingToOpenProvider getProviderOverride(
    covariant UpgradeBookingToOpenProvider provider,
  ) {
    return call(
      booking: provider.booking,
      reservedPlayers: provider.reservedPlayers,
      organizerNote: provider.organizerNote,
      isFriendlyMatch: provider.isFriendlyMatch,
      isPrivateMatch: provider.isPrivateMatch,
      openMatchMinLevel: provider.openMatchMinLevel,
      openMatchMaxLevel: provider.openMatchMaxLevel,
      approvalNeeded: provider.approvalNeeded,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<(int?, double?)> Function(UpgradeBookingToOpenRef ref) create) {
    return _$UpgradeBookingToOpenFamilyOverride(this, create);
  }
}

class _$UpgradeBookingToOpenFamilyOverride implements FamilyOverride {
  _$UpgradeBookingToOpenFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<(int?, double?)> Function(UpgradeBookingToOpenRef ref) create;

  @override
  final UpgradeBookingToOpenFamily overriddenFamily;

  @override
  UpgradeBookingToOpenProvider getProviderOverride(
    covariant UpgradeBookingToOpenProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [upgradeBookingToOpen].
class UpgradeBookingToOpenProvider
    extends AutoDisposeFutureProvider<(int?, double?)> {
  /// See also [upgradeBookingToOpen].
  UpgradeBookingToOpenProvider({
    required Bookings booking,
    required int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    bool? isPrivateMatch,
    required double? openMatchMinLevel,
    required double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) : this._internal(
          (ref) => upgradeBookingToOpen(
            ref as UpgradeBookingToOpenRef,
            booking: booking,
            reservedPlayers: reservedPlayers,
            organizerNote: organizerNote,
            isFriendlyMatch: isFriendlyMatch,
            isPrivateMatch: isPrivateMatch,
            openMatchMinLevel: openMatchMinLevel,
            openMatchMaxLevel: openMatchMaxLevel,
            approvalNeeded: approvalNeeded,
          ),
          from: upgradeBookingToOpenProvider,
          name: r'upgradeBookingToOpenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upgradeBookingToOpenHash,
          dependencies: UpgradeBookingToOpenFamily._dependencies,
          allTransitiveDependencies:
              UpgradeBookingToOpenFamily._allTransitiveDependencies,
          booking: booking,
          reservedPlayers: reservedPlayers,
          organizerNote: organizerNote,
          isFriendlyMatch: isFriendlyMatch,
          isPrivateMatch: isPrivateMatch,
          openMatchMinLevel: openMatchMinLevel,
          openMatchMaxLevel: openMatchMaxLevel,
          approvalNeeded: approvalNeeded,
        );

  UpgradeBookingToOpenProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.booking,
    required this.reservedPlayers,
    required this.organizerNote,
    required this.isFriendlyMatch,
    required this.isPrivateMatch,
    required this.openMatchMinLevel,
    required this.openMatchMaxLevel,
    required this.approvalNeeded,
  }) : super.internal();

  final Bookings booking;
  final int reservedPlayers;
  final String? organizerNote;
  final bool? isFriendlyMatch;
  final bool? isPrivateMatch;
  final double? openMatchMinLevel;
  final double? openMatchMaxLevel;
  final bool? approvalNeeded;

  @override
  Override overrideWith(
    FutureOr<(int?, double?)> Function(UpgradeBookingToOpenRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpgradeBookingToOpenProvider._internal(
        (ref) => create(ref as UpgradeBookingToOpenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        booking: booking,
        reservedPlayers: reservedPlayers,
        organizerNote: organizerNote,
        isFriendlyMatch: isFriendlyMatch,
        isPrivateMatch: isPrivateMatch,
        openMatchMinLevel: openMatchMinLevel,
        openMatchMaxLevel: openMatchMaxLevel,
        approvalNeeded: approvalNeeded,
      ),
    );
  }

  @override
  ({
    Bookings booking,
    int reservedPlayers,
    String? organizerNote,
    bool? isFriendlyMatch,
    bool? isPrivateMatch,
    double? openMatchMinLevel,
    double? openMatchMaxLevel,
    bool? approvalNeeded,
  }) get argument {
    return (
      booking: booking,
      reservedPlayers: reservedPlayers,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      isPrivateMatch: isPrivateMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
    );
  }

  @override
  AutoDisposeFutureProviderElement<(int?, double?)> createElement() {
    return _UpgradeBookingToOpenProviderElement(this);
  }

  UpgradeBookingToOpenProvider _copyWith(
    FutureOr<(int?, double?)> Function(UpgradeBookingToOpenRef ref) create,
  ) {
    return UpgradeBookingToOpenProvider._internal(
      (ref) => create(ref as UpgradeBookingToOpenRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      booking: booking,
      reservedPlayers: reservedPlayers,
      organizerNote: organizerNote,
      isFriendlyMatch: isFriendlyMatch,
      isPrivateMatch: isPrivateMatch,
      openMatchMinLevel: openMatchMinLevel,
      openMatchMaxLevel: openMatchMaxLevel,
      approvalNeeded: approvalNeeded,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpgradeBookingToOpenProvider &&
        other.booking == booking &&
        other.reservedPlayers == reservedPlayers &&
        other.organizerNote == organizerNote &&
        other.isFriendlyMatch == isFriendlyMatch &&
        other.isPrivateMatch == isPrivateMatch &&
        other.openMatchMinLevel == openMatchMinLevel &&
        other.openMatchMaxLevel == openMatchMaxLevel &&
        other.approvalNeeded == approvalNeeded;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, booking.hashCode);
    hash = _SystemHash.combine(hash, reservedPlayers.hashCode);
    hash = _SystemHash.combine(hash, organizerNote.hashCode);
    hash = _SystemHash.combine(hash, isFriendlyMatch.hashCode);
    hash = _SystemHash.combine(hash, isPrivateMatch.hashCode);
    hash = _SystemHash.combine(hash, openMatchMinLevel.hashCode);
    hash = _SystemHash.combine(hash, openMatchMaxLevel.hashCode);
    hash = _SystemHash.combine(hash, approvalNeeded.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpgradeBookingToOpenRef on AutoDisposeFutureProviderRef<(int?, double?)> {
  /// The parameter `booking` of this provider.
  Bookings get booking;

  /// The parameter `reservedPlayers` of this provider.
  int get reservedPlayers;

  /// The parameter `organizerNote` of this provider.
  String? get organizerNote;

  /// The parameter `isFriendlyMatch` of this provider.
  bool? get isFriendlyMatch;

  /// The parameter `isPrivateMatch` of this provider.
  bool? get isPrivateMatch;

  /// The parameter `openMatchMinLevel` of this provider.
  double? get openMatchMinLevel;

  /// The parameter `openMatchMaxLevel` of this provider.
  double? get openMatchMaxLevel;

  /// The parameter `approvalNeeded` of this provider.
  bool? get approvalNeeded;
}

class _UpgradeBookingToOpenProviderElement
    extends AutoDisposeFutureProviderElement<(int?, double?)>
    with UpgradeBookingToOpenRef {
  _UpgradeBookingToOpenProviderElement(super.provider);

  @override
  Bookings get booking => (origin as UpgradeBookingToOpenProvider).booking;
  @override
  int get reservedPlayers =>
      (origin as UpgradeBookingToOpenProvider).reservedPlayers;
  @override
  String? get organizerNote =>
      (origin as UpgradeBookingToOpenProvider).organizerNote;
  @override
  bool? get isFriendlyMatch =>
      (origin as UpgradeBookingToOpenProvider).isFriendlyMatch;
  @override
  bool? get isPrivateMatch =>
      (origin as UpgradeBookingToOpenProvider).isPrivateMatch;
  @override
  double? get openMatchMinLevel =>
      (origin as UpgradeBookingToOpenProvider).openMatchMinLevel;
  @override
  double? get openMatchMaxLevel =>
      (origin as UpgradeBookingToOpenProvider).openMatchMaxLevel;
  @override
  bool? get approvalNeeded =>
      (origin as UpgradeBookingToOpenProvider).approvalNeeded;
}

String _$fetchChatCountHash() => r'b322e51f3a27c4575af69af38ba3c62353795d05';

/// See also [fetchChatCount].
@ProviderFor(fetchChatCount)
const fetchChatCountProvider = FetchChatCountFamily();

/// See also [fetchChatCount].
class FetchChatCountFamily extends Family {
  /// See also [fetchChatCount].
  const FetchChatCountFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchChatCountProvider';

  /// See also [fetchChatCount].
  FetchChatCountProvider call({
    required int matchId,
  }) {
    return FetchChatCountProvider(
      matchId: matchId,
    );
  }

  @visibleForOverriding
  @override
  FetchChatCountProvider getProviderOverride(
    covariant FetchChatCountProvider provider,
  ) {
    return call(
      matchId: provider.matchId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<double?> Function(FetchChatCountRef ref) create) {
    return _$FetchChatCountFamilyOverride(this, create);
  }
}

class _$FetchChatCountFamilyOverride implements FamilyOverride {
  _$FetchChatCountFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<double?> Function(FetchChatCountRef ref) create;

  @override
  final FetchChatCountFamily overriddenFamily;

  @override
  FetchChatCountProvider getProviderOverride(
    covariant FetchChatCountProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchChatCount].
class FetchChatCountProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [fetchChatCount].
  FetchChatCountProvider({
    required int matchId,
  }) : this._internal(
          (ref) => fetchChatCount(
            ref as FetchChatCountRef,
            matchId: matchId,
          ),
          from: fetchChatCountProvider,
          name: r'fetchChatCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchChatCountHash,
          dependencies: FetchChatCountFamily._dependencies,
          allTransitiveDependencies:
              FetchChatCountFamily._allTransitiveDependencies,
          matchId: matchId,
        );

  FetchChatCountProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.matchId,
  }) : super.internal();

  final int matchId;

  @override
  Override overrideWith(
    FutureOr<double?> Function(FetchChatCountRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchChatCountProvider._internal(
        (ref) => create(ref as FetchChatCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        matchId: matchId,
      ),
    );
  }

  @override
  ({
    int matchId,
  }) get argument {
    return (matchId: matchId,);
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _FetchChatCountProviderElement(this);
  }

  FetchChatCountProvider _copyWith(
    FutureOr<double?> Function(FetchChatCountRef ref) create,
  ) {
    return FetchChatCountProvider._internal(
      (ref) => create(ref as FetchChatCountRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      matchId: matchId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchChatCountProvider && other.matchId == matchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, matchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchChatCountRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `matchId` of this provider.
  int get matchId;
}

class _FetchChatCountProviderElement
    extends AutoDisposeFutureProviderElement<double?> with FetchChatCountRef {
  _FetchChatCountProviderElement(super.provider);

  @override
  int get matchId => (origin as FetchChatCountProvider).matchId;
}

String _$bookLessonCourtHash() => r'2c5754ed5f3fba4f7166c87d979279df73036d7d';

/// See also [bookLessonCourt].
@ProviderFor(bookLessonCourt)
const bookLessonCourtProvider = BookLessonCourtFamily();

/// See also [bookLessonCourt].
class BookLessonCourtFamily extends Family {
  /// See also [bookLessonCourt].
  const BookLessonCourtFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookLessonCourtProvider';

  /// See also [bookLessonCourt].
  BookLessonCourtProvider call({
    required int lessonTime,
    required int courtId,
    required int lessonId,
    required int coachId,
    required int locationId,
    required DateTime dateTime,
    required LessonVariants? lessonVariant,
  }) {
    return BookLessonCourtProvider(
      lessonTime: lessonTime,
      courtId: courtId,
      lessonId: lessonId,
      coachId: coachId,
      locationId: locationId,
      dateTime: dateTime,
      lessonVariant: lessonVariant,
    );
  }

  @visibleForOverriding
  @override
  BookLessonCourtProvider getProviderOverride(
    covariant BookLessonCourtProvider provider,
  ) {
    return call(
      lessonTime: provider.lessonTime,
      courtId: provider.courtId,
      lessonId: provider.lessonId,
      coachId: provider.coachId,
      locationId: provider.locationId,
      dateTime: provider.dateTime,
      lessonVariant: provider.lessonVariant,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<void> Function(BookLessonCourtRef ref) create) {
    return _$BookLessonCourtFamilyOverride(this, create);
  }
}

class _$BookLessonCourtFamilyOverride implements FamilyOverride {
  _$BookLessonCourtFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<void> Function(BookLessonCourtRef ref) create;

  @override
  final BookLessonCourtFamily overriddenFamily;

  @override
  BookLessonCourtProvider getProviderOverride(
    covariant BookLessonCourtProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [bookLessonCourt].
class BookLessonCourtProvider extends AutoDisposeFutureProvider<void> {
  /// See also [bookLessonCourt].
  BookLessonCourtProvider({
    required int lessonTime,
    required int courtId,
    required int lessonId,
    required int coachId,
    required int locationId,
    required DateTime dateTime,
    required LessonVariants? lessonVariant,
  }) : this._internal(
          (ref) => bookLessonCourt(
            ref as BookLessonCourtRef,
            lessonTime: lessonTime,
            courtId: courtId,
            lessonId: lessonId,
            coachId: coachId,
            locationId: locationId,
            dateTime: dateTime,
            lessonVariant: lessonVariant,
          ),
          from: bookLessonCourtProvider,
          name: r'bookLessonCourtProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookLessonCourtHash,
          dependencies: BookLessonCourtFamily._dependencies,
          allTransitiveDependencies:
              BookLessonCourtFamily._allTransitiveDependencies,
          lessonTime: lessonTime,
          courtId: courtId,
          lessonId: lessonId,
          coachId: coachId,
          locationId: locationId,
          dateTime: dateTime,
          lessonVariant: lessonVariant,
        );

  BookLessonCourtProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonTime,
    required this.courtId,
    required this.lessonId,
    required this.coachId,
    required this.locationId,
    required this.dateTime,
    required this.lessonVariant,
  }) : super.internal();

  final int lessonTime;
  final int courtId;
  final int lessonId;
  final int coachId;
  final int locationId;
  final DateTime dateTime;
  final LessonVariants? lessonVariant;

  @override
  Override overrideWith(
    FutureOr<void> Function(BookLessonCourtRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookLessonCourtProvider._internal(
        (ref) => create(ref as BookLessonCourtRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonTime: lessonTime,
        courtId: courtId,
        lessonId: lessonId,
        coachId: coachId,
        locationId: locationId,
        dateTime: dateTime,
        lessonVariant: lessonVariant,
      ),
    );
  }

  @override
  ({
    int lessonTime,
    int courtId,
    int lessonId,
    int coachId,
    int locationId,
    DateTime dateTime,
    LessonVariants? lessonVariant,
  }) get argument {
    return (
      lessonTime: lessonTime,
      courtId: courtId,
      lessonId: lessonId,
      coachId: coachId,
      locationId: locationId,
      dateTime: dateTime,
      lessonVariant: lessonVariant,
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _BookLessonCourtProviderElement(this);
  }

  BookLessonCourtProvider _copyWith(
    FutureOr<void> Function(BookLessonCourtRef ref) create,
  ) {
    return BookLessonCourtProvider._internal(
      (ref) => create(ref as BookLessonCourtRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      lessonTime: lessonTime,
      courtId: courtId,
      lessonId: lessonId,
      coachId: coachId,
      locationId: locationId,
      dateTime: dateTime,
      lessonVariant: lessonVariant,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookLessonCourtProvider &&
        other.lessonTime == lessonTime &&
        other.courtId == courtId &&
        other.lessonId == lessonId &&
        other.coachId == coachId &&
        other.locationId == locationId &&
        other.dateTime == dateTime &&
        other.lessonVariant == lessonVariant;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonTime.hashCode);
    hash = _SystemHash.combine(hash, courtId.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);
    hash = _SystemHash.combine(hash, coachId.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);
    hash = _SystemHash.combine(hash, dateTime.hashCode);
    hash = _SystemHash.combine(hash, lessonVariant.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookLessonCourtRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `lessonTime` of this provider.
  int get lessonTime;

  /// The parameter `courtId` of this provider.
  int get courtId;

  /// The parameter `lessonId` of this provider.
  int get lessonId;

  /// The parameter `coachId` of this provider.
  int get coachId;

  /// The parameter `locationId` of this provider.
  int get locationId;

  /// The parameter `dateTime` of this provider.
  DateTime get dateTime;

  /// The parameter `lessonVariant` of this provider.
  LessonVariants? get lessonVariant;
}

class _BookLessonCourtProviderElement
    extends AutoDisposeFutureProviderElement<void> with BookLessonCourtRef {
  _BookLessonCourtProviderElement(super.provider);

  @override
  int get lessonTime => (origin as BookLessonCourtProvider).lessonTime;
  @override
  int get courtId => (origin as BookLessonCourtProvider).courtId;
  @override
  int get lessonId => (origin as BookLessonCourtProvider).lessonId;
  @override
  int get coachId => (origin as BookLessonCourtProvider).coachId;
  @override
  int get locationId => (origin as BookLessonCourtProvider).locationId;
  @override
  DateTime get dateTime => (origin as BookLessonCourtProvider).dateTime;
  @override
  LessonVariants? get lessonVariant =>
      (origin as BookLessonCourtProvider).lessonVariant;
}

String _$activeMembershipHash() => r'ee8ccc1ba16514605ab88600feb077b13b8fbc9a';

/// See also [activeMembership].
@ProviderFor(activeMembership)
final activeMembershipProvider =
    AutoDisposeFutureProvider<List<ActiveMemberships>>.internal(
  activeMembership,
  name: r'activeMembershipProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeMembershipHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveMembershipRef
    = AutoDisposeFutureProviderRef<List<ActiveMemberships>>;
String _$fetchActiveAndAllMembershipsHash() =>
    r'6781ec7fefd91d8883fd9e1f996ed75c840468f0';

/// See also [fetchActiveAndAllMemberships].
@ProviderFor(fetchActiveAndAllMemberships)
final fetchActiveAndAllMembershipsProvider =
    AutoDisposeFutureProvider<UserActiveMembership>.internal(
  fetchActiveAndAllMemberships,
  name: r'fetchActiveAndAllMembershipsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchActiveAndAllMembershipsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchActiveAndAllMembershipsRef
    = AutoDisposeFutureProviderRef<UserActiveMembership>;
String _$fetchAllMembershipsHash() =>
    r'007d54c5bde5f6a62f26bf17d547f8dc03edea10';

/// See also [fetchAllMemberships].
@ProviderFor(fetchAllMemberships)
final fetchAllMembershipsProvider =
    AutoDisposeFutureProvider<List<MembershipModel>>.internal(
  fetchAllMemberships,
  name: r'fetchAllMembershipsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAllMembershipsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchAllMembershipsRef
    = AutoDisposeFutureProviderRef<List<MembershipModel>>;
String _$fetchMembershipCategoryHash() =>
    r'af162354acb772960d85b39f152671a69e1c72c5';

/// See also [fetchMembershipCategory].
@ProviderFor(fetchMembershipCategory)
final fetchMembershipCategoryProvider =
    AutoDisposeFutureProvider<List<MembershipCategory>>.internal(
  fetchMembershipCategory,
  name: r'fetchMembershipCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchMembershipCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchMembershipCategoryRef
    = AutoDisposeFutureProviderRef<List<MembershipCategory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
