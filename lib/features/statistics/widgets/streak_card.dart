import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class StreakCard extends StatelessWidget {
  final int streak;

  const StreakCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                color: streak > 0 ? AppColors.warningAmber : AppColors.textSecondary,
                size: 48,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak Days',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: streak > 0 ? AppColors.warningAmber : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Current Streak', style: TextStyle(color: AppColors.textTertiary)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            streak > 0 
                ? 'Keep it up! You\'re doing great.' 
                : 'Read a book today to start your streak!',
            style: const TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
