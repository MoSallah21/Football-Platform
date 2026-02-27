import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/presentation/pages/layout/league_view.dart';
import 'package:football_platform/core/componants/components.dart';

import '../../bloc/league_bloc.dart';

class HomeLeague extends StatefulWidget {
  const HomeLeague({super.key});

  @override
  State<HomeLeague> createState() => _HomeLeagueState();
}

class _HomeLeagueState extends State<HomeLeague> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  // Static league data - computed once
  static final List<LeagueData> _leagues = [
    LeagueData(
      code: '39',
      title: 'Premier League',
      imagePath: 'assets/images/pre.png',
      colors: const [Color(0xFF37003C), Color(0xFF00FF87)],
      country: 'England',
    ),
    LeagueData(
      code: '140',
      title: 'LaLiga',
      imagePath: 'assets/images/liga.png',
      colors: const [Color(0xFFFF6B35), Color(0xFFF7931E)],
      country: 'Spain',
    ),
    LeagueData(
      code: '135',
      title: 'Serie A',
      imagePath: 'assets/images/seriea.png',
      colors: const [Color(0xFF004225), Color(0xFF0066CC)],
      country: 'Italy',
    ),
    LeagueData(
      code: '78',
      title: 'Bundesliga',
      imagePath: 'assets/images/bundesliga.png',
      colors: const [Color(0xFFD20515), Color(0xFFFFD700)],
      country: 'Germany',
    ),
    LeagueData(
      code: '61',
      title: 'Ligue 1',
      imagePath: 'assets/images/Ligue1.png',
      colors: const [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      country: 'France',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeagueBloc, LeagueState>(
      listener: _handleStateChange,
      buildWhen: _shouldRebuild,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildBody(context),
        );
      },
    );
  }

  void _handleStateChange(BuildContext context, LeagueState state) {
    if (state is DataCleared) {
      debugPrint('🏠 HomeLeague: Data cleared successfully');
    }
  }

  bool _shouldRebuild(LeagueState previous, LeagueState current) {
    // Only rebuild for states that affect this widget
    return current is DataCleared || current is AppInitState;
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildFloatingBalls(),
          _buildMainContent(),
          _buildTopGradient(),
        ],
      ),
    );
  }

  Widget _buildFloatingBalls() {
    return Positioned.fill(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Stack(
              children: List.generate(
                5,
                    (index) => _buildFloatingBall(index),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingBall(int index) {
    final animationOffset = (index * 0.2) % 1;
    final topPosition = 100.0 + (index * 120.0);
    final rightPosition = -50 + (50 * (_rotationAnimation.value + animationOffset) % 1);

    return Positioned(
      top: topPosition,
      right: rightPosition,
      child: Transform.rotate(
        angle: _rotationAnimation.value * 2 * 3.14159,
        child: Icon(
          Icons.sports_soccer,
          size: 30,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildLeagueGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          children: [
            Text(
              '🏆 European Leagues',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent,
                    offset: const Offset(0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Top 5 Football Competitions',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueGrid() {
    return SlideTransition(
      position: _slideAnimation,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.85,
        ),
        itemCount: _leagues.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildAnimatedLeagueCard(index);
        },
      ),
    );
  }

  Widget _buildAnimatedLeagueCard(int index) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_fadeAnimation.value * 0.2),
          child: _LeagueCard(
            league: _leagues[index],
            index: index,
          ),
        );
      },
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: RepaintBoundary(
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.0,
              colors: [
                Colors.blueAccent.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted as a separate stateless widget for better performance
class _LeagueCard extends StatelessWidget {
  final LeagueData league;
  final int index;

  const _LeagueCard({
    required this.league,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = LeagueBloc.get(context);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => _navigateToLeague(context, bloc),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: league.colors,
            ),
            boxShadow: [
              BoxShadow(
                color: league.colors.first.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _buildCardContent(),
          ),
        ),
      ),
    );
  }

  void _navigateToLeague(BuildContext context, LeagueBloc bloc) {
    navigateToWithPush(
      context,
      BlocProvider.value(
        value: bloc,
        child: LeagueView(league: league.code),
      ),
    );
  }

  Widget _buildCardContent() {
    return Stack(
      children: [
        _buildBackgroundPattern(),
        _buildBackgroundIcon(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundIcon() {
    return Positioned(
      top: -20,
      right: -20,
      child: Icon(
        Icons.sports_soccer,
        size: 80,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 12),
          _buildTitle(),
          const SizedBox(height: 4),
          _buildCountry(),
          const SizedBox(height: 8),
          _buildNavigationIndicator(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Expanded(
      flex: 3,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              league.imagePath,
              fit: BoxFit.contain,
              // Use cacheWidth for better memory usage
              cacheWidth: 160, // 2x for high DPI
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      league.title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCountry() {
    return Text(
      league.country,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildNavigationIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 12,
          ),
        ),
      ],
    );
  }
}

// Immutable league data class
@immutable
class LeagueData {
  final String code;
  final String title;
  final String imagePath;
  final List<Color> colors;
  final String country;

  const LeagueData({
    required this.code,
    required this.title,
    required this.imagePath,
    required this.colors,
    required this.country,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LeagueData &&
              runtimeType == other.runtimeType &&
              code == other.code;

  @override
  int get hashCode => code.hashCode;
}