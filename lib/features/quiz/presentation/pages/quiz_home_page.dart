import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/features/quiz/presentation/pages/choose_level_page.dart';
import 'package:football_platform/features/quiz/presentation/pages/questions_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/core/componants/background.dart';
import 'package:hexcolor/hexcolor.dart';


class QuizHomePage extends StatelessWidget {
  final int level;

  const QuizHomePage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<QuizBloc>(context).add(GetAllQuestionsEvent(level: level));
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        List<Text> levels = [
          Text(
            'Easy',
            style: _textStyle(),
          ),
          Text(
            'Medium',
            style: _textStyle(),
          ),
          Text(
            'Hard',
            style: _textStyle(),
          ),
        ];

        return Scaffold(
          backgroundColor: HexColor('#202124'),
          body: BackGround(
            img: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  children: [
                    Text(
                      'Q/A Game',
                      style: _textStyle(fontSize: 40),
                    ),
                    levels[level - 1], // Display the correct level label
                    SizedBox(height: 40),
                    if (state is GetAllQuestionsLoadingState)
                      Center(child: CircularProgressIndicator(color: Colors.purple)),
                    if (state is GetAllQuestionsErrorState)
                      Center(child: Text('Error: ${state.message}', style: _textStyle())),
                    if (state is GetAllQuestionsSuccessState)
                      _buildQuestionsSection(context, state.questions),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _textStyle({double fontSize = 16}) {
    return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      shadows: [
        Shadow(
          color: Colors.purple,
          offset: Offset(2, 1),
          blurRadius: 2,
        ),
      ],
    );
  }

  Widget _buildQuestionsSection(BuildContext context, List<Question> questions) {
    return Column(
      children: [
        actionButton(
          title: 'Start',
          buttonColor: Colors.purple,
          onTap: () {
            if (questions.isNotEmpty) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: BlocProvider.of<QuizBloc>(context),
                  child: QuestionsPage(questions: questions, totalTime: level),
                ),
              ));
            }
          },
        ),
        SizedBox(height: 20),
        actionButton(
          title: 'Back',
          buttonColor: Colors.redAccent,
          onTap: () {
            navigateTo(context, ChooseLevelPage());
          },
        ),
        SizedBox(height: 20),
        Text(
          'Total questions: ${questions.length}',
          style: _textStyle(fontSize: 16),
        ),
      ],
    );
  }
}

