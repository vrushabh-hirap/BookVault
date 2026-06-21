import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class SidebarLayout extends StatelessWidget {
  final Widget child;

  const SidebarLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // This is a stub for the shell route that we will flesh out during LibraryScreen generation
    // We will build the full sidebar here later
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: AppColors.backgroundSecondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.library_books), // Placeholder for logo
                      SizedBox(width: 8),
                      Text('BookVault', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Library'),
                  onTap: () => context.go('/library'),
                ),
                ListTile(
                  title: const Text('Statistics'),
                  onTap: () => context.go('/statistics'),
                ),
                ListTile(
                  title: const Text('Settings'),
                  onTap: () => context.go('/settings'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/scanner'),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: AppColors.borderSubtle),
          Expanded(child: child),
        ],
      ),
    );
  }
}
