import 'package:flutter/material.dart';

import '../../data/models/league_models/liveFixtures/live_fixture_data.dart';

class EventWidgetBuilder {
  final int homeTeamId;

  EventWidgetBuilder({required this.homeTeamId});

  Widget build(Event event) {
    switch (event.type) {
      case "Goal":
        return _buildGoal(event);
      case "Card":
        return _buildCard(event);
      case "subst":
        return _buildSubstitution(event);
      default:
        return _buildDefault(event);
    }
  }

  Widget _buildGoal(Event event) {
    final isHome = event.team.id == homeTeamId;
    final teamColor = isHome ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isHome ? Alignment.centerLeft : Alignment.centerRight,
          end: isHome ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            teamColor.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
            teamColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: teamColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: teamColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: isHome
              ? [
            _timeChip(event.time.time.toString(), teamColor),
            const SizedBox(width: 16),
            Expanded(
              child: _playerName(event.player.name, isHome),
            ),
            const SizedBox(width: 16),
            _goalIcon(teamColor),
          ]
              : [
            _goalIcon(teamColor),
            const SizedBox(width: 16),
            Expanded(
              child: _playerName(event.player.name, isHome),
            ),
            const SizedBox(width: 16),
            _timeChip(event.time.time.toString(), teamColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Event event) {
    final isHome = event.team.id == homeTeamId;
    final teamColor = isHome ? Colors.green : Colors.orange;
    final cardColor = event.detail == "Yellow Card" ? Colors.amber : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isHome ? Alignment.centerLeft : Alignment.centerRight,
          end: isHome ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            cardColor.withOpacity(0.1),
            Colors.white.withOpacity(0.1),
            cardColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: isHome
              ? [
            _timeChip(event.time.time.toString(), teamColor),
            const SizedBox(width: 16),
            Expanded(
              child: _playerName(event.player.name, isHome),
            ),
            const SizedBox(width: 16),
            _cardIcon(cardColor, event.detail),
          ]
              : [
            _cardIcon(cardColor, event.detail),
            const SizedBox(width: 16),
            Expanded(
              child: _playerName(event.player.name, isHome),
            ),
            const SizedBox(width: 16),
            _timeChip(event.time.time.toString(), teamColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSubstitution(Event event) {
    final isHome = event.team.id == homeTeamId;
    final teamColor = isHome ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isHome ? Alignment.centerLeft : Alignment.centerRight,
          end: isHome ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            Colors.blue.withOpacity(0.15),
            Colors.white.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: isHome
              ? [
            _timeChip(event.time.time.toString(), teamColor),
            const SizedBox(width: 16),
            Expanded(
              child: _substitutionPlayers(event.player.name, event.assist.name, isHome),
            ),
            const SizedBox(width: 16),
            _substitutionIcon(),
          ]
              : [
            _substitutionIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: _substitutionPlayers(event.player.name, event.assist.name, isHome),
            ),
            const SizedBox(width: 16),
            _timeChip(event.time.time.toString(), teamColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDefault(Event event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timeChip(event.time.time.toString(), Colors.blue),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    event.type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.detail,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // عناصر التصميم المحسنة
  Widget _timeChip(String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        "$time'",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
          shadows: [
            Shadow(
              color: color.withOpacity(0.8),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerName(String name, bool isHome) {
    return Text(
      name,
      textAlign: isHome ? TextAlign.left : TextAlign.right,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _substitutionPlayers(String playerOut, String playerIn, bool isHome) {
    return ClipRRect(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isHome ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        spacing: 4,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_upward,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  playerIn,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_downward,
                color: Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  playerOut,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _goalIcon(Color teamColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            teamColor.withOpacity(0.4),
            teamColor.withOpacity(0.2),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: teamColor.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: teamColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.sports_soccer,
        size: 28,
        color: Colors.white,
        shadows: [
          Shadow(
            color: teamColor.withOpacity(0.8),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _cardIcon(Color cardColor, String cardType) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardColor.withOpacity(0.4),
            cardColor.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cardColor.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        width: 20,
        height: 28,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            cardType == "Yellow Card" ? Icons.warning : Icons.close,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _substitutionIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.4),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swap_vert,
            color: Colors.white,
            size: 24,
            shadows: [
              Shadow(
                color: Colors.blue.withOpacity(0.8),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}