import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/book.dart';

class ExportService {
  Future<void> exportAsJson(List<Book> books, String outputPath) async {
    final jsonList = books.map((b) => b.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
    final file = File(outputPath);
    await file.writeAsString(jsonString);
  }

  Future<void> exportAsCsv(List<Book> books, String outputPath) async {
    final csvBuffer = StringBuffer();
    
    // Header row
    final headers = [
      'isbn',
      'title',
      'author',
      'publisher',
      'publication_date',
      'page_count',
      'categories',
      'date_added',
      'personal_rating',
      'personal_review',
      'reading_status',
      'current_page'
    ];
    csvBuffer.writeln(headers.map(_escapeCsvValue).join(','));

    // Data rows
    for (final book in books) {
      final row = [
        book.isbn,
        book.title,
        book.author,
        book.publisher ?? '',
        book.publicationDate ?? '',
        book.pageCount?.toString() ?? '',
        jsonEncode(book.categories),
        book.dateAdded.millisecondsSinceEpoch.toString(),
        book.personalRating?.toString() ?? '',
        book.personalReview ?? '',
        book.readingStatus.toDb(),
        book.currentPage.toString(),
      ];
      csvBuffer.writeln(row.map(_escapeCsvValue).join(','));
    }

    final file = File(outputPath);
    await file.writeAsString(csvBuffer.toString());
  }

  Future<void> createBackup(List<Book> books) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(docsDir.path, 'BookVault', 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final backupPath = p.join(backupDir.path, 'backup_$timestamp.json');
    await exportAsJson(books, backupPath);
  }

  String _escapeCsvValue(dynamic val) {
    if (val == null) return '';
    String str = val.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n') || str.contains('\r')) {
      str = '"${str.replaceAll('"', '""')}"';
    }
    return str;
  }
}
