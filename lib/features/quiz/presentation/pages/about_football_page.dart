import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/features/blogs/presentation/pages/blogs_page.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/features/quiz/presentation/pages/choose_level_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/injection_container.dart' as di;

class AboutFootBallPage extends StatefulWidget {
  const AboutFootBallPage({super.key});

  @override
  State<AboutFootBallPage> createState() => _AboutFootBallPageState();
}

class _AboutFootBallPageState extends State<AboutFootBallPage>
    with SingleTickerProviderStateMixin { // Reduced to single ticker
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Static cached data
  static const List<String> _imagePaths = [
    'assets/images/kdb.jpg',
    'assets/images/shotss.jpg',
  ];

  static const List<String> _titles = [
    'Games',
    'Blogs',
  ];

  static const List<String> _descriptions = [
    'Test your football knowledge',
    'Read the latest football news',
  ];

  static const List<IconData> _icons = [
    Icons.sports_soccer,
    Icons.article,
  ];

  static const List<List<Color>> _gradientColors = [
    [Color(0xFFFF6B35), Color(0xFFFF8F00)],
    [Color(0xFF1565C0), Color(0xFF0277BD)],
  ];

  static const List<Color> _accentColors = [
    Colors.deepOrange,
    Colors.lightBlue,
  ];

  static const List<String> _sportEmojis = [
    '🏆',
    '📰',
  ];

  // Cache pages
  static List<Widget>? _cachedPages;
  static List<Widget> _getPages() {
    _cachedPages ??= [
      BlocProvider(
        create: (context) => QuizBloc(getAllQuestions: di.sl()),
        child: ChooseLevelPage(),
      ),
      BlocProvider(
        create: (context) => BlogBloc(getAllBlogs: di.sl()),
        child: BlogsPage(),
      ),
    ];
    return _cachedPages!;
  }

  @override
  void initState() {
    super.initState();

    // Single animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F4C3A),
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
              Color(0xFF388E3C),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const _CompactHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: _OptimizedSportsCard(
                            imagePath: _imagePaths[0],
                            title: _titles[0],
                            description: _descriptions[0],
                            icon: _icons[0],
                            onTap: () => navigateToWithSlide(
                              context,
                              _getPages()[0],
                            ),
                            gradientColors: _gradientColors[0],
                            accentColor: _accentColors[0],
                            sportEmoji: _sportEmojis[0],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: _OptimizedSportsCard(
                            imagePath: _imagePaths[1],
                            title: _titles[1],
                            description: _descriptions[1],
                            icon: _icons[1],
                            onTap: () => navigateToWithSlide(
                              context,
                              _getPages()[1],
                            ),
                            gradientColors: _gradientColors[1],
                            accentColor: _accentColors[1],
                            sportEmoji: _sportEmojis[1],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Optimized static header
class _CompactHeader extends StatelessWidget {
  const _CompactHeader();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Static football icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.sports_soccer,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Title with gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Colors.yellowAccent],
              ).createShader(bounds),
              child: const Text(
                'FOOTBALL ARENA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(3, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.yellowAccent.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: const Text(
                '⚽ THE ULTIMATE FOOTBALL EXPERIENCE ⚽',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.yellowAccent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Highly optimized sports card
class _OptimizedSportsCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradientColors;
  final Color accentColor;
  final String sportEmoji;

  const _OptimizedSportsCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.gradientColors,
    required this.accentColor,
    required this.sportEmoji,
  });

  @override
  State<_OptimizedSportsCard> createState() => _OptimizedSportsCardState();
}

class _OptimizedSportsCardState extends State<_OptimizedSportsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _scaleController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _scaleController.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _scaleController.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(_isPressed ? 0.3 : 0.5),
                      spreadRadius: 3,
                      blurRadius: _isPressed ? 15 : 20,
                      offset: Offset(0, _isPressed ? 8 : 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          // Cache images for better performance
                          cacheHeight: 400,
                          cacheWidth: 800,
                          colorBlendMode: BlendMode.multiply,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),

                      // Gradient overlays
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.gradientColors[0].withOpacity(0.7),
                                widget.gradientColors[1].withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Sport emoji badge
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.sportEmoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      // Content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Title
                              Text(
                                widget.title.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.black54,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                    Shadow(
                                      color: widget.accentColor.withOpacity(0.5),
                                      offset: const Offset(0, 0),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Description
                              Text(
                                widget.description.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),

                              // Action button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'ENTER ARENA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.sports_soccer,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}