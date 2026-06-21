import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../core/db/daos/books_dao.dart';
import '../models/book.dart';
import '../models/reading_status.dart';

class ImportResult {
  final int imported;
  final int skipped;
  final List<String> errors;

  ImportResult({
    required this.imported,
    required this.skipped,
    required this.errors,
  });
}

class ImportService {
  final Uuid _uuid = const Uuid();

  Future<ImportResult> importFromJson(String filePath, BooksDao dao) async {
    int importedCount = 0;
    int skippedCount = 0;
    final List<String> errors = [];

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(imported: 0, skipped: 0, errors: ['File does not exist.']);
      }

      final content = await file.readAsString();
      final parsed = jsonDecode(content);

      if (parsed is! List) {
        return ImportResult(imported: 0, skipped: 0, errors: ['Invalid JSON format: Expected a list of books.']);
      }

      for (var i = 0; i < parsed.length; i++) {
        try {
          final item = parsed[i] as Map<String, dynamic>;
          final book = Book.fromJson(item);

          // Check for duplicate ISBN in database
          final existing = await dao.getBookByIsbn(book.isbn);
          if (existing != null) {
            skippedCount++;
            continue;
          }

          // Insert into database
          await dao.insertBook(book.toCompanion());
          importedCount++;
        } catch (e) {
          errors.add('Row $i failed to parse: $e');
        }
      }
    } catch (e) {
      errors.add('Failed to read file: $e');
    }

    return ImportResult(imported: importedCount, skipped: skippedCount, errors: errors);
  }

  Future<ImportResult> importFromCsv(String filePath, BooksDao dao) async {
    int importedCount = 0;
    int skippedCount = 0;
    final List<String> errors = [];

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(imported: 0, skipped: 0, errors: ['File does not exist.']);
      }

      final content = await file.readAsString();
      final rows = _parseCsv(content);

      if (rows.isEmpty) {
        return ImportResult(imported: 0, skipped: 0, errors: ['CSV file is empty.']);
      }

      final headers = rows.first.map((h) => h.trim().toLowerCase()).toList();
      final dataRows = rows.skip(1).toList();

      final isbnIdx = headers.indexOf('isbn');
      final titleIdx = headers.indexOf('title');
      final authorIdx = headers.indexOf('author');
      final publisherIdx = headers.indexOf('publisher');
      final pubDateIdx = headers.indexOf('publication_date');
      final pageCountIdx = headers.indexOf('page_count');
      final categoriesIdx = headers.indexOf('categories');
      final dateAddedIdx = headers.indexOf('date_added');
      final ratingIdx = headers.indexOf('personal_rating');
      final reviewIdx = headers.indexOf('personal_review');
      final statusIdx = headers.indexOf('reading_status');
      final currentPageIdx = headers.indexOf('current_page');

      if (isbnIdx == -1 || titleIdx == -1 || authorIdx == -1) {
        return ImportResult(
          imported: 0,
          skipped: 0,
          errors: ['CSV must contain at least isbn, title, and author columns.'],
        );
      }

      for (var i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        if (row.length <= isbnIdx || row.length <= titleIdx || row.length <= authorIdx) {
          errors.add('Row ${i + 2} has incomplete core fields (isbn, title, author).');
          continue;
        }

        try {
          final isbn = row[isbnIdx].trim();
          final title = row[titleIdx].trim();
          final author = row[authorIdx].trim();

          if (isbn.isEmpty || title.isEmpty || author.isEmpty) {
            errors.add('Row ${i + 2} has empty isbn, title, or author.');
            continue;
          }

          // Check duplicate ISBN
          final existing = await dao.getBookByIsbn(isbn);
          if (existing != null) {
            skippedCount++;
            continue;
          }

          final publisher = publisherIdx != -1 && row.length > publisherIdx ? row[publisherIdx].trim() : null;
          final publicationDate = pubDateIdx != -1 && row.length > pubDateIdx ? row[pubDateIdx].trim() : null;
          
          int? pageCount;
          if (pageCountIdx != -1 && row.length > pageCountIdx) {
            pageCount = int.tryParse(row[pageCountIdx].trim());
          }

          List<String> categories = [];
          if (categoriesIdx != -1 && row.length > categoriesIdx) {
            final catStr = row[categoriesIdx].trim();
            if (catStr.isNotEmpty) {
              try {
                final parsedCat = jsonDecode(catStr);
                if (parsedCat is List) {
                  categories = parsedCat.map((e) => e.toString()).toList();
                }
              } catch (_) {
                // If not valid JSON, treat it as a single category string
                categories = [catStr];
              }
            }
          }

          DateTime dateAdded = DateTime.now();
          if (dateAddedIdx != -1 && row.length > dateAddedIdx) {
            final ms = int.tryParse(row[dateAddedIdx].trim());
            if (ms != null) {
              dateAdded = DateTime.fromMillisecondsSinceEpoch(ms);
            }
          }

          int? personalRating;
          if (ratingIdx != -1 && row.length > ratingIdx) {
            personalRating = int.tryParse(row[ratingIdx].trim());
            if (personalRating != null && (personalRating < 1 || personalRating > 5)) {
              personalRating = null;
            }
          }

          final personalReview = reviewIdx != -1 && row.length > reviewIdx ? row[reviewIdx].trim() : null;

          ReadingStatus readingStatus = ReadingStatus.wantToRead;
          if (statusIdx != -1 && row.length > statusIdx) {
            readingStatus = ReadingStatus.fromDb(row[statusIdx].trim());
          }

          int currentPage = 0;
          if (currentPageIdx != -1 && row.length > currentPageIdx) {
            currentPage = int.tryParse(row[currentPageIdx].trim()) ?? 0;
          }

          final book = Book(
            id: _uuid.v4(),
            isbn: isbn,
            title: title,
            author: author,
            coverImageUrl: null,
            publisher: publisher,
            publicationDate: publicationDate,
            pageCount: pageCount,
            categories: categories,
            description: null,
            dateAdded: dateAdded,
            favoriteQuotes: const [],
            readingStatus: readingStatus,
            currentPage: currentPage,
          );

          book.personalRating = personalRating;
          book.personalReview = personalReview;

          await dao.insertBook(book.toCompanion());
          importedCount++;
        } catch (e) {
          errors.add('Row ${i + 2} failed to import: $e');
        }
      }
    } catch (e) {
      errors.add('Failed to read CSV: $e');
    }

    return ImportResult(imported: importedCount, skipped: skippedCount, errors: errors);
  }

  List<List<String>> _parseCsv(String csvText) {
    final List<List<String>> rows = [];
    final List<String> currentRow = [];
    final StringBuffer currentField = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < csvText.length; i++) {
      final char = csvText[i];

      if (inQuotes) {
        if (char == '"') {
          if (i + 1 < csvText.length && csvText[i + 1] == '"') {
            currentField.write('"');
            i++; // skip second quote
          } else {
            inQuotes = false;
          }
        } else {
          currentField.write(char);
        }
      } else {
        if (char == '"') {
          inQuotes = true;
        } else if (char == ',') {
          currentRow.add(currentField.toString());
          currentField.clear();
        } else if (char == '\n' || char == '\r') {
          if (char == '\r' && i + 1 < csvText.length && csvText[i + 1] == '\n') {
            i++;
          }
          currentRow.add(currentField.toString());
          currentField.clear();
          if (currentRow.isNotEmpty && currentRow.any((element) => element.isNotEmpty)) {
            rows.add(List.from(currentRow));
          }
          currentRow.clear();
        } else {
          currentField.write(char);
        }
      }
    }

    if (currentField.isNotEmpty || currentRow.isNotEmpty) {
      currentRow.add(currentField.toString());
      rows.add(currentRow);
    }

    return rows;
  }
}
