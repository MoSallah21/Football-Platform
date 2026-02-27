import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/presentation/bloc/league_bloc.dart';
import 'package:football_platform/features/news/presentation/pages/live_match_view.dart';
import 'package:football_platform/core/componants/components.dart';
import '../all_matches/all_matches.dart';
import 'package:intl/intl.dart';

class FixturesView extends StatefulWidget {
  final String league;
  const FixturesView({super.key, required this.league});

  @override
  State<FixturesView> createState() => _FixturesViewState();
}

class _FixturesViewState extends State<FixturesView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static final _timeFormatter = DateFormat('h:mm a');
  static final _dateFormatter = DateFormat('MMM d');

  // Modern, clean color palette
  static const _bgDark = Color(0xFF0D0F14);
  static const _cardBg = Color(0xFF1C1C1E);
  static const _liveRed = Color(0xFFFF3B30);
  static const _upcomingBlue = Color(0xFF007AFF);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xFF8E8E93);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String convertTo12HourFormat(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return _timeFormatter.format(dateTime);
    } catch (e) {
      return dateTimeString.length > 16 ? dateTimeString.substring(11, 16) : dateTimeString;
    }
  }

  String getDateLabel(String dateString) {
    try {
      final matchDate = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = matchDate.difference(now).inDays;

      if (difference == 0) return 'Today';
      if (difference == 1) return 'Tomorrow';
      if (difference == -1) return 'Yesterday';
      if (difference < 7 && difference > 0) return DateFormat('EEE').format(matchDate);
      return _dateFormatter.format(matchDate);
    } catch (e) {
      return dateString.length >= 10 ? dateString.substring(0, 10) : dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<LeagueBloc, LeagueState>(
      buildWhen: (previous, current) =>
      current is GetUpComingData || current is GetLiveData || current is LoadingState,
      builder: (BuildContext context, Object? state) {
        final bloc = context.read<LeagueBloc>();

        return Container(
          color: _bgDark,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Live Matches Section
              if (bloc.liveMatches.isNotEmpty) ...[
                _buildLiveMatchesHeader(),
                _buildLiveMatchesCarousel(bloc),
              ],

              // Upcoming Matches Section
              _buildUpcomingHeader(bloc),

              if (bloc.upcomingMatches.isEmpty)
                SliverFillRemaining(child: _buildEmptyState())
              else
                _buildUpcomingList(bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveMatchesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Row(
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _liveRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _liveRed.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'LIVE NOW',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveMatchesCarousel(LeagueBloc bloc) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: CarouselSlider.builder(
          itemCount: bloc.liveMatches.length,
          itemBuilder: (_, idx, p) => _buildLiveMatchCard(bloc.liveMatches[idx]),
          options: CarouselOptions(
            enableInfiniteScroll: bloc.liveMatches.length > 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            height: 200,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveMatchCard(FixtureData match) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        navigateToWithSlide(context, LiveMatchDetails(fixd: match));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1C1C1E),
              const Color(0xFF2C2C2E),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _liveRed.withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Glow effect in corner
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _liveRed.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Live indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: _liveRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            color: _liveRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${match.fixture.statue.elapsed}'",
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Teams and Score
                    Row(
                      children: [
                        Expanded(
                          child: _buildLiveTeam(
                            match.teams.home.logo,
                            match.teams.home.name,
                            isHome: true,
                          ),
                        ),

                        // Score Display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${match.goals.home}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: _textPrimary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: _textPrimary.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              Text(
                                '${match.goals.away}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: _textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: _buildLiveTeam(
                            match.teams.away.logo,
                            match.teams.away.name,
                            isHome: false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveTeam(String logo, String name, {required bool isHome}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              logo,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.sports_soccer,
                color: _textSecondary,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingHeader(LeagueBloc bloc) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                bloc.getAllMatchesData(widget.league);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: const AllMatches(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _upcomingBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _upcomingBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: _upcomingBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: _upcomingBlue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingList(LeagueBloc bloc) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: _buildUpcomingCard(bloc.upcomingMatches[index]),
                  ),
                );
              },
            );
          },
          childCount: bloc.upcomingMatches.length,
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(FixtureData match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Home Team
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    match.teams.home.name,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _buildTeamBadge(match.teams.home.logo),
              ],
            ),
          ),

          // Time
          Container(
            width: 85,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  convertTo12HourFormat(match.fixture.date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _upcomingBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  getDateLabel(match.fixture.date),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Away Team
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTeamBadge(match.teams.away.logo),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    match.teams.away.name,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
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

  Widget _buildTeamBadge(String logo) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.06),
      ),
      child: ClipOval(
        child: Image.network(
          logo,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.sports_soccer,
            color: _textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
            child: const Icon(
              Icons.event_note,
              size: 48,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No matches scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back soon for upcoming games',
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}