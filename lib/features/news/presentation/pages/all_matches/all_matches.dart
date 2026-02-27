import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/presentation/pages/live_match_view.dart';
import 'package:football_platform/core/componants/components.dart';
import '../../bloc/league_bloc.dart';
import 'package:intl/intl.dart';

class AllMatches extends StatefulWidget {
  const AllMatches({super.key});

  @override
  State<AllMatches> createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  static final _timeFormatter = DateFormat('h:mm a');
  static final _dateFormatter = DateFormat('MMM d');

  // Modern color palette - consistent with fixtures view
  static const _bgDark = Color(0xFF0D0F14);
  static const _cardBg = Color(0xFF1C1C1E);
  static const _liveRed = Color(0xFFFF3B30);
  static const _finishedGreen = Color(0xFF34C759);
  static const _upcomingBlue = Color(0xFF007AFF);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xFF8E8E93);

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
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
    return BlocBuilder<LeagueBloc, LeagueState>(
      buildWhen: (previous, current) =>
      current is GetAllMatches || current is LoadingState || current is ErrorState,
      builder: (context, state) {
        final bloc = context.read<LeagueBloc>();

        return Scaffold(
          backgroundColor: _bgDark,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),

              if (bloc.allMatches.isEmpty)
                SliverFillRemaining(child: _buildLoadingState())
              else
                _buildMatchesList(bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: _bgDark,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: _textPrimary,
            size: 20,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: FadeTransition(
          opacity: _headerAnimation,
          child: const Text(
            'All Matches',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _bgDark,
                _bgDark.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _cardBg,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_upcomingBlue),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading matches...',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList(LeagueBloc bloc) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final match = bloc.allMatches[index];

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 40)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildMatchCard(match, bloc),
                  ),
                );
              },
            );
          },
          childCount: bloc.allMatches.length,
        ),
      ),
    );
  }

  Widget _buildMatchCard(FixtureData match, LeagueBloc bloc) {
    final status = match.fixture.statue.short;
    final isLive = status == 'LIVE' || status == '1H' || status == '2H' || status == 'HT';
    final isFinished = status == 'FT' || status == 'AET' || status == 'PEN';
    final isUpcoming = status == 'NS' || status == 'TBD';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        navigateToWithPush(
          context,
          BlocProvider.value(
            value: bloc,
            child: LiveMatchDetails(fixd: match),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getStatusBorderColor(isLive, isFinished, isUpcoming),
            width: 1.5,
          ),
          boxShadow: isLive
              ? [
            BoxShadow(
              color: _liveRed.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          children: [
            // Match Status Header
            _buildStatusHeader(match, isLive, isFinished, isUpcoming),

            const SizedBox(height: 16),

            // Teams and Score
            Row(
              children: [
                // Home Team
                Expanded(
                  child: _buildTeam(
                    match.teams.home.logo,
                    match.teams.home.name,
                    match.goals.home,
                    isHome: true,
                    isWinner: isFinished && match.goals.home > match.goals.away,
                  ),
                ),

                // Score or Time
                _buildCenterSection(match, isLive, isFinished, isUpcoming),

                // Away Team
                Expanded(
                  child: _buildTeam(
                    match.teams.away.logo,
                    match.teams.away.name,
                    match.goals.away,
                    isHome: false,
                    isWinner: isFinished && match.goals.away > match.goals.home,
                  ),
                ),
              ],
            ),

            // Additional Info
            if (isLive) ...[
              const SizedBox(height: 12),
              _buildLiveInfo(match),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(FixtureData match, bool isLive, bool isFinished, bool isUpcoming) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isLive) {
      statusColor = _liveRed;
      statusText = 'LIVE';
      statusIcon = Icons.circle;
    } else if (isFinished) {
      statusColor = _finishedGreen;
      statusText = 'Full Time';
      statusIcon = Icons.check_circle;
    } else if (isUpcoming) {
      statusColor = _upcomingBlue;
      statusText = getDateLabel(match.fixture.date);
      statusIcon = Icons.schedule;
    } else {
      statusColor = _textSecondary;
      statusText = match.fixture.statue.short;
      statusIcon = Icons.info_outline;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                statusIcon,
                size: 14,
                color: statusColor,
              ),
              const SizedBox(width: 6),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeam(String logo, String name, int goals, {
    required bool isHome,
    required bool isWinner,
  }) {
    return Column(
      children: [
        // Team Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(
              color: isWinner
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.1),
              width: isWinner ? 2.5 : 1.5,
            ),
            boxShadow: isWinner
                ? [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
                : null,
          ),
          child: ClipOval(
            child: Image.network(
              logo,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.sports_soccer,
                color: _textSecondary,
                size: 28,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Team Name
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isWinner ? FontWeight.w700 : FontWeight.w600,
            color: isWinner ? const Color(0xFFFFD700) : _textPrimary,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCenterSection(FixtureData match, bool isLive, bool isFinished, bool isUpcoming) {
    if (isUpcoming) {
      return Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              convertTo12HourFormat(match.fixture.date),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _upcomingBlue,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'VS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 90,
      child: Column(
        children: [
          // Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${match.goals.home}',
                style: TextStyle(
                  fontSize: isLive ? 36 : 32,
                  fontWeight: FontWeight.w900,
                  color: _textPrimary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '-',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary.withOpacity(0.3),
                  ),
                ),
              ),
              Text(
                '${match.goals.away}',
                style: TextStyle(
                  fontSize: isLive ? 36 : 32,
                  fontWeight: FontWeight.w900,
                  color: _textPrimary,
                ),
              ),
            ],
          ),

          if (isLive) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _liveRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${match.fixture.statue.elapsed}'",
                style: const TextStyle(
                  color: _liveRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLiveInfo(FixtureData match) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: _liveRed,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Match in progress',
            style: TextStyle(
              color: _textPrimary.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBorderColor(bool isLive, bool isFinished, bool isUpcoming) {
    if (isLive) return _liveRed.withOpacity(0.4);
    if (isFinished) return _finishedGreen.withOpacity(0.3);
    if (isUpcoming) return _upcomingBlue.withOpacity(0.3);
    return Colors.white.withOpacity(0.08);
  }
}