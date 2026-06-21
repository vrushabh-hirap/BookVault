// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'105bd8a8ef41e172ff5db2d8e451479a0697fd42';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$bookListHash() => r'8327c3449e2dc913f34838ca9bc1956b5f9938e8';

/// See also [bookList].
@ProviderFor(bookList)
final bookListProvider = AutoDisposeStreamProvider<List<Book>>.internal(
  bookList,
  name: r'bookListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookListRef = AutoDisposeStreamProviderRef<List<Book>>;
String _$filteredBooksHash() => r'5cd30643d328924f28fd4ccf25f407a6c7813f2b';

/// See also [filteredBooks].
@ProviderFor(filteredBooks)
final filteredBooksProvider = AutoDisposeProvider<List<Book>>.internal(
  filteredBooks,
  name: r'filteredBooksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredBooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredBooksRef = AutoDisposeProviderRef<List<Book>>;
String _$bookFiltersHash() => r'd0e7987b03164f083da886b4e77f8e8411b65b6c';

/// See also [BookFilters].
@ProviderFor(BookFilters)
final bookFiltersProvider =
    AutoDisposeNotifierProvider<BookFilters, BookFiltersState>.internal(
      BookFilters.new,
      name: r'bookFiltersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookFiltersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookFilters = AutoDisposeNotifier<BookFiltersState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
