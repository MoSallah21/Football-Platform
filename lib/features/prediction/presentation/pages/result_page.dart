import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';

class FinalPredictPage extends StatefulWidget {
  const FinalPredictPage({
    super.key,
    required this.homeTeam,
    required this.homeImg,
    required this.awayTeam,
    required this.awayImg,
    required this.prediction,
    required this.homePos,
    required this.awayPos,
    required this.homeShoots,
    required this.awayShoots,
    required this.homeShootsOn,
    required this.awayShootsOn,
    required this.homeCorner,
    required this.awayCorner,
    required this.homeChances,
    required this.awayChances,
  });

  final double prediction;
  final String homeTeam;
  final String homeImg;
  final String awayTeam;
  final String awayImg;
  final String homePos;
  final String awayPos;
  final String homeShoots;
  final String awayShoots;
  final String homeShootsOn;
  final String awayShootsOn;
  final String homeCorner;
  final String awayCorner;
  final String homeChances;
  final String awayChances;

  @override
  State<FinalPredictPage> createState() => _FinalPredictPageState();
}

class _FinalPredictPageState extends State<FinalPredictPage>
    with SingleTickerProviderStateMixin {
  // Single animation controller for better performance
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Pre-calculated constant colors
  static final _bgColor1 = HexColor('#0F0F23');
  static final _bgColor2 = HexColor('#1A1A2E');
  static final _bgColor3 = HexColor('#16213E');
  static final _accentCyan = HexColor('#00D2FF');
  static final _accentOrange = HexColor('#FF6B35');
  static final _accentYellow = HexColor('#F7931E');
  static final _accentGold = HexColor('#FFD700');
  static final _accentOrange2 = HexColor('#FFA500');
  static final _accentBlue = HexColor('#3A7BD5');

  @override
  void initState() {
    super.initState();

    // Single animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Pulse animation (repeating)
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      // Repeat pulse animation
      _animationController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgColor1, _bgColor2, _bgColor3],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: widget.prediction == 0
              ? _DrawResult(
            slideAnimation: _slideAnimation,
            fadeAnimation: _fadeAnimation,
            pulseAnimation: _pulseAnimation,
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
            homeImg: widget.homeImg,
            awayImg: widget.awayImg,
            homePos: widget.homePos,
            awayPos: widget.awayPos,
            homeShoots: widget.homeShoots,
            awayShoots: widget.awayShoots,
            homeShootsOn: widget.homeShootsOn,
            awayShootsOn: widget.awayShootsOn,
            homeCorner: widget.homeCorner,
            awayCorner: widget.awayCorner,
            homeChances: widget.homeChances,
            awayChances: widget.awayChances,
          )
              : _WinResult(
            fadeAnimation: _fadeAnimation,
            pulseAnimation: _pulseAnimation,
            prediction: widget.prediction,
            homeTeam: widget.homeTeam,
            awayTeam: widget.awayTeam,
            homeImg: widget.homeImg,
            awayImg: widget.awayImg,
            homePos: widget.homePos,
            awayPos: widget.awayPos,
            homeShoots: widget.homeShoots,
            awayShoots: widget.awayShoots,
            homeShootsOn: widget.homeShootsOn,
            awayShootsOn: widget.awayShootsOn,
            homeCorner: widget.homeCorner,
            awayCorner: widget.awayCorner,
            homeChances: widget.homeChances,
            awayChances: widget.awayChances,
          ),
        ),
      ),
    );
  }
}

// Stateless Widget for Draw Result
class _DrawResult extends StatelessWidget {
  const _DrawResult({
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.pulseAnimation,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeImg,
    required this.awayImg,
    required this.homePos,
    required this.awayPos,
    required this.homeShoots,
    required this.awayShoots,
    required this.homeShootsOn,
    required this.awayShootsOn,
    required this.homeCorner,
    required this.awayCorner,
    required this.homeChances,
    required this.awayChances,
  });

  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final Animation<double> pulseAnimation;
  final String homeTeam;
  final String awayTeam;
  final String homeImg;
  final String awayImg;
  final String homePos;
  final String awayPos;
  final String homeShoots;
  final String awayShoots;
  final String homeShootsOn;
  final String awayShootsOn;
  final String homeCorner;
  final String awayCorner;
  final String homeChances;
  final String awayChances;

  static final _accentOrange = HexColor('#FF6B35');
  static final _accentYellow = HexColor('#F7931E');
  static final _accentCyan = HexColor('#00D2FF');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 80),

          // Animated Result Header
          SlideTransition(
            position: slideAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accentOrange, _accentYellow],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: _accentOrange.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: pulseAnimation.value,
                        child: const Text(
                          'DRAW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'MATCH RESULT',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Teams Display
          FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _accentCyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    homeTeam,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: _accentCyan,
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: _accentOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        color: _accentOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    awayTeam,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: _accentCyan,
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Team Images
          FadeTransition(
            opacity: fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TeamLogo(imagePath: homeImg),
                Container(
                  width: 2,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_accentCyan, _accentOrange],
                    ),
                  ),
                ),
                _TeamLogo(imagePath: awayImg),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Statistics
          FadeTransition(
            opacity: fadeAnimation,
            child: _ModernStats(
              homePos: homePos,
              awayPos: awayPos,
              homeShoots: homeShoots,
              awayShoots: awayShoots,
              homeShootsOn: homeShootsOn,
              awayShootsOn: awayShootsOn,
              homeCorner: homeCorner,
              awayCorner: awayCorner,
              homeChances: homeChances,
              awayChances: awayChances,
            ),
          ),

          const SizedBox(height: 30),
          const _ModernButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Stateless Widget for Win Result
