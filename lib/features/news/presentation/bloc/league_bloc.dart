import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/features/news/data/models/league_models/table.dart';
import 'package:football_platform/features/news/domain/usecases/get_all_matches.dart';
import 'package:football_platform/features/news/domain/usecases/get_league_table.dart';
import 'package:football_platform/features/news/domain/usecases/get_live_match_details.dart';
import 'package:football_platform/features/news/domain/usecases/get_live_matches.dart';
import 'package:football_platform/features/news/domain/usecases/get_top_scorers.dart';
import 'package:football_platform/features/news/domain/usecases/get_upcoming_matches.dart';

import 'enum.dart';
part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  final GetLeagueTableUseCase _getLeagueTableUseCase;
  final GetTopScoresUseCase _getTopScoresUseCase;
  final GetUpcomingUseCase _getUpcomingUseCase;
  final GetLiveMatchesUseCase _getLiveMatchesUseCase;
  final GetAllMatchesUseCase _getAllMatchesUseCase;
  final FetchLiveMatchesDataUseCase _fetchLiveMatchesDataUseCase;

  // Request deduplication with timeout
  final Map<String, _RequestInfo> _activeRequests = {};

  // Optimized cache with LRU eviction
  final Map<String, CachedData> _cache = {};
  static const int _maxCacheSize = 20;

  // Cache durations based on data volatility
  static const Duration _tableCacheDuration = Duration(minutes: 10);
  static const Duration _goalsCacheDuration = Duration(minutes: 15);
  static const Duration _matchesCacheDuration = Duration(minutes: 5);
  static const Duration _liveMatchCacheDuration = Duration(minutes: 1);

  // Request timeout
  static const Duration _requestTimeout = Duration(seconds: 30);

  LeagueBloc({
    required GetLeagueTableUseCase getLeagueTableUseCase,
    required GetTopScoresUseCase getTopScoresUseCase,
    required GetUpcomingUseCase getUpcomingUseCase,
    required GetLiveMatchesUseCase getLiveMatchesUseCase,
    required GetAllMatchesUseCase getAllMatchesUseCase,
    required FetchLiveMatchesDataUseCase fetchLiveMatchesDataUseCase,
  })  : _getLeagueTableUseCase = getLeagueTableUseCase,
        _getTopScoresUseCase = getTopScoresUseCase,
        _getUpcomingUseCase = getUpcomingUseCase,
        _getLiveMatchesUseCase = getLiveMatchesUseCase,
        _getAllMatchesUseCase = getAllMatchesUseCase,
        _fetchLiveMatchesDataUseCase = fetchLiveMatchesDataUseCase,
        super(AppInitState()) {
    on<AppStarted>(_onAppStarted);
    on<SelectIndexEvent>(_onSelectIndex);
    on<GetTableDataEvent>(_onGetTableData);
    on<GetGoalsDataEvent>(_onGetGoalsData);
    on<GetUpcomingDataEvent>(_onGetUpcomingData);
    on<GetLiveMatchEvent>(_onGetLiveMatch);
    on<GetAllMatchesDataEvent>(_onGetAllMatchesData);
    on<FetchLiveMatchDataEvent>(_onFetchLiveMatchData);
    on<RefreshDataEvent>(_onRefreshData);
    on<ClearCacheEvent>(_onClearCache);
    on<ClearAllDataEvent>(_onClearAllData);
    on<ChangeLeagueEvent>(_onChangeLeague);
  }

  static LeagueBloc get(BuildContext context) =>
      BlocProvider.of<LeagueBloc>(context);

  // Logic variables
  int selectedItem = 0;
  final List<String> titles = ['', 'Standings', 'Top Scorer 2024/2025'];
  String league = '';
  final List<Widget> pages = [];

  // Data variables - using final for collections that won't be reassigned
  final List<TableData> dataTable = [];
  final List<PlayerStats> goals = [];
  final List<FixtureData> liveMatches = [];
  final List<FixtureData> upcomingMatches = [];
  final List<FixtureData> allMatches = [];
  LiveMatchData lmd = LiveMatchData();
  bool receivedData = false;

  // Tab Controller
  late TabController tabController;
  int tabIndex = 0;

  void _onAppStarted(AppStarted event, Emitter<LeagueState> emit) {
    emit(AppInitState());
  }

  void _onSelectIndex(SelectIndexEvent event, Emitter<LeagueState> emit) {
    selectedItem = event.index;
    emit(ChangeSelectedIndex());
  }

  void _onChangeLeague(ChangeLeagueEvent event, Emitter<LeagueState> emit) {
    // Cancel active requests for old league
    _cancelLeagueRequests(league);

    _clearAllData();
    league = event.newLeague;
    selectedItem = 0;

    emit(DataCleared());

    // Preload critical data
    add(GetUpcomingDataEvent(event.newLeague));
    add(GetTableDataEvent(event.newLeague));
    add(GetGoalsDataEvent(event.newLeague));
  }

  void _onClearAllData(ClearAllDataEvent event, Emitter<LeagueState> emit) {
    _clearAllData();
    emit(DataCleared());
  }

  void _clearAllData() {
    dataTable.clear();
    goals.clear();
    liveMatches.clear();
    upcomingMatches.clear();
    allMatches.clear();

    lmd = LiveMatchData();
    receivedData = false;
    tabIndex = 0;
    pages.clear();
  }

  Future<void> _onGetTableData(
      GetTableDataEvent event,
      Emitter<LeagueState> emit,
      ) async {
    final requestKey = 'table_${event.league}';

    // Check for active request
    if (_activeRequests.containsKey(requestKey)) {
      await _activeRequests[requestKey]!.completer.future;
      return;
    }

    // Check cache with appropriate duration
    if (_isCacheValid(requestKey, _tableCacheDuration)) {
      final cachedData = _cache[requestKey]?.data as List<TableData>?;
      if (cachedData != null) {
        dataTable
          ..clear()
          ..addAll(cachedData);
        emit(GetTable());
        return;
      }
    }

    await _executeRequest<List<TableData>>(
      requestKey: requestKey,
      emit: emit,
      loadingState: LoadingState(loadingType: LoadingType.table),
      errorType: ErrorType.table,
      retryEvent: GetTableDataEvent(event.league),
      apiCall: () => _getLeagueTableUseCase.call(event.league),
      onSuccess: (data) {
        dataTable
          ..clear()
          ..addAll(data);
        _updateCache(requestKey, data);
        emit(GetTable());
      },
    );
  }

  Future<void> _onGetGoalsData(
      GetGoalsDataEvent event,
      Emitter<LeagueState> emit,
      ) async {
    final requestKey = 'goals_${event.league}';

    if (_activeRequests.containsKey(requestKey)) {
      await _activeRequests[requestKey]!.completer.future;
      return;
    }

    if (_isCacheValid(requestKey, _goalsCacheDuration)) {
      final cachedData = _cache[requestKey]?.data as List<PlayerStats>?;
      if (cachedData != null) {
        goals
          ..clear()
          ..addAll(cachedData);
        emit(GetGoals());
        return;
      }
    }

    await _executeRequest<List<PlayerStats>>(
      requestKey: requestKey,
      emit: emit,
      loadingState: LoadingState(loadingType: LoadingType.goals),
      errorType: ErrorType.goals,
      retryEvent: GetGoalsDataEvent(event.league),
      apiCall: () => _getTopScoresUseCase.call(event.league),
      onSuccess: (data) {
        goals
          ..clear()
          ..addAll(data);
        _updateCache(requestKey, data);
        emit(GetGoals());
      },
    );
  }

  Future<void> _onGetUpcomingData(
      GetUpcomingDataEvent event,
      Emitter<LeagueState> emit,
      ) async {
    final requestKey = 'upcoming_${event.league}';

    if (_activeRequests.containsKey(requestKey)) {
      await _activeRequests[requestKey]!.completer.future;
      return;
    }

    if (_isCacheValid(requestKey, _matchesCacheDuration)) {
      final cachedData = _cache[requestKey]?.data as Map<String, List<FixtureData>>?;
      if (cachedData != null) {
        upcomingMatches
          ..clear()
          ..addAll(cachedData['upcoming'] ?? []);
        liveMatches
          ..clear()
          ..addAll(cachedData['live'] ?? []);
        emit(GetUpComingData());
        return;
      }
    }

    final completer = Completer<void>();
    _activeRequests[requestKey] = _RequestInfo(
      completer: completer,
      timestamp: DateTime.now(),
    );

    try {
      emit(LoadingState(loadingType: LoadingType.matches));

      // Parallel API calls with timeout
      final results = await Future.wait([
        _getUpcomingUseCase.call(event.league),
        _getLiveMatchesUseCase.call(event.league),
      ]).timeout(_requestTimeout);

      final upcomingResult = results[0];
      final liveResult = results[1];

      String? errorMessage;
      final now = DateTime.now();
      final cutoffTime = now.subtract(const Duration(minutes: 90));

      upcomingResult.fold(
            (failure) => errorMessage = failure.message,
            (upcomingData) {
          // Filter and sort in one pass
          final filteredMatches = <FixtureData>[];

          for (final match in upcomingData) {
            try {
              final matchDate = DateTime.parse(match.fixture.date);
              if (matchDate.isAfter(cutoffTime)) {
                filteredMatches.add(match);
              }
            } catch (e) {
              // Skip invalid dates
              continue;
            }
          }

          // Sort by date
          filteredMatches.sort((a, b) {
            final dateA = DateTime.parse(a.fixture.date);
            final dateB = DateTime.parse(b.fixture.date);
            return dateA.compareTo(dateB);
          });

          upcomingMatches
            ..clear()
            ..addAll(filteredMatches);
        },
      );

      if (errorMessage == null) {
        liveResult.fold(
              (failure) => errorMessage = failure.message,
              (liveData) {
            liveMatches
              ..clear()
              ..addAll(liveData);
          },
        );
      }

      if (errorMessage != null) {
        emit(ErrorState(
          errorMessage!,
          errorType: ErrorType.matches,
          retryAction: () => add(GetUpcomingDataEvent(event.league)),
        ));
      } else {
        _updateCache(requestKey, {
          'upcoming': List<FixtureData>.from(upcomingMatches),
          'live': List<FixtureData>.from(liveMatches),
        });
        emit(GetUpComingData());
      }
    } on TimeoutException {
      emit(ErrorState(
        'Request timeout. Please try again.',
        errorType: ErrorType.matches,
        retryAction: () => add(GetUpcomingDataEvent(event.league)),
      ));
    } catch (e) {
      emit(ErrorState(
        'Error fetching match data: ${e.toString()}',
        errorType: ErrorType.matches,
        retryAction: () => add(GetUpcomingDataEvent(event.league)),
      ));
    } finally {
      _activeRequests.remove(requestKey);
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> _onGetLiveMatch(
      GetLiveMatchEvent event,
      Emitter<LeagueState> emit,
      ) async {
    final requestKey = 'live_${event.league}';

    if (_activeRequests.containsKey(requestKey)) {
      await _activeRequests[requestKey]!.completer.future;
      return;
    }

    // Live matches should have short cache
    if (_isCacheValid(requestKey, _liveMatchCacheDuration)) {
      final cachedData = _cache[requestKey]?.data as List<FixtureData>?;
      if (cachedData != null) {
        liveMatches
          ..clear()
          ..addAll(cachedData);
        emit(GetLiveData());
        return;
      }
    }

    await _executeRequest<List<FixtureData>>(
      requestKey: requestKey,
      emit: emit,
      loadingState: LoadingState(loadingType: LoadingType.liveMatches),
      errorType: ErrorType.liveMatches,
      retryEvent: GetLiveMatchEvent(event.league),
      apiCall: () => _getLiveMatchesUseCase.call(event.league),
      onSuccess: (data) {
        liveMatches
          ..clear()
          ..addAll(data);
        _updateCache(requestKey, data);
        emit(GetLiveData());
      },
    );
  }

  Future<void> _onGetAllMatchesData(
      GetAllMatchesDataEvent event,
      Emitter<LeagueState> emit,
      ) async {
    final requestKey = 'all_matches_${event.league}';

    if (_activeRequests.containsKey(requestKey)) {
      await _activeRequests[requestKey]!.completer.future;
      return;
    }

    if (_isCacheValid(requestKey, _matchesCacheDuration)) {
      final cachedData = _cache[requestKey]?.data as List<FixtureData>?;
      if (cachedData != null) {
        allMatches
          ..clear()
          ..addAll(cachedData);
        emit(GetAllMatches());
        return;
      }
    }

    await _executeRequest<List<FixtureData>>(
      requestKey: requestKey,
      emit: emit,
      loadingState: LoadingState(loadingType: LoadingType.allMatches),
      errorType: ErrorType.allMatches,
      retryEvent: GetAllMatchesDataEvent(event.league),
      apiCall: () => _getAllMatchesUseCase.call(event.league),
      onSuccess: (data) {
        // Sort by date
        data.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));

        allMatches
          ..clear()
          ..addAll(data);
        _updateCache(requestKey, data);
        emit(GetAllMatches());
      },
    );
  }

  Future<void> _onFetchLiveMatchData(
      FetchLiveMatchDataEvent event,
      Emitter<LeagueState> emit,
      ) async {
    final requestKey = 'live_match_${event.fixtureData.fixture.id}';

    if (_activeRequests.containsKey(requestKey)) {
      await _activeRequests[requestKey]!.completer.future;
      return;
    }

    await _executeRequest<LiveMatchData>(
      requestKey: requestKey,
      emit: emit,
      loadingState: LoadingState(loadingType: LoadingType.liveMatchData),
      errorType: ErrorType.liveMatchData,
      retryEvent: FetchLiveMatchDataEvent(event.fixtureData),
      apiCall: () => _fetchLiveMatchesDataUseCase.call(event.fixtureData.fixture.id),
      onSuccess: (data) {
        lmd = data;
        receivedData = true;
        tabIndex = tabController.index;
        emit(GetLiveMatchData());
      },
    );
  }

  Future<void> _onRefreshData(
      RefreshDataEvent event,
      Emitter<LeagueState> emit,
      ) async {
    _clearLeagueCache(event.league);

    switch (event.dataType) {
      case DataType.table:
        add(GetTableDataEvent(event.league));
        break;
      case DataType.goals:
        add(GetGoalsDataEvent(event.league));
        break;
      case DataType.matches:
        add(GetUpcomingDataEvent(event.league));
        break;
      case DataType.allMatches:
        add(GetAllMatchesDataEvent(event.league));
        break;
      case DataType.all:
      // Batch refresh
        add(GetTableDataEvent(event.league));
        add(GetGoalsDataEvent(event.league));
        add(GetUpcomingDataEvent(event.league));
        add(GetAllMatchesDataEvent(event.league));
        break;
    }
  }

  void _onClearCache(ClearCacheEvent event, Emitter<LeagueState> emit) {
    _cache.clear();
    emit(CacheCleared());
  }

  // Generic request executor to reduce code duplication
  Future<void> _executeRequest<T>({
    required String requestKey,
    required Emitter<LeagueState> emit,
    required LeagueState loadingState,
    required ErrorType errorType,
    required LeagueEvent retryEvent,
    required Future<dynamic> Function() apiCall,
    required void Function(T data) onSuccess,
  }) async {
    final completer = Completer<void>();
    _activeRequests[requestKey] = _RequestInfo(
      completer: completer,
      timestamp: DateTime.now(),
    );

    try {
      emit(loadingState);

      final result = await apiCall().timeout(_requestTimeout);

      await result.fold(
            (failure) async {
          emit(ErrorState(
            failure.message,
            errorType: errorType,
            retryAction: () => add(retryEvent),
          ));
        },
            (data) async {
          onSuccess(data as T);
        },
      );
    } on TimeoutException {
      emit(ErrorState(
        'Request timeout. Please try again.',
        errorType: errorType,
        retryAction: () => add(retryEvent),
      ));
    } catch (e) {
      emit(ErrorState(
        'Unexpected error: ${e.toString()}',
        errorType: errorType,
        retryAction: () => add(retryEvent),
      ));
    } finally {
      _activeRequests.remove(requestKey);
      if (!completer.isCompleted) completer.complete();
    }
  }

  // Helper methods
  void onTap(int idx) => add(SelectIndexEvent(idx));
  void getTableData(String league) => add(GetTableDataEvent(league));
  void getGoalsData(String league) => add(GetGoalsDataEvent(league));
  void getUpcomingData(String league) => add(GetUpcomingDataEvent(league));
  void getAllMatchesData(String league) => add(GetAllMatchesDataEvent(league));
  void fetchData(FixtureData data) => add(FetchLiveMatchDataEvent(data));
  void refreshData(String league, {DataType dataType = DataType.all}) =>
      add(RefreshDataEvent(league, dataType));
  void clearCache() => add(ClearCacheEvent());
  void clearAllData() => add(ClearAllDataEvent());
  void changeLeague(String newLeague) => add(ChangeLeagueEvent(newLeague));

  List<String> giveString(String s) => s.split(RegExp(r"(?=[A-Z])"));

  bool _isCacheValid(String key, Duration maxAge) {
    final cached = _cache[key];
    if (cached == null) return false;

    final age = DateTime.now().difference(cached.timestamp);
    if (age > maxAge) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  void _updateCache(String key, dynamic data) {
    // LRU cache eviction
    if (_cache.length >= _maxCacheSize) {
      final oldestKey = _cache.entries
          .reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      _cache.remove(oldestKey);
    }

    _cache[key] = CachedData(
      data: data,
      timestamp: DateTime.now(),
    );
  }

  void _clearLeagueCache(String league) {
    _cache.removeWhere((key, _) => key.contains(league));
  }

  void _cancelLeagueRequests(String league) {
    final keysToCancel = _activeRequests.keys
        .where((key) => key.contains(league))
        .toList();

    for (final key in keysToCancel) {
      final requestInfo = _activeRequests[key];
      if (requestInfo != null && !requestInfo.completer.isCompleted) {
        requestInfo.completer.complete();
      }
      _activeRequests.remove(key);
    }
  }

  @override
  Future<void> close() {
    // Complete all pending requests
    for (final requestInfo in _activeRequests.values) {
      if (!requestInfo.completer.isCompleted) {
        requestInfo.completer.complete();
      }
    }
    _activeRequests.clear();
    _cache.clear();

    return super.close();
  }
}

// Helper class for request tracking
class _RequestInfo {
  final Completer<void> completer;
  final DateTime timestamp;

  _RequestInfo({
    required this.completer,
    required this.timestamp,
  });
}

// Cache data wrapper
class CachedData {
  final dynamic data;
  final DateTime timestamp;

  CachedData({
    required this.data,
    required this.timestamp,
  });
}