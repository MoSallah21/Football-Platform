import 'team_data.dart';

// All team statistics as const values
class TeamConstants {
  TeamConstants._(); // Private constructor to prevent instantiation

  static const Map<String, TeamStats> homeTeams = {
    'MCY': manCityHome,
    'LIV': liverpoolHome,
    'ARS': arsenalHome,
    'MNU': manUnitedHome,
    'TOT': tottenhamHome,
    'CHE': chelseaHome,
    'BRI': brightonHome,
    'NSTL': newCastleHome,
    'WST': westHamHome,
    'NOTF': nottinghamForestHome,
    'CRYP': crystalPalaceHome,
    'FULH': fulhamHome,
    'BRY': burnleyHome,
    'WOF': wolvesHome,
    'BRNT': brentfordHome,
    'EVE': evertonHome,
    'SHF': sheffieldUnitedHome,
    'BRNO': bournemouthHome,
    'ASV': astonVillaHome,
  };

  static const Map<String, TeamStats> awayTeams = {
    'MCY': manCityAway,
    'LIV': liverpoolAway,
    'ARS': arsenalAway,
    'MNU': manUnitedAway,
    'TOT': tottenhamAway,
    'CHE': chelseaAway,
    'BRI': brightonAway,
    'NSTL': newCastleAway,
    'WST': westHamAway,
    'NOTF': nottinghamForestAway,
    'CRYP': crystalPalaceAway,
    'FULH': fulhamAway,
    'BRY': burnleyAway,
    'WOF': wolvesAway,
    'BRNT': brentfordAway,
    'EVE': evertonAway,
    'SHF': sheffieldUnitedAway,
    'BRNO': bournemouthAway,
    'ASV': astonVillaAway,
  };

  // HOME TEAM STATS
  static const manCityHome = TeamStats(
    name: 'MCY',
    displayName: 'Man City',
    imagePath: 'assets/images/clubs/manchester_city.png',
    code: 1,
    maxPos: 82.1, minPos: 36.5, meanPos: 66.32,
    maxShoots: 31, minShoots: 5, meanShoots: 17.18,
    maxCor: 15, minCor: 1, meanCor: 7.42,
    maxShOnTarget: 15, minShOnTarget: 1, meanShOnTarget: 6.28,
    maxCh: 6, minCh: 0, meanCh: 2.5,
  );

  static const liverpoolHome = TeamStats(
    name: 'LIV',
    displayName: 'Liverpool',
    imagePath: 'assets/images/clubs/liverpool_fc.png',
    code: 5,
    maxPos: 82.4, minPos: 31.9, meanPos: 62.92,
    maxShoots: 30, minShoots: 4, meanShoots: 17.71,
    maxCor: 14, minCor: 1, meanCor: 7.12,
    maxShOnTarget: 15, minShOnTarget: 1, meanShOnTarget: 6.12,
    maxCh: 6, minCh: 0, meanCh: 2.50,
  );

  static const arsenalHome = TeamStats(
    name: 'ARS',
    displayName: 'Arsenal',
    imagePath: 'assets/images/clubs/arsenal_fc.png',
    code: 2,
    maxPos: 81.7, minPos: 19.6, meanPos: 56.58,
    maxShoots: 31, minShoots: 1, meanShoots: 15.41,
    maxCor: 17, minCor: 0, meanCor: 6.03,
    maxShOnTarget: 12, minShOnTarget: 0, meanShOnTarget: 5.20,
    maxCh: 5, minCh: 0, meanCh: 1.42,
  );

  static const manUnitedHome = TeamStats(
    name: 'MNU',
    displayName: 'Man United',
    imagePath: 'assets/images/clubs/manchester_united.png',
    code: 3,
    maxPos: 71.8, minPos: 28.4, meanPos: 54.49,
    maxShoots: 29, minShoots: 2, meanShoots: 15.03,
    maxCor: 12, minCor: 1, meanCor: 5.40,
    maxShOnTarget: 11, minShOnTarget: 1, meanShOnTarget: 5.55,
    maxCh: 6, minCh: 0, meanCh: 2.06,
  );

