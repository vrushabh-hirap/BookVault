import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/import_service.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  // Initialized at main startup and overridden
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  static const _themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final saved = prefs.getString(_themeKey);
    if (saved == null) {
      return ThemeMode.dark; // Dark mode is default
    }
    return ThemeMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => ThemeMode.dark,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_themeKey, mode.name);
  }

  Future<void> toggleThemeMode() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

@riverpod
ExportService exportService(ExportServiceRef ref) {
  return ExportService();
}

@riverpod
ImportService importService(ImportServiceRef ref) {
  return ImportService();
}
