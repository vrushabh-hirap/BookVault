// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookLookupServiceHash() => r'19e08119d4df50d1c52bfc3f1b4187e12bfc2f2e';

/// See also [bookLookupService].
@ProviderFor(bookLookupService)
final bookLookupServiceProvider =
    AutoDisposeProvider<BookLookupService>.internal(
      bookLookupService,
      name: r'bookLookupServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookLookupServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookLookupServiceRef = AutoDisposeProviderRef<BookLookupService>;
String _$scannerStateHash() => r'27b24b8c840dcd0a6ad3aee5e0f7b8b19ec9016f';

/// See also [ScannerState].
@ProviderFor(ScannerState)
final scannerStateProvider =
    AutoDisposeNotifierProvider<ScannerState, ScannerStateData>.internal(
      ScannerState.new,
      name: r'scannerStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scannerStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScannerState = AutoDisposeNotifier<ScannerStateData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
