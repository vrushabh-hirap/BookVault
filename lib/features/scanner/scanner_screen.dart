import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/models/reading_status.dart';
import '../../shared/widgets/glass_card.dart';
import 'scanner_provider.dart';
import 'scanner_overlay.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  late MobileScannerController _scannerController;
  ReadingStatus _selectedStatus = ReadingStatus.wantToRead;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upcA, BarcodeFormat.upcE],
    );
    // Delay slightly to let the widget mount before updating state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scannerStateProvider.notifier).startScanning();
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final state = ref.read(scannerStateProvider);
    if (state.status != ScannerStatus.scanning) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        _scannerController.stop(); // Stop scanning immediately
        ref.read(scannerStateProvider.notifier).detectIsbn(barcode.rawValue!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scannerStateProvider);

    // Watch state to resume scanning if we cancelled the found book
    ref.listen(scannerStateProvider, (prev, next) {
      if (prev?.status != ScannerStatus.scanning && next.status == ScannerStatus.scanning) {
        _scannerController.start();
      }
      if (next.status == ScannerStatus.error && next.errorMessage != null && next.existingBook == null && next.foundBook == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.errorRed),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.errorRed, size: 64),
                    const SizedBox(height: 16),
                    Text('Camera not available', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          if (state.status == ScannerStatus.scanning || state.status == ScannerStatus.detected || state.status == ScannerStatus.fetching)
            const ScannerOverlay(),
            
          // Top controls
          Positioned(
            top: 48,
            left: 24,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () {
                ref.read(scannerStateProvider.notifier).reset();
                context.pop();
              },
            ),
          ),
          
          // Status indicator overlay
          if (state.status == ScannerStatus.detected)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.1),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(color: AppColors.accentPrimary, borderRadius: BorderRadius.circular(32)),
                    child: Text('ISBN detected: ${state.isbn}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            
          if (state.status == ScannerStatus.fetching)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.accentPrimary),
                      const SizedBox(height: 16),
                      Text('Fetching book details...', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            
          if (state.status == ScannerStatus.found && state.foundBook != null)
            _buildConfirmationDialog(context, ref, state),

          if (state.status == ScannerStatus.error && state.existingBook != null)
             _buildDuplicateDialog(context, ref, state),
             
          if (state.status == ScannerStatus.error && state.foundBook == null && state.existingBook == null)
             _buildNotFoundDialog(context, ref, state),
        ],
      ),
    );
  }

  Widget _buildConfirmationDialog(BuildContext context, WidgetRef ref, ScannerStateData state) {
    final book = state.foundBook!;
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GlassCard(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (book.coverImageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(imageUrl: book.coverImageUrl!, width: 100, height: 150, fit: BoxFit.cover),
                          )
                        else
                          Container(width: 100, height: 150, color: AppColors.backgroundSecondary, child: const Icon(Icons.book, size: 48)),
                        
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.title, style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 8),
                              Text(book.author, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('${book.publisher ?? 'Unknown'} · ${book.publicationDate ?? 'Unknown'} · ${book.pageCount ?? '?'} pages', style: const TextStyle(color: AppColors.textTertiary)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.borderSubtle), borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<ReadingStatus>(
                                        value: _selectedStatus,
                                        dropdownColor: AppColors.backgroundCard,
                                        items: ReadingStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
                                        onChanged: (v) {
                                          if (v != null) setState(() => _selectedStatus = v);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(scannerStateProvider.notifier).cancelFoundBook();
                          },
                          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final success = await ref.read(scannerStateProvider.notifier).confirmAddBook(book, _selectedStatus);
                            if (success && context.mounted) {
                              context.pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentPrimary, foregroundColor: Colors.white),
                          child: const Text('Add to Library'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDuplicateDialog(BuildContext context, WidgetRef ref, ScannerStateData state) {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GlassCard(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, size: 48, color: AppColors.infoBlue),
                    const SizedBox(height: 16),
                    Text('Already in Library', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    const Text('This book is already in your library.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(scannerStateProvider.notifier).startScanning();
                          },
                          child: const Text('Scan Another', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(scannerStateProvider.notifier).reset();
                            context.pushReplacement('/library/book/${state.existingBook!.id}');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.infoBlue, foregroundColor: Colors.white),
                          child: const Text('View Book'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundDialog(BuildContext context, WidgetRef ref, ScannerStateData state) {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GlassCard(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 48, color: AppColors.warningAmber),
                    const SizedBox(height: 16),
                    Text('Book Not Found', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Text('Could not find book info for ISBN: ${state.isbn}. Would you like to add it manually?', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(scannerStateProvider.notifier).startScanning();
                          },
                          child: const Text('Scan Another', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(scannerStateProvider.notifier).reset();
                            context.pop();
                            // Manual fallback
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.warningAmber, foregroundColor: Colors.black),
                          child: const Text('Add Manually'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
