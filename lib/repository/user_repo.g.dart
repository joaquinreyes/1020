// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepoHash() => r'97ad17a1d489e0d3aa8886512915644a524a1af8';

/// See also [authRepo].
@ProviderFor(authRepo)
final authRepoProvider = Provider<AuthRepo>.internal(
  authRepo,
  name: r'authRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepoRef = ProviderRef<AuthRepo>;
String _$loginUserHash() => r'6dcd9ab5ca307bef7e553297319ad86a440d88db';

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

/// See also [loginUser].
@ProviderFor(loginUser)
const loginUserProvider = LoginUserFamily();

/// See also [loginUser].
class LoginUserFamily extends Family {
  /// See also [loginUser].
  const LoginUserFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'loginUserProvider';

  /// See also [loginUser].
  LoginUserProvider call(
    String email,
    String password,
  ) {
    return LoginUserProvider(
      email,
      password,
    );
  }

  @visibleForOverriding
  @override
  LoginUserProvider getProviderOverride(
    covariant LoginUserProvider provider,
  ) {
    return call(
      provider.email,
      provider.password,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<AppUser?> Function(LoginUserRef ref) create) {
    return _$LoginUserFamilyOverride(this, create);
  }
}

class _$LoginUserFamilyOverride implements FamilyOverride {
  _$LoginUserFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<AppUser?> Function(LoginUserRef ref) create;

  @override
  final LoginUserFamily overriddenFamily;

  @override
  LoginUserProvider getProviderOverride(
    covariant LoginUserProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [loginUser].
class LoginUserProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [loginUser].
  LoginUserProvider(
    String email,
    String password,
  ) : this._internal(
          (ref) => loginUser(
            ref as LoginUserRef,
            email,
            password,
          ),
          from: loginUserProvider,
          name: r'loginUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginUserHash,
          dependencies: LoginUserFamily._dependencies,
          allTransitiveDependencies: LoginUserFamily._allTransitiveDependencies,
          email: email,
          password: password,
        );

  LoginUserProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
  }) : super.internal();

  final String email;
  final String password;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(LoginUserRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoginUserProvider._internal(
        (ref) => create(ref as LoginUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
      ),
    );
  }

  @override
  (
    String,
    String,
  ) get argument {
    return (
      email,
      password,
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _LoginUserProviderElement(this);
  }

  LoginUserProvider _copyWith(
    FutureOr<AppUser?> Function(LoginUserRef ref) create,
  ) {
    return LoginUserProvider._internal(
      (ref) => create(ref as LoginUserRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      email: email,
      password: password,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoginUserProvider &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoginUserRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;
}

class _LoginUserProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with LoginUserRef {
  _LoginUserProviderElement(super.provider);

  @override
  String get email => (origin as LoginUserProvider).email;
  @override
  String get password => (origin as LoginUserProvider).password;
}

String _$registerUserHash() => r'8cea4ebe62c9c7672d840412af619633db2fafdb';

/// See also [registerUser].
@ProviderFor(registerUser)
const registerUserProvider = RegisterUserFamily();

/// See also [registerUser].
class RegisterUserFamily extends Family {
  /// See also [registerUser].
  const RegisterUserFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'registerUserProvider';

  /// See also [registerUser].
  RegisterUserProvider call(
    RegisterModel model,
  ) {
    return RegisterUserProvider(
      model,
    );
  }

  @visibleForOverriding
  @override
  RegisterUserProvider getProviderOverride(
    covariant RegisterUserProvider provider,
  ) {
    return call(
      provider.model,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<AppUser?> Function(RegisterUserRef ref) create) {
    return _$RegisterUserFamilyOverride(this, create);
  }
}

class _$RegisterUserFamilyOverride implements FamilyOverride {
  _$RegisterUserFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<AppUser?> Function(RegisterUserRef ref) create;

  @override
  final RegisterUserFamily overriddenFamily;

  @override
  RegisterUserProvider getProviderOverride(
    covariant RegisterUserProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [registerUser].
class RegisterUserProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [registerUser].
  RegisterUserProvider(
    RegisterModel model,
  ) : this._internal(
          (ref) => registerUser(
            ref as RegisterUserRef,
            model,
          ),
          from: registerUserProvider,
          name: r'registerUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$registerUserHash,
          dependencies: RegisterUserFamily._dependencies,
          allTransitiveDependencies:
              RegisterUserFamily._allTransitiveDependencies,
          model: model,
        );

  RegisterUserProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.model,
  }) : super.internal();

  final RegisterModel model;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(RegisterUserRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegisterUserProvider._internal(
        (ref) => create(ref as RegisterUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        model: model,
      ),
    );
  }

  @override
  (RegisterModel,) get argument {
    return (model,);
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _RegisterUserProviderElement(this);
  }

  RegisterUserProvider _copyWith(
    FutureOr<AppUser?> Function(RegisterUserRef ref) create,
  ) {
    return RegisterUserProvider._internal(
      (ref) => create(ref as RegisterUserRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      model: model,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RegisterUserProvider && other.model == model;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, model.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RegisterUserRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `model` of this provider.
  RegisterModel get model;
}

class _RegisterUserProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with RegisterUserRef {
  _RegisterUserProviderElement(super.provider);

  @override
  RegisterModel get model => (origin as RegisterUserProvider).model;
}

String _$fetchUserHash() => r'099ebf003f1ab6676e312af39803bde0a7e5b1cd';

/// See also [fetchUser].
@ProviderFor(fetchUser)
final fetchUserProvider = FutureProvider<bool>.internal(
  fetchUser,
  name: r'fetchUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchUserRef = FutureProviderRef<bool>;
String _$updateUserHash() => r'6e09f6c67347edcae1e39a038ca65cc663905c9c';

/// See also [updateUser].
@ProviderFor(updateUser)
const updateUserProvider = UpdateUserFamily();

/// See also [updateUser].
class UpdateUserFamily extends Family {
  /// See also [updateUser].
  const UpdateUserFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateUserProvider';

  /// See also [updateUser].
  UpdateUserProvider call(
    User user,
  ) {
    return UpdateUserProvider(
      user,
    );
  }

  @visibleForOverriding
  @override
  UpdateUserProvider getProviderOverride(
    covariant UpdateUserProvider provider,
  ) {
    return call(
      provider.user,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(UpdateUserRef ref) create) {
    return _$UpdateUserFamilyOverride(this, create);
  }
}

class _$UpdateUserFamilyOverride implements FamilyOverride {
  _$UpdateUserFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(UpdateUserRef ref) create;

  @override
  final UpdateUserFamily overriddenFamily;

  @override
  UpdateUserProvider getProviderOverride(
    covariant UpdateUserProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [updateUser].
class UpdateUserProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updateUser].
  UpdateUserProvider(
    User user,
  ) : this._internal(
          (ref) => updateUser(
            ref as UpdateUserRef,
            user,
          ),
          from: updateUserProvider,
          name: r'updateUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateUserHash,
          dependencies: UpdateUserFamily._dependencies,
          allTransitiveDependencies:
              UpdateUserFamily._allTransitiveDependencies,
          user: user,
        );

  UpdateUserProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.user,
  }) : super.internal();

  final User user;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdateUserRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateUserProvider._internal(
        (ref) => create(ref as UpdateUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        user: user,
      ),
    );
  }

  @override
  (User,) get argument {
    return (user,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdateUserProviderElement(this);
  }

  UpdateUserProvider _copyWith(
    FutureOr<bool> Function(UpdateUserRef ref) create,
  ) {
    return UpdateUserProvider._internal(
      (ref) => create(ref as UpdateUserRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      user: user,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateUserProvider && other.user == user;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateUserRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `user` of this provider.
  User get user;
}

class _UpdateUserProviderElement extends AutoDisposeFutureProviderElement<bool>
    with UpdateUserRef {
  _UpdateUserProviderElement(super.provider);

  @override
  User get user => (origin as UpdateUserProvider).user;
}

String _$updateProfileHash() => r'13c111f47f5d8cb7ef253793fe3f802821901f78';

/// See also [updateProfile].
@ProviderFor(updateProfile)
const updateProfileProvider = UpdateProfileFamily();

/// See also [updateProfile].
class UpdateProfileFamily extends Family {
  /// See also [updateProfile].
  const UpdateProfileFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateProfileProvider';

  /// See also [updateProfile].
  UpdateProfileProvider call(
    File? file,
  ) {
    return UpdateProfileProvider(
      file,
    );
  }

  @visibleForOverriding
  @override
  UpdateProfileProvider getProviderOverride(
    covariant UpdateProfileProvider provider,
  ) {
    return call(
      provider.file,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(UpdateProfileRef ref) create) {
    return _$UpdateProfileFamilyOverride(this, create);
  }
}

class _$UpdateProfileFamilyOverride implements FamilyOverride {
  _$UpdateProfileFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(UpdateProfileRef ref) create;

  @override
  final UpdateProfileFamily overriddenFamily;

  @override
  UpdateProfileProvider getProviderOverride(
    covariant UpdateProfileProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [updateProfile].
class UpdateProfileProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updateProfile].
  UpdateProfileProvider(
    File? file,
  ) : this._internal(
          (ref) => updateProfile(
            ref as UpdateProfileRef,
            file,
          ),
          from: updateProfileProvider,
          name: r'updateProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateProfileHash,
          dependencies: UpdateProfileFamily._dependencies,
          allTransitiveDependencies:
              UpdateProfileFamily._allTransitiveDependencies,
          file: file,
        );

  UpdateProfileProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
  }) : super.internal();

  final File? file;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdateProfileRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateProfileProvider._internal(
        (ref) => create(ref as UpdateProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
      ),
    );
  }

  @override
  (File?,) get argument {
    return (file,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdateProfileProviderElement(this);
  }

  UpdateProfileProvider _copyWith(
    FutureOr<bool> Function(UpdateProfileRef ref) create,
  ) {
    return UpdateProfileProvider._internal(
      (ref) => create(ref as UpdateProfileRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      file: file,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProfileProvider && other.file == file;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateProfileRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `file` of this provider.
  File? get file;
}

class _UpdateProfileProviderElement
    extends AutoDisposeFutureProviderElement<bool> with UpdateProfileRef {
  _UpdateProfileProviderElement(super.provider);

  @override
  File? get file => (origin as UpdateProfileProvider).file;
}

String _$fetchAllCustomFieldsHash() =>
    r'98d9db596e582cbfee0285f28102e09a2d6f9ed7';

/// See also [fetchAllCustomFields].
@ProviderFor(fetchAllCustomFields)
final fetchAllCustomFieldsProvider =
    FutureProvider<List<CustomFields>>.internal(
  fetchAllCustomFields,
  name: r'fetchAllCustomFieldsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAllCustomFieldsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchAllCustomFieldsRef = FutureProviderRef<List<CustomFields>>;
String _$updatePictureAndUserHash() =>
    r'8de00c895ae4c370f698f5a2f1f61d29304aa1d9';

/// See also [updatePictureAndUser].
@ProviderFor(updatePictureAndUser)
const updatePictureAndUserProvider = UpdatePictureAndUserFamily();

/// See also [updatePictureAndUser].
class UpdatePictureAndUserFamily extends Family {
  /// See also [updatePictureAndUser].
  const UpdatePictureAndUserFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updatePictureAndUserProvider';

  /// See also [updatePictureAndUser].
  UpdatePictureAndUserProvider call(
    File? file,
    User user,
  ) {
    return UpdatePictureAndUserProvider(
      file,
      user,
    );
  }

  @visibleForOverriding
  @override
  UpdatePictureAndUserProvider getProviderOverride(
    covariant UpdatePictureAndUserProvider provider,
  ) {
    return call(
      provider.file,
      provider.user,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<(bool?, bool?)> Function(UpdatePictureAndUserRef ref) create) {
    return _$UpdatePictureAndUserFamilyOverride(this, create);
  }
}

class _$UpdatePictureAndUserFamilyOverride implements FamilyOverride {
  _$UpdatePictureAndUserFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<(bool?, bool?)> Function(UpdatePictureAndUserRef ref) create;

  @override
  final UpdatePictureAndUserFamily overriddenFamily;

  @override
  UpdatePictureAndUserProvider getProviderOverride(
    covariant UpdatePictureAndUserProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [updatePictureAndUser].
class UpdatePictureAndUserProvider
    extends AutoDisposeFutureProvider<(bool?, bool?)> {
  /// See also [updatePictureAndUser].
  UpdatePictureAndUserProvider(
    File? file,
    User user,
  ) : this._internal(
          (ref) => updatePictureAndUser(
            ref as UpdatePictureAndUserRef,
            file,
            user,
          ),
          from: updatePictureAndUserProvider,
          name: r'updatePictureAndUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updatePictureAndUserHash,
          dependencies: UpdatePictureAndUserFamily._dependencies,
          allTransitiveDependencies:
              UpdatePictureAndUserFamily._allTransitiveDependencies,
          file: file,
          user: user,
        );

  UpdatePictureAndUserProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
    required this.user,
  }) : super.internal();

  final File? file;
  final User user;

  @override
  Override overrideWith(
    FutureOr<(bool?, bool?)> Function(UpdatePictureAndUserRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdatePictureAndUserProvider._internal(
        (ref) => create(ref as UpdatePictureAndUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
        user: user,
      ),
    );
  }

  @override
  (
    File?,
    User,
  ) get argument {
    return (
      file,
      user,
    );
  }

  @override
  AutoDisposeFutureProviderElement<(bool?, bool?)> createElement() {
    return _UpdatePictureAndUserProviderElement(this);
  }

  UpdatePictureAndUserProvider _copyWith(
    FutureOr<(bool?, bool?)> Function(UpdatePictureAndUserRef ref) create,
  ) {
    return UpdatePictureAndUserProvider._internal(
      (ref) => create(ref as UpdatePictureAndUserRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      file: file,
      user: user,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePictureAndUserProvider &&
        other.file == file &&
        other.user == user;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdatePictureAndUserRef on AutoDisposeFutureProviderRef<(bool?, bool?)> {
  /// The parameter `file` of this provider.
  File? get file;

  /// The parameter `user` of this provider.
  User get user;
}

class _UpdatePictureAndUserProviderElement
    extends AutoDisposeFutureProviderElement<(bool?, bool?)>
    with UpdatePictureAndUserRef {
  _UpdatePictureAndUserProviderElement(super.provider);

  @override
  File? get file => (origin as UpdatePictureAndUserProvider).file;
  @override
  User get user => (origin as UpdatePictureAndUserProvider).user;
}

String _$updatePasswordHash() => r'a21d921bf0443cbc9cbbdd4f3357101361896c9f';

/// See also [updatePassword].
@ProviderFor(updatePassword)
const updatePasswordProvider = UpdatePasswordFamily();

/// See also [updatePassword].
class UpdatePasswordFamily extends Family {
  /// See also [updatePassword].
  const UpdatePasswordFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updatePasswordProvider';

  /// See also [updatePassword].
  UpdatePasswordProvider call({
    required String oldPassword,
    required String newPassword,
  }) {
    return UpdatePasswordProvider(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @visibleForOverriding
  @override
  UpdatePasswordProvider getProviderOverride(
    covariant UpdatePasswordProvider provider,
  ) {
    return call(
      oldPassword: provider.oldPassword,
      newPassword: provider.newPassword,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(UpdatePasswordRef ref) create) {
    return _$UpdatePasswordFamilyOverride(this, create);
  }
}

class _$UpdatePasswordFamilyOverride implements FamilyOverride {
  _$UpdatePasswordFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(UpdatePasswordRef ref) create;

  @override
  final UpdatePasswordFamily overriddenFamily;

  @override
  UpdatePasswordProvider getProviderOverride(
    covariant UpdatePasswordProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [updatePassword].
class UpdatePasswordProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updatePassword].
  UpdatePasswordProvider({
    required String oldPassword,
    required String newPassword,
  }) : this._internal(
          (ref) => updatePassword(
            ref as UpdatePasswordRef,
            oldPassword: oldPassword,
            newPassword: newPassword,
          ),
          from: updatePasswordProvider,
          name: r'updatePasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updatePasswordHash,
          dependencies: UpdatePasswordFamily._dependencies,
          allTransitiveDependencies:
              UpdatePasswordFamily._allTransitiveDependencies,
          oldPassword: oldPassword,
          newPassword: newPassword,
        );

  UpdatePasswordProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.oldPassword,
    required this.newPassword,
  }) : super.internal();

  final String oldPassword;
  final String newPassword;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdatePasswordRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdatePasswordProvider._internal(
        (ref) => create(ref as UpdatePasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );
  }

  @override
  ({
    String oldPassword,
    String newPassword,
  }) get argument {
    return (
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdatePasswordProviderElement(this);
  }

  UpdatePasswordProvider _copyWith(
    FutureOr<bool> Function(UpdatePasswordRef ref) create,
  ) {
    return UpdatePasswordProvider._internal(
      (ref) => create(ref as UpdatePasswordRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePasswordProvider &&
        other.oldPassword == oldPassword &&
        other.newPassword == newPassword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, oldPassword.hashCode);
    hash = _SystemHash.combine(hash, newPassword.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdatePasswordRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `oldPassword` of this provider.
  String get oldPassword;

  /// The parameter `newPassword` of this provider.
  String get newPassword;
}

class _UpdatePasswordProviderElement
    extends AutoDisposeFutureProviderElement<bool> with UpdatePasswordRef {
  _UpdatePasswordProviderElement(super.provider);

  @override
  String get oldPassword => (origin as UpdatePasswordProvider).oldPassword;
  @override
  String get newPassword => (origin as UpdatePasswordProvider).newPassword;
}

String _$deleteAccountHash() => r'bbfa8a9b19d4fe69f1595787ff5a5ed24063352d';

/// See also [deleteAccount].
@ProviderFor(deleteAccount)
const deleteAccountProvider = DeleteAccountFamily();

/// See also [deleteAccount].
class DeleteAccountFamily extends Family {
  /// See also [deleteAccount].
  const DeleteAccountFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteAccountProvider';

  /// See also [deleteAccount].
  DeleteAccountProvider call({
    required String password,
  }) {
    return DeleteAccountProvider(
      password: password,
    );
  }

  @visibleForOverriding
  @override
  DeleteAccountProvider getProviderOverride(
    covariant DeleteAccountProvider provider,
  ) {
    return call(
      password: provider.password,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(DeleteAccountRef ref) create) {
    return _$DeleteAccountFamilyOverride(this, create);
  }
}

class _$DeleteAccountFamilyOverride implements FamilyOverride {
  _$DeleteAccountFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(DeleteAccountRef ref) create;

  @override
  final DeleteAccountFamily overriddenFamily;

  @override
  DeleteAccountProvider getProviderOverride(
    covariant DeleteAccountProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [deleteAccount].
class DeleteAccountProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteAccount].
  DeleteAccountProvider({
    required String password,
  }) : this._internal(
          (ref) => deleteAccount(
            ref as DeleteAccountRef,
            password: password,
          ),
          from: deleteAccountProvider,
          name: r'deleteAccountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteAccountHash,
          dependencies: DeleteAccountFamily._dependencies,
          allTransitiveDependencies:
              DeleteAccountFamily._allTransitiveDependencies,
          password: password,
        );

  DeleteAccountProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.password,
  }) : super.internal();

  final String password;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteAccountRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteAccountProvider._internal(
        (ref) => create(ref as DeleteAccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        password: password,
      ),
    );
  }

  @override
  ({
    String password,
  }) get argument {
    return (password: password,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteAccountProviderElement(this);
  }

  DeleteAccountProvider _copyWith(
    FutureOr<bool> Function(DeleteAccountRef ref) create,
  ) {
    return DeleteAccountProvider._internal(
      (ref) => create(ref as DeleteAccountRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      password: password,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteAccountProvider && other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteAccountRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `password` of this provider.
  String get password;
}

class _DeleteAccountProviderElement
    extends AutoDisposeFutureProviderElement<bool> with DeleteAccountRef {
  _DeleteAccountProviderElement(super.provider);

  @override
  String get password => (origin as DeleteAccountProvider).password;
}

String _$saveFCMTokenHash() => r'c8f3a62078ac93dde6a0be4f03bbe9de0a1fde37';

/// See also [saveFCMToken].
@ProviderFor(saveFCMToken)
const saveFCMTokenProvider = SaveFCMTokenFamily();

/// See also [saveFCMToken].
class SaveFCMTokenFamily extends Family {
  /// See also [saveFCMToken].
  const SaveFCMTokenFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveFCMTokenProvider';

  /// See also [saveFCMToken].
  SaveFCMTokenProvider call(
    String token,
  ) {
    return SaveFCMTokenProvider(
      token,
    );
  }

  @visibleForOverriding
  @override
  SaveFCMTokenProvider getProviderOverride(
    covariant SaveFCMTokenProvider provider,
  ) {
    return call(
      provider.token,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<void> Function(SaveFCMTokenRef ref) create) {
    return _$SaveFCMTokenFamilyOverride(this, create);
  }
}

class _$SaveFCMTokenFamilyOverride implements FamilyOverride {
  _$SaveFCMTokenFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<void> Function(SaveFCMTokenRef ref) create;

  @override
  final SaveFCMTokenFamily overriddenFamily;

  @override
  SaveFCMTokenProvider getProviderOverride(
    covariant SaveFCMTokenProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [saveFCMToken].
class SaveFCMTokenProvider extends AutoDisposeFutureProvider<void> {
  /// See also [saveFCMToken].
  SaveFCMTokenProvider(
    String token,
  ) : this._internal(
          (ref) => saveFCMToken(
            ref as SaveFCMTokenRef,
            token,
          ),
          from: saveFCMTokenProvider,
          name: r'saveFCMTokenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveFCMTokenHash,
          dependencies: SaveFCMTokenFamily._dependencies,
          allTransitiveDependencies:
              SaveFCMTokenFamily._allTransitiveDependencies,
          token: token,
        );

  SaveFCMTokenProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveFCMTokenRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveFCMTokenProvider._internal(
        (ref) => create(ref as SaveFCMTokenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  (String,) get argument {
    return (token,);
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveFCMTokenProviderElement(this);
  }

  SaveFCMTokenProvider _copyWith(
    FutureOr<void> Function(SaveFCMTokenRef ref) create,
  ) {
    return SaveFCMTokenProvider._internal(
      (ref) => create(ref as SaveFCMTokenRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      token: token,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SaveFCMTokenProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SaveFCMTokenRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `token` of this provider.
  String get token;
}

class _SaveFCMTokenProviderElement
    extends AutoDisposeFutureProviderElement<void> with SaveFCMTokenRef {
  _SaveFCMTokenProviderElement(super.provider);

  @override
  String get token => (origin as SaveFCMTokenProvider).token;
}

String _$recoverPasswordHash() => r'000818da027fa41325fb9bcc7f8c384808f0bc06';

/// See also [recoverPassword].
@ProviderFor(recoverPassword)
const recoverPasswordProvider = RecoverPasswordFamily();

/// See also [recoverPassword].
class RecoverPasswordFamily extends Family {
  /// See also [recoverPassword].
  const RecoverPasswordFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recoverPasswordProvider';

  /// See also [recoverPassword].
  RecoverPasswordProvider call(
    String email,
  ) {
    return RecoverPasswordProvider(
      email,
    );
  }

  @visibleForOverriding
  @override
  RecoverPasswordProvider getProviderOverride(
    covariant RecoverPasswordProvider provider,
  ) {
    return call(
      provider.email,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<bool?> Function(RecoverPasswordRef ref) create) {
    return _$RecoverPasswordFamilyOverride(this, create);
  }
}

class _$RecoverPasswordFamilyOverride implements FamilyOverride {
  _$RecoverPasswordFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool?> Function(RecoverPasswordRef ref) create;

  @override
  final RecoverPasswordFamily overriddenFamily;

  @override
  RecoverPasswordProvider getProviderOverride(
    covariant RecoverPasswordProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [recoverPassword].
class RecoverPasswordProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [recoverPassword].
  RecoverPasswordProvider(
    String email,
  ) : this._internal(
          (ref) => recoverPassword(
            ref as RecoverPasswordRef,
            email,
          ),
          from: recoverPasswordProvider,
          name: r'recoverPasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recoverPasswordHash,
          dependencies: RecoverPasswordFamily._dependencies,
          allTransitiveDependencies:
              RecoverPasswordFamily._allTransitiveDependencies,
          email: email,
        );

  RecoverPasswordProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String email;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(RecoverPasswordRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoverPasswordProvider._internal(
        (ref) => create(ref as RecoverPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  (String,) get argument {
    return (email,);
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _RecoverPasswordProviderElement(this);
  }

  RecoverPasswordProvider _copyWith(
    FutureOr<bool?> Function(RecoverPasswordRef ref) create,
  ) {
    return RecoverPasswordProvider._internal(
      (ref) => create(ref as RecoverPasswordRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      email: email,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecoverPasswordProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecoverPasswordRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `email` of this provider.
  String get email;
}

class _RecoverPasswordProviderElement
    extends AutoDisposeFutureProviderElement<bool?> with RecoverPasswordRef {
  _RecoverPasswordProviderElement(super.provider);

  @override
  String get email => (origin as RecoverPasswordProvider).email;
}

String _$updateRecoveryPasswordHash() =>
    r'aca845866de76a720bea59f5d06e52538652841e';

/// See also [updateRecoveryPassword].
@ProviderFor(updateRecoveryPassword)
const updateRecoveryPasswordProvider = UpdateRecoveryPasswordFamily();

/// See also [updateRecoveryPassword].
class UpdateRecoveryPasswordFamily extends Family {
  /// See also [updateRecoveryPassword].
  const UpdateRecoveryPasswordFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateRecoveryPasswordProvider';

  /// See also [updateRecoveryPassword].
  UpdateRecoveryPasswordProvider call({
    required String email,
    required String password,
    required String token,
  }) {
    return UpdateRecoveryPasswordProvider(
      email: email,
      password: password,
      token: token,
    );
  }

  @visibleForOverriding
  @override
  UpdateRecoveryPasswordProvider getProviderOverride(
    covariant UpdateRecoveryPasswordProvider provider,
  ) {
    return call(
      email: provider.email,
      password: provider.password,
      token: provider.token,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<bool?> Function(UpdateRecoveryPasswordRef ref) create) {
    return _$UpdateRecoveryPasswordFamilyOverride(this, create);
  }
}

class _$UpdateRecoveryPasswordFamilyOverride implements FamilyOverride {
  _$UpdateRecoveryPasswordFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool?> Function(UpdateRecoveryPasswordRef ref) create;

  @override
  final UpdateRecoveryPasswordFamily overriddenFamily;

  @override
  UpdateRecoveryPasswordProvider getProviderOverride(
    covariant UpdateRecoveryPasswordProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [updateRecoveryPassword].
class UpdateRecoveryPasswordProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [updateRecoveryPassword].
  UpdateRecoveryPasswordProvider({
    required String email,
    required String password,
    required String token,
  }) : this._internal(
          (ref) => updateRecoveryPassword(
            ref as UpdateRecoveryPasswordRef,
            email: email,
            password: password,
            token: token,
          ),
          from: updateRecoveryPasswordProvider,
          name: r'updateRecoveryPasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateRecoveryPasswordHash,
          dependencies: UpdateRecoveryPasswordFamily._dependencies,
          allTransitiveDependencies:
              UpdateRecoveryPasswordFamily._allTransitiveDependencies,
          email: email,
          password: password,
          token: token,
        );

  UpdateRecoveryPasswordProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
    required this.token,
  }) : super.internal();

  final String email;
  final String password;
  final String token;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(UpdateRecoveryPasswordRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateRecoveryPasswordProvider._internal(
        (ref) => create(ref as UpdateRecoveryPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
        token: token,
      ),
    );
  }

  @override
  ({
    String email,
    String password,
    String token,
  }) get argument {
    return (
      email: email,
      password: password,
      token: token,
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _UpdateRecoveryPasswordProviderElement(this);
  }

  UpdateRecoveryPasswordProvider _copyWith(
    FutureOr<bool?> Function(UpdateRecoveryPasswordRef ref) create,
  ) {
    return UpdateRecoveryPasswordProvider._internal(
      (ref) => create(ref as UpdateRecoveryPasswordRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      email: email,
      password: password,
      token: token,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateRecoveryPasswordProvider &&
        other.email == email &&
        other.password == password &&
        other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateRecoveryPasswordRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;

  /// The parameter `token` of this provider.
  String get token;
}

class _UpdateRecoveryPasswordProviderElement
    extends AutoDisposeFutureProviderElement<bool?>
    with UpdateRecoveryPasswordRef {
  _UpdateRecoveryPasswordProviderElement(super.provider);

  @override
  String get email => (origin as UpdateRecoveryPasswordProvider).email;
  @override
  String get password => (origin as UpdateRecoveryPasswordProvider).password;
  @override
  String get token => (origin as UpdateRecoveryPasswordProvider).token;
}

String _$fetchUserAssessmentHash() =>
    r'771f158811b7bbbe45afa475e197b06c56cf9d59';

/// See also [fetchUserAssessment].
@ProviderFor(fetchUserAssessment)
const fetchUserAssessmentProvider = FetchUserAssessmentFamily();

/// See also [fetchUserAssessment].
class FetchUserAssessmentFamily extends Family {
  /// See also [fetchUserAssessment].
  const FetchUserAssessmentFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchUserAssessmentProvider';

  /// See also [fetchUserAssessment].
  FetchUserAssessmentProvider call({
    required int id,
  }) {
    return FetchUserAssessmentProvider(
      id: id,
    );
  }

  @visibleForOverriding
  @override
  FetchUserAssessmentProvider getProviderOverride(
    covariant FetchUserAssessmentProvider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<UserAssessment> Function(FetchUserAssessmentRef ref) create) {
    return _$FetchUserAssessmentFamilyOverride(this, create);
  }
}

class _$FetchUserAssessmentFamilyOverride implements FamilyOverride {
  _$FetchUserAssessmentFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<UserAssessment> Function(FetchUserAssessmentRef ref) create;

  @override
  final FetchUserAssessmentFamily overriddenFamily;

  @override
  FetchUserAssessmentProvider getProviderOverride(
    covariant FetchUserAssessmentProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchUserAssessment].
class FetchUserAssessmentProvider
    extends AutoDisposeFutureProvider<UserAssessment> {
  /// See also [fetchUserAssessment].
  FetchUserAssessmentProvider({
    required int id,
  }) : this._internal(
          (ref) => fetchUserAssessment(
            ref as FetchUserAssessmentRef,
            id: id,
          ),
          from: fetchUserAssessmentProvider,
          name: r'fetchUserAssessmentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserAssessmentHash,
          dependencies: FetchUserAssessmentFamily._dependencies,
          allTransitiveDependencies:
              FetchUserAssessmentFamily._allTransitiveDependencies,
          id: id,
        );

  FetchUserAssessmentProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<UserAssessment> Function(FetchUserAssessmentRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserAssessmentProvider._internal(
        (ref) => create(ref as FetchUserAssessmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  ({
    int id,
  }) get argument {
    return (id: id,);
  }

  @override
  AutoDisposeFutureProviderElement<UserAssessment> createElement() {
    return _FetchUserAssessmentProviderElement(this);
  }

  FetchUserAssessmentProvider _copyWith(
    FutureOr<UserAssessment> Function(FetchUserAssessmentRef ref) create,
  ) {
    return FetchUserAssessmentProvider._internal(
      (ref) => create(ref as FetchUserAssessmentRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      id: id,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserAssessmentProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserAssessmentRef on AutoDisposeFutureProviderRef<UserAssessment> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FetchUserAssessmentProviderElement
    extends AutoDisposeFutureProviderElement<UserAssessment>
    with FetchUserAssessmentRef {
  _FetchUserAssessmentProviderElement(super.provider);

  @override
  int get id => (origin as FetchUserAssessmentProvider).id;
}

String _$walletInfoHash() => r'b85e22a85700e433b87e7cbb00baacfdf2b91677';

/// See also [walletInfo].
@ProviderFor(walletInfo)
final walletInfoProvider = AutoDisposeFutureProvider<List<WalletInfo>>.internal(
  walletInfo,
  name: r'walletInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$walletInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WalletInfoRef = AutoDisposeFutureProviderRef<List<WalletInfo>>;
String _$transactionsHash() => r'14397e550e14e09358c2d9caef1aedaae2c241cc';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeFutureProvider<List<TransactionModel>>.internal(
  transactions,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransactionsRef = AutoDisposeFutureProviderRef<List<TransactionModel>>;
String _$fetchPlayersRankingHash() =>
    r'a9faaa488e7be6f072ad6e7c02bb882b1ec48922';

/// See also [fetchPlayersRanking].
@ProviderFor(fetchPlayersRanking)
const fetchPlayersRankingProvider = FetchPlayersRankingFamily();

/// See also [fetchPlayersRanking].
class FetchPlayersRankingFamily extends Family {
  /// See also [fetchPlayersRanking].
  const FetchPlayersRankingFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchPlayersRankingProvider';

  /// See also [fetchPlayersRanking].
  FetchPlayersRankingProvider call({
    required int page,
    required int limit,
    required String sportName,
  }) {
    return FetchPlayersRankingProvider(
      page: page,
      limit: limit,
      sportName: sportName,
    );
  }

  @visibleForOverriding
  @override
  FetchPlayersRankingProvider getProviderOverride(
    covariant FetchPlayersRankingProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      sportName: provider.sportName,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<PlayersRanking> Function(FetchPlayersRankingRef ref) create) {
    return _$FetchPlayersRankingFamilyOverride(this, create);
  }
}

class _$FetchPlayersRankingFamilyOverride implements FamilyOverride {
  _$FetchPlayersRankingFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<PlayersRanking> Function(FetchPlayersRankingRef ref) create;

  @override
  final FetchPlayersRankingFamily overriddenFamily;

  @override
  FetchPlayersRankingProvider getProviderOverride(
    covariant FetchPlayersRankingProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchPlayersRanking].
class FetchPlayersRankingProvider
    extends AutoDisposeFutureProvider<PlayersRanking> {
  /// See also [fetchPlayersRanking].
  FetchPlayersRankingProvider({
    required int page,
    required int limit,
    required String sportName,
  }) : this._internal(
          (ref) => fetchPlayersRanking(
            ref as FetchPlayersRankingRef,
            page: page,
            limit: limit,
            sportName: sportName,
          ),
          from: fetchPlayersRankingProvider,
          name: r'fetchPlayersRankingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPlayersRankingHash,
          dependencies: FetchPlayersRankingFamily._dependencies,
          allTransitiveDependencies:
              FetchPlayersRankingFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          sportName: sportName,
        );

  FetchPlayersRankingProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.sportName,
  }) : super.internal();

  final int page;
  final int limit;
  final String sportName;

  @override
  Override overrideWith(
    FutureOr<PlayersRanking> Function(FetchPlayersRankingRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPlayersRankingProvider._internal(
        (ref) => create(ref as FetchPlayersRankingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        sportName: sportName,
      ),
    );
  }

  @override
  ({
    int page,
    int limit,
    String sportName,
  }) get argument {
    return (
      page: page,
      limit: limit,
      sportName: sportName,
    );
  }

  @override
  AutoDisposeFutureProviderElement<PlayersRanking> createElement() {
    return _FetchPlayersRankingProviderElement(this);
  }

  FetchPlayersRankingProvider _copyWith(
    FutureOr<PlayersRanking> Function(FetchPlayersRankingRef ref) create,
  ) {
    return FetchPlayersRankingProvider._internal(
      (ref) => create(ref as FetchPlayersRankingRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      page: page,
      limit: limit,
      sportName: sportName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPlayersRankingProvider &&
        other.page == page &&
        other.limit == limit &&
        other.sportName == sportName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, sportName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPlayersRankingRef on AutoDisposeFutureProviderRef<PlayersRanking> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `sportName` of this provider.
  String get sportName;
}

class _FetchPlayersRankingProviderElement
    extends AutoDisposeFutureProviderElement<PlayersRanking>
    with FetchPlayersRankingRef {
  _FetchPlayersRankingProviderElement(super.provider);

  @override
  int get page => (origin as FetchPlayersRankingProvider).page;
  @override
  int get limit => (origin as FetchPlayersRankingProvider).limit;
  @override
  String get sportName => (origin as FetchPlayersRankingProvider).sportName;
}

String _$getUserMatchLevelsHash() =>
    r'fd50693f9e6c4acc846e26c23f655ec3a5bb2901';

/// See also [getUserMatchLevels].
@ProviderFor(getUserMatchLevels)
const getUserMatchLevelsProvider = GetUserMatchLevelsFamily();

/// See also [getUserMatchLevels].
class GetUserMatchLevelsFamily extends Family {
  /// See also [getUserMatchLevels].
  const GetUserMatchLevelsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getUserMatchLevelsProvider';

  /// See also [getUserMatchLevels].
  GetUserMatchLevelsProvider call({
    required int userId,
    required int matchNumber,
    required String sportName,
  }) {
    return GetUserMatchLevelsProvider(
      userId: userId,
      matchNumber: matchNumber,
      sportName: sportName,
    );
  }

  @visibleForOverriding
  @override
  GetUserMatchLevelsProvider getProviderOverride(
    covariant GetUserMatchLevelsProvider provider,
  ) {
    return call(
      userId: provider.userId,
      matchNumber: provider.matchNumber,
      sportName: provider.sportName,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<MatchLevel>> Function(GetUserMatchLevelsRef ref) create) {
    return _$GetUserMatchLevelsFamilyOverride(this, create);
  }
}

class _$GetUserMatchLevelsFamilyOverride implements FamilyOverride {
  _$GetUserMatchLevelsFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<MatchLevel>> Function(GetUserMatchLevelsRef ref) create;

  @override
  final GetUserMatchLevelsFamily overriddenFamily;

  @override
  GetUserMatchLevelsProvider getProviderOverride(
    covariant GetUserMatchLevelsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [getUserMatchLevels].
class GetUserMatchLevelsProvider
    extends AutoDisposeFutureProvider<List<MatchLevel>> {
  /// See also [getUserMatchLevels].
  GetUserMatchLevelsProvider({
    required int userId,
    required int matchNumber,
    required String sportName,
  }) : this._internal(
          (ref) => getUserMatchLevels(
            ref as GetUserMatchLevelsRef,
            userId: userId,
            matchNumber: matchNumber,
            sportName: sportName,
          ),
          from: getUserMatchLevelsProvider,
          name: r'getUserMatchLevelsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserMatchLevelsHash,
          dependencies: GetUserMatchLevelsFamily._dependencies,
          allTransitiveDependencies:
              GetUserMatchLevelsFamily._allTransitiveDependencies,
          userId: userId,
          matchNumber: matchNumber,
          sportName: sportName,
        );

  GetUserMatchLevelsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.matchNumber,
    required this.sportName,
  }) : super.internal();

  final int userId;
  final int matchNumber;
  final String sportName;

  @override
  Override overrideWith(
    FutureOr<List<MatchLevel>> Function(GetUserMatchLevelsRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserMatchLevelsProvider._internal(
        (ref) => create(ref as GetUserMatchLevelsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        matchNumber: matchNumber,
        sportName: sportName,
      ),
    );
  }

  @override
  ({
    int userId,
    int matchNumber,
    String sportName,
  }) get argument {
    return (
      userId: userId,
      matchNumber: matchNumber,
      sportName: sportName,
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MatchLevel>> createElement() {
    return _GetUserMatchLevelsProviderElement(this);
  }

  GetUserMatchLevelsProvider _copyWith(
    FutureOr<List<MatchLevel>> Function(GetUserMatchLevelsRef ref) create,
  ) {
    return GetUserMatchLevelsProvider._internal(
      (ref) => create(ref as GetUserMatchLevelsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
      matchNumber: matchNumber,
      sportName: sportName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserMatchLevelsProvider &&
        other.userId == userId &&
        other.matchNumber == matchNumber &&
        other.sportName == sportName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, matchNumber.hashCode);
    hash = _SystemHash.combine(hash, sportName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetUserMatchLevelsRef on AutoDisposeFutureProviderRef<List<MatchLevel>> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `matchNumber` of this provider.
  int get matchNumber;

  /// The parameter `sportName` of this provider.
  String get sportName;
}

class _GetUserMatchLevelsProviderElement
    extends AutoDisposeFutureProviderElement<List<MatchLevel>>
    with GetUserMatchLevelsRef {
  _GetUserMatchLevelsProviderElement(super.provider);

  @override
  int get userId => (origin as GetUserMatchLevelsProvider).userId;
  @override
  int get matchNumber => (origin as GetUserMatchLevelsProvider).matchNumber;
  @override
  String get sportName => (origin as GetUserMatchLevelsProvider).sportName;
}

String _$followFriendHash() => r'55162549fff7b37644a7d33dd835cb9905be9a0e';

/// See also [followFriend].
@ProviderFor(followFriend)
const followFriendProvider = FollowFriendFamily();

/// See also [followFriend].
class FollowFriendFamily extends Family {
  /// See also [followFriend].
  const FollowFriendFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'followFriendProvider';

  /// See also [followFriend].
  FollowFriendProvider call({
    required int userId,
  }) {
    return FollowFriendProvider(
      userId: userId,
    );
  }

  @visibleForOverriding
  @override
  FollowFriendProvider getProviderOverride(
    covariant FollowFriendProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(FollowFriendRef ref) create) {
    return _$FollowFriendFamilyOverride(this, create);
  }
}

class _$FollowFriendFamilyOverride implements FamilyOverride {
  _$FollowFriendFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(FollowFriendRef ref) create;

  @override
  final FollowFriendFamily overriddenFamily;

  @override
  FollowFriendProvider getProviderOverride(
    covariant FollowFriendProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [followFriend].
class FollowFriendProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [followFriend].
  FollowFriendProvider({
    required int userId,
  }) : this._internal(
          (ref) => followFriend(
            ref as FollowFriendRef,
            userId: userId,
          ),
          from: followFriendProvider,
          name: r'followFriendProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followFriendHash,
          dependencies: FollowFriendFamily._dependencies,
          allTransitiveDependencies:
              FollowFriendFamily._allTransitiveDependencies,
          userId: userId,
        );

  FollowFriendProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(FollowFriendRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowFriendProvider._internal(
        (ref) => create(ref as FollowFriendRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  ({
    int userId,
  }) get argument {
    return (userId: userId,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _FollowFriendProviderElement(this);
  }

  FollowFriendProvider _copyWith(
    FutureOr<bool> Function(FollowFriendRef ref) create,
  ) {
    return FollowFriendProvider._internal(
      (ref) => create(ref as FollowFriendRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FollowFriendProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowFriendRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _FollowFriendProviderElement
    extends AutoDisposeFutureProviderElement<bool> with FollowFriendRef {
  _FollowFriendProviderElement(super.provider);

  @override
  int get userId => (origin as FollowFriendProvider).userId;
}

String _$unfollowFriendHash() => r'ddd097f34a5d2b66ab8deb0028d31919ea068039';

/// See also [unfollowFriend].
@ProviderFor(unfollowFriend)
const unfollowFriendProvider = UnfollowFriendFamily();

/// See also [unfollowFriend].
class UnfollowFriendFamily extends Family {
  /// See also [unfollowFriend].
  const UnfollowFriendFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'unfollowFriendProvider';

  /// See also [unfollowFriend].
  UnfollowFriendProvider call({
    required int userId,
  }) {
    return UnfollowFriendProvider(
      userId: userId,
    );
  }

  @visibleForOverriding
  @override
  UnfollowFriendProvider getProviderOverride(
    covariant UnfollowFriendProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<bool> Function(UnfollowFriendRef ref) create) {
    return _$UnfollowFriendFamilyOverride(this, create);
  }
}

class _$UnfollowFriendFamilyOverride implements FamilyOverride {
  _$UnfollowFriendFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(UnfollowFriendRef ref) create;

  @override
  final UnfollowFriendFamily overriddenFamily;

  @override
  UnfollowFriendProvider getProviderOverride(
    covariant UnfollowFriendProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [unfollowFriend].
class UnfollowFriendProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [unfollowFriend].
  UnfollowFriendProvider({
    required int userId,
  }) : this._internal(
          (ref) => unfollowFriend(
            ref as UnfollowFriendRef,
            userId: userId,
          ),
          from: unfollowFriendProvider,
          name: r'unfollowFriendProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$unfollowFriendHash,
          dependencies: UnfollowFriendFamily._dependencies,
          allTransitiveDependencies:
              UnfollowFriendFamily._allTransitiveDependencies,
          userId: userId,
        );

  UnfollowFriendProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UnfollowFriendRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UnfollowFriendProvider._internal(
        (ref) => create(ref as UnfollowFriendRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  ({
    int userId,
  }) get argument {
    return (userId: userId,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UnfollowFriendProviderElement(this);
  }

  UnfollowFriendProvider _copyWith(
    FutureOr<bool> Function(UnfollowFriendRef ref) create,
  ) {
    return UnfollowFriendProvider._internal(
      (ref) => create(ref as UnfollowFriendRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnfollowFriendProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UnfollowFriendRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _UnfollowFriendProviderElement
    extends AutoDisposeFutureProviderElement<bool> with UnfollowFriendRef {
  _UnfollowFriendProviderElement(super.provider);

  @override
  int get userId => (origin as UnfollowFriendProvider).userId;
}

String _$checkFollowStatusHash() => r'db4865808980d7ac6b32ca63112e2255c3582699';

/// See also [checkFollowStatus].
@ProviderFor(checkFollowStatus)
const checkFollowStatusProvider = CheckFollowStatusFamily();

/// See also [checkFollowStatus].
class CheckFollowStatusFamily extends Family {
  /// See also [checkFollowStatus].
  const CheckFollowStatusFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'checkFollowStatusProvider';

  /// See also [checkFollowStatus].
  CheckFollowStatusProvider call({
    required int userId,
  }) {
    return CheckFollowStatusProvider(
      userId: userId,
    );
  }

  @visibleForOverriding
  @override
  CheckFollowStatusProvider getProviderOverride(
    covariant CheckFollowStatusProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<bool> Function(CheckFollowStatusRef ref) create) {
    return _$CheckFollowStatusFamilyOverride(this, create);
  }
}

class _$CheckFollowStatusFamilyOverride implements FamilyOverride {
  _$CheckFollowStatusFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<bool> Function(CheckFollowStatusRef ref) create;

  @override
  final CheckFollowStatusFamily overriddenFamily;

  @override
  CheckFollowStatusProvider getProviderOverride(
    covariant CheckFollowStatusProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [checkFollowStatus].
class CheckFollowStatusProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [checkFollowStatus].
  CheckFollowStatusProvider({
    required int userId,
  }) : this._internal(
          (ref) => checkFollowStatus(
            ref as CheckFollowStatusRef,
            userId: userId,
          ),
          from: checkFollowStatusProvider,
          name: r'checkFollowStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkFollowStatusHash,
          dependencies: CheckFollowStatusFamily._dependencies,
          allTransitiveDependencies:
              CheckFollowStatusFamily._allTransitiveDependencies,
          userId: userId,
        );

  CheckFollowStatusProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CheckFollowStatusRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckFollowStatusProvider._internal(
        (ref) => create(ref as CheckFollowStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  ({
    int userId,
  }) get argument {
    return (userId: userId,);
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CheckFollowStatusProviderElement(this);
  }

  CheckFollowStatusProvider _copyWith(
    FutureOr<bool> Function(CheckFollowStatusRef ref) create,
  ) {
    return CheckFollowStatusProvider._internal(
      (ref) => create(ref as CheckFollowStatusRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CheckFollowStatusProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CheckFollowStatusRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _CheckFollowStatusProviderElement
    extends AutoDisposeFutureProviderElement<bool> with CheckFollowStatusRef {
  _CheckFollowStatusProviderElement(super.provider);

  @override
  int get userId => (origin as CheckFollowStatusProvider).userId;
}

String _$getFollowingListHash() => r'ad5b243c0065512e926d36bbe126de02b3bb6b41';

/// See also [getFollowingList].
@ProviderFor(getFollowingList)
final getFollowingListProvider = AutoDisposeFutureProvider<FollowList>.internal(
  getFollowingList,
  name: r'getFollowingListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFollowingListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFollowingListRef = AutoDisposeFutureProviderRef<FollowList>;
String _$getFollowerListHash() => r'd9c4635b16a0d6c5148e60d8552bc3971921bc99';

/// See also [getFollowerList].
@ProviderFor(getFollowerList)
final getFollowerListProvider = AutoDisposeFutureProvider<FollowList>.internal(
  getFollowerList,
  name: r'getFollowerListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFollowerListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFollowerListRef = AutoDisposeFutureProviderRef<FollowList>;
String _$searchUsersHash() => r'650cb95d71853f79e4ff061cb7da49c954fdb84d';

/// See also [searchUsers].
@ProviderFor(searchUsers)
const searchUsersProvider = SearchUsersFamily();

/// See also [searchUsers].
class SearchUsersFamily extends Family {
  /// See also [searchUsers].
  const SearchUsersFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchUsersProvider';

  /// See also [searchUsers].
  SearchUsersProvider call({
    required int page,
    required int pageSize,
    required String search,
  }) {
    return SearchUsersProvider(
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }

  @visibleForOverriding
  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return call(
      page: provider.page,
      pageSize: provider.pageSize,
      search: provider.search,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<UserSearchResponse> Function(SearchUsersRef ref) create) {
    return _$SearchUsersFamilyOverride(this, create);
  }
}

class _$SearchUsersFamilyOverride implements FamilyOverride {
  _$SearchUsersFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<UserSearchResponse> Function(SearchUsersRef ref) create;

  @override
  final SearchUsersFamily overriddenFamily;

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [searchUsers].
class SearchUsersProvider
    extends AutoDisposeFutureProvider<UserSearchResponse> {
  /// See also [searchUsers].
  SearchUsersProvider({
    required int page,
    required int pageSize,
    required String search,
  }) : this._internal(
          (ref) => searchUsers(
            ref as SearchUsersRef,
            page: page,
            pageSize: pageSize,
            search: search,
          ),
          from: searchUsersProvider,
          name: r'searchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchUsersHash,
          dependencies: SearchUsersFamily._dependencies,
          allTransitiveDependencies:
              SearchUsersFamily._allTransitiveDependencies,
          page: page,
          pageSize: pageSize,
          search: search,
        );

  SearchUsersProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.pageSize,
    required this.search,
  }) : super.internal();

  final int page;
  final int pageSize;
  final String search;

  @override
  Override overrideWith(
    FutureOr<UserSearchResponse> Function(SearchUsersRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        (ref) => create(ref as SearchUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        pageSize: pageSize,
        search: search,
      ),
    );
  }

  @override
  ({
    int page,
    int pageSize,
    String search,
  }) get argument {
    return (
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserSearchResponse> createElement() {
    return _SearchUsersProviderElement(this);
  }

  SearchUsersProvider _copyWith(
    FutureOr<UserSearchResponse> Function(SearchUsersRef ref) create,
  ) {
    return SearchUsersProvider._internal(
      (ref) => create(ref as SearchUsersRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider &&
        other.page == page &&
        other.pageSize == pageSize &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchUsersRef on AutoDisposeFutureProviderRef<UserSearchResponse> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `pageSize` of this provider.
  int get pageSize;

  /// The parameter `search` of this provider.
  String get search;
}

class _SearchUsersProviderElement
    extends AutoDisposeFutureProviderElement<UserSearchResponse>
    with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  int get page => (origin as SearchUsersProvider).page;
  @override
  int get pageSize => (origin as SearchUsersProvider).pageSize;
  @override
  String get search => (origin as SearchUsersProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
