import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/strings/failures.dart';
import 'package:football_platform/features/prediction/data/models/team_prediction_model.dart';
import 'package:football_platform/features/prediction/domain/usecases/predict_result.dart';
import 'package:football_platform/core/utl/items.dart';
import '../../../../core/const/team_constants.dart';
import '../../../../core/const/team_data.dart';

part 'predict_event.dart';
part 'predict_state.dart';

class PredictBloc extends Bloc<PredictEvent, PredictState> {
  static PredictBloc get(context) => BlocProvider.of(context);

  final PredictUseCase predict;

  // Cache MenuItem widgets for better performance
  late final List<MenuItem> _teams;

  // Current prediction model
  late TeamPredictionModel model;

  PredictBloc({required this.predict}) : super(PredictInitState()) {
    // Initialize teams list once
    _teams = _createTeamsList();

    // Initialize empty model
    model = _createEmptyModel();

    on<PredictResultEvent>(_onPredictResult);
    on<SelectHomeTeamEvent>(_onSelectHomeTeam);
    on<SelectAwayTeamEvent>(_onSelectAwayTeam);
  }

  List<MenuItem> get teams => _teams;

  // Handle prediction event
  Future<void> _onPredictResult(
      PredictResultEvent event,
      Emitter<PredictState> emit,
      ) async {
    emit(PredictResultLoadingState());

    final failureOrResult = await predict.call(
      mode: event.mode,
      homeCode: event.homeCode,
      awayCode: event.awayCode,
      homeShootsOn: event.homeShootsOn ?? 0,
      awayShootsOn: event.awayShootsOn ?? 0,
      homeShoots: event.homeShoots ?? 0,
      awayShoots: event.awayShoots ?? 0,
      homePoss: event.homePoss ?? 0,
      awayPoss: event.awayPoss ?? 0,
      homeCorners: event.homeCorners ?? 0,
      awayCorners: event.awayCorners ?? 0,
      homeChances: event.homeChances ?? 0,
      awayChances: event.awayChances ?? 0,
    );

    failureOrResult.fold(
          (failure) => emit(
        PredictResultErrorState(message: _mapFailureToMessage(failure)),
      ),
          (result) => emit(PredictResultSuccessState(result: result)),
    );
  }

  // Handle home team selection
  void _onSelectHomeTeam(
      SelectHomeTeamEvent event,
      Emitter<PredictState> emit,
      ) {
    final teamStats = TeamConstants.homeTeams[event.teamCode];
    if (teamStats != null) {
      _updateModelWithHomeTeam(teamStats);
      emit(SelectHomeTeam());
    }
  }

  // Handle away team selection
  void _onSelectAwayTeam(
      SelectAwayTeamEvent event,
      Emitter<PredictState> emit,
      ) {
    final teamStats = TeamConstants.awayTeams[event.teamCode];
    if (teamStats != null) {
      _updateModelWithAwayTeam(teamStats);
      emit(SelectAwayTeam());
    }
  }

  // Public methods for backwards compatibility
  void onChangedHome(BuildContext context, MenuItem item) {
    add(SelectHomeTeamEvent(teamCode: item.text));
  }

  void onChangedAway(BuildContext context, MenuItem item) {
    add(SelectAwayTeamEvent(teamCode: item.text));
  }

  // Update model with home team stats
  void _updateModelWithHomeTeam(TeamStats stats) {
    model = model.copyWith(
      homeTeam: stats.displayName,
      homeImg: stats.imagePath,
      homeCode: stats.code.toDouble(),
      maxHomePos: stats.maxPos,
      minHomePos: stats.minPos,
      meanHomePos: stats.meanPos,
      maxHomeShoots: stats.maxShoots.toDouble(),
      minHomeShoots: stats.minShoots.toDouble(),
      meanHomeShoots: stats.meanShoots,
      maxHomeCor: stats.maxCor.toDouble(),
      minHomeCor: stats.minCor.toDouble(),
      meanHomeCor: stats.meanCor,
      maxHomeShOnTarget: stats.maxShOnTarget.toDouble(),
      minHomeShOnTarget: stats.minShOnTarget.toDouble(),
      meanHomeShOnTarget: stats.meanShOnTarget,
      maxHomeCh: stats.maxCh.toDouble(),
      minHomeCh: stats.minCh.toDouble(),
      meanHomeCh: stats.meanCh,
    );
  }

