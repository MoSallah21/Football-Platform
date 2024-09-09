import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/prediction/presentation/pages/pick_team_page.dart';
import 'package:football_platform/features/quiz/presentation/pages/about_football_page.dart';
import 'package:football_platform/modules/league/league_home/league_home.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:football_platform/modules/tactical_board/board_screen/board_screen.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeagueCubit, LeagueState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = LeagueCubit.get(context);
        List<String> titles = [
          'Leagues',
          'Prediction Of Premier League Match',
          'About Football',
          'Tactics board',
        ];
        List<String> images = [
          'assets/images/league.png',
          'assets/images/cup.png',
          'assets/images/football_86.png',
          'assets/images/tactical 1.png',
        ];
        List<Widget> pages = [
          HomeLeague(),
          PickTeamPage(mode: 1),
          AboutFootBallPage(),
          Board(),
        ];
        return Scaffold(
          body: SizedBox.expand(
            child: BackGround(
              img: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40, top: 50),
                      child: Text(
                        'Mo Football Platform',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          shadows: [
                            Shadow(
                              color: Colors.purple,
                              offset: Offset(2, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30.0,
                          crossAxisSpacing: 15.0,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: titles.length,
                        itemBuilder: (context, index) {
                          return buildGridItem(
                            context,
                            cubit,
                            index,
                            titles,
                            images,
                            pages,
                          );
                        },
                        shrinkWrap: false,
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGridItem(
      BuildContext context,
      LeagueCubit cubit,
      int index,
      List<String> titles,
      List<String> images,
      List<Widget> pages,
      ) {
    return InkWell(
      onTap: () {
        cubit.index = index;
        navigateTo(context, pages[index]);
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Image.asset(images[index]),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Center(
              child: Text(
                titles[index],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
