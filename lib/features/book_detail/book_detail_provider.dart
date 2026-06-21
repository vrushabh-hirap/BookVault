import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../library/library_provider.dart';
import '../../shared/models/book.dart';
import '../../shared/models/reading_status.dart';

part 'book_detail_provider.g.dart';

@riverpod
Book? bookDetail(BookDetailRef ref, String id) {
  final booksAsync = ref.watch(bookListProvider);
  final books = booksAsync.value ?? [];
  
  // Find book by ID
  try {
    return books.firstWhere((b) => b.id == id);
  } catch (_) {
    return null;
  }
}

@riverpod
class BookDetailController extends _$BookDetailController {
  @override
  void build() {}

  Future<void> updateReadingStatus(Book book, ReadingStatus status) async {
    final updated = book.toCompanion().copyWith(
      readingStatus: Value(status.toDb()),
      currentPage: status == ReadingStatus.finished && book.pageCount != null
          ? Value(book.pageCount!)
          : const Value.absent(),
    );
    await ref.read(appDatabaseProvider).booksDao.updateBook(updated);
  }

  Future<void> updateCurrentPage(Book book, int page) async {
    final updated = book.toCompanion().copyWith(
      currentPage: Value(page),
      readingStatus: book.pageCount != null && page >= book.pageCount!
          ? Value(ReadingStatus.finished.toDb())
          : const Value.absent(),
    );
    await ref.read(appDatabaseProvider).booksDao.updateBook(updated);
  }

  Future<void> updateRating(Book book, int? rating) async {
    final updated = book.toCompanion().copyWith(
      personalRating: Value(rating),
    );
    await ref.read(appDatabaseProvider).booksDao.updateBook(updated);
  }

  Future<void> updateReview(Book book, String review) async {
    final updated = book.toCompanion().copyWith(
      personalReview: Value(review),
    );
    await ref.read(appDatabaseProvider).booksDao.updateBook(updated);
  }

  Future<void> addQuote(Book book, String quote) async {
    final quotes = List<String>.from(book.favoriteQuotes)..add(quote);
    final updated = book.toCompanion().copyWith(
      favoriteQuotes: Value(jsonEncode(quotes)),
    );
    await ref.read(appDatabaseProvider).booksDao.updateBook(updated);
  }

  Future<void> deleteQuote(Book book, String quote) async {
    final quotes = List<String>.from(book.favoriteQuotes)..remove(quote);
    final updated = book.toCompanion().copyWith(
      favoriteQuotes: Value(jsonEncode(quotes)),
    );
    await ref.read(appDatabaseProvider).booksDao.updateBook(updated);
  }

  Future<void> deleteBook(String id) async {
    await ref.read(appDatabaseProvider).booksDao.deleteBook(id);
  }
}
