import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/league_models/fixture_data.dart';
import 'package:football_platform/modules/league/all_matchs/all_matches.dart';
import 'package:football_platform/modules/league/live_match/live_match_view.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:hexcolor/hexcolor.dart';

class FixturesView extends StatefulWidget {
  final String league;
  const FixturesView({super.key, required this.league});

  @override
  State<FixturesView> createState() => FixturesViewState();
}

class FixturesViewState extends State<FixturesView> {
  final LeagueCubit cubit = LeagueCubit();
  @override
  void initState() {
    cubit.getUpcomingData(widget.league);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(
      bloc: cubit,
      builder: (BuildContext context, Object? state) {
        return SafeArea(
          child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  color: HexColor('#202124'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "مباريات تلعب الان",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .purple, // Change to the desired purple color
                                offset: Offset(2,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                2, // Adjust the blur radius based on your preference
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height/3.5,
                          width: MediaQuery.of(context).size.width,
                          child: cubit.upcomingMatches.isEmpty
                              ? Center(
                                  child: Text("لايوجد مباريات تلعب الان",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.white),),
                                )
                              : cubit.liveMatches.isEmpty
                                  ? Center(
                                      child: const Text(
                                        "لايوجد مباريات الان",
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 25,
                                        shadows: [
                                          Shadow(
                                            color: Colors
                                                .purple, // Change to the desired purple color
                                            offset: Offset(1,
                                                1), // Adjust the offset based on your preference
                                            blurRadius:
                                            1, // Adjust the blur radius based on your preference
                                          ),
                                        ],
                                      ),
                                      ),
                                    )
                                  : CarouselSlider.builder(
                                      itemCount: cubit.liveMatches.length,
                                      itemBuilder: (_, idx, p) {
                                        return buildLiveMatchWidget(
                                            idx, cubit.liveMatches[idx]);
                                      },
                              options: CarouselOptions(
                                enableInfiniteScroll: cubit.liveMatches.length > 1,  // Disable infinite scroll if there's only one element
                              ),
                                    )),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "المباريات القادمة",
                              style: TextStyle(
                                fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purple, // Change to the desired purple color
                                      offset: Offset(1,
                                          1), // Adjust the offset based on your preference
                                      blurRadius:
                                      1, // Adjust the blur radius based on your preference
                                    ),
                                  ]
                              ),
                            ),
                            InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "مشاهدة الكل",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors
                                                .purple, // Change to the desired purple color
                                            offset: Offset(1,
                                                1), // Adjust the offset based on your preference
                                            blurRadius:
                                            5, // Adjust the blur radius based on your preference
                                          ),
                                        ]
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 20,
                                    color: Color(0xffFE2B84),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllMatches(
                                              league: widget.league,
                                            )));
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: cubit.upcomingMatches.isEmpty
                              ? const Center(child: Text("لايوجد مباريات قادمة",style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: cubit.upcomingMatches.length,
                                  itemBuilder: (context, idx) {
                                    return buildUpcomingTile(
                                        cubit.upcomingMatches[idx], cubit);
                                  }))
                    ],
                  )
              ),
        );

      },
    );
  }

  Widget buildLiveMatchWidget(int idx, FixtureData fixed) {
    return InkWell(
      onTap: () {
        navigateToWithSlide(context, LiveMatchDetails(fixd: fixed));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 50, 6, 56),
          gradient: const LinearGradient(
              colors: [ Color(0xFF38002B),
                Color(0xFF390A3A),
                Color(0xFF472954),]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              fixed.league.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text("الجولة - " + fixed.league.round.substring(17),
                style: TextStyle(color: Colors.white, fontSize: 12)),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.network(
                      fixed.teams.home.logo,
                      width: 75,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(fixed.teams.home.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('مضيف',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        fixed.goals.home.toString() +
                            " : " +
                            fixed.goals.away.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffFE2B84)),
                        borderRadius: BorderRadius.circular(5),
                        //color: Color(0xffFE2B84).withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                            fixed.fixture.statue.elapsed.toString() + '\'',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Image.network(
                      fixed.teams.away.logo,
                      width: 75,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(fixed.teams.away.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('ضيف',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget buildUpcomingTile(FixtureData data, LeagueCubit cubit) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 75,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.shade700,Colors.blue.shade500],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
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
                                  .purpleAccent, // Change to the desired purple color
                              offset: Offset(1,
                                  1), // Adjust the offset based on your preference
                              blurRadius:
                              1, // Adjust the blur radius based on your preference
                            ),
                          ],

                        ),
                      ),
                    ),
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
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.fixture.date.substring(11, 16),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(data.fixture.date.substring(0, 10),style: TextStyle(color: Colors.black),),
                  ],
                ),
              ),
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
                                  .purpleAccent, // Change to the desired purple color
                              offset: Offset(1,
                                  1), // Adjust the offset based on your preference
                              blurRadius:
                              1, // Adjust the blur radius based on your preference
                            ),
                          ],

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
