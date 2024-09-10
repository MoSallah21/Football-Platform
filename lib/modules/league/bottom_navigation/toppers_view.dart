import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';

class TopInLeagueView extends StatefulWidget {
  final String league;
  const TopInLeagueView({super.key, required this.league});

  @override
  State<TopInLeagueView> createState() => _TopInLeagueViewState();
}

class _TopInLeagueViewState extends State<TopInLeagueView> {
  final LeagueCubit cubit = LeagueCubit();
  @override
  void initState() {
    cubit.getGoalsData(widget.league);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(
      bloc: cubit,
      builder: (BuildContext context, Object? state) {
        return Column(children: [
          Expanded(
            child: cubit.goals.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Colors.purple,))
                : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                      margin: const EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '1',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffFE2B84),shadows: [
                                  Shadow(
                                    color: Colors
                                        .purple, // Change to the desired purple color
                                    offset: Offset(1,
                                        1), // Adjust the offset based on your preference
                                    blurRadius:
                                    1, // Adjust the blur radius based on your preference
                                  ),
                                ]),
                              ),
                              Text(cubit.goals[0].player.name,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              Text(cubit.goals[0].stats.team.name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  cubit.goals[0].stats.goals.total
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Color(0xffFE2B84),shadows: [
                                    Shadow(
                                      color: Colors
                                          .purple, // Change to the desired purple color
                                      offset: Offset(1,
                                          1), // Adjust the offset based on your preference
                                      blurRadius:
                                      1, // Adjust the blur radius based on your preference
                                    ),
                                  ]))
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                                cubit.goals[0].player.image),
                          ),
                        ],
                      )),
                  const Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text("POS",
                                  style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,shadows: [
                                    Shadow(
                                      color: Colors
                                          .purple, // Change to the desired purple color
                                      offset: Offset(1,
                                          1), // Adjust the offset based on your preference
                                      blurRadius:
                                      1, // Adjust the blur radius based on your preference
                                    ),
                                  ])))),
                      Expanded(
                          flex: 3,
                          child: Center(
                              child: Text("PL",
                                  style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,shadows: [
                                    Shadow(
                                      color: Colors
                                          .purple, // Change to the desired purple color
                                      offset: Offset(1,
                                          1), // Adjust the offset based on your preference
                                      blurRadius:
                                      1, // Adjust the blur radius based on your preference
                                    ),
                                  ])))),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text("Club",
                                  style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,shadows: [
                                    Shadow(
                                      color: Colors
                                          .purple, // Change to the desired purple color
                                      offset: Offset(1,
                                          1), // Adjust the offset based on your preference
                                      blurRadius:
                                      1, // Adjust the blur radius based on your preference
                                    ),
                                  ])))),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text("G",
                                  style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,shadows: [
                                    Shadow(
                                      color: Colors
                                          .purple, // Change to the desired purple color
                                      offset: Offset(1,
                                          1), // Adjust the offset based on your preference
                                      blurRadius:
                                      1, // Adjust the blur radius based on your preference
                                    ),
                                  ])))),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cubit.goals.length - 1,
                      itemBuilder: (context, idx) {
                        return buildTile(idx + 1, cubit);
                      })
                ],
              ),
            )
            // )
            ,
          )
        ]);
      },
    );
  }

  Widget buildTile(int idx, LeagueCubit cubit) {
    PlayerStats data = cubit.goals[idx];
    return SizedBox(
        height: 75,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                  child: Text((idx + 1).toString(),
                      style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors
                                .purple, // Change to the desired purple color
                            offset: Offset(1,
                                1), // Adjust the offset based on your preference
                            blurRadius:
                            2, // Adjust the blur radius based on your preference
                          ),
                        ],


                      ))),
            ),
            Expanded(
              flex: 3,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.network(data.player.image, width: 50, fit: BoxFit.cover),
                SizedBox(
                  width: 10,
                ),
                Text(
                  data.player.name,
                  style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,                          shadows: [
                    Shadow(
                      color: Colors
                          .purple, // Change to the desired purple color
                      offset: Offset(1,
                          1), // Adjust the offset based on your preference
                      blurRadius:
                      2, // Adjust the blur radius based on your preference
                    ),
                  ],),
                ),
              ]),
            ),
            Expanded(
              flex: 1,
              child:
                  Center(child: Image.network(data.stats.team.logo, width: 35)),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: Text(data.stats.goals.total.toString(),
                      style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors
                                  .purple, // Change to the desired purple color
                              offset: Offset(1,
                                  1), // Adjust the offset based on your preference
                              blurRadius:
                              2, // Adjust the blur radius based on your preference
                            ),
                          ],))),
            ),
          ],
        ));
  }
}
