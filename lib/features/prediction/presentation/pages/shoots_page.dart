import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/prediction/presentation/pages/coreners_chances_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';

class ShootsPage extends StatefulWidget {
  const ShootsPage({
    super.key,
    required this.mode,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeImg,
    required this.awayImg,
    required this.homePos,
    required this.awayPos,
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
  final double homePos;
  final double awayPos;
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
  State<ShootsPage> createState() => _ShootsPageState();
}

class _ShootsPageState extends State<ShootsPage>
    with SingleTickerProviderStateMixin {
  // Single animation controller for better performance
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Text controllers
  late final TextEditingController _homeShootsController;
  late final TextEditingController _awayShootsController;
  late final TextEditingController _homeShootsOnController;
  late final TextEditingController _awayShootsOnController;

  // State variables
  bool _isHomeShotsMean = false;
  bool _isAwayShotsMean = false;
  bool _isHomeShotsOnMean = false;
  bool _isAwayShotsOnMean = false;

  // Cached regex pattern
  static final _numberRegex = RegExp(r'^\d*\.?\d{0,2}');

  // Pre-calculated constant colors
  static const _bgColor1 = Color(0xFF1a1a2e);
  static const _bgColor2 = Color(0xFF16213e);
  static const _bgColor3 = Color(0xFF0f3460);
  static const _accentCyan = Color(0xFF00d2ff);
  static const _accentBlue = Color(0xFF3742fa);
  static const _accentPurple = Color(0xFF5f27cd);
  static const _cardColor1 = Color(0xFF2d3436);
  static const _cardColor2 = Color(0xFF636e72);

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _homeShootsController = TextEditingController();
    _awayShootsController = TextEditingController();
    _homeShootsOnController = TextEditingController();
    _awayShootsOnController = TextEditingController();

    // Single animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Create animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _homeShootsController.dispose();
    _awayShootsController.dispose();
    _homeShootsOnController.dispose();
    _awayShootsOnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_bgColor1, _bgColor2, _bgColor3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Hero Image Section
                _buildHeroImage(mediaSize),

                const SizedBox(height: 30),

                // Title Section
                _buildTitle(),

                const SizedBox(height: 40),

                // Teams Section
                _buildTeamsSection(),

                const SizedBox(height: 50),

                // Continue Button
                _buildContinueButton(mediaSize),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(Size mediaSize) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: mediaSize.height * 0.35,
        child: Stack(
          children: [
            // Gradient overlay only (removed heavy image for performance)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _accentCyan.withOpacity(0.2),
                      _accentBlue.withOpacity(0.4),
                      _accentPurple.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Radial gradient accent
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      _accentCyan.withOpacity(0.3),
                      Colors.transparent,
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: const [
            Text(
              'SHOTS PREDICTION',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: _accentCyan,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'How many shots do you expect for each team?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Home Team
          _TeamCard(
            teamImage: widget.homeImg,
            isHome: true,
            shootsController: _homeShootsController,
            shootsOnController: _homeShootsOnController,
            isShotsMean: _isHomeShotsMean,
            isShotsOnMean: _isHomeShotsOnMean,
            avgShoots: widget.homeAvgShoots,
            avgShootsOn: widget.homeAvgShootsOn,
            slideAnimation: _slideAnimation,
            fadeAnimation: _fadeAnimation,
            onShotsChanged: (isMean) {
              setState(() {
                _isHomeShotsMean = isMean;
                _homeShootsController.text = isMean
                    ? widget.homeAvgShoots.toInt().toString()
                    : '';
              });
            },
            onShotsOnChanged: (isMean) {
              setState(() {
                _isHomeShotsOnMean = isMean;
                _homeShootsOnController.text = isMean
                    ? widget.homeAvgShootsOn.toInt().toString()
                    : '';
              });
            },
          ),

          // Versus Section
          _VersusSection(fadeAnimation: _fadeAnimation),

          // Away Team
          _TeamCard(
            teamImage: widget.awayImg,
            isHome: false,
            shootsController: _awayShootsController,
            shootsOnController: _awayShootsOnController,
            isShotsMean: _isAwayShotsMean,
            isShotsOnMean: _isAwayShotsOnMean,
            avgShoots: widget.awayAvgShoots,
            avgShootsOn: widget.awayAvgShootsOn,
            slideAnimation: _slideAnimation,
            fadeAnimation: _fadeAnimation,
            onShotsChanged: (isMean) {
              setState(() {
                _isAwayShotsMean = isMean;
                _awayShootsController.text = isMean
                    ? widget.awayAvgShoots.toInt().toString()
                    : '';
              });
            },
            onShotsOnChanged: (isMean) {
              setState(() {
                _isAwayShotsOnMean = isMean;
                _awayShootsOnController.text = isMean
                    ? widget.awayAvgShootsOn.toInt().toString()
                    : '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(Size mediaSize) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: mediaSize.width * 0.8,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_accentCyan, _accentBlue, _accentPurple],
          ),
          borderRadius: BorderRadius.circular(27.5),
          boxShadow: [
            BoxShadow(
              color: _accentCyan.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(27.5),
            onTap: _handleNextButton,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_soccer, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'CONTINUE TO CORNERS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNextButton() {
    final homeShots = _homeShootsController.text;
    final homeOn = _homeShootsOnController.text;
    final awayShots = _awayShootsController.text;
    final awayOn = _awayShootsOnController.text;

    if (homeShots.isEmpty || homeOn.isEmpty || awayShots.isEmpty || awayOn.isEmpty) {
      _showSnackBar('Please enter all values for each team to predict the outcome between them.');
      return;
    }

    final homeShotsValue = double.tryParse(homeShots);
    final homeOnValue = double.tryParse(homeOn);
    final awayShotsValue = double.tryParse(awayShots);
    final awayOnValue = double.tryParse(awayOn);

    if (homeShotsValue == null || homeOnValue == null ||
        awayShotsValue == null || awayOnValue == null) {
      _showSnackBar('Please enter valid numbers');
      return;
    }

    if (homeShotsValue > 34 || awayShotsValue > 32 ||
        homeShotsValue < 1 || awayShotsValue < 1) {
      _showSnackBar('The values are not realistic, please adjust them according to reality.');
      return;
    }

    if (homeShotsValue < homeOnValue || awayShotsValue < awayOnValue) {
      _showSnackBar('The total number of shots cannot be less than the number of shots on goal');
      return;
    }

    navigateToWithSlide(
      context,
      CornersChancesPage(
        mode: widget.mode,
        homeTeam: widget.homeTeam,
        homeImg: widget.homeImg,
        homePos: widget.homePos,
        homeShoots: homeShotsValue,
        homeShootsOn: homeOnValue,
        awayTeam: widget.awayTeam,
        awayImg: widget.awayImg,
        awayPos: widget.awayPos,
        awayShoots: awayShotsValue,
        homeCode: widget.homeCode,
        awayCode: widget.awayCode,
        awayShootsOn: awayOnValue,
        homeAvgChances: widget.homeAvgChances,
        homeAvgCorners: widget.homeAvgCorners,
        awayAvgCorners: widget.awayAvgCorners,
        awayAvgChances: widget.awayAvgChances,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _cardColor1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// Stateless Team Card Widget for better performance
class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.teamImage,
    required this.isHome,
    required this.shootsController,
    required this.shootsOnController,
    required this.isShotsMean,
    required this.isShotsOnMean,
    required this.avgShoots,
    required this.avgShootsOn,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onShotsChanged,
    required this.onShotsOnChanged,
  });

  final String teamImage;
  final bool isHome;
  final TextEditingController shootsController;
  final TextEditingController shootsOnController;
  final bool isShotsMean;
  final bool isShotsOnMean;
  final double avgShoots;
  final double avgShootsOn;
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final ValueChanged<bool> onShotsChanged;
  final ValueChanged<bool> onShotsOnChanged;

  static const _accentCyan = Color(0xFF00d2ff);
  static const _cardColor1 = Color(0xFF2d3436);
  static const _cardColor2 = Color(0xFF636e72);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _cardColor1.withOpacity(0.9),
                  _cardColor2.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Team Image with Glow Effect
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: _accentCyan.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      teamImage,
                      fit: BoxFit.cover,
                      cacheWidth: 140,
                      cacheHeight: 140,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Team Label
                Text(
                  isHome ? 'HOME' : 'AWAY',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: _accentCyan,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Total Shots Input
                _InputField(
                  controller: shootsController,
                  label: 'Total',
                  isMean: isShotsMean,
                  onChanged: onShotsChanged,
                ),

                const SizedBox(height: 15),

                // Shots On Target Input
                _InputField(
                  controller: shootsOnController,
                  label: 'On Target',
                  isMean: isShotsOnMean,
                  onChanged: onShotsOnChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Stateless Input Field Widget
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.isMean,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool isMean;
  final ValueChanged<bool> onChanged;

  static final _numberRegex = RegExp(r'^\d*\.?\d{0,2}');
  static const _accentCyan = Color(0xFF00d2ff);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            // Custom Checkbox
            GestureDetector(
              onTap: () => onChanged(!isMean),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isMean ? _accentCyan : Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  color: isMean ? _accentCyan : Colors.transparent,
                ),
                child: isMean
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 8),

            // Input Field
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  cursorColor: _accentCyan,
                  cursorHeight: 20,
                  cursorWidth: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.allow(_numberRegex),
                  ],
                  onTap: () {
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Stateless Versus Section Widget
class _VersusSection extends StatelessWidget {
  const _VersusSection({required this.fadeAnimation});

  final Animation<double> fadeAnimation;

  static const _accentCyan = Color(0xFF00d2ff);
  static const _accentBlue = Color(0xFF3742fa);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_accentCyan, _accentBlue],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _accentCyan.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'SHOTS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}