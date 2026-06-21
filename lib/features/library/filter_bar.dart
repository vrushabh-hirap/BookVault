import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/reading_status.dart';
import 'library_provider.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(bookFiltersProvider);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusDropdown(context, ref, filters.statusFilter),
          const SizedBox(width: 12),
          _buildRatingDropdown(context, ref, filters.ratingFilter),
          const SizedBox(width: 12),
          _buildSortDropdown(context, ref, filters.sortBy),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, WidgetRef ref, ReadingStatus? current) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReadingStatus?>(
          value: current,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          dropdownColor: AppColors.backgroundCard,
          items: [
            const DropdownMenuItem(value: null, child: Text('All Statuses')),
            ...ReadingStatus.values.map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.label),
            )),
          ],
          onChanged: (val) {
            ref.read(bookFiltersProvider.notifier).setStatusFilter(val);
          },
        ),
      ),
    );
  }

  Widget _buildRatingDropdown(BuildContext context, WidgetRef ref, int? current) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: current,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          dropdownColor: AppColors.backgroundCard,
          items: [
            const DropdownMenuItem(value: null, child: Text('Any Rating')),
            ...List.generate(5, (index) {
              final rating = index + 1;
              return DropdownMenuItem(
                value: rating,
                child: Text('≥ $rating ★'),
              );
            }),
          ],
          onChanged: (val) {
            ref.read(bookFiltersProvider.notifier).setRatingFilter(val);
          },
        ),
      ),
    );
  }

  Widget _buildSortDropdown(BuildContext context, WidgetRef ref, SortOption current) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOption>(
          value: current,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          dropdownColor: AppColors.backgroundCard,
          items: SortOption.values.map((s) {
            String label = s.name;
            switch(s) {
              case SortOption.dateAddedDesc: label = 'Date Added (Newest)'; break;
              case SortOption.dateAddedAsc: label = 'Date Added (Oldest)'; break;
              case SortOption.titleAsc: label = 'Title (A-Z)'; break;
              case SortOption.authorAsc: label = 'Author (A-Z)'; break;
              case SortOption.ratingDesc: label = 'Rating (Highest)'; break;
            }
            return DropdownMenuItem(
              value: s,
              child: Text(label),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(bookFiltersProvider.notifier).setSortBy(val);
            }
          },
        ),
      ),
    );
  }
}
