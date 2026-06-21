import 'package:drift/drift.dart';

@DataClassName('BookData')
class Books extends Table {
  TextColumn get id => text()();
  TextColumn get isbn => text().unique()();
  TextColumn get title => text()();
  TextColumn get author => text()();
  TextColumn get coverImageUrl => text().nullable().named('cover_image_url')();
  TextColumn get publisher => text().nullable()();
  TextColumn get publicationDate => text().nullable().named('publication_date')();
  IntColumn get pageCount => integer().nullable().named('page_count')();
  TextColumn get categories => text().nullable()(); // stored as JSON array string
  TextColumn get description => text().nullable()();
  IntColumn get dateAdded => integer().named('date_added')(); // Unix timestamp (ms)
  IntColumn get personalRating => integer().nullable().customConstraint('CHECK (personal_rating >= 1 AND personal_rating <= 5)').named('personal_rating')();
  TextColumn get personalReview => text().nullable().named('personal_review')();
  TextColumn get favoriteQuotes => text().withDefault(const Constant('[]')).named('favorite_quotes')(); // stored as JSON array string
  TextColumn get readingStatus => text().withDefault(const Constant('want_to_read')).named('reading_status')();
  IntColumn get currentPage => integer().withDefault(const Constant(0)).named('current_page')();

  @override
  Set<Column> get primaryKey => {id};
}