  static const tottenhamHome = TeamStats(
    name: 'TOT',
    displayName: 'Tottenham',
    imagePath: 'assets/images/clubs/tottenham_hotspur.png',
    code: 8,
    maxPos: 74.2, minPos: 28.8, meanPos: 51.39,
    maxShoots: 27, minShoots: 2, meanShoots: 13.22,
    maxCor: 19, minCor: 0, meanCor: 5.16,
    maxShOnTarget: 13, minShOnTarget: 0, meanShOnTarget: 5.27,
    maxCh: 6, minCh: 0, meanCh: 1.96,
  );

  static const chelseaHome = TeamStats(
    name: 'CHE',
    displayName: 'Chelsea',
    imagePath: 'assets/images/clubs/chelsea_fc.png',
    code: 12,
    maxPos: 80.1, minPos: 34.3, meanPos: 60.98,
    maxShoots: 27, minShoots: 4, meanShoots: 14.78,
    maxCor: 16, minCor: 0, meanCor: 6.22,
    maxShOnTarget: 14, minShOnTarget: 0, meanShOnTarget: 5.21,
    maxCh: 5, minCh: 0, meanCh: 1.72,
  );

  static const brightonHome = TeamStats(
    name: 'BRI',
    displayName: 'Brighton',
    imagePath: 'assets/images/clubs/brighton.png',
    code: 6,
    maxPos: 77.7, minPos: 34.9, meanPos: 55.80,
    maxShoots: 33, minShoots: 2, meanShoots: 15.09,
    maxCor: 15, minCor: 1, meanCor: 6.23,
    maxShOnTarget: 15, minShOnTarget: 0, meanShOnTarget: 4.77,
    maxCh: 5, minCh: 0, meanCh: 1.51,
  );

  static const newCastleHome = TeamStats(
    name: 'NSTL',
    displayName: 'Newcastle',
    imagePath: 'assets/images/clubs/new_castle.png',
    code: 4,
    maxPos: 77.6, minPos: 20.8, meanPos: 43.86,
    maxShoots: 26, minShoots: 4, meanShoots: 13.35,
    maxCor: 15, minCor: 0, meanCor: 5.33,
    maxShOnTarget: 11, minShOnTarget: 1, meanShOnTarget: 4.47,
    maxCh: 7, minCh: 0, meanCh: 1.49,
  );

  static const westHamHome = TeamStats(
    name: 'WST',
    displayName: 'West Ham',
    imagePath: 'assets/images/clubs/west_ham_united.png',
    code: 14,
    maxPos: 64.3, minPos: 21.8, meanPos: 44.20,
    maxShoots: 25, minShoots: 3, meanShoots: 12.39,
    maxCor: 14, minCor: 1, meanCor: 5.18,
    maxShOnTarget: 10, minShOnTarget: 1, meanShOnTarget: 4.15,
    maxCh: 5, minCh: 0, meanCh: 1.36,
  );

  static const nottinghamForestHome = TeamStats(
    name: 'NOTF',
    displayName: 'Nottingham',
    imagePath: 'assets/images/clubs/nottingham_forest.png',
    code: 16,
    maxPos: 57.6, minPos: 18.3, meanPos: 36.84,
    maxShoots: 20, minShoots: 3, meanShoots: 9.94,
    maxCor: 10, minCor: 0, meanCor: 3.0,
    maxShOnTarget: 7, minShOnTarget: 0, meanShOnTarget: 3.39,
    maxCh: 4, minCh: 0, meanCh: 0.90,
  );