class _WinResult extends StatelessWidget {
  const _WinResult({
    required this.fadeAnimation,
    required this.pulseAnimation,
    required this.prediction,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeImg,
    required this.awayImg,
    required this.homePos,
    required this.awayPos,
    required this.homeShoots,
    required this.awayShoots,
    required this.homeShootsOn,
    required this.awayShootsOn,
    required this.homeCorner,
    required this.awayCorner,
    required this.homeChances,
    required this.awayChances,
  });

  final Animation<double> fadeAnimation;
  final Animation<double> pulseAnimation;
  final double prediction;
  final String homeTeam;
  final String awayTeam;
  final String homeImg;
  final String awayImg;
  final String homePos;
  final String awayPos;
  final String homeShoots;
  final String awayShoots;
  final String homeShootsOn;
  final String awayShootsOn;
  final String homeCorner;
  final String awayCorner;
  final String homeChances;
  final String awayChances;

  static final _accentGold = HexColor('#FFD700');
  static final _accentOrange = HexColor('#FF6B35');
  static final _accentOrange2 = HexColor('#FFA500');
  static final _accentCyan = HexColor('#00D2FF');

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final winnerImg = prediction == -1 ? homeImg : awayImg;
    final winnerName = prediction == -1 ? homeTeam : awayTeam;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 60),

          // Winner Display
          FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              height: mediaSize.height / 3,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _accentGold.withOpacity(0.3),
                    _accentOrange.withOpacity(0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accentGold.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        winnerImg,
                        fit: BoxFit.contain,
                        cacheWidth: 600,
                        cacheHeight: 600,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Winner Text
          FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_accentGold, _accentOrange2],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: _accentGold.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: pulseAnimation.value,
                            child: const Text(
                              'WINNER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        winnerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Teams Comparison
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _accentCyan.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TeamLogo(imagePath: homeImg),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: _accentOrange.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'VS',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      _TeamLogo(imagePath: awayImg),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Statistics
                _ModernStats(
                  homePos: homePos,
                  awayPos: awayPos,
                  homeShoots: homeShoots,
                  awayShoots: awayShoots,
                  homeShootsOn: homeShootsOn,
                  awayShootsOn: awayShootsOn,
                  homeCorner: homeCorner,
                  awayCorner: awayCorner,
                  homeChances: homeChances,
                  awayChances: awayChances,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const _ModernButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Stateless Team Logo Widget
class _TeamLogo extends StatelessWidget {
  const _TeamLogo({required this.imagePath});

  final String imagePath;

  static final _accentCyan = HexColor('#00D2FF');
  static final _accentOrange = HexColor('#FF6B35');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            _accentCyan.withOpacity(0.3),
            _accentOrange.withOpacity(0.3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _accentCyan.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// Stateless Modern Stats Widget
class _ModernStats extends StatelessWidget {
  const _ModernStats({
    required this.homePos,
    required this.awayPos,
    required this.homeShoots,
    required this.awayShoots,
    required this.homeShootsOn,
    required this.awayShootsOn,
    required this.homeCorner,
    required this.awayCorner,
    required this.homeChances,
    required this.awayChances,
  });

  final String homePos;
  final String awayPos;
  final String homeShoots;
  final String awayShoots;
  final String homeShootsOn;
  final String awayShootsOn;
  final String homeCorner;
  final String awayCorner;
  final String homeChances;
  final String awayChances;

  static final _accentCyan = HexColor('#00D2FF');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _accentCyan.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'MATCH STATISTICS',
            style: TextStyle(
              color: _accentCyan,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _StatRow(
            label: 'Possession',
            homeValue: '$homePos%',
            awayValue: '$awayPos%',
            icon: Icons.sports_soccer,
          ),
          _StatRow(
            label: 'Shots',
            homeValue: homeShoots,
            awayValue: awayShoots,
            icon: Icons.gps_fixed,
          ),
          _StatRow(
            label: 'Shots on Goal',
            homeValue: homeShootsOn,
            awayValue: awayShootsOn,
            icon: Icons.center_focus_strong,
          ),
          _StatRow(
            label: 'Corner Kicks',
            homeValue: homeCorner,
            awayValue: awayCorner,
            icon: Icons.call_made,
          ),
          _StatRow(
            label: 'Chances',
            homeValue: homeChances,
            awayValue: awayChances,
            icon: Icons.trending_up,
          ),
        ],
      ),
    );
  }
}

// Stateless Stat Row Widget
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.homeValue,
    required this.awayValue,
    required this.icon,
  });

  final String label;
  final String homeValue;
  final String awayValue;
  final IconData icon;

  static final _accentOrange = HexColor('#FF6B35');
  static final _accentCyan = HexColor('#00D2FF');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _accentOrange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              homeValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Icon(
                  icon,
                  color: _accentOrange,
                  size: 24,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        color: _accentCyan.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              awayValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// Stateless Modern Button Widget
class _ModernButton extends StatelessWidget {
  const _ModernButton();

  static final _accentCyan = HexColor('#00D2FF');
  static final _accentBlue = HexColor('#3A7BD5');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [_accentCyan, _accentBlue],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _accentCyan.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              HapticFeedback.mediumImpact();
              navigateAndFinish(context, HomeScreen());
            },
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'BACK TO HOME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}