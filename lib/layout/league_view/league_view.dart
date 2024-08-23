import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:football_platform/modules/league/bottom_navigation/fixtuer_view.dart';
import 'package:football_platform/modules/league/bottom_navigation/table_view.dart';
import 'package:football_platform/modules/league/bottom_navigation/toppers_view.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:hexcolor/hexcolor.dart';

class LeagueView extends StatefulWidget {
  final String league;
  const LeagueView({Key? key, required this.league}) : super(key: key);

  @override
  State<LeagueView> createState() => LeagueViewState();
}

class LeagueViewState extends State<LeagueView> {
  final LeagueCubit cubit = LeagueCubit();

  @override
  void initState() {
    cubit.selectedItem = 0;
    cubit.league = widget.league;
    cubit.pages.add(FixturesView(league: cubit.league));
    cubit.pages.add(TableView(league: cubit.league));
    cubit.pages.add(TopInLeagueView(league: cubit.league));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(
      bloc: cubit,
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          backgroundColor: HexColor('#202124'),
        appBar:cubit.selectedItem!=0? AppBar(
          backgroundColor:HexColor('#202124') ,
          elevation: 0,
          automaticallyImplyLeading:false,

          title: Text('${cubit.titles[cubit.selectedItem]}',
            style: TextStyle(color: Colors.white,
              fontSize: 20,
              shadows: [
                Shadow(
                  color: Colors
                      .purple, // Change to the desired purple color
                  offset: Offset(2,
                      1),
                  blurRadius:
                  2,
                ),
              ]),)
          ,):null,

        body: cubit.pages.elementAt(cubit.selectedItem),
                bottomNavigationBar: SnakeNavigationBar.color(
                snakeViewColor: Colors.purple.shade100,
                unselectedItemColor: Colors.purple.shade100,
                 snakeShape:SnakeShape.indicator,
        behaviour:SnakeBarBehaviour.floating ,
            backgroundColor:HexColor('#202124'),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            elevation: 0,
            currentIndex: cubit.selectedItem,
            onTap: (index) {
              cubit.onTap(index);
            },
            items: [
            BottomNavigationBarItem(icon: Icon(Icons.tab,), label: 'Statistics'),
            BottomNavigationBarItem(icon: Icon(Icons.compare), label: 'Standings'),
            BottomNavigationBarItem(icon: Icon(Icons.score), label: 'Top scorer '),

                ],

        ),
        );
      },
    );
  }
}
