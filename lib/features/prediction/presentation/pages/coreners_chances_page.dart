import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/prediction/presentation/bloc/predict_bloc.dart';
import 'package:football_platform/core/componants/components.dart';
import 'result_page.dart';

class CornersChancesPage extends StatefulWidget {
  final double mode;
  final String homeTeam;
  final String awayTeam;
  final String homeImg;
  final String awayImg;
  final double homePos;
  final double awayPos;
  final double homeShoots;
  final double awayShoots;
  final double homeShootsOn;
  final double awayShootsOn;
  final double homeCode;
  final double awayCode;
  final double homeAvgCorners;
  final double homeAvgChances;
  final double awayAvgCorners;
  final double awayAvgChances;

  const CornersChancesPage({
    super.key,
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
    required this.homeCode,
    required this.awayCode,
    required this.homeAvgCorners,
    required this.awayAvgCorners,
    required this.homeAvgChances,
    required this.awayAvgChances,
    required this.mode,
  });

  @override
  State<CornersChancesPage> createState() => _CornersChancesPageState();
}

class _CornersChancesPageState extends State<CornersChancesPage>
    with SingleTickerProviderStateMixin {
  // Single animation controller instead of multiple
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers
  late TextEditingController _homeCornersController;
  late TextEditingController _awayCornersController;
  late TextEditingController _homeChancesController;
  late TextEditingController _awayChancesController;

  // State
  bool _isHomeCornersMean = false;
  bool _isAwayCornersMean = false;
  bool _isHomeChancesMean = false;
  bool _isAwayChancesMean = false;
  bool _isImageVisible = false;

  // Constants
  static const int _maxCorners = 18;
  static const int _maxHomeChances = 7;
  static const int _maxAwayChances = 6;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _homeCornersController = TextEditingController();
    _awayCornersController = TextEditingController();
    _homeChancesController = TextEditingController();
    _awayChancesController = TextEditingController();

    // Single animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isImageVisible = true);
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _homeCornersController.dispose();
    _awayCornersController.dispose();
    _homeChancesController.dispose();
    _awayChancesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleNextButton() {
    final homeCorners = _homeCornersController.text;
    final awayCorners = _awayCornersController.text;
    final homeChances = _homeChancesController.text;
    final awayChances = _awayChancesController.text;

    // Validation
    if (homeCorners.isEmpty || awayCorners.isEmpty ||
        homeChances.isEmpty || awayChances.isEmpty) {
      _showSnackBar('Please enter all values for each team to predict the outcome between them.');
      return;
    }

    final homeCornersValue = double.parse(homeCorners);
    final awayCornersValue = double.parse(awayCorners);
    final homeChancesValue = double.parse(homeChances);
    final awayChancesValue = double.parse(awayChances);

    if (homeCornersValue > _maxCorners || awayCornersValue > _maxCorners ||
        homeCornersValue < 0 || awayCornersValue < 0) {
      _showSnackBar('The values are not realistic, please adjust them according to reality.');
      return;
    }

    if (homeChancesValue > _maxHomeChances || awayChancesValue > _maxAwayChances ||
        homeChancesValue < 0 || awayChancesValue < 0) {
      _showSnackBar('The values are not realistic, please adjust them according to reality.');
      return;
    }

    final cubit = PredictBloc.get(context);
    cubit.add(PredictResultEvent(
      mode: 1,
      homeCode: cubit.model.homeCode,
      awayCode: cubit.model.awayCode,
      homePoss: 0,
      awayPoss: 0,
      homeCorners: homeCornersValue,
      awayCorners: awayCornersValue,
      homeChances: homeChancesValue,
      awayChances: awayChancesValue,
      homeShootsOn: 0,
      homeShoots: 0,
      awayShoots: 0,
      awayShootsOn: 0,
    ));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PredictBloc, PredictState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF24243e),
                  Color(0xFF302B63),
                  Color(0xFF0F0C29),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Hero Image Section
                    _HeroImageSection(
                      isVisible: _isImageVisible,
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),

                    const SizedBox(height: 30),

                    // Title Section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const _TitleSection(),
                    ),

                    const SizedBox(height: 40),

                    // Teams Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // Home Team
                          _TeamCard(
                            slideAnimation: _slideAnimation,
                            fadeAnimation: _fadeAnimation,
                            teamName: widget.homeTeam,
                            teamImage: widget.homeImg,
                            isHome: true,
                            cornersController: _homeCornersController,
                            chancesController: _homeChancesController,
                            isCornersMean: _isHomeCornersMean,
                            isChancesMean: _isHomeChancesMean,
                            avgCorners: widget.homeAvgCorners,
                            avgChances: widget.homeAvgChances,
                            onCornersChanged: (isMean) {
                              setState(() {
                                _isHomeCornersMean = isMean!;
                                _homeCornersController.text = isMean
                                    ? widget.homeAvgCorners.toInt().toString()
                                    : "";
                              });
                            },
                            onChancesChanged: (isMean) {
                              setState(() {
                                _isHomeChancesMean = isMean!;
                                _homeChancesController.text = isMean
                                    ? widget.homeAvgChances.toInt().toString()
                                    : "";
                              });
                            },
                          ),

                          // Versus Section
                          _VersusSection(fadeAnimation: _fadeAnimation),

                          // Away Team
                          _TeamCard(
                            slideAnimation: _slideAnimation,
                            fadeAnimation: _fadeAnimation,
                            teamName: widget.awayTeam,
                            teamImage: widget.awayImg,
                            isHome: false,
                            cornersController: _awayCornersController,
                            chancesController: _awayChancesController,
                            isCornersMean: _isAwayCornersMean,
                            isChancesMean: _isAwayChancesMean,
                            avgCorners: widget.awayAvgCorners,
                            avgChances: widget.awayAvgChances,
                            onCornersChanged: (isMean) {
                              setState(() {
                                _isAwayCornersMean = isMean!;
                                _awayCornersController.text = isMean
                                    ? widget.awayAvgCorners.toInt().toString()
                                    : "";
                              });
                            },
                            onChancesChanged: (isMean) {
                              setState(() {
                                _isAwayChancesMean = isMean!;
                                _awayChancesController.text = isMean
                                    ? widget.awayAvgChances.toInt().toString()
                                    : "";
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Predict Button
                    _PredictButton(
                      slideAnimation: _slideAnimation,
                      onTap: _handleNextButton,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) async {
        if (state is PredictResultSuccessState) {
          final cubit = PredictBloc.get(context);
          final result = state.result;

          navigateToWithSlide(
            context,
            FinalPredictPage(
              homeTeam: cubit.model.homeTeam,
              awayTeam: cubit.model.awayTeam,
              homeImg: cubit.model.homeImg,
              awayImg: cubit.model.awayImg,
              prediction: result['prediction'][0][0].toDouble(),
              homePos: result['pr'][0][1].toStringAsFixed(2),
              homeShoots: result['pr'][0][2].toStringAsFixed(2),
              homeCorner: result['pr'][0][3].toStringAsFixed(2),
              homeShootsOn: result['pr'][0][4].toStringAsFixed(2),
              homeChances: result['pr'][0][5].toStringAsFixed(2),
              awayPos: result['pr'][0][7].toStringAsFixed(2),
              awayShoots: result['pr'][0][8].toStringAsFixed(2),
              awayCorner: result['pr'][0][9].toStringAsFixed(2),
              awayShootsOn: result['pr'][0][10].toStringAsFixed(2),
              awayChances: result['pr'][0][11].toStringAsFixed(2),
            ),
          );

          final player = AudioPlayer();
          await player.play(AssetSource('sounds/crawd.mp3'));
        }
      },
    );
  }
}

// ============================================================================
// SEPARATE STATELESS WIDGETS FOR BETTER PERFORMANCE
// ============================================================================

class _HeroImageSection extends StatelessWidget {
  final bool isVisible;
  final double height;

  const _HeroImageSection({
    required this.isVisible,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/liverpool.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  cacheWidth: 1200,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFFf093fb).withOpacity(0.3),
                        const Color(0xFF4facfe).withOpacity(0.6),
                        const Color(0xFF667eea).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFf093fb), Color(0xFF4facfe)],
            ).createShader(bounds),
            child: const Text(
              'CORNERS PREDICTION',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How many corners and chances do you expect for each team ?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final String teamName;
  final String teamImage;
  final bool isHome;
  final TextEditingController cornersController;
  final TextEditingController chancesController;
  final bool isCornersMean;
  final bool isChancesMean;
  final double avgCorners;
  final double avgChances;
  final Function(bool?) onCornersChanged;
  final Function(bool?) onChancesChanged;

  const _TeamCard({
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.teamName,
    required this.teamImage,
    required this.isHome,
    required this.cornersController,
    required this.chancesController,
    required this.isCornersMean,
    required this.isChancesMean,
    required this.avgCorners,
    required this.avgChances,
    required this.onCornersChanged,
    required this.onChancesChanged,
  });

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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withOpacity(0.8),
                  const Color(0xFF764ba2).withOpacity(0.6),
                  const Color(0xFF434343).withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF667eea).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Team Image
                RepaintBoundary(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFf093fb).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: const Color(0xFFf5576c).withOpacity(0.3),
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
                        color: Color(0xFFf093fb),
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Corners Input
                _InputField(
                  controller: cornersController,
                  label: 'CORNERS',
                  isMean: isCornersMean,
                  onChanged: onCornersChanged,
                ),

                const SizedBox(height: 15),

                // Chances Input
                _InputField(
                  controller: chancesController,
                  label: 'CHANCES',
                  isMean: isChancesMean,
                  onChanged: onChancesChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isMean;
  final Function(bool?) onChanged;

  const _InputField({
    required this.controller,
    required this.label,
    required this.isMean,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
            // Checkbox
            _CustomCheckbox(
              isChecked: isMean,
              onTap: () => onChanged(!isMean),
            ),
            const SizedBox(width: 8),

            // Input Field
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF667eea).withOpacity(0.4),
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  cursorColor: const Color(0xFFf093fb),
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
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

class _CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;

  const _CustomCheckbox({
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isChecked
                ? const Color(0xFFf093fb)
                : Colors.white.withOpacity(0.5),
            width: 2,
          ),
          gradient: isChecked
              ? const LinearGradient(
            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          )
              : null,
        ),
        child: isChecked
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : null,
      ),
    );
  }
}

class _VersusSection extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const _VersusSection({required this.fadeAnimation});

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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFf093fb),
                      Color(0xFFf5576c),
                      Color(0xFF4facfe),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFf093fb).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
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
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'CORNERS \n&\n CHANCES',
                  textAlign: TextAlign.center,
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

class _PredictButton extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onTap;

  const _PredictButton({
    required this.slideAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SlideTransition(
      position: slideAnimation,
      child: Container(
        width: width * 0.8,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf093fb),
              Color(0xFFf5576c),
              Color(0xFF4facfe),
              Color(0xFF00f2fe),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
          borderRadius: BorderRadius.circular(27.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFf093fb).withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(0, 12),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: const Color(0xFF4facfe).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(27.5),
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_soccer, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'PREDICT',
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
}