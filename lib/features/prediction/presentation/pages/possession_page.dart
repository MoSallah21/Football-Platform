import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_platform/features/prediction/presentation/pages/shoots_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';

class PossessionPage extends StatefulWidget {
  const PossessionPage({
    super.key,
    required this.mode,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeImg,
    required this.awayImg,
    required this.homeCode,
    required this.awayCode,
    required this.homeAvgShoots,
    required this.homeAvgShootsOn,
    required this.awayAvgShoots,
    required this.awayAvgShootsOn,
    required this.homeAvgCorners,
    required this.awayAvgCorners,
    required this.homeAvgChances,
    required this.awayAvgChances,
  });

  final double mode;
  final String homeTeam;
  final String awayTeam;
  final String homeImg;
  final String awayImg;
  final double homeCode;
  final double awayCode;
  final double homeAvgShoots;
  final double homeAvgShootsOn;
  final double awayAvgShoots;
  final double awayAvgShootsOn;
  final double homeAvgCorners;
  final double homeAvgChances;
  final double awayAvgCorners;
  final double awayAvgChances;

  @override
  State<PossessionPage> createState() => _PossessionPageState();
}

class _PossessionPageState extends State<PossessionPage>
    with SingleTickerProviderStateMixin {
  // Use single AnimationController for better performance
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late final TextEditingController _homePosController;
  late final TextEditingController _awayPosController;

  // Cache regex pattern
  static final _numberRegex = RegExp(r'^\d*\.?\d{0,2}$');

  // Pre-calculate constant colors
  static const _backgroundColor = Color(0xFF0A0E27);
  static const _gradientStart = Color(0xFF0A0E27);
  static const _gradientMiddle = Color(0xFF1A1F3A);
  static const _gradientEnd = Color(0xFF2A2F4A);
  static const _accentGreen = Color(0xFF00FF88);
  static const _accentBlue = Color(0xFF0066FF);
  static const _cardColor1 = Color(0xFF1E2A4A);
  static const _cardColor2 = Color(0xFF2A3A5A);
  static const _inputBg1 = Color(0xFF2A3A5A);
  static const _inputBg2 = Color(0xFF1E2A4A);

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _homePosController = TextEditingController();
    _awayPosController = TextEditingController();

    // Single animation controller with optimized duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Create animations from single controller
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Start animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _homePosController.dispose();
    _awayPosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_gradientStart, _gradientMiddle, _gradientEnd],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Better scroll performance
          child: Column(
            children: [
              // Optimized header
              _buildHeader(context),

              // Title
              _buildTitle(),

              // Team cards
              _buildTeamCards(),

              const SizedBox(height: 40),

              // Action button
              _buildActionButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: mediaHeight / 2.5,
        child: Stack(
          children: [
            // Static gradient overlay (removed image for performance)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      _accentGreen.withOpacity(0.1),
                      _accentBlue.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            // Radial gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      Colors.transparent,
                      _accentGreen.withOpacity(0.1),
                      _accentBlue.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _accentGreen.withOpacity(0.1),
              _accentBlue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _accentGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Text(
          'Ball Possession Prediction',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: _accentGreen,
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCards() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _cardColor1.withOpacity(0.8),
              _cardColor2.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _accentGreen.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _accentGreen.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Home Team
            Expanded(
              child: _TeamCard(
                label: 'HOME',
                imagePath: widget.homeImg,
                teamName: widget.homeTeam,
                controller: _homePosController,
                accentColor: _accentGreen,
              ),
            ),

            // VS separator
            _buildVsSeparator(),

            // Away Team
            Expanded(
              child: _TeamCard(
                label: 'AWAY',
                imagePath: widget.awayImg,
                teamName: widget.awayTeam,
                controller: _awayPosController,
                accentColor: _accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVsSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_accentGreen, _accentBlue],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _accentGreen.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_accentGreen, _accentBlue],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _accentGreen.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleNextAction,
            borderRadius: BorderRadius.circular(30),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CONTINUE TO SHOOTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNextAction() {
    final homePos = _homePosController.text;
    final awayPos = _awayPosController.text;

    if (homePos.isEmpty || awayPos.isEmpty) {
      _showModernSnackBar('Please enter possession values for both teams', Colors.red);
      return;
    }

    final homePosValue = double.tryParse(homePos);
    final awayPosValue = double.tryParse(awayPos);

    if (homePosValue == null || awayPosValue == null) {
      _showModernSnackBar('Please enter valid numbers', Colors.orange);
      return;
    }

    if (homePosValue >= 83 || awayPosValue >= 83) {
      _showModernSnackBar('Please enter realistic possession values', Colors.orange);
      return;
    }

    navigateToWithSlide(
      context,
      ShootsPage(
        mode: widget.mode,
        homeTeam: widget.homeTeam,
        homeImg: widget.homeImg,
        homePos: homePosValue,
        awayTeam: widget.awayTeam,
        awayImg: widget.awayImg,
        awayPos: awayPosValue,
        homeCode: widget.homeCode,
        awayCode: widget.awayCode,
        homeAvgShoots: widget.homeAvgShoots,
        homeAvgShootsOn: widget.homeAvgShootsOn,
        homeAvgChances: widget.homeAvgChances,
        homeAvgCorners: widget.homeAvgCorners,
        awayAvgShoots: widget.awayAvgShoots,
        awayAvgShootsOn: widget.awayAvgShootsOn,
        awayAvgCorners: widget.awayAvgCorners,
        awayAvgChances: widget.awayAvgChances,
      ),
    );
  }

  void _showModernSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}

// Separate stateless widget for team card - better performance
class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.label,
    required this.imagePath,
    required this.teamName,
    required this.controller,
    required this.accentColor,
  });

  final String label;
  final String imagePath;
  final String teamName;
  final TextEditingController controller;
  final Color accentColor;

  static final _numberRegex = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Team logo with glow effect
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              cacheWidth: 180, // Cache image at 2x size for performance
              cacheHeight: 180,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Team label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Possession input
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '%',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 60,
                  maxWidth: 80,
                ),
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2A3A5A),
                      Color(0xFF1E2A4A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: accentColor.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  cursorColor: accentColor,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.allow(_numberRegex),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}