import 'package:drift/drift.dart';
import 'package:bookvault/core/db/app_database.dart';
import 'package:bookvault/core/db/books_table.dart';

part 'books_dao.g.dart';

@DriftAccessor(tables: [Books])
class BooksDao extends DatabaseAccessor<AppDatabase> with _$BooksDaoMixin {
  BooksDao(super.db);

  // Queries
  Stream<List<BookData>> watchAllBooks() => select(books).watch();
  
  Stream<List<BookData>> watchBooksByStatus(String status) =>
      (select(books)..where((t) => t.readingStatus.equals(status))).watch();

  Future<BookData?> getBookByIsbn(String isbn) =>
      (select(books)..where((t) => t.isbn.equals(isbn))).getSingleOrNull();

  Future<BookData?> getBookById(String id) =>
      (select(books)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<BookData>> searchBooks(String query) {
    final searchPattern = '%$query%';
    return (select(books)
          ..where((t) =>
              t.title.like(searchPattern) |
              t.author.like(searchPattern) |
              t.isbn.like(searchPattern)))
        .get();
  }

  // Mutations
  Future<int> insertBook(BooksCompanion book) => into(books).insert(book);
  Future<bool> updateBook(BooksCompanion book) => update(books).replace(book);
  Future<int> deleteBook(String id) => (delete(books)..where((t) => t.id.equals(id))).go();

  // Stats
  Future<int> countByStatus(String status) async {
    final query = selectOnly(books)..addColumns([books.id.count()]);
    query.where(books.readingStatus.equals(status));
    final row = await query.getSingle();
    return row.read(books.id.count()) ?? 0;
  }

  Future<double> averageRating() async {
    final avgRating = books.personalRating.avg();
    final query = selectOnly(books)..addColumns([avgRating]);
    query.where(books.personalRating.isNotNull());
    final row = await query.getSingle();
    return row.read(avgRating) ?? 0.0;
  }

  Future<int> totalPagesRead() async {
    final sumPages = books.currentPage.sum();
    final query = selectOnly(books)..addColumns([sumPages]);
    final row = await query.getSingle();
    return row.read(sumPages) ?? 0;
  }

  Future<List<BookData>> getBooksAddedThisYear() {
    final yearStart = DateTime(DateTime.now().year).millisecondsSinceEpoch;
    return (select(books)..where((t) => t.dateAdded.isBiggerOrEqualValue(yearStart))).get();
  }
}
