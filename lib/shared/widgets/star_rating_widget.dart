import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StarRatingWidget extends StatefulWidget {
  final int? rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;
  final bool readOnly;

  const StarRatingWidget({
    super.key,
    this.rating,
    this.onRatingChanged,
    this.size = 24.0,
    this.readOnly = false,
  });

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isActive = _hoveredIndex != null
            ? starIndex <= _hoveredIndex!
            : (widget.rating != null && starIndex <= widget.rating!);

        Widget star = Icon(
          isActive ? Icons.star_rounded : Icons.star_outline_rounded,
          color: isActive ? AppColors.starColor : AppColors.textSecondary,
          size: widget.size,
        ).animate(target: isActive ? 1 : 0).scaleXY(end: 1.1, duration: 150.ms);

        if (widget.readOnly) return star;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hoveredIndex = starIndex),
          onExit: (_) => setState(() => _hoveredIndex = null),
          child: GestureDetector(
            onTap: () {
              if (widget.onRatingChanged != null) {
                widget.onRatingChanged!(starIndex);
              }
            },
            child: star,
          ),
        );
      }),
    );
  }
}
