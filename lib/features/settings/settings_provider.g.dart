// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'3a9f8412df34c1653d08100c9826aa2125b80f7f';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$exportServiceHash() => r'edc220eae2ce95c4525795c2a7cb863536d31d1f';

/// See also [exportService].
@ProviderFor(exportService)
final exportServiceProvider = AutoDisposeProvider<ExportService>.internal(
  exportService,
  name: r'exportServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exportServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExportServiceRef = AutoDisposeProviderRef<ExportService>;
String _$importServiceHash() => r'd5536644891057063edbc6aa341b3be6ff707b7e';

/// See also [importService].
@ProviderFor(importService)
final importServiceProvider = AutoDisposeProvider<ImportService>.internal(
  importService,
  name: r'importServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$importServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ImportServiceRef = AutoDisposeProviderRef<ImportService>;
String _$appThemeModeHash() => r'e045bd08cd187a1f26aabd83ad24d303a9a6659b';

/// See also [AppThemeMode].
@ProviderFor(AppThemeMode)
final appThemeModeProvider = NotifierProvider<AppThemeMode, ThemeMode>.internal(
  AppThemeMode.new,
  name: r'appThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppThemeMode = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
