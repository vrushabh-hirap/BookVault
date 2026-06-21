// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: json['id'] as String,
  isbn: json['isbn'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  coverImageUrl: json['cover_image_url'] as String?,
  publisher: json['publisher'] as String?,
  publicationDate: json['publication_date'] as String?,
  pageCount: (json['page_count'] as num?)?.toInt(),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  dateAdded: Book._dateTimeFromEpoch((json['date_added'] as num).toInt()),
  personalRating: (json['personal_rating'] as num?)?.toInt(),
  personalReview: json['personal_review'] as String?,
  favoriteQuotes: (json['favorite_quotes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  readingStatus: Book._readingStatusFromJson(json['reading_status'] as String),
  currentPage: (json['current_page'] as num).toInt(),
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'isbn': instance.isbn,
  'title': instance.title,
  'author': instance.author,
  'cover_image_url': instance.coverImageUrl,
  'publisher': instance.publisher,
  'publication_date': instance.publicationDate,
  'page_count': instance.pageCount,
  'categories': instance.categories,
  'description': instance.description,
  'date_added': Book._dateTimeToEpoch(instance.dateAdded),
  'personal_rating': instance.personalRating,
  'personal_review': instance.personalReview,
  'favorite_quotes': instance.favoriteQuotes,
  'reading_status': Book._readingStatusToJson(instance.readingStatus),
  'current_page': instance.currentPage,
};
