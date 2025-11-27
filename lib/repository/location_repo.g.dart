// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationRepoHash() => r'8c8833b6eae0f5f8516c5f835702e4d5ce535f2e';

/// See also [locationRepo].
@ProviderFor(locationRepo)
final locationRepoProvider = AutoDisposeProvider<LocationRepo>.internal(
  locationRepo,
  name: r'locationRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$locationRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationRepoRef = AutoDisposeProviderRef<LocationRepo>;
String _$fetchLocationHash() => r'3f1d050bb034379a536142da7b29341114ff7d00';

/// See also [fetchLocation].
@ProviderFor(fetchLocation)
final fetchLocationProvider = FutureProvider<Position?>.internal(
  fetchLocation,
  name: r'fetchLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchLocationRef = FutureProviderRef<Position?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
