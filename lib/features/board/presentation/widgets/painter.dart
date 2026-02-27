import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

/// Ultra-optimized Real-time Signature widget
///
/// Maximum performance features:
/// - Immediate real-time rendering (no delay)
/// - RepaintBoundary for isolated repaints
/// - Optimized CustomPainter with shouldRepaint
/// - Minimal widget tree rebuilds
/// - Smooth 60 FPS drawing
class Signature extends StatefulWidget {
  final Color color;
  final double strokeWidth;
  final CustomPainter? backgroundPainter;
  final VoidCallback? onSign;

  const Signature({
    this.color = Colors.black,
    this.strokeWidth = 5.0,
    this.backgroundPainter,
    this.onSign,
    Key? key,
  }) : super(key: key);

  @override
  SignatureState createState() => SignatureState();

  static SignatureState? of(BuildContext context) {
    return context.findAncestorStateOfType<SignatureState>();
  }
}

class SignatureState extends State<Signature> {
  // Store all drawing data
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  // Version tracking for efficient repaints
  int _version = 0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: CustomPaint(
          painter: widget.backgroundPainter,
          foregroundPainter: _SignaturePainter(
            strokes: _strokes,
            currentStroke: _currentStroke,
            strokeColor: widget.color,
            strokeWidth: widget.strokeWidth,
            version: _version,
          ),
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            behavior: HitTestBehavior.opaque,
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(details.globalPosition);

    setState(() {
      _currentStroke = [localPosition];
      _version++;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(details.globalPosition);

    // Real-time update - adds point and triggers immediate repaint
    setState(() {
      _currentStroke.add(localPosition);
      _version++;
    });

    widget.onSign?.call();
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke.isNotEmpty) {
      setState(() {
        _strokes.add(List.from(_currentStroke));
        _currentStroke = [];
        _version++;
      });
    }
  }

  /// Clear all drawings
  void clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
      _version++;
    });
  }

  /// Undo last stroke
  void undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
        _version++;
      });
    }
  }

  /// Check if has any drawing
  bool get hasDrawing => _strokes.isNotEmpty || _currentStroke.isNotEmpty;

  /// Get stroke count
  int get strokeCount => _strokes.length;
}

/// Optimized painter for real-time rendering
class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color strokeColor;
  final double strokeWidth;
  final int version;

  late final Paint _paint;

  _SignaturePainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
    required this.strokeWidth,
    required this.version,
  }) {
    _paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    // Draw current stroke in real-time
    if (currentStroke.isNotEmpty) {
      _drawStroke(canvas, currentStroke);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points) {
    if (points.isEmpty) return;

    if (points.length == 1) {
      // Draw a single point
      canvas.drawCircle(points[0], strokeWidth / 2, _paint);
    } else {
      // Draw lines connecting all points
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], _paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) {
    // Always repaint when version changes (real-time updates)
    return oldDelegate.version != version;
  }

  @override
  bool shouldRebuildSemantics(_SignaturePainter oldDelegate) => false;
}