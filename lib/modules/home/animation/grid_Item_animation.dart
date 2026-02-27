import 'package:flutter/material.dart';

/// Highly optimized grid item animation controller
/// Reduced from multiple animations to single essential animation
class GridItemAnimationController {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool _isDisposed = false;

  // Getters
  Animation<double> get scaleAnimation => _scaleAnimation;

  void initialize(TickerProvider vsync) {
    if (_isDisposed) return;

    // Single controller with minimal duration
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150), // Reduced from 200
      vsync: vsync,
    );

    _setupAnimation();
  }

  void _setupAnimation() {
    if (_isDisposed) return;

    // Simple scale animation - removed glow and stagger for performance
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95, // Subtle press effect
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
  }

  void startPress() {
    if (_isDisposed) return;
    _scaleController.forward();
  }

  void stopPress() {
    if (_isDisposed) return;
    _scaleController.reverse();
  }

  void dispose() {
    _isDisposed = true;
    _scaleController.dispose();
  }
}