import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../library/library_provider.dart';
import '../../shared/models/book.dart';
import '../../shared/models/reading_status.dart';

part 'statistics_provider.g.dart';

class BookStats {
  final int totalBooks;
  final int readingBooks;
  final int finishedBooks;
  final int wantToReadBooks;
  final int droppedBooks;
  final double averageRating;
  final int totalPagesRead;
  final Map<String, int> genreDistribution;
  final Map<String, int> addedByMonth;
  final int currentStreak;

  BookStats({
    required this.totalBooks,
    required this.readingBooks,
    required this.finishedBooks,
    required this.wantToReadBooks,
    required this.droppedBooks,
    required this.averageRating,
    required this.totalPagesRead,
    required this.genreDistribution,
    required this.addedByMonth,
    required this.currentStreak,
  });
}

@riverpod
Future<BookStats> bookStats(BookStatsRef ref) async {
  final booksAsync = ref.watch(bookListProvider);
  final List<Book> books = booksAsync.value ?? [];

  // 1. Status counts
  int reading = 0;
  int finished = 0;
  int wantToRead = 0;
  int dropped = 0;
  int totalPages = 0;
  double sumRatings = 0.0;
  int ratedCount = 0;

  final List<DateTime> dateAddedList = [];

  for (final book in books) {
    switch (book.readingStatus) {
      case ReadingStatus.currentlyReading:
        reading++;
        break;
      case ReadingStatus.finished:
        finished++;
        break;
      case ReadingStatus.wantToRead:
        wantToRead++;
        break;
      case ReadingStatus.dropped:
        dropped++;
        break;
    }

    totalPages += book.currentPage;

    if (book.personalRating != null) {
      sumRatings += book.personalRating!;
      ratedCount++;
    }

    dateAddedList.add(book.dateAdded);
  }

  final averageRating = ratedCount > 0 ? sumRatings / ratedCount : 0.0;

  // 2. Genre/Category distribution
  final genreCounts = <String, int>{};
  for (final book in books) {
    if (book.categories.isEmpty) {
      genreCounts['Uncategorized'] = (genreCounts['Uncategorized'] ?? 0) + 1;
    } else {
      for (final cat in book.categories) {
        final formattedCat = cat.trim();
        if (formattedCat.isNotEmpty) {
          genreCounts[formattedCat] = (genreCounts[formattedCat] ?? 0) + 1;
        }
      }
    }
  }

  // 3. Books added per month (last 12 months)
  final addedByMonth = <String, int>{};
  final now = DateTime.now();
  final formatter = DateFormat('MMM yyyy');

  for (int i = 11; i >= 0; i--) {
    final targetMonth = DateTime(now.year, now.month - i, 1);
    addedByMonth[formatter.format(targetMonth)] = 0;
  }

  for (final book in books) {
    final key = formatter.format(book.dateAdded);
    if (addedByMonth.containsKey(key)) {
      addedByMonth[key] = addedByMonth[key]! + 1;
    }
  }

  // 4. Reading streak calculations
  final currentStreak = _calculateStreak(dateAddedList);

  return BookStats(
    totalBooks: books.length,
    readingBooks: reading,
    finishedBooks: finished,
    wantToReadBooks: wantToRead,
    droppedBooks: dropped,
    averageRating: averageRating,
    totalPagesRead: totalPages,
    genreDistribution: genreCounts,
    addedByMonth: addedByMonth,
    currentStreak: currentStreak,
  );
}

int _calculateStreak(List<DateTime> dates) {
  if (dates.isEmpty) return 0;

  final dateSet = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  final yesterdayDate = todayDate.subtract(const Duration(days: 1));

  DateTime currentCheck;
  if (dateSet.contains(todayDate)) {
    currentCheck = todayDate;
  } else if (dateSet.contains(yesterdayDate)) {
    currentCheck = yesterdayDate;
  } else {
    return 0; // Streak broken
  }

  int streak = 0;
  while (dateSet.contains(currentCheck)) {
    streak++;
    currentCheck = currentCheck.subtract(const Duration(days: 1));
  }
  return streak;
}
