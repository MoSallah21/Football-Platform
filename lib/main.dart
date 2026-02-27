import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/splash_screen/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/bloc_observer.dart';
import 'core/cache/cache_helper.dart';
import 'injection_container.dart' as di;

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI immediately (no async needed)
  _configureSystemUI();

  // Initialize critical services with error handling
  await _initializeCriticalServices();

  // Set up global configurations
  Bloc.observer = MyBlocObserver();

  // Optimize memory usage
  _optimizeMemoryUsage();

  runApp(const MyApp());
}

Future<void> _initializeCriticalServices() async {
  try {
    // Run critical initializations in parallel
    await Future.wait<void>([
      CacheHelper.init(),
      Firebase.initializeApp(),
      di.init(),
    ], eagerError: true);
  } catch (e) {
    // Log error but don't crash the app
    if (kDebugMode) {
      print('Initialization error: $e');
    }
    // You might want to show an error screen here
  }
}

void _configureSystemUI() {
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
}

void _optimizeMemoryUsage() {
  // Enable deferred loading of images
  if (!kDebugMode) {
    // Reduce image cache size in production
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Static theme to prevent rebuilding
  static ThemeData? _cachedTheme;

  static ThemeData get _theme {
    _cachedTheme ??= _buildTheme();
    return _cachedTheme!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mo Football Platform',
      theme: _theme,
      home: const SplashPage(),

      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Fixed text scaling
          ),
          child: child!,
        );
      },

      // Optimize scrolling performance
      scrollBehavior: const _CustomScrollBehavior(),

      // Disable performance overlay in production
      showPerformanceOverlay: false,

      // Disable checkerboard layers
      checkerboardRasterCacheImages: false,
      checkerboardOffscreenLayers: false,

      // Disable debug banner
      showSemanticsDebugger: false,
    );
  }

  static ThemeData _buildTheme() {
    // Pre-load Google Fonts to prevent loading delays
    final textTheme = GoogleFonts.latoTextTheme();

    return ThemeData(
      useMaterial3: true,

      // Color scheme
      primaryColor: Colors.purple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.light,
      ),

      // Splash and highlight colors
      splashColor: Colors.purple.withOpacity(0.3),
      highlightColor: Colors.purple.withOpacity(0.1),

      // Optimized text theme with pre-defined styles
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
        displayMedium: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
        displaySmall: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
        headlineLarge: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w600, height: 1.3),
        headlineMedium: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
        headlineSmall: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
        titleLarge: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w600, height: 1.4),
        titleMedium: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4),
        titleSmall: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4),
        bodyLarge: GoogleFonts.lato(fontSize: 16, height: 1.5),
        bodyMedium: GoogleFonts.lato(fontSize: 14, height: 1.4),
        bodySmall: GoogleFonts.lato(fontSize: 12, height: 1.3),
        labelLarge: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, height: 1.2),
        labelMedium: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w500, height: 1.2),
        labelSmall: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w500, height: 1.2),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.15,
        ),
      ),

      // Scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return Colors.purple.withOpacity(0.9);
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.purple.withOpacity(0.8);
          }
          return Colors.purple.withOpacity(0.6);
        }),
        trackColor: WidgetStateProperty.all(Colors.purple.withOpacity(0.1)),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(6.0),
        crossAxisMargin: 2.0,
        mainAxisMargin: 4.0,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.purple.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.purple,
          side: const BorderSide(color: Colors.purple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Platform adaptive design
      platform: defaultTargetPlatform,

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

// Custom scroll behavior for better performance
class _CustomScrollBehavior extends ScrollBehavior {
  const _CustomScrollBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // No scrollbar by default for better performance
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}