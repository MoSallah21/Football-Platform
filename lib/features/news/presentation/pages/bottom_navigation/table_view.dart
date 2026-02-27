import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/league_bloc.dart';

// ============================================================================
// TABLE VIEW - Clean, Scannable Design
// ============================================================================

class TableView extends StatefulWidget {
  final String league;
  const TableView({super.key, required this.league});

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView>
    with AutomaticKeepAliveClientMixin {

  // Modern color palette
  static const _bgDark = Color(0xFF0D0F14);
  static const _cardBg = Color(0xFF1C1C1E);
  static const _championsBlue = Color(0xFF007AFF);
  static const _europaOrange = Color(0xFFFF9500);
  static const _relegationRed = Color(0xFFFF3B30);
  static const _championGold = Color(0xFFFFD700);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xFF8E8E93);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<LeagueBloc, LeagueState>(
      buildWhen: (previous, current) =>
      current is GetTable || current is LoadingState || current is ErrorState,
      builder: (BuildContext context, Object? state) {
        final bloc = context.read<LeagueBloc>();

        if (bloc.dataTable.isEmpty) {
          return _buildLoadingScreen();
        }

        return Container(
          color: _bgDark,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(),
              _buildLegend(),
              _buildTableList(bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: _bgDark,
      child: Center(
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
                  valueColor: AlwaysStoppedAnimation<Color>(_championsBlue),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading standings...',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: _championsBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'League Standings',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildLegendItem(_championGold, 'Champion'),
            _buildLegendItem(_championsBlue, 'UCL'),
            _buildLegendItem(_europaOrange, 'UEL'),
            _buildLegendItem(_relegationRed, 'Relegation'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableList(LeagueBloc bloc) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final team = bloc.dataTable[index];
            final totalTeams = bloc.dataTable.length;

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 30)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: _buildTableRow(team, totalTeams),
                  ),
                );
              },
            );
          },
          childCount: bloc.dataTable.length,
        ),
      ),
    );
  }

  Widget _buildTableRow(dynamic team, int totalTeams) {
    final rank = team.rank;
    final isChampion = rank == 1;
    final isChampionsLeague = rank <= 4;
    final isEuropaLeague = rank == 5 || rank == 6;
    final isRelegation = rank >= totalTeams - 2;

    Color borderColor = Colors.white.withOpacity(0.08);
    if (isChampion) borderColor = _championGold.withOpacity(0.5);
    else if (isChampionsLeague) borderColor = _championsBlue.withOpacity(0.4);
    else if (isEuropaLeague) borderColor = _europaOrange.withOpacity(0.4);
    else if (isRelegation) borderColor = _relegationRed.withOpacity(0.4);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          // Rank
          _buildRankBadge(rank, isChampion, isChampionsLeague, isEuropaLeague, isRelegation),

          const SizedBox(width: 12),

          // Team Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
            child: ClipOval(
              child: Image.network(
                team.team.logo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.sports_soccer,
                  color: _textSecondary,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Team Name
          Expanded(
            child: Text(
              team.team.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isChampion ? FontWeight.w700 : FontWeight.w600,
                color: isChampion ? _championGold : _textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Stats
          _buildStatItem(team.all.played.toString(), 'P'),
          _buildStatItem(team.goalsDiff.toString(), 'GD',
              color: team.goalsDiff > 0 ? _championsBlue : _textSecondary),
          _buildPointsBadge(team.points.toString()),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank, bool isChampion, bool isChampionsLeague,
      bool isEuropaLeague, bool isRelegation) {
    Color bgColor = Colors.white.withOpacity(0.08);
    Color textColor = _textPrimary;

    if (isChampion) {
      bgColor = _championGold.withOpacity(0.2);
      textColor = _championGold;
    } else if (isChampionsLeague) {
      bgColor = _championsBlue.withOpacity(0.2);
      textColor = _championsBlue;
    } else if (isEuropaLeague) {
      bgColor = _europaOrange.withOpacity(0.2);
      textColor = _europaOrange;
    } else if (isRelegation) {
      bgColor = _relegationRed.withOpacity(0.2);
      textColor = _relegationRed;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {Color? color}) {
    return Container(
      width: 42,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color ?? _textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge(String points) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: _championsBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            points,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _championsBlue,
            ),
          ),
          const Text(
            'PTS',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: _championsBlue,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TOP SCORERS VIEW - Gamified Experience
// ============================================================================

class TopScorersRedesigned extends StatefulWidget {
  final String league;
  const TopScorersRedesigned({super.key, required this.league});

  @override
  State<TopScorersRedesigned> createState() => _TopScorersRedesignedState();
}

class _TopScorersRedesignedState extends State<TopScorersRedesigned>
    with AutomaticKeepAliveClientMixin {

  static const _bgDark = Color(0xFF0D0F14);
  static const _cardBg = Color(0xFF1C1C1E);
  static const _gold = Color(0xFFFFD700);
  static const _silver = Color(0xFFC0C0C0);
  static const _bronze = Color(0xFFCD7F32);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xFF8E8E93);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<LeagueBloc, LeagueState>(
      buildWhen: (previous, current) =>
      current is GetGoals || current is LoadingState || current is ErrorState,
      builder: (BuildContext context, LeagueState state) {
        final bloc = context.read<LeagueBloc>();

        if (bloc.goals.isEmpty) {
          return _buildLoadingScreen();
        }

        return Container(
          color: _bgDark,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(),
              if (bloc.goals.length >= 3) _buildPodium(bloc.goals.take(3).toList()),
              _buildScorersList(bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: _bgDark,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _cardBg,
              ),
              child: const Center(
                child: Icon(Icons.sports_soccer, size: 40, color: _textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading top scorers...',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.emoji_events, color: _gold, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Top Scorers',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(List<dynamic> topThree) {
    if (topThree.length < 3) return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 2nd Place
            Expanded(child: _buildPodiumPlace(topThree[1], 2, 160, _silver)),
            const SizedBox(width: 12),
            // 1st Place
            Expanded(child: _buildPodiumPlace(topThree[0], 1, 200, _gold)),
            const SizedBox(width: 12),
            // 3rd Place
            Expanded(child: _buildPodiumPlace(topThree[2], 3, 140, _bronze)),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumPlace(dynamic player, int rank, double height, Color color) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (rank * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Player Photo
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  player.player.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: _cardBg,
                    child: const Icon(Icons.person, color: _textSecondary, size: 30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Player Name
            Text(
              player.player.name.split(' ').last,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),

            // Goals
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${player.stats.goals.total}⚽',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Podium Base
            Transform.scale(
              scale: value,
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color.withOpacity(0.6)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScorersList(LeagueBloc bloc) {
    final restOfScorers = bloc.goals.length > 3 ? bloc.goals.sublist(3) : <dynamic>[];

    if (restOfScorers.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final player = restOfScorers[index];
            final rank = index + 4;

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 40)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: _buildScorerCard(player, rank),
                  ),
                );
              },
            );
          },
          childCount: restOfScorers.length,
        ),
      ),
    );
  }

  Widget _buildScorerCard(dynamic player, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _textPrimary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Player Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              player.player.image,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                color: Colors.white.withOpacity(0.08),
                child: const Icon(Icons.person, color: _textSecondary, size: 24),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Player Name
          Expanded(
            child: Text(
              player.player.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Team Logo
          ClipOval(
            child: Image.network(
              player.stats.team.logo,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 28,
                height: 28,
                color: Colors.white.withOpacity(0.08),
                child: const Icon(Icons.sports_soccer, color: _textSecondary, size: 16),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Goals
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              player.stats.goals.total.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF007AFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}