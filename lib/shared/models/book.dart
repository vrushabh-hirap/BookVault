import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:drift/drift.dart' show Value;
import 'reading_status.dart';
import '../../core/db/app_database.dart'; // generated drift database

part 'book.g.dart';

@JsonSerializable(explicitToJson: true)
class Book {
  final String id;           // UUID v4
  final String isbn;
  final String title;
  final String author;
  
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;
  final String? publisher;
  
  @JsonKey(name: 'publication_date')
  final String? publicationDate;
  
  @JsonKey(name: 'page_count')
  final int? pageCount;
  
  final List<String> categories;
  final String? description;
  
  @JsonKey(name: 'date_added', fromJson: _dateTimeFromEpoch, toJson: _dateTimeToEpoch)
  final DateTime dateAdded;
  
  @JsonKey(name: 'personal_rating')
  int? personalRating;       // 1–5, nullable until user rates
  
  @JsonKey(name: 'personal_review')
  String? personalReview;
  
  @JsonKey(name: 'favorite_quotes')
  List<String> favoriteQuotes;
  
  @JsonKey(name: 'reading_status', fromJson: _readingStatusFromJson, toJson: _readingStatusToJson)
  ReadingStatus readingStatus;
  
  @JsonKey(name: 'current_page')
  int currentPage;

  Book({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    this.coverImageUrl,
    this.publisher,
    this.publicationDate,
    this.pageCount,
    required this.categories,
    this.description,
    required this.dateAdded,
    this.personalRating,
    this.personalReview,
    required this.favoriteQuotes,
    required this.readingStatus,
    required this.currentPage,
  });

  // Computed — no storage
  double get progressPercent {
    if (pageCount == null || pageCount! <= 0) return 0;
    return (currentPage / pageCount!).clamp(0.0, 1.0);
  }

  String get progressDisplay {
    final pct = (progressPercent * 100).toStringAsFixed(0);
    return '$pct%';
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);

  // Conversion from Drift database model BookData
  factory Book.fromDbData(BookData data) {
    List<String> parseJsonList(String? jsonStr) {
      if (jsonStr == null || jsonStr.isEmpty) return [];
      try {
        final parsed = jsonDecode(jsonStr);
        if (parsed is List) {
          return parsed.map((e) => e.toString()).toList();
        }
      } catch (_) {}
      return [];
    }

    return Book(
      id: data.id,
      isbn: data.isbn,
      title: data.title,
      author: data.author,
      coverImageUrl: data.coverImageUrl,
      publisher: data.publisher,
      publicationDate: data.publicationDate,
      pageCount: data.pageCount,
      categories: parseJsonList(data.categories),
      description: data.description,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(data.dateAdded),
      personalRating: data.personalRating,
      personalReview: data.personalReview,
      favoriteQuotes: parseJsonList(data.favoriteQuotes),
      readingStatus: ReadingStatus.fromDb(data.readingStatus),
      currentPage: data.currentPage,
    );
  }

  // Conversion to Drift BooksCompanion
  BooksCompanion toCompanion() {
    return BooksCompanion(
      id: Value(id),
      isbn: Value(isbn),
      title: Value(title),
      author: Value(author),
      coverImageUrl: Value(coverImageUrl),
      publisher: Value(publisher),
      publicationDate: Value(publicationDate),
      pageCount: Value(pageCount),
      categories: Value(jsonEncode(categories)),
      description: Value(description),
      dateAdded: Value(dateAdded.millisecondsSinceEpoch),
      personalRating: Value(personalRating),
      personalReview: Value(personalReview),
      favoriteQuotes: Value(jsonEncode(favoriteQuotes)),
      readingStatus: Value(readingStatus.toDb()),
      currentPage: Value(currentPage),
    );
  }

  // JSON Helpers
  static DateTime _dateTimeFromEpoch(int epoch) => DateTime.fromMillisecondsSinceEpoch(epoch);
  static int _dateTimeToEpoch(DateTime dt) => dt.millisecondsSinceEpoch;

  static ReadingStatus _readingStatusFromJson(String value) => ReadingStatus.fromDb(value);
  static String _readingStatusToJson(ReadingStatus status) => status.toDb();
}