  static const crystalPalaceHome = TeamStats(
    name: 'CRYP',
    displayName: 'Crystal Palace',
    imagePath: 'assets/images/clubs/crystal_palace.png',
    code: 11,
    maxPos: 75.0, minPos: 25.7, meanPos: 46.42,
    maxShoots: 31, minShoots: 2, meanShoots: 10.68,
    maxCor: 11, minCor: 0, meanCor: 4.57,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 3.63,
    maxCh: 5, minCh: 0, meanCh: 1.02,
  );

  static const fulhamHome = TeamStats(
    name: 'FULH',
    displayName: 'Fulham',
    imagePath: 'assets/images/clubs/fulham.png',
    code: 10,
    maxPos: 76.6, minPos: 28.0, meanPos: 50.21,
    maxShoots: 24, minShoots: 1, meanShoots: 11.95,
    maxCor: 13, minCor: 0, meanCor: 4.86,
    maxShOnTarget: 11, minShOnTarget: 0, meanShOnTarget: 3.76,
    maxCh: 5, minCh: 0, meanCh: 1.0,
  );

  static const burnleyHome = TeamStats(
    name: 'BRY',
    displayName: 'Burnley',
    imagePath: 'assets/images/clubs/burnley.png',
    code: 23,
    maxPos: 56.1, minPos: 23.3, meanPos: 41.38,
    maxShoots: 18, minShoots: 3, meanShoots: 10.75,
    maxCor: 10, minCor: 1, meanCor: 4.87,
    maxShOnTarget: 9, minShOnTarget: 1, meanShOnTarget: 3.46,
    maxCh: 4, minCh: 0, meanCh: 1.17,
  );

  static const wolvesHome = TeamStats(
    name: 'WOF',
    displayName: 'Wolverhampton',
    imagePath: 'assets/images/clubs/wolverhampton_wanderers.png',
    code: 13,
    maxPos: 72.4, minPos: 28.6, meanPos: 50.13,
    maxShoots: 25, minShoots: 2, meanShoots: 11.78,
    maxCor: 12, minCor: 0, meanCor: 5.17,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 3.89,
    maxCh: 4, minCh: 0, meanCh: 0.92,
  );

  static const brentfordHome = TeamStats(
    name: 'BRNT',
    displayName: 'Brentford',
    imagePath: 'assets/images/clubs/brentford_fc.png',
    code: 9,
    maxPos: 72.5, minPos: 23.7, meanPos: 44.13,
    maxShoots: 24, minShoots: 5, meanShoots: 11.78,
    maxCor: 12, minCor: 0, meanCor: 4.5,
    maxShOnTarget: 10, minShOnTarget: 0, meanShOnTarget: 4.41,
    maxCh: 5, minCh: 0, meanCh: 1.56,
  );

  static const evertonHome = TeamStats(
    name: 'EVE',
    displayName: 'Everton',
    imagePath: 'assets/images/clubs/everton.png',
    code: 17,
    maxPos: 67.8, minPos: 17.6, meanPos: 43.5,
    maxShoots: 23, minShoots: 1, meanShoots: 11.48,
    maxCor: 13, minCor: 1, meanCor: 4.77,
    maxShOnTarget: 10, minShOnTarget: 0, meanShOnTarget: 4.03,
    maxCh: 4, minCh: 0, meanCh: 1.19,
  );

  static const sheffieldUnitedHome = TeamStats(
    name: 'SHF',
    displayName: 'Sheffield United',
    imagePath: 'assets/images/clubs/sheffield_united.png',
    code: 18,
    maxPos: 60.0, minPos: 20.0, meanPos: 40.0,
    maxShoots: 20, minShoots: 2, meanShoots: 10.0,
    maxCor: 10, minCor: 0, meanCor: 4.0,
    maxShOnTarget: 8, minShOnTarget: 0, meanShOnTarget: 3.5,
    maxCh: 3, minCh: 0, meanCh: 1.0,
  );

