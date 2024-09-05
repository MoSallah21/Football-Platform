import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/question_model/model.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(AppInitState());

  static AboutCubit get(context) => BlocProvider.of(context);
int index=0;
  //get question from firebase
  Stream<List<QuestionModel>> getQuestion({required int level}) {
    return FirebaseFirestore.instance
        .collection('questions')
        .where('level', isEqualTo: level)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => QuestionModel.fromJson(doc.data()))
          .toList();
    });
  }

  late int currentTime;
  late Timer timer;
  int currentIndex = 0;
  String selectedAnswer = '';
  int score = 0;
  void selectAnswer(String answer) {
    selectedAnswer = answer;
    emit(SelectAnswer());
  }

  void nextQuestion() {
    currentIndex++;
    selectedAnswer = '';
    emit(SelectAnswer());
  }

  void timerLess() {
    currentTime -= 1;
    emit(TimerLess());
  }
}
