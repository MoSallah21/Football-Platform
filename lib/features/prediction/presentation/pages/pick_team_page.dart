import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/prediction/presentation/bloc/predict_bloc.dart';
import 'package:football_platform/features/prediction/presentation/pages/possession_page.dart';
import 'package:football_platform/features/prediction/presentation/pages/result_page.dart';
import 'package:football_platform/core/utl/items.dart';
import 'package:football_platform/core/componants/components.dart';

class PickTeamPage extends StatefulWidget {
  final int mode;

  const PickTeamPage({super.key, required this.mode});

  @override
  State<PickTeamPage> createState() => _PickTeamPageState();
}

class _PickTeamPageState extends State<PickTeamPage>
    with SingleTickerProviderStateMixin {
  // Single animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State
  bool _isImageVisible = false;
  bool _isTeamSelected = false;
  int _selectedMode = 2; // Default to Partial Effect

  // Timers
  Timer? _imageTimer;
  Timer? _teamSelectionTimer;

  @override
  void initState() {
    super.initState();

    // Single animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation
    _imageTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isImageVisible = true);
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    _teamSelectionTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTeamSelectionAnimation() {
    _teamSelectionTimer?.cancel();
    _teamSelectionTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isTeamSelected = true);
      }
    });
  }

  void _handleModeChange(int value) {
    setState(() => _selectedMode = value);
    HapticFeedback.lightImpact();
  }

  void _handleButtonPress(PredictBloc cubit) {
    HapticFeedback.mediumImpact();

    if (cubit.model.homeTeam.isEmpty || cubit.model.awayTeam.isEmpty) {
      _showCustomSnackBar('Please choose both teams');
      return;
    }

    if (cubit.model.homeTeam == cubit.model.awayTeam) {
      _showCustomSnackBar('Please choose different teams');
      return;
    }

    if (widget.mode == 1) {
      cubit.add(PredictResultEvent(
        mode: 1,
        homeCode: cubit.model.homeCode,
        awayCode: cubit.model.awayCode,
        homePoss: 0,
        awayPoss: 0,
        homeCorners: 0,
        awayChances: 0,
        awayCorners: 0,
        homeChances: 0,
        homeShootsOn: 0,
        homeShoots: 0,
        awayShoots: 0,
        awayShootsOn: 0,
      ));
    } else if (widget.mode == 2) {
      navigateToWithSlide(
        context,
        PossessionPage(
          mode: _selectedMode.ceilToDouble(),
          homeTeam: cubit.model.homeTeam,
          awayTeam: cubit.model.awayTeam,
          homeImg: cubit.model.homeImg,
          awayImg: cubit.model.awayImg,
          homeCode: cubit.model.homeCode,
          awayCode: cubit.model.awayCode,
          homeAvgShoots: cubit.model.meanHomeShoots,
          homeAvgShootsOn: cubit.model.meanHomeShOnTarget,
          homeAvgChances: cubit.model.meanHomeCh,
          homeAvgCorners: cubit.model.meanHomeCor,
          awayAvgShoots: cubit.model.meanAwayShoots,
          awayAvgShootsOn: cubit.model.meanAwayShOnTarget,
          awayAvgCorners: cubit.model.meanAwayCor,
          awayAvgChances: cubit.model.meanAwayCh,
        ),
      );
    }
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2D1B69),
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
      listener: (context, state) {
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
        }
      },
      builder: (context, state) {
        final cubit = PredictBloc.get(context);

        // Handle team selection animation
        if (cubit.model.homeImg.isNotEmpty &&
            cubit.model.awayImg.isNotEmpty &&
            !_isTeamSelected) {
          _handleTeamSelectionAnimation();
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2D1B69),
                  Color(0xFF38003C),
                  Color(0xFF1A0E2E),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Header Section
                    _HeaderSection(
                      fadeAnimation: _fadeAnimation,
                      isVisible: _isImageVisible,
                    ),

                    // Title Section
                    _TitleSection(slideAnimation: _slideAnimation),

                    // Team Selection Section
                    _TeamSelectionSection(
                      cubit: cubit,
                      onHomeTeamChanged: (item) {
                        HapticFeedback.lightImpact();
                        cubit.onChangedHome(context, item);
                      },
                      onAwayTeamChanged: (item) {
                        HapticFeedback.lightImpact();
                        cubit.onChangedAway(context, item);
                      },
                    ),

                    // VS Section
                    if (cubit.model.homeImg.isNotEmpty &&
                        cubit.model.awayImg.isNotEmpty)
                      _VSSection(
                        isVisible: _isTeamSelected,
                        homeImg: cubit.model.homeImg,
                        homeTeam: cubit.model.homeTeam,
                        awayImg: cubit.model.awayImg,
                        awayTeam: cubit.model.awayTeam,
                      ),

                    const SizedBox(height: 40),

                    // Mode Selection (if not mode 1)
                    if (widget.mode != 1)
                      _ModeSelection(
                        selectedMode: _selectedMode,
                        onModeChanged: _handleModeChange,
                      ),

                    const SizedBox(height: 30),

                    // Action Button
                    _ActionButton(
                      onPressed: () => _handleButtonPress(cubit),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// SEPARATE STATELESS WIDGETS FOR BETTER PERFORMANCE
// ============================================================================

class _HeaderSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final bool isVisible;

  const _HeaderSection({
    required this.fadeAnimation,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 3.2;

    return FadeTransition(
      opacity: fadeAnimation,
      child: RepaintBoundary(
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    'assets/images/eps.jpg',
                    fit: BoxFit.cover,
                    cacheWidth: 1200,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF9333EA).withOpacity(0.8),
                      const Color(0xFF7C3AED).withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // Pattern
              const Positioned.fill(
                child: _FootballPattern(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FootballPattern extends StatelessWidget {
  const _FootballPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FootballPatternPainter(),
    );
  }
}

class _FootballPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        paint,
      );
    }

    // Draw center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 8,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TitleSection extends StatelessWidget {
  final Animation<Offset> slideAnimation;

  const _TitleSection({required this.slideAnimation});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            const Text(
              'SELECT TEAMS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    color: Color(0xFF9333EA),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamSelectionSection extends StatelessWidget {
  final PredictBloc cubit;
  final Function(MenuItem) onHomeTeamChanged;
  final Function(MenuItem) onAwayTeamChanged;

  const _TeamSelectionSection({
    required this.cubit,
    required this.onHomeTeamChanged,
    required this.onAwayTeamChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Home Team Dropdown
          _TeamDropdown(
            cubit: cubit,
            isHome: true,
            label: "HOME TEAM",
            icon: Icons.home_rounded,
            onChanged: onHomeTeamChanged,
          ),

          const SizedBox(height: 20),

          // Away Team Dropdown
          _TeamDropdown(
            cubit: cubit,
            isHome: false,
            label: "AWAY TEAM",
            icon: Icons.flight_takeoff_rounded,
            onChanged: onAwayTeamChanged,
          ),
        ],
      ),
    );
  }
}

class _TeamDropdown extends StatelessWidget {
  final PredictBloc cubit;
  final bool isHome;
  final String label;
  final IconData icon;
  final Function(MenuItem) onChanged;

  const _TeamDropdown({
    required this.cubit,
    required this.isHome,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTeam = isHome ? cubit.model.homeTeam : cubit.model.awayTeam;
    final hint = isHome ? 'Choose Home Team' : 'Choose Away Team';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1B69).withOpacity(0.4),
            const Color(0xFF4C1D95).withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF9333EA).withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38003C).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: const Color(0xFFA855F7),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFA855F7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<MenuItem>(
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    selectedTeam.isEmpty ? hint : selectedTeam,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                items: cubit.teams
                    .map((item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: _DropdownItem(item: item),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
                buttonStyleData: const ButtonStyleData(
                  height: 60,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF2D1B69),
                    border: Border.all(
                      color: const Color(0xFF9333EA).withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF38003C).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all(6),
                    thumbVisibility: WidgetStateProperty.all(true),
                    thumbColor: WidgetStateProperty.all(
                      const Color(0xFF9333EA),
                    ),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final MenuItem item;

  const _DropdownItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C3AED).withOpacity(0.3),
                const Color(0xFF9333EA).withOpacity(0.2),
              ],
            ),
          ),
          child: item.icon,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _VSSection extends StatelessWidget {
  final bool isVisible;
  final String homeImg;
  final String homeTeam;
  final String awayImg;
  final String awayTeam;

  const _VSSection({
    required this.isVisible,
    required this.homeImg,
    required this.homeTeam,
    required this.awayImg,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2D1B69).withOpacity(0.5),
              const Color(0xFF4C1D95).withOpacity(0.4),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF9333EA).withOpacity(0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9333EA).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _TeamLogo(imagePath: homeImg, teamName: homeTeam),
            const _VSBadge(),
            _TeamLogo(imagePath: awayImg, teamName: awayTeam),
          ],
        ),
      ),
    );
  }
}

