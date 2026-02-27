import 'package:flutter/material.dart';

/// Optimized draggable icon widget with performance improvements:
/// - Cached size calculations
/// - Const constructors where possible
/// - Reduced setState calls
/// - Efficient clamping logic
/// - Optional physics for smooth animations
class DraggableIcon extends StatefulWidget {
  const DraggableIcon({
    required this.child,
    this.bounds,
    this.initialAlignment = Alignment.bottomRight,
    this.onDragUpdate,
    this.onDragEnd,
    this.enablePhysics = false,
    super.key,
  });

  final Widget child;
  final Rect? bounds;
  final Alignment initialAlignment;
  final ValueChanged<Alignment>? onDragUpdate;
  final ValueChanged<Alignment>? onDragEnd;
  final bool enablePhysics;

  @override
  DraggableIconState createState() => DraggableIconState();
}

class DraggableIconState extends State<DraggableIcon>
    with SingleTickerProviderStateMixin {
  late Alignment _dragAlignment;
  Size? _cachedSize;
  AnimationController? _animationController;
  Animation<Alignment>? _animation;

  // Cached values for better performance
  static const double _estimatedIconSize = 40.0;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _dragAlignment = widget.initialAlignment;

    if (widget.enablePhysics) {
      _animationController = AnimationController(
        duration: _animationDuration,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update cached size when dependencies change
    _cachedSize = MediaQuery.sizeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    _cachedSize ??= MediaQuery.sizeOf(context);

    Widget child = Align(
      alignment: _dragAlignment,
      child: widget.child,
    );

    // Wrap with animation if physics enabled
    if (widget.enablePhysics && _animation != null) {
      child = AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Align(
            alignment: _animation!.value,
            child: widget.child,
          );
        },
      );
    }

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: child,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final size = _cachedSize;
    if (size == null) return;

    // Calculate new alignment
    final deltaAlignment = Alignment(
      details.delta.dx / (size.width / 2),
      details.delta.dy / (size.height / 2),
    );

    final newAlignment = _dragAlignment + deltaAlignment;
    final clampedAlignment = _clampAlignment(newAlignment);

    setState(() {
      _dragAlignment = clampedAlignment;
    });

    widget.onDragUpdate?.call(clampedAlignment);
  }

  void _onPanEnd(DragEndDetails details) {
    final clampedAlignment = _clampAlignment(_dragAlignment);

    if (clampedAlignment != _dragAlignment) {
      setState(() {
        _dragAlignment = clampedAlignment;
      });
    }

    widget.onDragEnd?.call(clampedAlignment);
  }

  /// Clamp alignment within bounds
  Alignment _clampAlignment(Alignment alignment) {
    final size = _cachedSize;
    if (size == null) return alignment;

    double clampedX = alignment.x;
    double clampedY = alignment.y;

    if (widget.bounds != null) {
      // Use custom bounds
      final bounds = widget.bounds!;
      final screenWidth = size.width;
      final screenHeight = size.height;

      // Convert bounds to alignment ratios
      final leftBound = (bounds.left / screenWidth) * 2 - 1;
      final rightBound = (bounds.right / screenWidth) * 2 - 1;
      final topBound = (bounds.top / screenHeight) * 2 - 1;
      final bottomBound = (bounds.bottom / screenHeight) * 2 - 1;

      clampedX = clampedX.clamp(leftBound, rightBound);
      clampedY = clampedY.clamp(topBound, bottomBound);
    } else {
      // Use screen bounds with margin for icon
      final margin = _estimatedIconSize / size.width;
      final verticalMargin = _estimatedIconSize / size.height;

      clampedX = clampedX.clamp(-1.0 + margin, 1.0 - margin);
      clampedY = clampedY.clamp(-1.0 + verticalMargin, 1.0 - verticalMargin);
    }

    return Alignment(clampedX, clampedY);
  }

  /// Reset position to initial alignment
  void resetPosition({bool animate = false}) {
    if (animate && widget.enablePhysics) {
      _animateToAlignment(widget.initialAlignment);
    } else {
      setState(() {
        _dragAlignment = widget.initialAlignment;
      });
    }
  }

  /// Move to specific alignment
  void moveToAlignment(Alignment alignment, {bool animate = false}) {
    final clampedAlignment = _clampAlignment(alignment);

    if (animate && widget.enablePhysics) {
      _animateToAlignment(clampedAlignment);
    } else {
      setState(() {
        _dragAlignment = clampedAlignment;
      });
    }
  }

  /// Animate to target alignment
  void _animateToAlignment(Alignment target) {
    if (_animationController == null) return;

    _animation = AlignmentTween(
      begin: _dragAlignment,
      end: target,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    ));

    _animationController!.forward(from: 0).then((_) {
      setState(() {
        _dragAlignment = target;
      });
    });
  }

  /// Get current alignment
  Alignment get currentAlignment => _dragAlignment;
}

