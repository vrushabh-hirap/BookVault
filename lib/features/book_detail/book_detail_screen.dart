import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/models/book.dart';
import '../../shared/models/reading_status.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/loading_skeleton.dart';
import 'book_detail_provider.dart';
import 'reading_progress_section.dart';
import 'review_section.dart';
import 'quotes_section.dart';

class BookDetailScreen extends ConsumerWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookDetailProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/library');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.errorRed),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: book == null
          ? const Center(child: Text('Book not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Cover Image
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildCover(book.coverImageUrl),
                    ),
                  ),
                  const SizedBox(width: 48),
                  // Right Column: Details
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                book.title,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.2),
                              ),
                            ),
                            const SizedBox(width: 16),
                            _buildStatusDropdown(context, ref, book),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${book.author} · ${book.publisher ?? 'Unknown Publisher'} · ${book.publicationDate ?? 'Unknown Year'}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                        ),
                        if (book.categories.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: book.categories.map((c) => Chip(
                              label: Text(c, style: const TextStyle(fontSize: 12)),
                              backgroundColor: AppColors.backgroundCard,
                              side: const BorderSide(color: AppColors.borderSubtle),
                            )).toList(),
                          ),
                        ],
                        const SizedBox(height: 24),
                        if (book.description != null && book.description!.isNotEmpty) ...[
                          Text(
                            book.description!,
                            style: const TextStyle(height: 1.6, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 32),
                        ],
                        const Divider(color: AppColors.borderSubtle),
                        const SizedBox(height: 32),
                        
                        ReadingProgressSection(book: book),
                        const SizedBox(height: 32),
                        
                        ReviewSection(book: book),
                        const SizedBox(height: 32),
                        
                        QuotesSection(book: book),
                        const SizedBox(height: 64), // bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCover(String? url) {
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => const LoadingSkeleton(height: 400),
        errorWidget: (context, url, error) => Container(
          height: 400,
          color: AppColors.backgroundCard,
          child: const Center(child: Icon(Icons.book, size: 64, color: AppColors.textSecondary)),
        ),
      );
    }
    return Container(
      height: 400,
      color: AppColors.backgroundCard,
      child: const Center(child: Icon(Icons.book, size: 64, color: AppColors.textSecondary)),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, WidgetRef ref, Book book) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReadingStatus>(
          value: book.readingStatus,
          dropdownColor: AppColors.backgroundCard,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          items: ReadingStatus.values.map((s) => DropdownMenuItem(
            value: s,
            child: Text(s.label, style: const TextStyle(fontWeight: FontWeight.w500)),
          )).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(bookDetailControllerProvider.notifier).updateReadingStatus(book, val);
            }
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Delete Book',
        message: 'Are you sure you want to remove this book from your library? This action cannot be undone.',
        confirmLabel: 'Delete',
        onConfirm: () async {
          await ref.read(bookDetailControllerProvider.notifier).deleteBook(bookId);
          if (context.mounted) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/library');
            }
          }
        },
      ),
    );
  }
}
