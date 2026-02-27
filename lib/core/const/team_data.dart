// Team statistics data model
class TeamStats {
  final String name;
  final String displayName;
  final String imagePath;
  final int code;

  // Possession stats
  final double maxPos;
  final double minPos;
  final double meanPos;

  // Shooting stats
  final int maxShoots;
  final int minShoots;
  final double meanShoots;

  // Corners stats
  final int maxCor;
  final int minCor;
  final double meanCor;

  // Shots on target stats
  final int maxShOnTarget;
  final int minShOnTarget;
  final double meanShOnTarget;

  // Chances stats
  final int maxCh;
  final int minCh;
  final double meanCh;

  const TeamStats({
    required this.name,
    required this.displayName,
    required this.imagePath,
    required this.code,
    required this.maxPos,
    required this.minPos,
    required this.meanPos,
    required this.maxShoots,
    required this.minShoots,
    required this.meanShoots,
    required this.maxCor,
    required this.minCor,
    required this.meanCor,
    required this.maxShOnTarget,
    required this.minShOnTarget,
    required this.meanShOnTarget,
    required this.maxCh,
    required this.minCh,
    required this.meanCh,
  });

  // Create separate home and away stats
  TeamStats copyWith({
    String? name,
    String? displayName,
    String? imagePath,
    int? code,
    double? maxPos,
    double? minPos,
    double? meanPos,
    int? maxShoots,
    int? minShoots,
    double? meanShoots,
    int? maxCor,
    int? minCor,
    double? meanCor,
    int? maxShOnTarget,
    int? minShOnTarget,
    double? meanShOnTarget,
    int? maxCh,
    int? minCh,
    double? meanCh,
  }) {
    return TeamStats(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      imagePath: imagePath ?? this.imagePath,
      code: code ?? this.code,
      maxPos: maxPos ?? this.maxPos,
      minPos: minPos ?? this.minPos,
      meanPos: meanPos ?? this.meanPos,
      maxShoots: maxShoots ?? this.maxShoots,
      minShoots: minShoots ?? this.minShoots,
      meanShoots: meanShoots ?? this.meanShoots,
      maxCor: maxCor ?? this.maxCor,
      minCor: minCor ?? this.minCor,
      meanCor: meanCor ?? this.meanCor,
      maxShOnTarget: maxShOnTarget ?? this.maxShOnTarget,
      minShOnTarget: minShOnTarget ?? this.minShOnTarget,
      meanShOnTarget: meanShOnTarget ?? this.meanShOnTarget,
      maxCh: maxCh ?? this.maxCh,
      minCh: minCh ?? this.minCh,
      meanCh: meanCh ?? this.meanCh,
    );
  }
}