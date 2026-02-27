enum LoadingType {
  general,
  table,
  goals,
  matches,
  liveMatches,
  allMatches,
  liveMatchData,
}

enum ErrorType {
  general,
  table,
  goals,
  matches,
  liveMatches,
  allMatches,
  liveMatchData,
}

enum DataType {
  table,
  goals,
  matches,
  allMatches,
  all,
}class CachedData {
  final dynamic data;
  final DateTime timestamp;

  CachedData({
    required this.data,
    required this.timestamp,
  });
}
