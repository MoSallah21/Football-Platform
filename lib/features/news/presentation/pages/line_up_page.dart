import 'dart:math';
import 'package:flutter/material.dart';

class LineUpWidget extends StatelessWidget {
  final bool receivedData;
  final String coachHomePhoto;
  final String coachAwayPhoto;
  final String coachHomeName;
  final String coachAwayName;
  final String homeFormation;
  final String awayFormation;
  final List<Player> homeStarters;
  final List<Player> awayStarters;
  final List<Player> homeSubs;
  final List<Player> awaySubs;

  const LineUpWidget({
    Key? key,
    required this.receivedData,
    required this.coachHomePhoto,
    required this.coachAwayPhoto,
    required this.coachHomeName,
    required this.coachAwayName,
    required this.homeFormation,
    required this.awayFormation,
    required this.homeStarters,
    required this.awayStarters,
    required this.homeSubs,
    required this.awaySubs,
  }) : super(key: key);

  // ============================================================================
  // THEME CONSTANTS - Pre-computed for performance
  // ============================================================================

  static const _blueShade = Color(0xFF1A237E);
  static const _purpleShade = Color(0xFF4A148C);
  static const _indigoShade = Color(0xFF1A237E);
  static const _greenAccent = Color(0xFF4CAF50);
  static const _orangeAccent = Color(0xFFFF9800);
  static const _greyAccent = Color(0xFF9E9E9E);

  // Alpha values
  static const _alpha80 = 204;
  static const _alpha50 = 128;
  static const _alpha40 = 102;
  static const _alpha30 = 77;
  static const _alpha20 = 51;
  static const _alpha10 = 25;
  static const _alpha05 = 13;

