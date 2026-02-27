import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final bool receivedData;
  final List<dynamic> homeStats;
  final List<dynamic> awayStats;

  const StatsWidget({
    Key? key,
    required this.receivedData,
    required this.homeStats,
    required this.awayStats,
  }) : super(key: key);

  // ============================================================================
  // THEME CONSTANTS - Pre-computed for performance
  // ============================================================================

  static const _blueShade = Color(0xFF1A237E);
  static const _purpleShade = Color(0xFF4A148C);
  static const _indigoShade = Color(0xFF1A237E);
  static const _greenAccent = Color(0xFF4CAF50);
  static const _orangeAccent = Color(0xFFFF9800);

  // Alpha values
  static const _alpha80 = 204;
  static const _alpha50 = 128;
  static const _alpha30 = 77;
  static const _alpha20 = 51;
  static const _alpha15 = 38;
  static const _alpha10 = 25;
  static const _alpha05 = 13;

  // Pre-computed gradients
  static final _backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: const [_blueShade, _purpleShade, _indigoShade],
  );

  static final _headerCardGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha10),
      Colors.white.withAlpha(_alpha05),
    ],
  );

  static final _homeGradient = LinearGradient(
    colors: [
      _greenAccent.withAlpha(_alpha30),
      _greenAccent.withAlpha(_alpha10),
    ],
  );

  static final _awayGradient = LinearGradient(
    colors: [
      _orangeAccent.withAlpha(_alpha30),
      _orangeAccent.withAlpha(_alpha10),
    ],
  );

  static final _statCardGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.white.withAlpha(_alpha05),
      Colors.white.withAlpha(_alpha10),
      Colors.white.withAlpha(_alpha05),
    ],
  );

  static final _labelGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha15),
      Colors.white.withAlpha(_alpha05),
    ],
  );

  static final _dividerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white.withAlpha(_alpha80),
      Colors.white.withAlpha(_alpha20),
    ],
  );

  // Pre-computed border colors
  static final _whiteBorder20 = Colors.white.withAlpha(_alpha20);
  static final _whiteBorder10 = Colors.white.withAlpha(_alpha10);
  static final _greenBorder = _greenAccent.withAlpha(_alpha50);
  static final _greenBorder30 = _greenAccent.withAlpha(_alpha30);
  static final _orangeBorder = _orangeAccent.withAlpha(_alpha50);
  static final _orangeBorder30 = _orangeAccent.withAlpha(_alpha30);

  // Pre-computed shadows
  static final _cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(_alpha30),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static final _statItemShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(_alpha20),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final _loadingShadow = [
    BoxShadow(
      color: Colors.blue.withAlpha(_alpha30),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];

  static final _textShadow = [
    Shadow(
      color: Colors.black.withAlpha(_alpha50),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final _greenTextShadow = [
    Shadow(
      color: _greenAccent.withAlpha(_alpha80),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static final _orangeTextShadow = [
    Shadow(
      color: _orangeAccent.withAlpha(_alpha80),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static final _loadingTextShadow = [
    Shadow(
      color: Colors.black.withAlpha(_alpha50),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  // Pre-computed text styles
  static const _headerTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const _loadingTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const _statValueTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.white,
  );

  static const _statLabelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ============================================================================
  // BUILD METHOD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    if (!receivedData) {
      return _buildLoadingState();
    }

    return _buildStatsContent();
  }

  // ============================================================================
  // LOADING STATE
  // ============================================================================

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(_alpha10),
                  boxShadow: _loadingShadow,
                ),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Loading Stats...',
                style: _loadingTextStyle.copyWith(shadows: _loadingTextShadow),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // STATS CONTENT
  // ============================================================================

  Widget _buildStatsContent() {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          _buildStatsList(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // ============================================================================
  // HEADER
  // ============================================================================

  Widget _buildHeader() {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: _headerCardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _whiteBorder20,
            width: 1,
          ),
          boxShadow: _cardShadow,
        ),
        child: Row(
          children: [
            Expanded(child: _buildTeamHeader(isHome: true)),
            _buildDivider(),
            Expanded(child: _buildTeamHeader(isHome: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader({required bool isHome}) {
    final color = isHome ? _greenAccent : _orangeAccent;
    final borderColor = isHome ? _greenBorder : _orangeBorder;
    final icon = isHome ? Icons.home : Icons.sports_soccer;
    final label = isHome ? 'HOME' : 'AWAY';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(_alpha20),
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: _headerTextStyle.copyWith(shadows: _textShadow),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 2,
      height: 50,
      decoration: BoxDecoration(gradient: _dividerGradient),
    );
  }

  // ============================================================================
  // STATS LIST
  // ============================================================================

  Widget _buildStatsList() {
    // Validate data before building
    final itemCount = _getValidItemCount();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return RepaintBoundary(
            child: _buildStatItem(index),
          );
        },
        childCount: itemCount,
      ),
    );
  }

  int _getValidItemCount() {
    // Ensure both lists have same length and are not empty
    if (homeStats.isEmpty || awayStats.isEmpty) return 0;
    return homeStats.length < awayStats.length
        ? homeStats.length
        : awayStats.length;
  }

  Widget _buildStatItem(int index) {
    // Safety check
    if (index >= homeStats.length || index >= awayStats.length) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: _statCardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _whiteBorder10,
          width: 1,
        ),
        boxShadow: _statItemShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildStatValue(
                  homeStats[index].value?.toString() ?? '0',
                  isHome: true,
                ),
              ),
              Expanded(
                flex: 3,
                child: _buildStatLabel(
                  homeStats[index].label?.toString() ?? 'Unknown',
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildStatValue(
                  awayStats[index].value?.toString() ?? '0',
                  isHome: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatValue(String value, {required bool isHome}) {
    final gradient = isHome ? _homeGradient : _awayGradient;
    final borderColor = isHome ? _greenBorder30 : _orangeBorder30;
    final shadow = isHome ? _greenTextShadow : _orangeTextShadow;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: _statValueTextStyle.copyWith(shadows: shadow),
      ),
    );
  }

  Widget _buildStatLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: _labelGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _whiteBorder20,
          width: 1,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: _statLabelTextStyle.copyWith(shadows: _textShadow),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}