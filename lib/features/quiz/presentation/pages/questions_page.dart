import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/features/quiz/presentation/pages/result_page.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:hexcolor/hexcolor.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key, required this.questions, required this.totalTime });
  final List<Question> questions;
  final int totalTime;

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Timer timer;
  late int time;

  @override
  void initState() {
    super.initState();

    time = context.read<QuizBloc>().currentTime;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final bloc = context.read<QuizBloc>();

      if (bloc.currentTime > 0) {
        bloc.add(TimerTickEvent());
      } else {
        timer.cancel();
        _navigateToResultScreen();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _navigateToResultScreen() {
    final bloc = context.read<QuizBloc>();
    navigateAndFinish(
      context,
      ResultPage(score: bloc.score, questions: widget.questions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (BuildContext context, QuizState state) {
        final bloc = context.read<QuizBloc>();
        if (state is GetAllQuestionsSuccessState || state is TimerTickState) {
          final currentQuestion = widget.questions[bloc.currentIndex];
          return Scaffold(
            body: BackGround(
              img: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    _buildTimer(context),
                    SizedBox(height: 40),
                    _buildQuestionText(currentQuestion.question),
                    SizedBox(height: 10),
                    _buildAnswersList(currentQuestion),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator()); // عرض تحميل في الحالات الأخرى
        }
      },
    );
  }

  Widget _buildTimer(BuildContext context) {
    final bloc = context.read<QuizBloc>();
    return SizedBox(
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: LinearProgressIndicator(
                color: HexColor('#202124'),
                backgroundColor: Colors.purple,
                value: bloc.currentTime / time,
              ),
            ),
            Center(
              child: Text(
                bloc.currentTime.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText(String question) {
    return Text(
      'Question :',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        shadows: [
          Shadow(
            color: Colors.purple,
            offset: Offset(1, 1),
            blurRadius: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersList(Question currentQuestion) {
    return Expanded(
      child: ListView.builder(
        itemCount: currentQuestion.answers!.length,
        itemBuilder: (BuildContext context, int index) {
          final answer = currentQuestion.answers![index];
          final bloc = context.read<QuizBloc>();

          return AnswerTile(
            isSelected: answer == bloc.selectedAnswer,
            answer: answer,
            correctAnswer: currentQuestion.correctAnswer,
            onTap: () {
              bloc.add(SelectAnswerEvent(answer));
              if (answer == currentQuestion.correctAnswer) {
                bloc.score++;
              }
              Future.delayed(Duration(milliseconds: 400), () {
                if (bloc.currentIndex == widget.questions.length - 1) {
                  _navigateToResultScreen();
                } else {
                  bloc.add(NextQuestionEvent());
                }
              });
            },
          );
        },
      ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  final bool isSelected;
  final String answer;
  final String correctAnswer;
  final Function onTap;

  const AnswerTile({
    Key? key,
    required this.isSelected,
    required this.answer,
    required this.correctAnswer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0), // Adjust the radius as needed
      child: Card(
        color: cardColor,
        child: ListTile(
          onTap: () => onTap(),
          title: Text(
            answer,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Color get cardColor {
    if (!isSelected) return Colors.white;

    if (answer == correctAnswer) return Colors.purpleAccent;

    return Colors.redAccent;
  }
}
