import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = constraints.maxWidth > 500 ? 350.0 : constraints.maxWidth * 0.7;
        final topOffset = (constraints.maxHeight - boxSize) / 2;
        final leftOffset = (constraints.maxWidth - boxSize) / 2;

        return Stack(
          children: [
            // Darkened background with hole
            Positioned.fill(
              child: CustomPaint(
                painter: _OverlayHolePainter(),
              ),
            ),
            
            // Corner brackets
            Positioned(
              top: topOffset,
              left: leftOffset,
              width: boxSize,
              height: boxSize,
              child: CustomPaint(
                painter: _BracketsPainter(),
              ),
            ),

            // Animated scan line
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final lineY = topOffset + (boxSize - 4) * _animation.value;
                return Positioned(
                  top: lineY,
                  left: leftOffset + 16,
                  width: boxSize - 32,
                  height: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentPrimary.withOpacity(0.0),
                          AppColors.accentPrimary,
                          AppColors.accentPrimary.withOpacity(0.0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPrimary.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                  ),
                );
              },
            ),

            // Instructional text
            Positioned(
              bottom: topOffset - 80,
              left: 0,
              right: 0,
              child: const Text(
                'Point camera at barcode\n[ESC to cancel]',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
              ),
            )
          ],
        );
      },
    );
  }
}

class _OverlayHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);
    
    final boxSize = size.width > 500 ? 350.0 : size.width * 0.7;
    final topOffset = (size.height - boxSize) / 2;
    final leftOffset = (size.width - boxSize) / 2;

    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(leftOffset, topOffset, boxSize, boxSize),
      const Radius.circular(16),
    );

    final path = Path()
      ..addRect(outerRect)
      ..addRRect(innerRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BracketsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentPrimary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double length = 40;
    const double radius = 16;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(0, length)
        ..lineTo(0, radius)
        ..quadraticBezierTo(0, 0, radius, 0)
        ..lineTo(length, 0),
      paint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, 0)
        ..lineTo(size.width - radius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, radius)
        ..lineTo(size.width, length),
      paint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - length)
        ..lineTo(0, size.height - radius)
        ..quadraticBezierTo(0, size.height, radius, size.height)
        ..lineTo(length, size.height),
      paint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, size.height)
        ..lineTo(size.width - radius, size.height)
        ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
        ..lineTo(size.width, size.height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
