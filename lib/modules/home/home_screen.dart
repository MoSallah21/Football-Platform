import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/presentation/bloc/league_bloc.dart';
import 'package:football_platform/features/prediction/presentation/bloc/predict_bloc.dart';
import 'package:football_platform/features/prediction/presentation/pages/choose_mode_page.dart';
import 'package:football_platform/features/quiz/presentation/pages/about_football_page.dart';
import 'package:football_platform/features/news/presentation/pages/layout/league_home.dart';
import 'package:football_platform/features/board/presentation/pages/board_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/injection_container.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin { // Reduced to single ticker
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  bool _isDialogShowing = false;

  // Static cached data
  static const List<String> _titles = [
    'Leagues',
    'Match Predictions',
    'Football Knowledge',
    'Tactics Board',
  ];

  static const List<String> _subtitles = [
    'Explore Championships',
    'AI-Powered Analysis',
    'Learn & Master',
    'Strategic Planning',
  ];

  static const List<String> _images = [
    'assets/images/league.png',
    'assets/images/cup.png',
    'assets/images/football_86.png',
    'assets/images/tactical 1.png',
  ];

  static const List<List<Color>> _gradientColors = [
    [Color(0xFF2E8B57), Color(0xFF90EE90)],
    [Color(0xFFFF6B35), Color(0xFFFFD700)],
    [Color(0xFF1E90FF), Color(0xFF87CEEB)],
    [Color(0xFF8B0000), Color(0xFFDC143C)],
  ];

  static const List<IconData> _icons = [
    Icons.emoji_events,
    Icons.psychology_alt,
    Icons.school,
    Icons.sports_football,
  ];

  // Cache pages to prevent rebuilding
  static List<Widget>? _cachedPages;
  static List<Widget> _getPages() {
    _cachedPages ??= [
      BlocProvider<LeagueBloc>(
        create: (context) => LeagueBloc(
          getLeagueTableUseCase: di.sl(),
          getTopScoresUseCase: di.sl(),
          getUpcomingUseCase: di.sl(),
          getLiveMatchesUseCase: di.sl(),
          getAllMatchesUseCase: di.sl(),
          fetchLiveMatchesDataUseCase: di.sl(),
        ),
        child: const HomeLeague(),
      ),
      BlocProvider(
        create: (context) => PredictBloc(predict: di.sl()),
        child: ChooseModeScreen(),
      ),
      AboutFootBallPage(),
      const BoardPage(),
    ];
    return _cachedPages!;
  }

  void _showComingSoonDialog() {
    if (_isDialogShowing) return;

    setState(() => _isDialogShowing = true);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const _ComingSoonDialog(),
    ).then((_) {
      if (mounted) {
        setState(() => _isDialogShowing = false);
      }
    });
  }

  void _handleItemTap(int index) {
    if (index == 1) {
      _showComingSoonDialog();
    } else {
      navigateTo(context, _getPages()[index]);
    }
  }

  @override
  void initState() {
    super.initState();

    // Single animation controller for better performance
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    ));

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
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
              Color(0xFF0F4C75),
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
              Color(0xFF388E3C),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                const _StatsRow(),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildGrid(),
                ),
                const _Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const _CompactHeader(),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1.0,
      ),
      itemCount: _titles.length,
      itemBuilder: (context, index) => _OptimizedGridItem(
        title: _titles[index],
        subtitle: _subtitles[index],
        image: _images[index],
        gradientColors: _gradientColors[index],
        icon: _icons[index],
        index: index,
        onTap: () => _handleItemTap(index),
      ),
      physics: const BouncingScrollPhysics(),
      // Performance optimizations
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 200,
    );
  }
}

// Separate dialog widget to prevent rebuilds
class _ComingSoonDialog extends StatelessWidget {
  const _ComingSoonDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E8B57), Color(0xFF90EE90)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E8B57).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 3,
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.construction,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Coming Soon!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Match Predictions feature is currently under development.\nStay tuned for exciting updates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2E8B57),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 5,
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Optimized header widget
class _CompactHeader extends StatelessWidget {
  const _CompactHeader();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, top: 5),
        child: Column(
          children: [
            // Static icon without animation for better performance
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                ),
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E8B57), Color(0xFF32CD32), Color(0xFF90EE90)],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              ),
              child: const Text(
                'MO FOOTBALL ARENA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your Ultimate Football Experience',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Optimized stats row
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: '4', label: 'Features', icon: Icons.stars),
          _StatItem(value: '24/7', label: 'Available', icon: Icons.access_time),
          _StatItem(value: '∞', label: 'Possibilities', icon: Icons.all_inclusive),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// Optimized footer
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_soccer, color: Colors.white38, size: 12),
                SizedBox(width: 6),
                Text(
                  'Version 1.0 • Championship Edition',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.sports_soccer, color: Colors.white38, size: 12),
              ],
            ),
            SizedBox(height: 2),
            Text(
              'Powered by Mo Sallah & Football Passion',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 8,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Highly optimized grid item
class _OptimizedGridItem extends StatefulWidget {
  const _OptimizedGridItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.gradientColors,
    required this.icon,
    required this.index,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String image;
  final List<Color> gradientColors;
  final IconData icon;
  final int index;
  final VoidCallback onTap;

  @override
  State<_OptimizedGridItem> createState() => _OptimizedGridItemState();
}

class _OptimizedGridItemState extends State<_OptimizedGridItem>
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradientColors[0].withOpacity(_isPressed ? 0.3 : 0.5),
                      blurRadius: _isPressed ? 10 : 20,
                      offset: Offset(0, _isPressed ? 5 : 12),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          flex: 2,
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 50),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                widget.image,
                                fit: BoxFit.contain,
                                height: 40,
                                // Cache images for better performance
                                cacheHeight: 80,
                                cacheWidth: 80,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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