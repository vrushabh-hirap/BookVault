import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/db/app_database.dart';
import '../../shared/models/book.dart';
import '../../shared/models/reading_status.dart';

part 'library_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
Stream<List<Book>> bookList(BookListRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.booksDao.watchAllBooks().map((list) {
    return list.map((data) => Book.fromDbData(data)).toList();
  });
}

class BookFiltersState {
  final String searchQuery;
  final ReadingStatus? statusFilter;
  final int? ratingFilter;
  final String? genreFilter;
  final String sortBy; // 'date_added' | 'title' | 'author' | 'personal_rating'

  const BookFiltersState({
    this.searchQuery = '',
    this.statusFilter,
    this.ratingFilter,
    this.genreFilter,
    this.sortBy = 'date_added',
  });

  BookFiltersState copyWith({
    String? searchQuery,
    ReadingStatus? Function()? statusFilter,
    int? Function()? ratingFilter,
    String? Function()? genreFilter,
    String? sortBy,
  }) {
    return BookFiltersState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      ratingFilter: ratingFilter != null ? ratingFilter() : this.ratingFilter,
      genreFilter: genreFilter != null ? genreFilter() : this.genreFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

@riverpod
class BookFilters extends _$BookFilters {
  @override
  BookFiltersState build() {
    return const BookFiltersState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(ReadingStatus? status) {
    state = state.copyWith(statusFilter: () => status);
  }

  void setRatingFilter(int? rating) {
    state = state.copyWith(ratingFilter: () => rating);
  }

  void setGenreFilter(String? genre) {
    state = state.copyWith(genreFilter: () => genre);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void reset() {
    state = const BookFiltersState();
  }
}

@riverpod
List<Book> filteredBooks(FilteredBooksRef ref) {
  final booksAsync = ref.watch(bookListProvider);
  final filters = ref.watch(bookFiltersProvider);

  // If stream hasn't loaded or has error, return empty list
  final books = booksAsync.value ?? [];

  return books.where((book) {
    // 1. Search query filter (title, author, isbn)
    if (filters.searchQuery.isNotEmpty) {
      final q = filters.searchQuery.toLowerCase();
      final titleMatch = book.title.toLowerCase().contains(q);
      final authorMatch = book.author.toLowerCase().contains(q);
      final isbnMatch = book.isbn.toLowerCase().contains(q);
      if (!titleMatch && !authorMatch && !isbnMatch) {
        return false;
      }
    }

    // 2. Status filter
    if (filters.statusFilter != null && book.readingStatus != filters.statusFilter) {
      return false;
    }

    // 3. Rating filter (filter >= N stars)
    if (filters.ratingFilter != null) {
      if (book.personalRating == null || book.personalRating! < filters.ratingFilter!) {
        return false;
      }
    }

    // 4. Genre / Category filter
    if (filters.genreFilter != null) {
      if (!book.categories.contains(filters.genreFilter)) {
        return false;
      }
    }

    return true;
  }).toList()
    ..sort((a, b) {
      switch (filters.sortBy) {
        case 'title':
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case 'author':
          return a.author.toLowerCase().compareTo(b.author.toLowerCase());
        case 'personal_rating':
          final rA = a.personalRating ?? 0;
          final rB = b.personalRating ?? 0;
          return rB.compareTo(rA); // Descending rating
        case 'date_added':
        default:
          return b.dateAdded.compareTo(a.dateAdded); // Descending added date (newest first)
      }
    });
}
