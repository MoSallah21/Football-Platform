part of 'predict_bloc.dart';


abstract class PredictState{}

class PredictInitState extends PredictState{}

class PredictResultLoadingState extends PredictState{}

class PredictResultErrorState extends PredictState{
  final String message;

  PredictResultErrorState({required this.message});
}

class PredictResultSuccessState extends PredictState{
  final Map<String, dynamic> result;

  PredictResultSuccessState({required this.result});

}
class SelectHomeTeam extends PredictState{}

class SelectAwayTeam extends PredictState{}




