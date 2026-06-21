import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/glass_card.dart';
import 'statistics_provider.dart';
import 'widgets/status_pie_chart.dart';
import 'widgets/books_bar_chart.dart';
import 'widgets/streak_card.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(bookStatsProvider);

    return Scaffold(
      body: statsAsync.when(
        data: (stats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Statistics', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 32),
                
                // Top Row: Overall Cards
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Total Books', stats.totalBooks.toString(), Icons.library_books)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Pages Read', stats.totalPagesRead.toString(), Icons.menu_book)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Avg Rating', stats.averageRating > 0 ? '${stats.averageRating.toStringAsFixed(1)} ★' : '-', Icons.star, color: AppColors.starColor)),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Middle Row: Charts
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reading Status', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 24),
                            StatusPieChart(
                              reading: stats.readingBooks,
                              finished: stats.finishedBooks,
                              wantToRead: stats.wantToReadBooks,
                              dropped: stats.droppedBooks,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Books Added (Last 12 Months)', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 250,
                              child: BooksBarChart(addedByMonth: stats.addedByMonth),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Bottom Row: Streaks & Genres
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: StreakCard(streak: stats.currentStreak),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Top Categories', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            _buildCategoriesList(stats.genreDistribution),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 64), // bottom padding
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {Color? color}) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? AppColors.textSecondary, size: 28),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(Map<String, int> distribution) {
    if (distribution.isEmpty) {
      return const Text('No categories found.', style: TextStyle(color: AppColors.textSecondary));
    }
    
    // Sort by count descending
    final entries = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    // Take top 10
    final topEntries = entries.take(10).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: topEntries.map((e) {
        return Chip(
          label: Text('${e.key} (${e.value})', style: const TextStyle(fontSize: 12)),
          backgroundColor: AppColors.backgroundCard,
          side: const BorderSide(color: AppColors.borderSubtle),
        );
      }).toList(),
    );
  }
}
