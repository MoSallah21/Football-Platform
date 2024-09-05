import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/game/domain/entities/question.dart';
import 'package:football_platform/features/game/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/features/game/presentation/pages/choose_level_page.dart';
import 'package:football_platform/features/game/presentation/pages/questions_page.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:hexcolor/hexcolor.dart';


class QuizHomePage extends StatelessWidget {
  final int level;

  const QuizHomePage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        // No actions needed in listener in this case
      },
      builder: (context, state) {
        // Only dispatch event if not in loading state and questions are not available
        if (state is GetAllQuestionsErrorState) {
          BlocProvider.of<QuizBloc>(context).add(GetAllQuestionsEvent(level: level));
        }

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
