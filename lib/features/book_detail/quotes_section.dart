import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/book.dart';
import '../../shared/widgets/glass_card.dart';
import 'book_detail_provider.dart';

class QuotesSection extends ConsumerWidget {
  final Book book;

  const QuotesSection({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('FAVORITE QUOTES', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
            TextButton.icon(
              onPressed: () => _showAddQuoteDialog(context, ref),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Quote'),
              style: TextButton.styleFrom(foregroundColor: AppColors.accentPrimary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (book.favoriteQuotes.isEmpty)
          const Text('No quotes added yet.', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic))
        else
          ...book.favoriteQuotes.map((quote) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '"$quote"',
                        style: const TextStyle(fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: AppColors.textSecondary,
                      onPressed: () {
                        ref.read(bookDetailControllerProvider.notifier).deleteQuote(book, quote);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  void _showAddQuoteDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: const Text('Add Quote'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter a quote...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(bookDetailControllerProvider.notifier).addQuote(book, controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
