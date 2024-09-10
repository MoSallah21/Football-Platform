import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/modules/league/bottom_navigation/fixtuer_view.dart';
import 'package:football_platform/modules/league/live_match/live_match_view.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';

class AllMatches extends StatefulWidget {
  final String league;
  const AllMatches({super.key, required this.league});
  @override
  State<AllMatches> createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches> {
  final LeagueCubit cubit = LeagueCubit();
  @override
  void initState() {
    cubit.getAllMatchesData(widget.league);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(
      bloc: cubit,
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#202124'),
            elevation: 0.0,
            title:  Text('All Matches',style:TextStyle(color: Colors.purple.shade200),),
          ),
          backgroundColor: HexColor('#202124'),
          body: cubit.allMatches.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.purple),
                )
              : ListView.builder(
                  itemCount: cubit.allMatches.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return tileBuilder(cubit.allMatches[index]);
                  },
                ),
        );
      },
    );
  }

  Widget tileBuilder(FixtureData data) {
    if (data.fixture.statue.short == "NS")
      return FixturesViewState().buildUpcomingTile(data, cubit);

    return buildDoneTile(data);
  }

  Widget buildDoneTile(FixtureData data) {
    int val = 0;
    if (data.goals.home > data.goals.away) val = 1;
    if (data.goals.home < data.goals.away) val = -1;

    TextStyle norm =  TextStyle(
      fontSize: 20,
      color: Colors.white,
      shadows: [
        Shadow(
          color: Colors
              .purpleAccent.shade100, // Change to the desired purple color
          offset: Offset(1,
              1), // Adjust the offset based on your preference
          blurRadius:
          1, // Adjust the blur radius based on your preference
        ),
      ],

    );
    TextStyle win = const TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: Colors.purpleAccent);

    return InkWell(
      child: Container(

        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        padding: EdgeInsets.all(7),
        height: 75,
        decoration: BoxDecoration(
            color: HexColor('#202124'), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Text(
                          data.teams.home.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ],

                          ),
                        )),
                    SizedBox(
                      width: 2,
                    ),
                    Image.network(
                      data.teams.home.logo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.goals.home.toString(),
                          style: val == 1 ? win : norm,
                        ),
                        SizedBox(width: 7),
                        Text(
                          ":",
                          style: norm,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          data.goals.away.toString(),
                          style: val == -1 ? win : norm,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(data.fixture.statue.short,style: TextStyle(color: Colors.white),),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      data.teams.away.logo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Expanded(
                        child: Text(
                          data.teams.away.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ],

                          ),
                        )),
                  ],
                ))
          ],
        ),
      ),
      onTap: () {
        navigateToWithPush(context, LiveMatchDetails(fixd: data));
      },
    );
  }
}
