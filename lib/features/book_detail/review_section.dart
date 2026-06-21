import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/book.dart';
import '../../shared/widgets/star_rating_widget.dart';
import 'book_detail_provider.dart';

class ReviewSection extends ConsumerStatefulWidget {
  final Book book;

  const ReviewSection({super.key, required this.book});

  @override
  ConsumerState<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends ConsumerState<ReviewSection> {
  late TextEditingController _reviewController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController(text: widget.book.personalReview ?? '');
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onReviewChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      ref.read(bookDetailControllerProvider.notifier).updateReview(widget.book, val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PERSONAL REVIEW', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        StarRatingWidget(
          rating: widget.book.personalRating,
          onRatingChanged: (val) {
            ref.read(bookDetailControllerProvider.notifier).updateRating(widget.book, val);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _reviewController,
          maxLines: 4,
          onChanged: _onReviewChanged,
          decoration: InputDecoration(
            hintText: 'Write your thoughts here...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.backgroundCard,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderSubtle)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderSubtle)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentPrimary)),
          ),
        ),
      ],
    );
  }
}