  static const bournemouthHome = TeamStats(
    name: 'BRNO',
    displayName: 'Bournemouth',
    imagePath: 'assets/images/clubs/bournemouth_fc.png',
    code: 15,
    maxPos: 64.6, minPos: 19.9, meanPos: 40.51,
    maxShoots: 19, minShoots: 3, meanShoots: 9.92,
    maxCor: 8, minCor: 0, meanCor: 4.05,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 3.64,
    maxCh: 2, minCh: 0, meanCh: 1.01,
  );

  static const astonVillaHome = TeamStats(
    name: 'ASV',
    displayName: 'Aston Villa',
    imagePath: 'assets/images/clubs/aston_villa.png',
    code: 7,
    maxPos: 64.6, minPos: 19.9, meanPos: 47.96,
    maxShoots: 19, minShoots: 3, meanShoots: 12.75,
    maxCor: 8, minCor: 0, meanCor: 5.16,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 4.59,
    maxCh: 2, minCh: 0, meanCh: 1.45,
  );

  // AWAY TEAM STATS
  static const manCityAway = TeamStats(
    name: 'MCY',
    displayName: 'Man City',
    imagePath: 'assets/images/clubs/manchester_city.png',
    code: 1,
    maxPos: 80.9, minPos: 36.5, meanPos: 65.67,
    maxShoots: 31, minShoots: 5, meanShoots: 16.77,
    maxCor: 14, minCor: 1, meanCor: 7.02,
    maxShOnTarget: 15, minShOnTarget: 1, meanShOnTarget: 6.07,
    maxCh: 6, minCh: 0, meanCh: 2.36,
  );

  static const liverpoolAway = TeamStats(
    name: 'LIV',
    displayName: 'Liverpool',
    imagePath: 'assets/images/clubs/liverpool_fc.png',
    code: 5,
    maxPos: 82.4, minPos: 31.9, meanPos: 62.18,
    maxShoots: 30, minShoots: 4, meanShoots: 17.03,
    maxCor: 14, minCor: 1, meanCor: 6.85,
    maxShOnTarget: 15, minShOnTarget: 1, meanShOnTarget: 5.98,
    maxCh: 6, minCh: 0, meanCh: 2.49,
  );

  static const arsenalAway = TeamStats(
    name: 'ARS',
    displayName: 'Arsenal',
    imagePath: 'assets/images/clubs/arsenal_fc.png',
    code: 2,
    maxPos: 81.7, minPos: 19.6, meanPos: 55.46,
    maxShoots: 31, minShoots: 1, meanShoots: 14.36,
    maxCor: 17, minCor: 0, meanCor: 5.57,
    maxShOnTarget: 12, minShOnTarget: 0, meanShOnTarget: 4.85,
    maxCh: 5, minCh: 0, meanCh: 1.37,
  );

  static const manUnitedAway = TeamStats(
    name: 'MNU',
    displayName: 'Man United',
    imagePath: 'assets/images/clubs/manchester_united.png',
    code: 3,
    maxPos: 71.8, minPos: 28.4, meanPos: 54.12,
    maxShoots: 29, minShoots: 2, meanShoots: 14.26,
    maxCor: 12, minCor: 1, meanCor: 5.17,
    maxShOnTarget: 11, minShOnTarget: 1, meanShOnTarget: 5.38,
    maxCh: 6, minCh: 0, meanCh: 1.90,
  );

  static const tottenhamAway = TeamStats(
    name: 'TOT',
    displayName: 'Tottenham',
    imagePath: 'assets/images/clubs/tottenham_hotspur.png',
    code: 8,
    maxPos: 74.2, minPos: 28.8, meanPos: 51.14,
    maxShoots: 27, minShoots: 2, meanShoots: 12.73,
    maxCor: 19, minCor: 0, meanCor: 4.91,
    maxShOnTarget: 13, minShOnTarget: 0, meanShOnTarget: 5.02,
    maxCh: 6, minCh: 0, meanCh: 1.83,
  );

