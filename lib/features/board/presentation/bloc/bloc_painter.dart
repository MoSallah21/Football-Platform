import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

// ============================================================================
// EVENTS
// ============================================================================

abstract class SignatureEvent {}

class StartDrawing extends SignatureEvent {
  final Offset position;
  StartDrawing(this.position);
}

class UpdateDrawing extends SignatureEvent {
  final Offset position;
  UpdateDrawing(this.position);
}

class EndDrawing extends SignatureEvent {}

class ClearSignature extends SignatureEvent {}

class UndoLastStroke extends SignatureEvent {}

// ============================================================================
// STATE
// ============================================================================

class SignatureState {
  final List<List<Offset>> completedStrokes;
  final List<Offset> currentStroke;
  final bool hasDrawing;
  final int version; // For triggering repaints

  const SignatureState({
    this.completedStrokes = const [],
    this.currentStroke = const [],
    this.hasDrawing = false,
    this.version = 0,
  });

  SignatureState copyWith({
    List<List<Offset>>? completedStrokes,
    List<Offset>? currentStroke,
    bool? hasDrawing,
    int? version,
  }) {
    return SignatureState(
      completedStrokes: completedStrokes ?? this.completedStrokes,
      currentStroke: currentStroke ?? this.currentStroke,
      hasDrawing: hasDrawing ?? this.hasDrawing,
      version: version ?? this.version,
    );
  }
}

// ============================================================================
// BLOC
// ============================================================================

class SignatureBloc extends Bloc<SignatureEvent, SignatureState> {
  SignatureBloc() : super(const SignatureState()) {
    on<StartDrawing>(_onStartDrawing);
    on<UpdateDrawing>(_onUpdateDrawing);
    on<EndDrawing>(_onEndDrawing);
    on<ClearSignature>(_onClearSignature);
    on<UndoLastStroke>(_onUndoLastStroke);
  }

  void _onStartDrawing(StartDrawing event, Emitter<SignatureState> emit) {
    emit(state.copyWith(
      currentStroke: [event.position],
      hasDrawing: true,
      version: state.version + 1,
    ));
  }

  void _onUpdateDrawing(UpdateDrawing event, Emitter<SignatureState> emit) {
    // Real-time update: add point to current stroke
    final updatedStroke = List<Offset>.from(state.currentStroke)
      ..add(event.position);

    emit(state.copyWith(
      currentStroke: updatedStroke,
      version: state.version + 1,
    ));
  }

  void _onEndDrawing(EndDrawing event, Emitter<SignatureState> emit) {
    if (state.currentStroke.isNotEmpty) {
      final updatedStrokes = List<List<Offset>>.from(state.completedStrokes)
        ..add(state.currentStroke);

      emit(state.copyWith(
        completedStrokes: updatedStrokes,
        currentStroke: [],
        version: state.version + 1,
      ));
    }
  }

  void _onClearSignature(ClearSignature event, Emitter<SignatureState> emit) {
    emit(const SignatureState());
  }

  void _onUndoLastStroke(UndoLastStroke event, Emitter<SignatureState> emit) {
    if (state.completedStrokes.isNotEmpty) {
      final updatedStrokes = List<List<Offset>>.from(state.completedStrokes)
        ..removeLast();

      emit(state.copyWith(
        completedStrokes: updatedStrokes,
        hasDrawing: updatedStrokes.isNotEmpty,
        version: state.version + 1,
      ));
    }
  }
}

// ============================================================================
// WIDGET
// ============================================================================

class SignatureBlocWidget extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final CustomPainter? backgroundPainter;
  final VoidCallback? onSign;

  const SignatureBlocWidget({
    this.color = Colors.black,
    this.strokeWidth = 5.0,
    this.backgroundPainter,
    this.onSign,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignatureBloc, SignatureState>(
      // CRITICAL: Always rebuild when version changes for real-time updates
      buildWhen: (previous, current) => previous.version != current.version,
      builder: (context, state) {
        return RepaintBoundary(
          child: ClipRect(
            child: CustomPaint(
              painter: backgroundPainter,
              foregroundPainter: _SignaturePainterBloc(
                completedStrokes: state.completedStrokes,
                currentStroke: state.currentStroke,
                strokeColor: color,
                strokeWidth: strokeWidth,
                version: state.version,
              ),
              child: _SignatureGestureDetector(onSign: onSign),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// GESTURE DETECTOR
// ============================================================================

class _SignatureGestureDetector extends StatelessWidget {
  final VoidCallback? onSign;

  const _SignatureGestureDetector({this.onSign});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localPosition = box.globalToLocal(details.globalPosition);
          context.read<SignatureBloc>().add(StartDrawing(localPosition));
        }
      },
      onPanUpdate: (details) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localPosition = box.globalToLocal(details.globalPosition);
          context.read<SignatureBloc>().add(UpdateDrawing(localPosition));
          onSign?.call();
        }
      },
      onPanEnd: (details) {
        context.read<SignatureBloc>().add(EndDrawing());
      },
      behavior: HitTestBehavior.opaque,
    );
  }
}

// ============================================================================
// PAINTER
// ============================================================================

class _SignaturePainterBloc extends CustomPainter {
  final List<List<Offset>> completedStrokes;
  final List<Offset> currentStroke;
  final Color strokeColor;
  final double strokeWidth;
  final int version;

  late final Paint _paint;

  _SignaturePainterBloc({
    required this.completedStrokes,
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
    for (final stroke in completedStrokes) {
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
      // Single point - draw circle
      canvas.drawCircle(points[0], strokeWidth / 2, _paint);
    } else {
      // Multiple points - draw connected lines
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], _paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainterBloc oldDelegate) {
    // Repaint whenever version changes
    return oldDelegate.version != version;
  }

  @override
  bool shouldRebuildSemantics(_SignaturePainterBloc oldDelegate) => false;
}

// ============================================================================
// HELPER EXTENSIONS
// ============================================================================

extension SignatureBlocExtension on BuildContext {
  void clearSignature() {
    read<SignatureBloc>().add(ClearSignature());
  }

  void undoLastStroke() {
    read<SignatureBloc>().add(UndoLastStroke());
  }

  bool hasSignature() {
    return read<SignatureBloc>().state.hasDrawing;
  }

  int getStrokeCount() {
    return read<SignatureBloc>().state.completedStrokes.length;
  }
}