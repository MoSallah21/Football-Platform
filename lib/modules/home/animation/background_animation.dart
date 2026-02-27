import 'package:flutter/material.dart';
import 'dart:math' as math;

// Optimized Stadium Lines Painter
class OptimizedStadiumLinesPainter extends CustomPainter {
  final Animation<double> animation;
  late Paint _paint;

  OptimizedStadiumLinesPainter({required this.animation}) : super(repaint: animation) {
    // Pre-initialize paint object for better performance
    _paint = Paint()
      ..color = Colors.white.withAlpha(5)
      ..strokeWidth = 0.8 // Reduced stroke width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = false; // Disable anti-aliasing for better performance
  }

  @override
  void paint(Canvas canvas, Size size) {
    const lineSpacing = 50.0; // Increased spacing to reduce line count
    final offset = (animation.value * lineSpacing) % lineSpacing;
    final lineCount = (size.height / lineSpacing).ceil() + 2;

    // Use path for batch drawing - more efficient
    final path = Path();

    for (int i = 0; i < lineCount; i++) {
      final y = (i * lineSpacing) - lineSpacing + offset;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant OptimizedStadiumLinesPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

// Optimized Grass Pattern Painter
class OptimizedGrassPatternPainter extends CustomPainter {
  static Paint? _cachedPaint;

  @override
  void paint(Canvas canvas, Size size) {
    // Cache paint object to avoid recreation
    _cachedPaint ??= Paint()
      ..color = Colors.white.withOpacity(0.03) // Reduced opacity
      ..strokeWidth = 0.3 // Reduced stroke width
      ..isAntiAlias = false; // Disable for better performance

    const lineCount = 15; // Reduced line count
    final spacing = size.width / lineCount;

    // Use path for batch drawing
    final path = Path();

    for (int i = 0; i < lineCount; i++) {
      final x = spacing * i;
      path.moveTo(x, 0);
      path.lineTo(x, size.height);
    }

    canvas.drawPath(path, _cachedPaint!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Optimized Floating Football Elements Widget
class OptimizedFloatingFootballs extends StatelessWidget {
  final Animation<double> animation;
  final Size screenSize;

  const OptimizedFloatingFootballs({
    super.key,
    required this.animation,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: screenSize,
          painter: FloatingFootballPainter(
            animation: animation,
            screenSize: screenSize,
          ),
        );
      },
    );
  }
}

// Custom painter for floating footballs - more efficient than multiple Positioned widgets
class FloatingFootballPainter extends CustomPainter {
  final Animation<double> animation;
  final Size screenSize;
  static const int footballCount = 4; // Reduced from 6

  FloatingFootballPainter({
    required this.animation,
    required this.screenSize,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < footballCount; i++) {
      final progress = (animation.value + i * 0.4) % 2;
      final x = -30 + (progress * screenSize.width);
      final y = 50 + (i * 150.0);

      // Draw football icon using path instead of widget for better performance
      _drawFootballIcon(
        canvas,
        Offset(x, y),
        15 + (i * 2.0), // size
        Colors.white.withOpacity(0.04 + (i * 0.008)), // opacity
        animation.value * math.pi, // rotation
      );
    }
  }

  void _drawFootballIcon(Canvas canvas, Offset center, double size, Color color, double rotation) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // Simple circle representation of football for performance
    canvas.drawCircle(Offset.zero, size / 2, paint);

    // Add some lines to make it look like a football
    final linePaint = Paint()
      ..color = color.withOpacity(color.opacity * 0.8)
      ..strokeWidth = size * 0.1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(-size * 0.3, 0),
      Offset(size * 0.3, 0),
      linePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FloatingFootballPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}