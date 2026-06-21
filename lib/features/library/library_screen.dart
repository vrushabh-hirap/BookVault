import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import 'library_provider.dart';
import '../statistics/statistics_provider.dart';
import 'book_card.dart';
import 'filter_bar.dart';
import 'search_bar.dart';
import '../../shared/widgets/glass_card.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooksAsync = ref.watch(filteredBooksProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, meta: true): () {
          _searchFocusNode.requestFocus();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 2, child: LibrarySearchBar(focusNode: _searchFocusNode)),
                SizedBox(width: 16),
                Expanded(flex: 3, child: FilterBar()),
              ],
            ),
            const SizedBox(height: 24),
            _buildAnalyticsBar(ref),
            const SizedBox(height: 24),
            Expanded(
              child: filteredBooksAsync.when(
                data: (books) {
                  if (books.isEmpty) {
                    return const Center(child: Text('No books found.'));
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 3;
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 5;
                      } else if (constraints.maxWidth > 900) {
                        crossAxisCount = 4;
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: books[index]);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAnalyticsBar(WidgetRef ref) {
    final statsAsync = ref.watch(bookStatsProvider);
    return statsAsync.when(
      data: (stats) {
        final cards = [
          _StatCardData('Total', stats.totalBooks.toString(), Icons.book),
          _StatCardData('Reading', stats.readingBooks.toString(), Icons.menu_book, color: AppColors.warningAmber),
          _StatCardData('Finished', stats.finishedBooks.toString(), Icons.check_circle, color: AppColors.successGreen),
          _StatCardData('Want to Read', stats.wantToReadBooks.toString(), Icons.bookmark, color: AppColors.infoBlue),
          _StatCardData('Avg Rating', stats.averageRating > 0 ? '${stats.averageRating.toStringAsFixed(1)} ★' : '-', Icons.star, color: AppColors.starColor),
        ];

        return Row(
          children: cards.asMap().entries.map((entry) {
            final delay = entry.key * 80;
            final data = entry.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: entry.key < cards.length - 1 ? 16.0 : 0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Column(
                    children: [
                      Text(
                        data.value,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(data.icon, size: 14, color: data.color ?? AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            data.label,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms, delay: delay.ms).slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: 80, child: Center(child: Text('Stats error'))),
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  _StatCardData(this.label, this.value, this.icon, {this.color});
}
