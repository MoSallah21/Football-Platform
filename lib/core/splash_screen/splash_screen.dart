import 'package:flutter/material.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/core/componants/background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  String _appVersion = '';
  bool _isLoading = true;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  // Cache animations to prevent rebuilding
  static const Duration _animationDuration = Duration(milliseconds: 1500);
  static const Duration _minSplashDuration = Duration(milliseconds: 2500);
  static const Duration _navigationDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    // Fade animation with optimized curve
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Scale animation for subtle zoom effect
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();

    try {
      // Run package info fetch asynchronously
      final packageInfo = await PackageInfo.fromPlatform();

      if (!mounted) return;

      setState(() {
        _appVersion = packageInfo.version;
        _isLoading = false;
      });

      // Start animation
      _animationController.forward();

      // Calculate remaining time to meet minimum splash duration
      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = _minSplashDuration - elapsedTime;

      if (remainingTime.isNegative) {
        // If already past minimum duration, wait a bit for animation
        await Future.delayed(_navigationDelay);
      } else {
        // Wait for remaining time
        await Future.delayed(remainingTime);
      }

      if (mounted) {
        _navigateToHome();
      }
    } catch (e) {
      // Handle error gracefully
      if (!mounted) return;

      setState(() {
        _appVersion = '1.0.0'; // Default version
        _isLoading = false;
      });

      _animationController.forward();

      // Still navigate even if version fetch failed
      await Future.delayed(_minSplashDuration);
      if (mounted) {
        _navigateToHome();
      }
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const HomeScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Optimized fade transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(
        img: 3,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Lottie animation with optimized settings
                _buildLottieAnimation(),

                // App info section
                _buildAppInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return RepaintBoundary(
      child: Lottie.asset(
        'assets/lottie/splash_ball.json',
        width: 300,
        height: 300,
        fit: BoxFit.contain, // Changed from fill for better performance
        repeat: true,
        animate: true,
        // Performance optimizations
        options: LottieOptions(
          enableMergePaths: true, // Reduce draw calls
        ),
        // Reduce memory usage by limiting animation layers
        frameRate: FrameRate.max,
      ),
    );
  }

  Widget _buildAppInfo() {
    if (_isLoading) {
      return const _LoadingIndicator();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _AppInfoContent(appVersion: _appVersion),
      ),
    );
  }
}

// Separate widget to prevent rebuilds
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          strokeWidth: 3,
        ),
      ),
    );
  }
}

// Separate widget for app info to optimize rebuilds
class _AppInfoContent extends StatelessWidget {
  final String appVersion;

  const _AppInfoContent({required this.appVersion});

  // Cache text styles to prevent rebuilding
  static final _titleStyle = GoogleFonts.caveat(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      shadows: [
        Shadow(
          color: Colors.purple,
          offset: Offset(2, 2),
          blurRadius: 8,
        ),
        Shadow(
          color: Colors.black26,
          offset: Offset(1, 1),
          blurRadius: 4,
        ),
      ],
    ),
  );

  static final _versionStyle = GoogleFonts.caveat(
    textStyle: const TextStyle(
      color: Colors.purple,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
      shadows: [
        Shadow(
          color: Colors.white,
          offset: Offset(1, 1),
          blurRadius: 6,
        ),
        Shadow(
          color: Colors.black12,
          offset: Offset(0.5, 0.5),
          blurRadius: 2,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App title
          Text(
            "Mo Football Platform",
            style: _titleStyle,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Version text
          Text(
            "Version $appVersion",
            style: _versionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}