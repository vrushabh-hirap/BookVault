import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/glass_card.dart';
import '../library/library_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 32),
            
            _buildSection(
              context,
              title: 'Appearance',
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle between light and dark themes', style: TextStyle(color: AppColors.textSecondary)),
                value: themeMode == ThemeMode.dark,
                onChanged: (val) {
                  ref.read(appThemeModeProvider.notifier).toggleThemeMode();
                },
                activeColor: AppColors.accentPrimary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              title: 'Data Management',
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Export Library as JSON'),
                    subtitle: const Text('Save your entire library data to a file', style: TextStyle(color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.upload, color: AppColors.textSecondary),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _handleExport(context, ref),
                  ),
                  const Divider(color: AppColors.borderSubtle),
                  ListTile(
                    title: const Text('Import Library from JSON'),
                    subtitle: const Text('Restore your library from a previous export', style: TextStyle(color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.download, color: AppColors.textSecondary),
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _handleImport(context, ref),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              title: 'About',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BookVault v1.0.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Created by BookVault Team', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Text('A beautiful, distraction-free way to track your reading journey.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ],
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Library as JSON',
        fileName: 'bookvault_export.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final exportService = ref.read(exportServiceProvider);
        final books = ref.read(bookListProvider).value ?? [];
        await exportService.exportAsJson(books, outputFile);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Library exported successfully'), backgroundColor: AppColors.successGreen),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    }
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Import Library from JSON',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final importService = ref.read(importServiceProvider);
        final db = ref.read(appDatabaseProvider);
        
        final importResult = await importService.importFromJson(result.files.single.path!, db.booksDao);
        
        if (context.mounted) {
          if (importResult.errors.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Import completed with errors. ${importResult.imported} imported, ${importResult.skipped} skipped.'), backgroundColor: AppColors.warningAmber),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Library imported successfully! ${importResult.imported} added, ${importResult.skipped} duplicates skipped.'), backgroundColor: AppColors.successGreen),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    }
  }
}