  static const chelseaAway = TeamStats(
    name: 'CHE',
    displayName: 'Chelsea',
    imagePath: 'assets/images/clubs/chelsea_fc.png',
    code: 12,
    maxPos: 80.1, minPos: 34.3, meanPos: 60.89,
    maxShoots: 27, minShoots: 4, meanShoots: 14.33,
    maxCor: 16, minCor: 0, meanCor: 5.94,
    maxShOnTarget: 14, minShOnTarget: 0, meanShOnTarget: 5.07,
    maxCh: 5, minCh: 0, meanCh: 1.69,
  );

  static const brightonAway = TeamStats(
    name: 'BRI',
    displayName: 'Brighton',
    imagePath: 'assets/images/clubs/brighton.png',
    code: 6,
    maxPos: 77.7, minPos: 34.9, meanPos: 55.37,
    maxShoots: 33, minShoots: 2, meanShoots: 13.93,
    maxCor: 15, minCor: 1, meanCor: 5.71,
    maxShOnTarget: 15, minShOnTarget: 0, meanShOnTarget: 4.62,
    maxCh: 5, minCh: 0, meanCh: 1.52,
  );

  static const newCastleAway = TeamStats(
    name: 'NSTL',
    displayName: 'Newcastle',
    imagePath: 'assets/images/clubs/new_castle.png',
    code: 4,
    maxPos: 77.6, minPos: 20.8, meanPos: 43.58,
    maxShoots: 26, minShoots: 4, meanShoots: 12.42,
    maxCor: 15, minCor: 0, meanCor: 5.18,
    maxShOnTarget: 11, minShOnTarget: 1, meanShOnTarget: 4.28,
    maxCh: 7, minCh: 0, meanCh: 1.35,
  );

  static const westHamAway = TeamStats(
    name: 'WST',
    displayName: 'West Ham',
    imagePath: 'assets/images/clubs/west_ham_united.png',
    code: 14,
    maxPos: 64.3, minPos: 21.8, meanPos: 44.32,
    maxShoots: 25, minShoots: 3, meanShoots: 12.14,
    maxCor: 14, minCor: 1, meanCor: 5.12,
    maxShOnTarget: 10, minShOnTarget: 1, meanShOnTarget: 4.05,
    maxCh: 5, minCh: 0, meanCh: 1.33,
  );

  static const nottinghamForestAway = TeamStats(
    name: 'NOTF',
    displayName: 'Nottingham',
    imagePath: 'assets/images/clubs/nottingham_forest.png',
    code: 16,
    maxPos: 57.6, minPos: 18.3, meanPos: 37.22,
    maxShoots: 20, minShoots: 3, meanShoots: 9.68,
    maxCor: 10, minCor: 0, meanCor: 3.36,
    maxShOnTarget: 7, minShOnTarget: 0, meanShOnTarget: 3.10,
    maxCh: 4, minCh: 0, meanCh: 0.86,
  );

  static const crystalPalaceAway = TeamStats(
    name: 'CRYP',
    displayName: 'Crystal Palace',
    imagePath: 'assets/images/clubs/crystal_palace.png',
    code: 11,
    maxPos: 75.0, minPos: 25.7, meanPos: 45.84,
    maxShoots: 31, minShoots: 2, meanShoots: 10.41,
    maxCor: 11, minCor: 0, meanCor: 4.5,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 3.64,
    maxCh: 5, minCh: 0, meanCh: 0.99,
  );

  static const fulhamAway = TeamStats(
    name: 'FULH',
    displayName: 'Fulham',
    imagePath: 'assets/images/clubs/fulham.png',
    code: 10,
    maxPos: 76.6, minPos: 28.0, meanPos: 49.19,
    maxShoots: 24, minShoots: 1, meanShoots: 11.46,
    maxCor: 13, minCor: 0, meanCor: 4.59,
    maxShOnTarget: 11, minShOnTarget: 0, meanShOnTarget: 3.75,
    maxCh: 5, minCh: 0, meanCh: 1.0,
  );

