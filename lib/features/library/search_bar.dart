import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import 'library_provider.dart';

class LibrarySearchBar extends ConsumerWidget {
  final FocusNode? focusNode;

  const LibrarySearchBar({super.key, this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      focusNode: focusNode,
      onChanged: (val) {
        ref.read(bookFiltersProvider.notifier).setSearchQuery(val);
      },
      decoration: InputDecoration(
        hintText: 'Search title, author, or ISBN... (CMD+F)',
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.backgroundCard,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentPrimary, width: 1),
        ),
      ),
    );
  }
}
