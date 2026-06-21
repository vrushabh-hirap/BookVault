import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/models/book.dart';
import '../../shared/models/reading_status.dart';
import '../../shared/services/book_lookup_service.dart';
import '../library/library_provider.dart';

part 'scanner_provider.g.dart';

@riverpod
BookLookupService bookLookupService(BookLookupServiceRef ref) {
  return BookLookupService();
}

enum ScannerStatus {
  idle,
  scanning,
  detected,
  fetching,
  found,
  error;
}

class ScannerStateData {
  final ScannerStatus status;
  final String? isbn;
  final Book? foundBook;
  final Book? existingBook; // When duplicate ISBN is scanned
  final String? errorMessage;

  const ScannerStateData({
    this.status = ScannerStatus.idle,
    this.isbn,
    this.foundBook,
    this.existingBook,
    this.errorMessage,
  });

  ScannerStateData copyWith({
    ScannerStatus? status,
    String? Function()? isbn,
    Book? Function()? foundBook,
    Book? Function()? existingBook,
    String? Function()? errorMessage,
  }) {
    return ScannerStateData(
      status: status ?? this.status,
      isbn: isbn != null ? isbn() : this.isbn,
      foundBook: foundBook != null ? foundBook() : this.foundBook,
      existingBook: existingBook != null ? existingBook() : this.existingBook,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

@riverpod
class ScannerState extends _$ScannerState {
  @override
  ScannerStateData build() {
    return const ScannerStateData();
  }

  void startScanning() {
    state = const ScannerStateData(status: ScannerStatus.scanning);
  }

  void stopScanning() {
    state = const ScannerStateData(status: ScannerStatus.idle);
  }

  void reset() {
    state = const ScannerStateData();
  }

  Future<void> detectIsbn(String isbn) async {
    final sanitized = isbn.replaceAll(RegExp(r'[\s-]'), '');
    if (sanitized.isEmpty) return;

    state = state.copyWith(
      status: ScannerStatus.detected,
      isbn: () => sanitized,
      errorMessage: () => null,
      existingBook: () => null,
      foundBook: () => null,
    );

    // 1. Check if ISBN is duplicate
    final db = ref.read(appDatabaseProvider);
    final existingData = await db.booksDao.getBookByIsbn(sanitized);
    
    if (existingData != null) {
      final existingBook = Book.fromDbData(existingData);
      state = state.copyWith(
        status: ScannerStatus.error,
        existingBook: () => existingBook,
        errorMessage: () => 'This book is already in your library.',
      );
      return;
    }

    // 2. Fetch book details
    state = state.copyWith(status: ScannerStatus.fetching);

    try {
      final lookupService = ref.read(bookLookupServiceProvider);
      final book = await lookupService.lookupByIsbn(sanitized);

      if (book != null) {
        state = state.copyWith(
          status: ScannerStatus.found,
          foundBook: () => book,
        );
      } else {
        state = state.copyWith(
          status: ScannerStatus.error,
          errorMessage: () => 'Book not found for ISBN: $sanitized',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ScannerStatus.error,
        errorMessage: () => 'Could not fetch book info: $e',
      );
    }
  }

  Future<bool> confirmAddBook(Book book, ReadingStatus initialStatus) async {
    try {
      final db = ref.read(appDatabaseProvider);
      
      // Update status on the model to match initial user selection
      book.readingStatus = initialStatus;
      if (initialStatus == ReadingStatus.finished && book.pageCount != null) {
        book.currentPage = book.pageCount!;
      }

      await db.booksDao.insertBook(book.toCompanion());
      reset();
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ScannerStatus.error,
        errorMessage: () => 'Failed to save book. Try again.',
      );
      return false;
    }
  }

  void cancelFoundBook() {
    state = state.copyWith(
      status: ScannerStatus.scanning,
      foundBook: () => null,
    );
  }
}