  static const burnleyAway = TeamStats(
    name: 'BRY',
    displayName: 'Burnley',
    imagePath: 'assets/images/clubs/burnley.png',
    code: 23,
    maxPos: 56.1, minPos: 23.3, meanPos: 40.74,
    maxShoots: 18, minShoots: 3, meanShoots: 10.30,
    maxCor: 10, minCor: 1, meanCor: 4.64,
    maxShOnTarget: 9, minShOnTarget: 1, meanShOnTarget: 3.34,
    maxCh: 4, minCh: 0, meanCh: 1.10,
  );

  static const wolvesAway = TeamStats(
    name: 'WOF',
    displayName: 'Wolves',
    imagePath: 'assets/images/clubs/wolverhampton_wanderers.png',
    code: 13,
    maxPos: 72.4, minPos: 28.6, meanPos: 49.65,
    maxShoots: 25, minShoots: 2, meanShoots: 11.20,
    maxCor: 12, minCor: 0, meanCor: 4.93,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 3.64,
    maxCh: 4, minCh: 0, meanCh: 0.85,
  );

  static const brentfordAway = TeamStats(
    name: 'BRNT',
    displayName: 'Brentford',
    imagePath: 'assets/images/clubs/brentford_fc.png',
    code: 9,
    maxPos: 72.5, minPos: 23.7, meanPos: 44.01,
    maxShoots: 24, minShoots: 5, meanShoots: 11.18,
    maxCor: 12, minCor: 0, meanCor: 4.23,
    maxShOnTarget: 10, minShOnTarget: 0, meanShOnTarget: 4.17,
    maxCh: 5, minCh: 0, meanCh: 1.52,
  );

  static const evertonAway = TeamStats(
    name: 'EVE',
    displayName: 'Everton',
    imagePath: 'assets/images/clubs/everton.png',
    code: 17,
    maxPos: 67.8, minPos: 17.6, meanPos: 42.90,
    maxShoots: 23, minShoots: 1, meanShoots: 11.10,
    maxCor: 13, minCor: 1, meanCor: 4.42,
    maxShOnTarget: 10, minShOnTarget: 0, meanShOnTarget: 3.84,
    maxCh: 4, minCh: 0, meanCh: 1.14,
  );

  static const sheffieldUnitedAway = TeamStats(
    name: 'SHF',
    displayName: 'Sheffield United',
    imagePath: 'assets/images/clubs/sheffield_united.png',
    code: 18,
    maxPos: 60.0, minPos: 20.0, meanPos: 39.0,
    maxShoots: 20, minShoots: 2, meanShoots: 9.5,
    maxCor: 10, minCor: 0, meanCor: 3.5,
    maxShOnTarget: 8, minShOnTarget: 0, meanShOnTarget: 3.0,
    maxCh: 3, minCh: 0, meanCh: 0.8,
  );

  static const bournemouthAway = TeamStats(
    name: 'BRNO',
    displayName: 'Bournemouth',
    imagePath: 'assets/images/clubs/bournemouth_fc.png',
    code: 15,
    maxPos: 64.6, minPos: 19.9, meanPos: 40.1,
    maxShoots: 19, minShoots: 3, meanShoots: 9.0,
    maxCor: 8, minCor: 0, meanCor: 3.0,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 3.0,
    maxCh: 2, minCh: 0, meanCh: 0.0,
  );

  static const astonVillaAway = TeamStats(
    name: 'ASV',
    displayName: 'Aston Villa',
    imagePath: 'assets/images/clubs/aston_villa.png',
    code: 7,
    maxPos: 64.6, minPos: 19.9, meanPos: 47.8,
    maxShoots: 19, minShoots: 3, meanShoots: 12.0,
    maxCor: 8, minCor: 0, meanCor: 5.0,
    maxShOnTarget: 9, minShOnTarget: 0, meanShOnTarget: 4.0,
    maxCh: 2, minCh: 0, meanCh: 1.0,
  );
}