  // Pre-computed gradients
  static final _backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: const [_blueShade, _purpleShade, _indigoShade],
  );

  static final _cardGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha10),
      Colors.white.withAlpha(_alpha05),
    ],
  );

  static final _sectionHeaderGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha20),
      Colors.white.withAlpha(_alpha10),
    ],
  );

  static final _substituteHeaderGradient = LinearGradient(
    colors: [
      _greyAccent.withAlpha(_alpha30),
      _greyAccent.withAlpha(_alpha10),
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

  static final _homeCoachGradient = LinearGradient(
    colors: [
      _greenAccent.withAlpha(_alpha30),
      _greenAccent.withAlpha(_alpha10),
    ],
  );

  static final _awayCoachGradient = LinearGradient(
    colors: [
      _orangeAccent.withAlpha(_alpha30),
      _orangeAccent.withAlpha(_alpha10),
    ],
  );

  static final _homeFormationGradient = LinearGradient(
    colors: [
      _greenAccent.withAlpha(_alpha30),
      _greenAccent.withAlpha(_alpha10),
    ],
  );

  static final _awayFormationGradient = LinearGradient(
    colors: [
      _orangeAccent.withAlpha(_alpha30),
      _orangeAccent.withAlpha(_alpha10),
    ],
  );

  static final _homePlayerNumberGradient = LinearGradient(
    colors: [
      _greenAccent.withAlpha(_alpha30),
      _greenAccent.withAlpha(_alpha10),
    ],
  );

  static final _awayPlayerNumberGradient = LinearGradient(
    colors: [
      _orangeAccent.withAlpha(_alpha30),
      _orangeAccent.withAlpha(_alpha10),
    ],
  );

  static final _starterRowGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha10),
      Colors.white.withAlpha(_alpha05),
    ],
  );

  static final _substituteRowGradient = LinearGradient(
    colors: [
      Colors.white.withAlpha(_alpha05),
      Colors.white.withAlpha(3), // ~0.025
    ],
  );

  // Pre-computed shadows
  static final _cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(_alpha30),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static final _sectionHeaderShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(_alpha20),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final _coachPhotoShadow = [
    BoxShadow(
      color: _greenAccent.withAlpha(_alpha30),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final _formationShadow = [
    BoxShadow(
      color: _greenAccent.withAlpha(_alpha20),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];

  static final _playerRowShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(_alpha10),
      blurRadius: 4,
      offset: const Offset(0, 2),
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
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static final _smallTextShadow = [
    Shadow(
      color: Colors.black.withAlpha(_alpha50),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final _playerTextShadow = [
    Shadow(
      color: Colors.black.withAlpha(_alpha30),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final _greenTextShadow = [
    Shadow(
      color: _greenAccent.withAlpha(_alpha80),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final _orangeTextShadow = [
    Shadow(
      color: _orangeAccent.withAlpha(_alpha80),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  // Pre-computed border colors
  static final _whiteBorder30 = Colors.white.withAlpha(_alpha30);
  static final _whiteBorder20 = Colors.white.withAlpha(_alpha20);
  static final _whiteBorder10 = Colors.white.withAlpha(_alpha10);
  static final _greyBorder30 = _greyAccent.withAlpha(_alpha30);
  static final _greenBorder50 = _greenAccent.withAlpha(_alpha50);
  static final _greenBorder40 = _greenAccent.withAlpha(_alpha40);
  static final _orangeBorder50 = _orangeAccent.withAlpha(_alpha50);
  static final _orangeBorder40 = _orangeAccent.withAlpha(_alpha40);

  // Pre-computed text styles
  static const _loadingTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const _sectionHeaderTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  );

  static const _coachRoleTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const _coachNameTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.white,
  );

  static const _formationTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.white,
  );

  static const _playerNumberTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.white,
  );

  static const _playerNameTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );

  static const _vsDividerTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  // ============================================================================
  // BUILD METHOD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    if (!receivedData) {
      return _buildLoadingState();
    }

    return _buildLineUpContent();
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
                'Loading Lineup...',
                style: _loadingTextStyle.copyWith(shadows: _textShadow),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // LINEUP CONTENT
  // ============================================================================

  Widget _buildLineUpContent() {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          _buildCoachesSection(),
          _buildFormationSection(),
          _buildStartersSection(),
          _buildSubstitutesSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // ============================================================================
  // COACHES SECTION
  // ============================================================================

  Widget _buildCoachesSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildSectionHeader("COACHES", Icons.person_4_rounded),
          RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: _buildCardDecoration(),
              child: Row(
                children: [
                  Expanded(child: _buildCoachCard(isHome: true)),
                  _buildDivider(),
                  Expanded(child: _buildCoachCard(isHome: false)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard({required bool isHome}) {
    final photo = isHome ? coachHomePhoto : coachAwayPhoto;
    final name = isHome ? coachHomeName : coachAwayName;
    final color = isHome ? _greenAccent : _orangeAccent;
    final role = isHome ? "HOME" : "AWAY";
    final gradient = isHome ? _homeCoachGradient : _awayCoachGradient;
    final borderColor = isHome ? _greenBorder50 : _orangeBorder50;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(_alpha30),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              photo,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _greyAccent.withAlpha(_alpha30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          role,
          style: _coachRoleTextStyle.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _coachNameTextStyle.copyWith(shadows: _smallTextShadow),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 2,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(gradient: _dividerGradient),
    );
  }

  // ============================================================================
  // FORMATION SECTION
  // ============================================================================

  Widget _buildFormationSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildSectionHeader("LineUp", Icons.sports_soccer),
          RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: _buildCardDecoration(),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFormationCard(
                      homeFormation,
                      _homeFormationGradient,
                      _greenBorder50,
                      _greenAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFormationCard(
                      awayFormation,
                      _awayFormationGradient,
                      _orangeBorder50,
                      _orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormationCard(
      String formation,
      Gradient gradient,
      Color borderColor,
      Color shadowColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(_alpha20),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        formation,
        textAlign: TextAlign.center,
        style: _formationTextStyle.copyWith(
          shadows: [
            Shadow(
              color: shadowColor.withAlpha(_alpha80),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // STARTERS SECTION
  // ============================================================================

  Widget _buildStartersSection() {
    final itemCount = _getValidStarterCount();

    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildSectionHeader("STARTING LINEUP", Icons.groups),
          if (itemCount == 0)
            _buildEmptyState("No starters available")
          else
            _buildPlayerList(
              itemCount: itemCount,
              isStarter: true,
            ),
        ],
      ),
    );
  }

  int _getValidStarterCount() {
    if (homeStarters.isEmpty || awayStarters.isEmpty) return 0;
    return min(homeStarters.length, awayStarters.length);
  }

  // ============================================================================
  // SUBSTITUTES SECTION
  // ============================================================================

  Widget _buildSubstitutesSection() {
    final itemCount = _getValidSubstituteCount();

    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildSectionHeader(
            "SUBSTITUTES",
            Icons.people_outline,
            isSubstitute: true,
          ),
          if (itemCount == 0)
            _buildEmptyState("No substitutes available")
          else
            _buildPlayerList(
              itemCount: itemCount,
              isStarter: false,
            ),
        ],
      ),
    );
  }

  int _getValidSubstituteCount() {
    if (homeSubs.isEmpty || awaySubs.isEmpty) return 0;
    return min(homeSubs.length, awaySubs.length);
  }

  // ============================================================================
  // PLAYER LIST
  // ============================================================================

  Widget _buildPlayerList({
    required int itemCount,
    required bool isStarter,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: _buildPlayerRow(index: index, isStarter: isStarter),
        );
      },
    );
  }

  Widget _buildPlayerRow({
    required int index,
    required bool isStarter,
  }) {
    // Get player lists based on type
    final leftPlayers = isStarter ? homeStarters : homeSubs;
    final rightPlayers = isStarter ? awayStarters : awaySubs;

    // Safety check
    if (index >= leftPlayers.length || index >= rightPlayers.length) {
      return const SizedBox.shrink();
    }

    final leftPlayer = leftPlayers[index];
    final rightPlayer = rightPlayers[index];

    final Color accentColor = isStarter ? Colors.white : Colors.grey.shade400;
    final gradient = isStarter ? _starterRowGradient : _substituteRowGradient;
    final borderColor = isStarter ? _whiteBorder20 : _whiteBorder10;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: _playerRowShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPlayerInfo(
              number: leftPlayer.number,
              name: leftPlayer.name,
              isHome: true,
              accentColor: accentColor,
              isStarter: isStarter,
            ),
          ),
          _buildVsDivider(),
          Expanded(
            child: _buildPlayerInfo(
              number: rightPlayer.number,
              name: rightPlayer.name,
              isHome: false,
              accentColor: accentColor,
              isStarter: isStarter,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo({
    required int number,
    required String name,
    required bool isHome,
    required Color accentColor,
    required bool isStarter,
  }) {
    if (isHome) {
      return Row(
        children: [
          _buildPlayerNumber(number, isHome: true),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPlayerName(name, accentColor, isStarter),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: _buildPlayerName(
              name,
              accentColor,
              isStarter,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 12),
          _buildPlayerNumber(number, isHome: false),
        ],
      );
    }
  }

  Widget _buildPlayerNumber(int number, {required bool isHome}) {
    final gradient = isHome ? _homePlayerNumberGradient : _awayPlayerNumberGradient;
    final borderColor = isHome ? _greenBorder40 : _orangeBorder40;
    final shadow = isHome ? _greenTextShadow : _orangeTextShadow;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: _playerNumberTextStyle.copyWith(shadows: shadow),
        ),
      ),
    );
  }

  Widget _buildPlayerName(
      String name,
      Color color,
      bool isStarter, {
        TextAlign textAlign = TextAlign.start,
      }) {
    return Text(
      name,
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _playerNameTextStyle.copyWith(
        color: color,
        shadows: isStarter ? _playerTextShadow : null,
      ),
    );
  }

  Widget _buildVsDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "VS",
        style: _vsDividerTextStyle.copyWith(
          color: Colors.white.withAlpha(_alpha80 - 30), // ~60% opacity
        ),
      ),
    );
  }

  // ============================================================================
  // HELPER WIDGETS
  // ============================================================================

  Widget _buildSectionHeader(
      String title,
      IconData icon, {
        bool isSubstitute = false,
      }) {
    final gradient = isSubstitute ? _substituteHeaderGradient : _sectionHeaderGradient;
    final borderColor = isSubstitute ? _greyBorder30 : _whiteBorder30;
    final color = isSubstitute ? Colors.grey.shade300 : Colors.white;

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          boxShadow: _sectionHeaderShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: _sectionHeaderTextStyle.copyWith(
                color: color,
                shadows: _textShadow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withAlpha(_alpha80 - 30), // ~60% opacity
          fontSize: 14,
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: _cardGradient,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: _whiteBorder20,
        width: 1,
      ),
      boxShadow: _cardShadow,
    );
  }
}

// ============================================================================
// PLAYER MODEL
// ============================================================================

class Player {
  final int number;
  final String name;

  const Player({required this.number, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Player &&
              runtimeType == other.runtimeType &&
              number == other.number &&
              name == other.name;

  @override
  int get hashCode => number.hashCode ^ name.hashCode;
}