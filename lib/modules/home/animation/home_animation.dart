import 'package:flutter/material.dart';

/// Optimized Home Animation Controller
/// Reduced from 5 controllers to 1 main controller for maximum performance
class HomeAnimationController {
  late AnimationController _mainController;

  // Single fade animation
  late Animation<double> _fadeAnimation;

  bool _isDisposed = false;

  // Getters
  Animation<double> get fadeAnimation => _fadeAnimation;

  void initialize(TickerProvider vsync) {
    if (_isDisposed) return;

    // Single controller for all animations
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 600), // Reduced from 800
      vsync: vsync,
    );

    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    if (_isDisposed) return;

    // Simple fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() {
    if (_isDisposed) return;
    _mainController.forward();
  }

  void dispose() {
    _isDisposed = true;
    _mainController.dispose();
  }
}