class _TeamLogo extends StatelessWidget {
  final String imagePath;
  final String teamName;

  const _TeamLogo({
    required this.imagePath,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7C3AED).withOpacity(0.3),
                  const Color(0xFF9333EA).withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF9333EA).withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38003C).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                cacheWidth: 160,
                cacheHeight: 160,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 100,
          child: Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _VSBadge extends StatelessWidget {
  const _VSBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Icon(
          Icons.sports_soccer,
          color: Color(0xFFA855F7),
          size: 24,
        ),
      ],
    );
  }
}

class _ModeSelection extends StatelessWidget {
  final int selectedMode;
  final Function(int) onModeChanged;

  const _ModeSelection({
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1B69).withOpacity(0.4),
            const Color(0xFF4C1D95).withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF9333EA).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PREDICTION MODE',
            style: TextStyle(
              color: Color(0xFFA855F7),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _ModeOption(
                  value: 2,
                  label: 'Partial Effect',
                  icon: Icons.analytics_outlined,
                  isSelected: selectedMode == 2,
                  onTap: () => onModeChanged(2),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _ModeOption(
                  value: 3,
                  label: 'Full Effect',
                  icon: Icons.auto_graph_rounded,
                  isSelected: selectedMode == 3,
                  onTap: () => onModeChanged(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : const Color(0xFF9333EA).withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFFA855F7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFA855F7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_soccer, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'START PREDICTION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
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