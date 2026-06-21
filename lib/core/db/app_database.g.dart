// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, BookData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isbnMeta = const VerificationMeta('isbn');
  @override
  late final GeneratedColumn<String> isbn = GeneratedColumn<String>(
    'isbn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverImageUrlMeta = const VerificationMeta(
    'coverImageUrl',
  );
  @override
  late final GeneratedColumn<String> coverImageUrl = GeneratedColumn<String>(
    'cover_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicationDateMeta = const VerificationMeta(
    'publicationDate',
  );
  @override
  late final GeneratedColumn<String> publicationDate = GeneratedColumn<String>(
    'publication_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriesMeta = const VerificationMeta(
    'categories',
  );
  @override
  late final GeneratedColumn<String> categories = GeneratedColumn<String>(
    'categories',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<int> dateAdded = GeneratedColumn<int>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalRatingMeta = const VerificationMeta(
    'personalRating',
  );
  @override
  late final GeneratedColumn<int> personalRating = GeneratedColumn<int>(
    'personal_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (personal_rating >= 1 AND personal_rating <= 5)',
  );
  static const VerificationMeta _personalReviewMeta = const VerificationMeta(
    'personalReview',
  );
  @override
  late final GeneratedColumn<String> personalReview = GeneratedColumn<String>(
    'personal_review',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteQuotesMeta = const VerificationMeta(
    'favoriteQuotes',
  );
  @override
  late final GeneratedColumn<String> favoriteQuotes = GeneratedColumn<String>(
    'favorite_quotes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _readingStatusMeta = const VerificationMeta(
    'readingStatus',
  );
  @override
  late final GeneratedColumn<String> readingStatus = GeneratedColumn<String>(
    'reading_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('want_to_read'),
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isbn,
    title,
    author,
    coverImageUrl,
    publisher,
    publicationDate,
    pageCount,
    categories,
    description,
    dateAdded,
    personalRating,
    personalReview,
    favoriteQuotes,
    readingStatus,
    currentPage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('isbn')) {
      context.handle(
        _isbnMeta,
        isbn.isAcceptableOrUnknown(data['isbn']!, _isbnMeta),
      );
    } else if (isInserting) {
      context.missing(_isbnMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('cover_image_url')) {
      context.handle(
        _coverImageUrlMeta,
        coverImageUrl.isAcceptableOrUnknown(
          data['cover_image_url']!,
          _coverImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('publication_date')) {
      context.handle(
        _publicationDateMeta,
        publicationDate.isAcceptableOrUnknown(
          data['publication_date']!,
          _publicationDateMeta,
        ),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('categories')) {
      context.handle(
        _categoriesMeta,
        categories.isAcceptableOrUnknown(data['categories']!, _categoriesMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('personal_rating')) {
      context.handle(
        _personalRatingMeta,
        personalRating.isAcceptableOrUnknown(
          data['personal_rating']!,
          _personalRatingMeta,
        ),
      );
    }
    if (data.containsKey('personal_review')) {
      context.handle(
        _personalReviewMeta,
        personalReview.isAcceptableOrUnknown(
          data['personal_review']!,
          _personalReviewMeta,
        ),
      );
    }
    if (data.containsKey('favorite_quotes')) {
      context.handle(
        _favoriteQuotesMeta,
        favoriteQuotes.isAcceptableOrUnknown(
          data['favorite_quotes']!,
          _favoriteQuotesMeta,
        ),
      );
    }
    if (data.containsKey('reading_status')) {
      context.handle(
        _readingStatusMeta,
        readingStatus.isAcceptableOrUnknown(
          data['reading_status']!,
          _readingStatusMeta,
        ),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isbn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      coverImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image_url'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      publicationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publication_date'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      categories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categories'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_added'],
      )!,
      personalRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personal_rating'],
      ),
      personalReview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_review'],
      ),
      favoriteQuotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_quotes'],
      )!,
      readingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_status'],
      )!,
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class BookData extends DataClass implements Insertable<BookData> {
  final String id;
  final String isbn;
  final String title;
  final String author;
  final String? coverImageUrl;
  final String? publisher;
  final String? publicationDate;
  final int? pageCount;
  final String? categories;
  final String? description;
  final int dateAdded;
  final int? personalRating;
  final String? personalReview;
  final String favoriteQuotes;
  final String readingStatus;
  final int currentPage;
  const BookData({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    this.coverImageUrl,
    this.publisher,
    this.publicationDate,
    this.pageCount,
    this.categories,
    this.description,
    required this.dateAdded,
    this.personalRating,
    this.personalReview,
    required this.favoriteQuotes,
    required this.readingStatus,
    required this.currentPage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['isbn'] = Variable<String>(isbn);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || coverImageUrl != null) {
      map['cover_image_url'] = Variable<String>(coverImageUrl);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || publicationDate != null) {
      map['publication_date'] = Variable<String>(publicationDate);
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    if (!nullToAbsent || categories != null) {
      map['categories'] = Variable<String>(categories);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date_added'] = Variable<int>(dateAdded);
    if (!nullToAbsent || personalRating != null) {
      map['personal_rating'] = Variable<int>(personalRating);
    }
    if (!nullToAbsent || personalReview != null) {
      map['personal_review'] = Variable<String>(personalReview);
    }
    map['favorite_quotes'] = Variable<String>(favoriteQuotes);
    map['reading_status'] = Variable<String>(readingStatus);
    map['current_page'] = Variable<int>(currentPage);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      isbn: Value(isbn),
      title: Value(title),
      author: Value(author),
      coverImageUrl: coverImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImageUrl),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      publicationDate: publicationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publicationDate),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      categories: categories == null && nullToAbsent
          ? const Value.absent()
          : Value(categories),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dateAdded: Value(dateAdded),
      personalRating: personalRating == null && nullToAbsent
          ? const Value.absent()
          : Value(personalRating),
      personalReview: personalReview == null && nullToAbsent
          ? const Value.absent()
          : Value(personalReview),
      favoriteQuotes: Value(favoriteQuotes),
      readingStatus: Value(readingStatus),
      currentPage: Value(currentPage),
    );
  }

  factory BookData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookData(
      id: serializer.fromJson<String>(json['id']),
      isbn: serializer.fromJson<String>(json['isbn']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      coverImageUrl: serializer.fromJson<String?>(json['coverImageUrl']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      publicationDate: serializer.fromJson<String?>(json['publicationDate']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      categories: serializer.fromJson<String?>(json['categories']),
      description: serializer.fromJson<String?>(json['description']),
      dateAdded: serializer.fromJson<int>(json['dateAdded']),
      personalRating: serializer.fromJson<int?>(json['personalRating']),
      personalReview: serializer.fromJson<String?>(json['personalReview']),
      favoriteQuotes: serializer.fromJson<String>(json['favoriteQuotes']),
      readingStatus: serializer.fromJson<String>(json['readingStatus']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isbn': serializer.toJson<String>(isbn),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'coverImageUrl': serializer.toJson<String?>(coverImageUrl),
      'publisher': serializer.toJson<String?>(publisher),
      'publicationDate': serializer.toJson<String?>(publicationDate),
      'pageCount': serializer.toJson<int?>(pageCount),
      'categories': serializer.toJson<String?>(categories),
      'description': serializer.toJson<String?>(description),
      'dateAdded': serializer.toJson<int>(dateAdded),
      'personalRating': serializer.toJson<int?>(personalRating),
      'personalReview': serializer.toJson<String?>(personalReview),
      'favoriteQuotes': serializer.toJson<String>(favoriteQuotes),
      'readingStatus': serializer.toJson<String>(readingStatus),
      'currentPage': serializer.toJson<int>(currentPage),
    };
  }

  BookData copyWith({
    String? id,
    String? isbn,
    String? title,
    String? author,
    Value<String?> coverImageUrl = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> publicationDate = const Value.absent(),
    Value<int?> pageCount = const Value.absent(),
    Value<String?> categories = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? dateAdded,
    Value<int?> personalRating = const Value.absent(),
    Value<String?> personalReview = const Value.absent(),
    String? favoriteQuotes,
    String? readingStatus,
    int? currentPage,
  }) => BookData(
    id: id ?? this.id,
    isbn: isbn ?? this.isbn,
    title: title ?? this.title,
    author: author ?? this.author,
    coverImageUrl: coverImageUrl.present
        ? coverImageUrl.value
        : this.coverImageUrl,
    publisher: publisher.present ? publisher.value : this.publisher,
    publicationDate: publicationDate.present
        ? publicationDate.value
        : this.publicationDate,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    categories: categories.present ? categories.value : this.categories,
    description: description.present ? description.value : this.description,
    dateAdded: dateAdded ?? this.dateAdded,
    personalRating: personalRating.present
        ? personalRating.value
        : this.personalRating,
    personalReview: personalReview.present
        ? personalReview.value
        : this.personalReview,
    favoriteQuotes: favoriteQuotes ?? this.favoriteQuotes,
    readingStatus: readingStatus ?? this.readingStatus,
    currentPage: currentPage ?? this.currentPage,
  );
  BookData copyWithCompanion(BooksCompanion data) {
    return BookData(
      id: data.id.present ? data.id.value : this.id,
      isbn: data.isbn.present ? data.isbn.value : this.isbn,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      coverImageUrl: data.coverImageUrl.present
          ? data.coverImageUrl.value
          : this.coverImageUrl,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      publicationDate: data.publicationDate.present
          ? data.publicationDate.value
          : this.publicationDate,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      categories: data.categories.present
          ? data.categories.value
          : this.categories,
      description: data.description.present
          ? data.description.value
          : this.description,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      personalRating: data.personalRating.present
          ? data.personalRating.value
          : this.personalRating,
      personalReview: data.personalReview.present
          ? data.personalReview.value
          : this.personalReview,
      favoriteQuotes: data.favoriteQuotes.present
          ? data.favoriteQuotes.value
          : this.favoriteQuotes,
      readingStatus: data.readingStatus.present
          ? data.readingStatus.value
          : this.readingStatus,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookData(')
          ..write('id: $id, ')
          ..write('isbn: $isbn, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('coverImageUrl: $coverImageUrl, ')
          ..write('publisher: $publisher, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('pageCount: $pageCount, ')
          ..write('categories: $categories, ')
          ..write('description: $description, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('personalRating: $personalRating, ')
          ..write('personalReview: $personalReview, ')
          ..write('favoriteQuotes: $favoriteQuotes, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('currentPage: $currentPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isbn,
    title,
    author,
    coverImageUrl,
    publisher,
    publicationDate,
    pageCount,
    categories,
    description,
    dateAdded,
    personalRating,
    personalReview,
    favoriteQuotes,
    readingStatus,
    currentPage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookData &&
          other.id == this.id &&
          other.isbn == this.isbn &&
          other.title == this.title &&
          other.author == this.author &&
          other.coverImageUrl == this.coverImageUrl &&
          other.publisher == this.publisher &&
          other.publicationDate == this.publicationDate &&
          other.pageCount == this.pageCount &&
          other.categories == this.categories &&
          other.description == this.description &&
          other.dateAdded == this.dateAdded &&
          other.personalRating == this.personalRating &&
          other.personalReview == this.personalReview &&
          other.favoriteQuotes == this.favoriteQuotes &&
          other.readingStatus == this.readingStatus &&
          other.currentPage == this.currentPage);
}

class BooksCompanion extends UpdateCompanion<BookData> {
  final Value<String> id;
  final Value<String> isbn;
  final Value<String> title;
  final Value<String> author;
  final Value<String?> coverImageUrl;
  final Value<String?> publisher;
  final Value<String?> publicationDate;
  final Value<int?> pageCount;
  final Value<String?> categories;
  final Value<String?> description;
  final Value<int> dateAdded;
  final Value<int?> personalRating;
  final Value<String?> personalReview;
  final Value<String> favoriteQuotes;
  final Value<String> readingStatus;
  final Value<int> currentPage;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.isbn = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.coverImageUrl = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.categories = const Value.absent(),
    this.description = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.personalRating = const Value.absent(),
    this.personalReview = const Value.absent(),
    this.favoriteQuotes = const Value.absent(),
    this.readingStatus = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String isbn,
    required String title,
    required String author,
    this.coverImageUrl = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.categories = const Value.absent(),
    this.description = const Value.absent(),
    required int dateAdded,
    this.personalRating = const Value.absent(),
    this.personalReview = const Value.absent(),
    this.favoriteQuotes = const Value.absent(),
    this.readingStatus = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       isbn = Value(isbn),
       title = Value(title),
       author = Value(author),
       dateAdded = Value(dateAdded);
  static Insertable<BookData> custom({
    Expression<String>? id,
    Expression<String>? isbn,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? coverImageUrl,
    Expression<String>? publisher,
    Expression<String>? publicationDate,
    Expression<int>? pageCount,
    Expression<String>? categories,
    Expression<String>? description,
    Expression<int>? dateAdded,
    Expression<int>? personalRating,
    Expression<String>? personalReview,
    Expression<String>? favoriteQuotes,
    Expression<String>? readingStatus,
    Expression<int>? currentPage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isbn != null) 'isbn': isbn,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
      if (publisher != null) 'publisher': publisher,
      if (publicationDate != null) 'publication_date': publicationDate,
      if (pageCount != null) 'page_count': pageCount,
      if (categories != null) 'categories': categories,
      if (description != null) 'description': description,
      if (dateAdded != null) 'date_added': dateAdded,
      if (personalRating != null) 'personal_rating': personalRating,
      if (personalReview != null) 'personal_review': personalReview,
      if (favoriteQuotes != null) 'favorite_quotes': favoriteQuotes,
      if (readingStatus != null) 'reading_status': readingStatus,
      if (currentPage != null) 'current_page': currentPage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<String>? id,
    Value<String>? isbn,
    Value<String>? title,
    Value<String>? author,
    Value<String?>? coverImageUrl,
    Value<String?>? publisher,
    Value<String?>? publicationDate,
    Value<int?>? pageCount,
    Value<String?>? categories,
    Value<String?>? description,
    Value<int>? dateAdded,
    Value<int?>? personalRating,
    Value<String?>? personalReview,
    Value<String>? favoriteQuotes,
    Value<String>? readingStatus,
    Value<int>? currentPage,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      author: author ?? this.author,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      publisher: publisher ?? this.publisher,
      publicationDate: publicationDate ?? this.publicationDate,
      pageCount: pageCount ?? this.pageCount,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      dateAdded: dateAdded ?? this.dateAdded,
      personalRating: personalRating ?? this.personalRating,
      personalReview: personalReview ?? this.personalReview,
      favoriteQuotes: favoriteQuotes ?? this.favoriteQuotes,
      readingStatus: readingStatus ?? this.readingStatus,
      currentPage: currentPage ?? this.currentPage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isbn.present) {
      map['isbn'] = Variable<String>(isbn.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (coverImageUrl.present) {
      map['cover_image_url'] = Variable<String>(coverImageUrl.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (publicationDate.present) {
      map['publication_date'] = Variable<String>(publicationDate.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (categories.present) {
      map['categories'] = Variable<String>(categories.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<int>(dateAdded.value);
    }
    if (personalRating.present) {
      map['personal_rating'] = Variable<int>(personalRating.value);
    }
    if (personalReview.present) {
      map['personal_review'] = Variable<String>(personalReview.value);
    }
    if (favoriteQuotes.present) {
      map['favorite_quotes'] = Variable<String>(favoriteQuotes.value);
    }
    if (readingStatus.present) {
      map['reading_status'] = Variable<String>(readingStatus.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('isbn: $isbn, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('coverImageUrl: $coverImageUrl, ')
          ..write('publisher: $publisher, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('pageCount: $pageCount, ')
          ..write('categories: $categories, ')
          ..write('description: $description, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('personalRating: $personalRating, ')
          ..write('personalReview: $personalReview, ')
          ..write('favoriteQuotes: $favoriteQuotes, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('currentPage: $currentPage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final BooksDao booksDao = BooksDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [books];
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required String id,
      required String isbn,
      required String title,
      required String author,
      Value<String?> coverImageUrl,
      Value<String?> publisher,
      Value<String?> publicationDate,
      Value<int?> pageCount,
      Value<String?> categories,
      Value<String?> description,
      required int dateAdded,
      Value<int?> personalRating,
      Value<String?> personalReview,
      Value<String> favoriteQuotes,
      Value<String> readingStatus,
      Value<int> currentPage,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<String> id,
      Value<String> isbn,
      Value<String> title,
      Value<String> author,
      Value<String?> coverImageUrl,
      Value<String?> publisher,
      Value<String?> publicationDate,
      Value<int?> pageCount,
      Value<String?> categories,
      Value<String?> description,
      Value<int> dateAdded,
      Value<int?> personalRating,
      Value<String?> personalReview,
      Value<String> favoriteQuotes,
      Value<String> readingStatus,
      Value<int> currentPage,
      Value<int> rowid,
    });

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn => $composableBuilder(
    column: $table.isbn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImageUrl => $composableBuilder(
    column: $table.coverImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get personalRating => $composableBuilder(
    column: $table.personalRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalReview => $composableBuilder(
    column: $table.personalReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteQuotes => $composableBuilder(
    column: $table.favoriteQuotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn => $composableBuilder(
    column: $table.isbn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImageUrl => $composableBuilder(
    column: $table.coverImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get personalRating => $composableBuilder(
    column: $table.personalRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalReview => $composableBuilder(
    column: $table.personalReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteQuotes => $composableBuilder(
    column: $table.favoriteQuotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get isbn =>
      $composableBuilder(column: $table.isbn, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get coverImageUrl => $composableBuilder(
    column: $table.coverImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<int> get personalRating => $composableBuilder(
    column: $table.personalRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalReview => $composableBuilder(
    column: $table.personalReview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favoriteQuotes => $composableBuilder(
    column: $table.favoriteQuotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          BookData,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (BookData, BaseReferences<_$AppDatabase, $BooksTable, BookData>),
          BookData,
          PrefetchHooks Function()
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> isbn = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String?> coverImageUrl = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publicationDate = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> categories = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> dateAdded = const Value.absent(),
                Value<int?> personalRating = const Value.absent(),
                Value<String?> personalReview = const Value.absent(),
                Value<String> favoriteQuotes = const Value.absent(),
                Value<String> readingStatus = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                isbn: isbn,
                title: title,
                author: author,
                coverImageUrl: coverImageUrl,
                publisher: publisher,
                publicationDate: publicationDate,
                pageCount: pageCount,
                categories: categories,
                description: description,
                dateAdded: dateAdded,
                personalRating: personalRating,
                personalReview: personalReview,
                favoriteQuotes: favoriteQuotes,
                readingStatus: readingStatus,
                currentPage: currentPage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String isbn,
                required String title,
                required String author,
                Value<String?> coverImageUrl = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publicationDate = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> categories = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required int dateAdded,
                Value<int?> personalRating = const Value.absent(),
                Value<String?> personalReview = const Value.absent(),
                Value<String> favoriteQuotes = const Value.absent(),
                Value<String> readingStatus = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                isbn: isbn,
                title: title,
                author: author,
                coverImageUrl: coverImageUrl,
                publisher: publisher,
                publicationDate: publicationDate,
                pageCount: pageCount,
                categories: categories,
                description: description,
                dateAdded: dateAdded,
                personalRating: personalRating,
                personalReview: personalReview,
                favoriteQuotes: favoriteQuotes,
                readingStatus: readingStatus,
                currentPage: currentPage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      BookData,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (BookData, BaseReferences<_$AppDatabase, $BooksTable, BookData>),
      BookData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
}
