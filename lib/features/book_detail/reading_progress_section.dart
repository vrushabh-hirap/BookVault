import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/book.dart';
import '../../shared/widgets/progress_bar_widget.dart';
import 'book_detail_provider.dart';

class ReadingProgressSection extends ConsumerStatefulWidget {
  final Book book;

  const ReadingProgressSection({super.key, required this.book});

  @override
  ConsumerState<ReadingProgressSection> createState() => _ReadingProgressSectionState();
}

class _ReadingProgressSectionState extends ConsumerState<ReadingProgressSection> {
  late TextEditingController _pageController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController(text: widget.book.currentPage.toString());
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveProgress();
      }
    });
  }

  @override
  void didUpdateWidget(ReadingProgressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.currentPage != widget.book.currentPage) {
      if (!_focusNode.hasFocus) {
        _pageController.text = widget.book.currentPage.toString();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveProgress() {
    final newPage = int.tryParse(_pageController.text);
    if (newPage != null && newPage != widget.book.currentPage) {
      ref.read(bookDetailControllerProvider.notifier).updateCurrentPage(widget.book, newPage);
    } else {
      _pageController.text = widget.book.currentPage.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('READING PROGRESS', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        ProgressBarWidget(
          progress: widget.book.progressPercent,
          currentPage: widget.book.currentPage,
          totalPages: widget.book.pageCount ?? 0,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Current Page: ', style: TextStyle(color: AppColors.textSecondary)),
            SizedBox(
              width: 80,
              height: 36,
              child: TextField(
                controller: _pageController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onSubmitted: (_) => _saveProgress(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: AppColors.backgroundCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderSubtle)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderSubtle)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.accentPrimary)),
                ),
              ),
            ),
            if (widget.book.pageCount != null)
              Text(' / ${widget.book.pageCount} pages', style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}