  // Update model with away team stats
  void _updateModelWithAwayTeam(TeamStats stats) {
    model = model.copyWith(
      awayTeam: stats.displayName,
      awayImg: stats.imagePath,
      awayCode: stats.code.toDouble(),
      maxAwayPos: stats.maxPos,
      minAwayPos: stats.minPos,
      meanAwayPos: stats.meanPos,
      maxAwayShoots: stats.maxShoots.toDouble(),
      minAwayShoots: stats.minShoots.toDouble(),
      meanAwayShoots: stats.meanShoots,
      maxAwayCor: stats.maxCor.toDouble(),
      minAwayCor: stats.minCor.toDouble(),
      meanAwayCor: stats.meanCor,
      maxAwayShOnTarget: stats.maxShOnTarget.toDouble(),
      minAwayShOnTarget: stats.minShOnTarget.toDouble(),
      meanAwayShOnTarget: stats.meanShOnTarget,
      maxAwayCh: stats.maxCh.toDouble(),
      minAwayCh: stats.minCh.toDouble(),
      meanAwayCh: stats.meanCh,
    );
  }

  // Create teams list (called once)
  List<MenuItem> _createTeamsList() {
    return const [
      MenuItem(
        text: 'MCY',
        icon: Image(
          image: AssetImage('assets/images/clubs/manchester_city.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'LIV',
        icon: Image(
          image: AssetImage('assets/images/clubs/liverpool_fc.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'ARS',
        icon: Image(
          image: AssetImage('assets/images/clubs/arsenal_fc.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'MNU',
        icon: Image(
          image: AssetImage('assets/images/clubs/manchester_united.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'TOT',
        icon: Image(
          image: AssetImage('assets/images/clubs/tottenham_hotspur.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'CHE',
        icon: Image(
          image: AssetImage('assets/images/clubs/chelsea_fc.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'BRI',
        icon: Image(
          image: AssetImage('assets/images/clubs/brighton.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'NSTL',
        icon: Image(
          image: AssetImage('assets/images/clubs/new_castle.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'WST',
        icon: Image(
          image: AssetImage('assets/images/clubs/west_ham_united.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'NOTF',
        icon: Image(
          image: AssetImage('assets/images/clubs/nottingham_forest.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'CRYP',
        icon: Image(
          image: AssetImage('assets/images/clubs/crystal_palace.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'FULH',
        icon: Image(
          image: AssetImage('assets/images/clubs/fulham.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'BRY',
        icon: Image(
          image: AssetImage('assets/images/clubs/burnley.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'WOF',
        icon: Image(
          image: AssetImage('assets/images/clubs/wolverhampton_wanderers.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'BRNT',
        icon: Image(
          image: AssetImage('assets/images/clubs/brentford_fc.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'EVE',
        icon: Image(
          image: AssetImage('assets/images/clubs/everton.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'SHF',
        icon: Image(
          image: AssetImage('assets/images/clubs/sheffield_united.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'BRNO',
        icon: Image(
          image: AssetImage('assets/images/clubs/bournemouth_fc.png'),
          width: 60,
          height: 30,
        ),
      ),
      MenuItem(
        text: 'ASV',
        icon: Image(
          image: AssetImage('assets/images/clubs/aston_villa.png'),
          width: 60,
          height: 30,
        ),
      ),
    ];
  }

  // Create empty model
  TeamPredictionModel _createEmptyModel() {
    return TeamPredictionModel(
      homeTeam: '',
      homeCode: 0.0,
      awayTeam: '',
      awayCode: 0.0,
      homeImg: '',
      awayImg: '',
      homePos: 0.0,
      awayPos: 0.0,
      homeShoots: 0.0,
      awayShoots: 0.0,
      homeCor: 0.0,
      awayCor: 0.0,
      homeShOnTarget: 0.0,
      awayShOnTarget: 0.0,
      homeCh: 0.0,
      awayCh: 0.0,
      minHomePos: 0.0,
      maxHomePos: 0.0,
      meanHomePos: 0.0,
      minAwayPos: 0.0,
      maxAwayPos: 0.0,
      meanAwayPos: 0.0,
      maxHomeShoots: 0.0,
      minHomeShoots: 0.0,
      maxAwayShoots: 0.0,
      meanHomeShoots: 0.0,
      meanAwayShoots: 0.0,
      maxHomeCor: 0.0,
      maxAwayCor: 0.0,
      minHomeCor: 0.0,
      minAwayCor: 0.0,
      meanHomeCor: 0.0,
      meanAwayCor: 0.0,
      maxHomeCh: 0.0,
      minHomeCh: 0.0,
      maxAwayCh: 0.0,
      minAwayCh: 0.0,
      meanHomeCh: 0.0,
      meanAwayCh: 0.0,
      maxAwayShOnTarget: 0.0,
      minAwayShOnTarget: 0.0,
      maxHomeShOnTarget: 0.0,
      minHomeShOnTarget: 0.0,
      meanHomeShOnTarget: 0.0,
      meanAwayShOnTarget: 0.0,
      minAwayShoots: 0.0,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OffLineFailure:
        return OFF_LINE_FAILURE_MESSAGE;
      default:
        return "Unexpected error, please try again later";
    }
  }
}