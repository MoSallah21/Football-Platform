import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/core/componants/background.dart';
import '../bloc/quiz_bloc.dart';
import 'quiz_home_page.dart';

class ChooseLevelPage extends StatefulWidget {
  const ChooseLevelPage({super.key});

  @override
  State<ChooseLevelPage> createState() => _ChooseLevelPageState();
}

class _ChooseLevelPageState extends State<ChooseLevelPage>
    with SingleTickerProviderStateMixin { // Reduced to single ticker
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Static level data - created once at compile time
  static const List<Map<String, dynamic>> _levelsData = [
    {
      'title': 'Easy',
      'subtitle': 'Perfect for beginners',
      'icon': Icons.sentiment_satisfied,
      'level': 1,
    },
    {
      'title': 'Medium',
      'subtitle': 'Moderate challenge',
      'icon': Icons.sentiment_neutral,
      'level': 2,
    },
    {
      'title': 'Hard',
      'subtitle': 'Ultimate challenge',
      'icon': Icons.sentiment_very_dissatisfied,
      'level': 3,
    },
  ];

  // Static gradient colors - precomputed
  static final List<List<Color>> _gradients = [
    [Colors.green.shade400, Colors.green.shade600],
    [Colors.orange.shade400, Colors.orange.shade600],
    [Colors.red.shade400, Colors.red.shade600],
  ];

  static final List<Color> _shadowColors = [
    Colors.green.withOpacity(0.4),
    Colors.orange.withOpacity(0.4),
    Colors.red.withOpacity(0.4),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fadeController.forward();
  }

  void _initializeAnimations() {
    // Single simple fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(
        img: 2,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                const SizedBox(height: 60),
                const _HeaderCard(),
                const SizedBox(height: 50),
                ..._buildLevelButtons(),
                const SizedBox(height: 30),
                _ExitButton(
                  onTap: () => navigateAndFinish(context, const HomeScreen()),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLevelButtons() {
    return List.generate(_levelsData.length, (index) {
      return RepaintBoundary(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: _LevelCard(
            level: _levelsData[index],
            gradient: _gradients[index],
            shadowColor: _shadowColors[index],
            onTap: () => navigateToWithSlide(
              context,
              BlocProvider.value(value: context.read<QuizBloc>(),
              child: QuizHomePage(level: _levelsData[index]['level'] as int)),
            ),
          ),
        ),
      );
    });
  }
}

// Optimized header card - const widget
class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.3),
              Colors.deepPurple.withOpacity(0.3),
              Colors.indigo.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Column(
          children: [
            _HeaderIcon(),
            SizedBox(height: 20),
            _HeaderTitle(),
            SizedBox(height: 10),
            _HeaderSubtitle(),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.6),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.emoji_events,
        color: Colors.white,
        size: 45,
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.white,
          Colors.purple.shade200,
          Colors.indigo.shade200,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        'Q/A Game',
        style: TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
      ),
    );
  }
}

class _HeaderSubtitle extends StatelessWidget {
  const _HeaderSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Choose Your Level',
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        shadows: [
          Shadow(
            color: Colors.purple.withOpacity(0.7),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}

// Optimized level card with press animation only
class _LevelCard extends StatefulWidget {
  final Map<String, dynamic> level;
  final List<Color> gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard>
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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor,
                  blurRadius: _isPressed ? 15 : 20,
                  offset: Offset(0, _isPressed ? 8 : 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
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
                borderRadius: BorderRadius.circular(25),
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      _LevelIcon(icon: widget.level['icon'] as IconData),
                      const SizedBox(width: 20),
                      _LevelInfo(
                        title: widget.level['title'] as String,
                        subtitle: widget.level['subtitle'] as String,
                      ),
                      const _ArrowIcon(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LevelIcon extends StatelessWidget {
  final IconData icon;

  const _LevelIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class _LevelInfo extends StatelessWidget {
  final String title;
  final String subtitle;

  const _LevelInfo({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowIcon extends StatelessWidget {
  const _ArrowIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

// Optimized exit button
class _ExitButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ExitButton({required this.onTap});

  @override
  State<_ExitButton> createState() => _ExitButtonState();
}

class _ExitButtonState extends State<_ExitButton>
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
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade600, Colors.grey.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: _isPressed ? 12 : 15,
                    offset: Offset(0, _isPressed ? 6 : 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
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
                  borderRadius: BorderRadius.circular(25),
                  splashColor: Colors.white.withOpacity(0.3),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ExitIcon(),
                        SizedBox(width: 15),
                        Text(
                          'Exit to Home',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExitIcon extends StatelessWidget {
  const _ExitIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.exit_to_app,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}