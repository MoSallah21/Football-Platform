import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import '../../bloc/league_bloc.dart';
import 'dart:math' as math;

class TopInLeagueView extends StatefulWidget {
  final String league;
  const TopInLeagueView({super.key, required this.league});

  @override
  State<TopInLeagueView> createState() => _TopInLeagueViewState();
}

class _TopInLeagueViewState extends State<TopInLeagueView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Performance optimizations - Pre-computed colors
  static const _backgroundColor1 = Color(0xFF0A0E1A);
  static const _backgroundColor2 = Color(0xFF1A1F35);
  static const _backgroundColor3 = Color(0xFF252B42);
  static const _accentGold = Color(0xFFFFD700);
  static const _accentPurple = Color(0xFF9C27FF);
  static const _accentBlue = Color(0xFF00B8FF);
  static const _accentPink = Color(0xFFFF1493);

  // Pre-computed gradients
  static final _backgroundGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_backgroundColor1, _backgroundColor2, _backgroundColor3],
  );

  static final _championGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD700),
      Color(0xFFFFB800),
      Color(0xFFFF8C00),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static final _glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withOpacity(0.15),
      Colors.white.withOpacity(0.05),
    ],
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<LeagueBloc, LeagueState>(
      buildWhen: (previous, current) =>
      current is GetGoals ||
          current is LoadingState ||
          current is ErrorState,
      builder: (BuildContext context, LeagueState state) {
        final bloc = context.read<LeagueBloc>();

        if (bloc.goals.isEmpty) {
          return _buildLoadingScreen();
        }

        if (!_fadeController.isCompleted) {
          _fadeController.forward();
          _slideController.forward();
        }

        return RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(gradient: _backgroundGradient),
            child: Stack(
              children: [
                // Animated background particles
                _buildParticleBackground(),

                // Main content
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        // Header with league info
                        SliverToBoxAdapter(
                          child: _buildHeader(),
                        ),

                        // Champion spotlight
                        SliverToBoxAdapter(
                          child: _buildChampionSpotlight(bloc),
                        ),

                        // Top 3 podium
                        SliverToBoxAdapter(
                          child: _buildPodium(bloc),
                        ),

                        // Rest of the list with modern cards
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                return RepaintBoundary(
                                  key: ValueKey('scorer_${bloc.goals[index + 3].player.id}'),
                                  child: _buildModernScorerCard(
                                    index + 4,
                                    bloc.goals[index + 3],
                                    index,
                                  ),
                                );
                              },
                              childCount: math.max(0, bloc.goals.length - 3),
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: Stack(
        children: [
          _buildParticleBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated pulsing ball
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.9 + (0.1 * math.sin(value * math.pi * 2)),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _championGradient,
                          boxShadow: [
                            BoxShadow(
                              color: _accentGold.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sports_soccer,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                ShaderMask(
                  shaderCallback: (bounds) => _championGradient.createShader(bounds),
                  child: const Text(
                    'Loading Champions...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => _championGradient.createShader(bounds),
            child: const Text(
              'TOP SCORERS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.league.toUpperCase()} • ${DateTime.now().year}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionSpotlight(LeagueBloc bloc) {
    if (bloc.goals.isEmpty) return const SizedBox();
    final champion = bloc.goals[0];

    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1500),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.85 + (0.15 * value),
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: _championGradient,
                    boxShadow: [
                      BoxShadow(
                        color: _accentGold.withOpacity(0.3 + (0.2 * _glowController.value)),
                        blurRadius: 30 + (10 * _glowController.value),
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        blurRadius: 60,
                        spreadRadius: -5,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Animated gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            // Left side - Info
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Crown badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'CHAMPION',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Player name
                                  Text(
                                    champion.player.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),

                                  // Team
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            champion.stats.team.logo,
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => const Icon(
                                              Icons.sports_soccer,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          champion.stats.team.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Goals counter
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.sports_soccer,
                                          color: Colors.white,
                                          size: 24,
                                        ),  
                                        const SizedBox(width: 10),
                                        Text(
                                          '${champion.stats.goals.total}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'GOALS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right side - Player image
                            Expanded(
                              flex: 2,
                              child: Hero(
                                tag: 'player_${champion.player.id}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Image.network(
                                      champion.player.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPodium(LeagueBloc bloc) {
    if (bloc.goals.length < 3) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(
            child: _buildPodiumPlace(
              bloc.goals[1],
              2,
              160,
              const Color(0xFFC0C0C0),
            ),
          ),
          const SizedBox(width: 12),

          // 1st place (already shown above, show mini version)
          Expanded(
            child: _buildPodiumPlace(
              bloc.goals[0],
              1,
              200,
              const Color(0xFFFFD700),
              isHighlighted: true,
            ),
          ),
          const SizedBox(width: 12),

          // 3rd place
          Expanded(
            child: _buildPodiumPlace(
              bloc.goals[2],
              3,
              140,
              const Color(0xFFCD7F32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(
      PlayerStats player,
      int rank,
      double height,
      Color accentColor, {
        bool isHighlighted = false,
      }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (rank * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, height * (1 - value)),
          child: GestureDetector(
            onTap: () {
              // Add haptic feedback or navigation
            },
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accentColor.withOpacity(0.3),
                    accentColor.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: accentColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rank badge
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          rank.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Player image
                    Flexible(
                      child: ClipOval(
                        child: Image.network(
                          player.player.image,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Goals
                    Text(
                      '${player.stats.goals.total}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Player name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        player.player.name.split(' ').last,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernScorerCard(int rank, PlayerStats player, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _glassGradient,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Add navigation or details
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Rank
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _getRankGradientColors(rank),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              rank.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Player image
                        Hero(
                          tag: 'player_${player.player.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                player.player.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Player info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.player.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      player.stats.team.logo,
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      player.stats.team.name,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Goals
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _accentPurple.withOpacity(0.3),
                                _accentBlue.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            player.stats.goals.total.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getRankGradientColors(int rank) {
    if (rank <= 5) {
      return [_accentPurple.withOpacity(0.7), _accentBlue.withOpacity(0.7)];
    } else if (rank <= 10) {
      return [_accentBlue.withOpacity(0.5), Colors.cyan.withOpacity(0.5)];
    }
    return [
      Colors.white.withOpacity(0.2),
      Colors.white.withOpacity(0.1),
    ];
  }

  // Helper method for optimized image loading
  Widget _buildOptimizedImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: (width * MediaQuery.of(context).devicePixelRatio).round(),
      cacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
      errorBuilder: (_, __, ___) => errorWidget ?? Container(
        width: width,
        height: height,
        color: Colors.white.withOpacity(0.1),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

// Custom painter for animated background particles
class ParticlePainter extends CustomPainter {
  final double animationValue;
  static final List<Particle> _cachedParticles = _generateParticles();

  ParticlePainter(this.animationValue);

  static List<Particle> _generateParticles() {
    final random = math.Random(42); // Fixed seed for consistency
    return List.generate(20, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: 1 + random.nextDouble() * 2,
        speed: 0.1 + random.nextDouble() * 0.3,
        opacity: 0.05 + random.nextDouble() * 0.15,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in _cachedParticles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      final yOffset = ((animationValue * particle.speed) % 1.0) * size.height;
      final x = particle.x * size.width;
      final y = (particle.y * size.height + yOffset) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}

class Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
  });
}