// ============================================================================
// OPTIMIZED BOUNDED DRAGGABLE ICON
// ============================================================================

class BoundedDraggableIcon extends StatelessWidget {
  const BoundedDraggableIcon({
    required this.child,
    required this.fieldBounds,
    this.initialAlignment = Alignment.center,
    this.onDragUpdate,
    this.onDragEnd,
    super.key,
  });

  final Widget child;
  final Rect fieldBounds;
  final Alignment initialAlignment;
  final ValueChanged<Alignment>? onDragUpdate;
  final ValueChanged<Alignment>? onDragEnd;

  @override
  Widget build(BuildContext context) {
    return DraggableIcon(
      bounds: fieldBounds,
      initialAlignment: initialAlignment,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      child: child,
    );
  }
}

// ============================================================================
// DRAG BOUNDARY CONTAINER
// ============================================================================

class DragBoundary extends StatelessWidget {
  const DragBoundary({
    required this.child,
    required this.draggableItems,
    this.showBoundary = false,
    this.boundaryPadding = 0.1,
    super.key,
  });

  final Widget child;
  final List<Widget> draggableItems;
  final bool showBoundary;
  final double boundaryPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define movement area (e.g., 80% of available space)
        final boundaryRect = Rect.fromLTWH(
          constraints.maxWidth * boundaryPadding,
          constraints.maxHeight * boundaryPadding,
          constraints.maxWidth * (1 - 2 * boundaryPadding),
          constraints.maxHeight * (1 - 2 * boundaryPadding),
        );

        return Stack(
          children: [
            child,
            // Optional visible boundary
            if (showBoundary)
              Positioned.fromRect(
                rect: boundaryRect,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            // Draggable items
            ...draggableItems.map(
                  (item) => DraggableIcon(
                bounds: boundaryRect,
                child: item,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// CONTROLLER FOR EXTERNAL CONTROL
// ============================================================================

class DraggableIconController {
  DraggableIconState? _state;

  void attach(DraggableIconState state) {
    _state = state;
  }

  void detach() {
    _state = null;
  }

  void resetPosition({bool animate = false}) {
    _state?.resetPosition(animate: animate);
  }

  void moveToAlignment(Alignment alignment, {bool animate = false}) {
    _state?.moveToAlignment(alignment, animate: animate);
  }

  Alignment? get currentAlignment => _state?.currentAlignment;

  bool get isAttached => _state != null;
}

// ============================================================================
// CONTROLLED DRAGGABLE ICON
// ============================================================================

class ControlledDraggableIcon extends StatefulWidget {
  const ControlledDraggableIcon({
    required this.child,
    required this.controller,
    this.bounds,
    this.initialAlignment = Alignment.center,
    this.onDragUpdate,
    this.onDragEnd,
    super.key,
  });

  final Widget child;
  final DraggableIconController controller;
  final Rect? bounds;
  final Alignment initialAlignment;
  final ValueChanged<Alignment>? onDragUpdate;
  final ValueChanged<Alignment>? onDragEnd;

  @override
  State<ControlledDraggableIcon> createState() => _ControlledDraggableIconState();
}

class _ControlledDraggableIconState extends State<ControlledDraggableIcon> {
  final GlobalKey<DraggableIconState> _key = GlobalKey<DraggableIconState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.attach(_key.currentState!);
    });
  }

  @override
  void dispose() {
    widget.controller.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableIcon(
      key: _key,
      bounds: widget.bounds,
      initialAlignment: widget.initialAlignment,
      onDragUpdate: widget.onDragUpdate,
      onDragEnd: widget.onDragEnd,
      child: widget.child,
    );
  }
}