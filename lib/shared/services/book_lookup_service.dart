import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../models/reading_status.dart';
import '../../core/constants/api_constants.dart';

class BookLookupService {
  final Dio _dio;
  final Uuid _uuid = const Uuid();

  BookLookupService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
              receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
            ));

  Future<Book?> lookupByIsbn(String isbn) async {
    // Sanitize ISBN (remove dashes, spaces)
    final sanitizedIsbn = isbn.replaceAll(RegExp(r'[\s-]'), '');
    if (sanitizedIsbn.isEmpty) return null;

    try {
      debugPrint('Attempting Google Books API lookup for ISBN: $sanitizedIsbn');
      final googleBook = await _lookupGoogleBooks(sanitizedIsbn);
      if (googleBook != null) {
        return googleBook;
      }
    } catch (e) {
      debugPrint('Google Books API lookup failed: $e');
    }

    try {
      debugPrint('Attempting Open Library API lookup fallback for ISBN: $sanitizedIsbn');
      final openLibraryBook = await _lookupOpenLibrary(sanitizedIsbn);
      if (openLibraryBook != null) {
        return openLibraryBook;
      }
    } catch (e) {
      debugPrint('Open Library API lookup failed: $e');
    }

    return null;
  }

  Future<Book?> _lookupGoogleBooks(String isbn) async {
    final url = ApiConstants.googleBooksUrl(isbn);
    final response = await _dio.get(url);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final totalItems = data['totalItems'] as int? ?? 0;
      if (totalItems == 0) return null;

      final items = data['items'] as List<dynamic>?;
      if (items == null || items.isEmpty) return null;

      final volumeInfo = items[0]['volumeInfo'] as Map<String, dynamic>?;
      if (volumeInfo == null) return null;

      // Extract required fields
      final title = volumeInfo['title'] as String? ?? 'Unknown Title';
      
      final authorsList = volumeInfo['authors'] as List<dynamic>?;
      final author = authorsList != null && authorsList.isNotEmpty
          ? authorsList.map((e) => e.toString()).join(', ')
          : 'Unknown Author';

      var coverImageUrl = volumeInfo['imageLinks']?['thumbnail'] as String?;
      if (coverImageUrl != null) {
        coverImageUrl = coverImageUrl.replaceFirst('http://', 'https://');
      }

      final publisher = volumeInfo['publisher'] as String?;
      final publicationDate = volumeInfo['publishedDate'] as String?;
      final pageCount = volumeInfo['pageCount'] as int?;
      
      final categoriesList = volumeInfo['categories'] as List<dynamic>?;
      final categories = categoriesList != null
          ? categoriesList.map((e) => e.toString()).toList()
          : <String>[];

      final description = volumeInfo['description'] as String?;

      return Book(
        id: _uuid.v4(),
        isbn: isbn,
        title: title,
        author: author,
        coverImageUrl: coverImageUrl,
        publisher: publisher,
        publicationDate: publicationDate,
        pageCount: pageCount,
        categories: categories,
        description: description,
        dateAdded: DateTime.now(),
        favoriteQuotes: const [],
        readingStatus: ReadingStatus.wantToRead,
        currentPage: 0,
      );
    }
    return null;
  }

  Future<Book?> _lookupOpenLibrary(String isbn) async {
    final url = ApiConstants.openLibraryUrl(isbn);
    final response = await _dio.get(url);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final bookKey = 'ISBN:$isbn';
      if (!data.containsKey(bookKey)) return null;

      final bookData = data[bookKey] as Map<String, dynamic>?;
      if (bookData == null) return null;

      // Extract required fields
      final title = bookData['title'] as String? ?? 'Unknown Title';

      final authorsList = bookData['authors'] as List<dynamic>?;
      final author = authorsList != null && authorsList.isNotEmpty
          ? authorsList.map((e) {
              if (e is Map && e.containsKey('name')) {
                return e['name'].toString();
              }
              return e.toString();
            }).join(', ')
          : 'Unknown Author';

      // Cover image (large or medium)
      String? coverImageUrl;
      final coverData = bookData['cover'] as Map<String, dynamic>?;
      if (coverData != null) {
        coverImageUrl = coverData['large'] as String? ?? coverData['medium'] as String?;
      }

      // Publisher
      String? publisher;
      final publishersList = bookData['publishers'] as List<dynamic>?;
      if (publishersList != null && publishersList.isNotEmpty) {
        publisher = publishersList.map((e) {
          if (e is Map && e.containsKey('name')) {
            return e['name'].toString();
          }
          return e.toString();
        }).join(', ');
      }

      final publicationDate = bookData['publish_date'] as String?;
      final pageCount = bookData['number_of_pages'] as int?;

      // Categories
      final categories = <String>[];
      final subjectsList = bookData['subjects'] as List<dynamic>?;
      if (subjectsList != null) {
        for (var subject in subjectsList) {
          if (subject is Map && subject.containsKey('name')) {
            categories.add(subject['name'].toString());
          } else if (subject is String) {
            categories.add(subject);
          }
        }
      }

      final description = bookData['notes'] as String?;

      return Book(
        id: _uuid.v4(),
        isbn: isbn,
        title: title,
        author: author,
        coverImageUrl: coverImageUrl,
        publisher: publisher,
        publicationDate: publicationDate,
        pageCount: pageCount,
        categories: categories,
        description: description,
        dateAdded: DateTime.now(),
        favoriteQuotes: const [],
        readingStatus: ReadingStatus.wantToRead,
        currentPage: 0,
      );
    }
    return null;
  }
}
