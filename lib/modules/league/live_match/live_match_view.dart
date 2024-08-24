import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/league_models/fixture_data.dart';
import 'package:football_platform/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:hexcolor/hexcolor.dart';

class LiveMatchDetails extends StatefulWidget {
  final FixtureData fixd;
  const LiveMatchDetails({super.key, required this.fixd});

  @override
  State<LiveMatchDetails> createState() => _LiveMatchDetailsState();
}

class _LiveMatchDetailsState extends State<LiveMatchDetails>
    with TickerProviderStateMixin {
  final LeagueCubit cubit = LeagueCubit();

  @override
  void initState() {
    cubit.fetchData(widget.fixd);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (BuildContext context, Object? state) {
        cubit.tabController =
            TabController(length: 3, vsync: this, initialIndex: cubit.tabIndex);

        return Scaffold(
            backgroundColor: HexColor('#202124'),
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    // padding: EdgeInsets.all(10),
                    height: 215,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 50, 6, 56),
                      gradient: const LinearGradient(
                          colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.fixd.fixture.venue.name,
                          style:  TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
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
                        ),
                        Text(
                          widget.fixd.fixture.venue.city,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Round - " +
                                widget.fixd.league.round.substring(17),
                            style:
                                TextStyle(color: Colors.white, fontSize: 15,)),
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
                                  widget.fixd.teams.home.logo,
                                  width: 75,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(widget.fixd.teams.home.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,

                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Home',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10,shadows: [
                                      Shadow(
                                        color: Colors
                                            .purpleAccent.shade100, // Change to the desired purple color
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                        1, // Adjust the blur radius based on your preference
                                      ),
                                    ],)),
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
                                    widget.fixd.goals.away.toString() +
                                        ":" +
                                        widget.fixd.goals.home.toString(),
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
                                    border:
                                        Border.all(color: Color(0xffFE2B84)),
                                    borderRadius: BorderRadius.circular(5),
                                    //color: Color(0xffFE2B84).withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                        widget.fixd.fixture.statue.elapsed
                                                .toString() +
                                            '\'',
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
                                  widget.fixd.teams.away.logo,
                                  width: 75,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.fixd.teams.away.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Away',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10,shadows: [
                                      Shadow(
                                        color: Colors
                                            .purpleAccent.shade100, // Change to the desired purple color
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                        1, // Adjust the blur radius based on your preference
                                      ),
                                    ],)),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: Colors.deepPurple
                    ),
                    child: Column(children: [
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: TabBar(
                            controller: cubit.tabController,
                            isScrollable: false,
                            labelStyle: TextStyle(color:Colors.white,shadows: [
                            Shadow(
                            color: Colors
                                .purpleAccent.shade100, // Change to the desired purple color
                              offset: Offset(1,
                                  1), // Adjust the offset based on your preference
                              blurRadius:
                              1, // Adjust the blur radius based on your preference
                            ),
                            ] ),
                            automaticIndicatorColorAdjustment: false,
                            unselectedLabelStyle:TextStyle(color:Colors.black,) ,
                            indicator: BoxDecoration(
                              color: Colors.purple.shade500,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tabs: [
                              Tab(text: "Events"),
                              Tab(text: "Statistics"),
                              Tab(text: "lineUp")
                            ]),
                      ),
                      Expanded(
                        child: TabBarView(
                            controller: cubit.tabController,
                            children: [
                              summaryWidget(),
                              statsWidget(),
                              lineUpWidget(),
                            ]),
                      )
                    ]),
                  ))
                ],
              ),
            ));
      },
    );
  }

  Widget summaryWidget() {
    return !(cubit.receivedData)
        ? const Center(
            child: CircularProgressIndicator(color: Colors.purple),
          )
        : cubit.lmd.allEvent.isEmpty
            ? Center(
                child: Text(
                  "Not yet",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
            : ListView(children: listOfEvents(),physics: BouncingScrollPhysics(),);
  }

  Widget statsWidget() {
    return !(cubit.receivedData)
        ?  Center(
            child: CircularProgressIndicator(color: Colors.purple),
          )
        : ListView(
            scrollDirection: Axis.vertical,physics: BouncingScrollPhysics(),
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cubit.lmd.fixStats.home.length,
                  itemBuilder: (_, idx) {
                    return Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cubit.lmd.fixStats.home[idx].value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white,shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1,
                              ),
                            ]),
                          ),
                          Text(
                            cubit.lmd.fixStats.home[idx].label,
                            style: TextStyle(fontSize: 15,color: Colors.white),
                          ),
                          Text(
                            cubit.lmd.fixStats.away[idx].value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white,shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ]),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          );
  }

  Widget lineUpWidget() {
    return !(cubit.receivedData)
        ?  Center(
            child: CircularProgressIndicator(color: Colors.purple),
          )
        : ListView(scrollDirection: Axis.vertical,physics: BouncingScrollPhysics(), children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text("Coach",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                      Shadow(
                        color: Colors
                            .purpleAccent.shade100, // Change to the desired purple color
                        offset: Offset(1,
                            1), // Adjust the offset based on your preference
                        blurRadius:
                        1, // Adjust the blur radius based on your preference
                      ),
                    ],)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Image.network(
                      cubit.lmd.lineUps.home.coach.photo,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: Image.network(
                    cubit.lmd.lineUps.away.coach.photo,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )),
                )
              ],
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        cubit.lmd.lineUps.home.coach.name,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                          Shadow(
                            color: Colors
                                .purpleAccent.shade100, // Change to the desired purple color
                            offset: Offset(1,
                                1), // Adjust the offset based on your preference
                            blurRadius:
                            1, // Adjust the blur radius based on your preference
                          ),
                        ],),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                        child: Text(cubit.lmd.lineUps.away.coach.name,
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ],))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text("lineUp",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                      Shadow(
                        color: Colors
                            .purpleAccent.shade100, // Change to the desired purple color
                        offset: Offset(1,
                            1), // Adjust the offset based on your preference
                        blurRadius:
                        1, // Adjust the blur radius based on your preference
                      ),
                    ],)),
              ),
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(cubit.lmd.lineUps.home.formation,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                            Shadow(
                              color: Colors
                                  .purpleAccent.shade100, // Change to the desired purple color
                              offset: Offset(1,
                                  1), // Adjust the offset based on your preference
                              blurRadius:
                              1, // Adjust the blur radius based on your preference
                            ),
                          ],)),
                    ),
                  ),
                  Expanded(
                    child: Center(
                        child: Text(cubit.lmd.lineUps.away.formation,
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                              Shadow(
                                color: Colors
                                    .purpleAccent.shade100, // Change to the desired purple color
                                offset: Offset(1,
                                    1), // Adjust the offset based on your preference
                                blurRadius:
                                1, // Adjust the blur radius based on your preference
                              ),
                            ],))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text("Main",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                      Shadow(
                        color: Colors
                            .purpleAccent.shade100, // Change to the desired purple color
                        offset: Offset(1,
                            1), // Adjust the offset based on your preference
                        blurRadius:
                        1, // Adjust the blur radius based on your preference
                      ),
                    ],)),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    cubit.lmd.lineUps.home.startAndSub.starteleven.length,
                itemBuilder: (_, idx) {
                  return SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    cubit.lmd.lineUps.home.startAndSub
                                        .starteleven[idx].number
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                                          Shadow(
                                            color: Colors
                                                .purpleAccent.shade100, // Change to the desired purple color
                                            offset: Offset(1,
                                                1), // Adjust the offset based on your preference
                                            blurRadius:
                                            1, // Adjust the blur radius based on your preference
                                          ),
                                        ],)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    cubit.lmd.lineUps.home.startAndSub
                                        .starteleven[idx].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                                          Shadow(
                                            color: Colors
                                                .purpleAccent.shade100, // Change to the desired purple color
                                            offset: Offset(1,
                                                1), // Adjust the offset based on your preference
                                            blurRadius:
                                            1, // Adjust the blur radius based on your preference
                                          ),
                                        ],)),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    cubit.lmd.lineUps.away.startAndSub
                                        .starteleven[idx].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                                          Shadow(
                                            color: Colors
                                                .purpleAccent.shade100, // Change to the desired purple color
                                            offset: Offset(1,
                                                1), // Adjust the offset based on your preference
                                            blurRadius:
                                            1, // Adjust the blur radius based on your preference
                                          ),
                                        ],)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    cubit.lmd.lineUps.away.startAndSub
                                        .starteleven[idx].number
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.white,shadows: [
                                          Shadow(
                                            color: Colors
                                                .purpleAccent.shade100, // Change to the desired purple color
                                            offset: Offset(1,
                                                1), // Adjust the offset based on your preference
                                            blurRadius:
                                            1, // Adjust the blur radius based on your preference
                                          ),
                                        ],)),
                              ],
                            ))
                      ],
                    ),
                  );
                }),
             SizedBox(
              height: 30,
              child: Center(
                child: Text("Rev",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,shadows: [
                      ],)),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min<int>(
                    cubit.lmd.lineUps.away.startAndSub.substitue.length,
                    cubit.lmd.lineUps.home.startAndSub.substitue.length),
                itemBuilder: (_, idx) {
                  return SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    cubit.lmd.lineUps.home.startAndSub
                                        .substitue[idx].number
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    cubit.lmd.lineUps.home.startAndSub
                                        .substitue[idx].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    cubit.lmd.lineUps.away.startAndSub
                                        .substitue[idx].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    cubit.lmd.lineUps.away.startAndSub
                                        .substitue[idx].number
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                              ],
                            ))
                      ],
                    ),
                  );
                })
          ]);
  }

  List<Widget> listOfEvents() {
    List<Widget> curatedList = [];

    for (int i = 0; i < cubit.lmd.allEvent.length; i++) {
      curatedList.add(eventMaker(cubit.lmd.allEvent[i]));
    }
    return curatedList;
  }

  Widget eventMaker(Event event) {
    int home = widget.fixd.teams.home.id;
    String type = event.type;
    switch (type) {
      case "Goal":
        {
          if (event.team.id == home) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 75,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(event.time.time.toString() + "\'",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.player.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 20,
                  ),
                  goal(),
                ],
              ),
            );
          } else
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 75,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.all(5),
              //  margin: EdgeInsets.fromLTRB(0,2.5,0, 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  goal(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.player.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.time.time.toString() + "\'",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            );
        }

      case "Card":
        {
          if (event.team.id == home) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 75,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(event.time.time.toString() + "\'",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.player.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    width: 20,
                  ),
                  event.detail == "Yellow Card" ? yellowCard() : redCard(),
                ],
              ),
            );
          } else
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 75,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.all(5),
              // margin: EdgeInsets.fromLTRB(0,2.5,0, 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  event.detail == "Yellow Card" ? yellowCard() : redCard(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.player.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.time.time.toString() + "\'",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            );
        }

      case "subst":
        {
          if (event.team.id == home) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 75,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.all(5),
              // margin: EdgeInsets.fromLTRB(0,2.5,0, 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(event.time.time.toString() + "\'",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.player.name),
                      Text(event.assist.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  sub(),
                ],
              ),
            );
          } else
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 75,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  sub(),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.player.name),
                      Text(event.assist.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(event.time.time.toString() + "\'",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            );
        }

      default:
        {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 75,

            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  event.time.time.toString() + "'  " + event.type,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  event.detail,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
    }
  }

  Widget goal() {
    return const Icon(
      Icons.sports_soccer,
      size: 25,
    );
  }

  Widget redCard() {
    return Container(
      color: Colors.red,
      height: 20,
      width: 15,
    );
  }

  Widget yellowCard() {
    return Container(
      color: Colors.yellow,
      height: 20,
      width: 15,
    );
  }

  Widget sub() {
    return const Row(children: [
      Icon(
        Icons.arrow_upward,
        color: Colors.green,
        size: 20,
      ),
      Icon(
        Icons.arrow_downward,
        color: Colors.red,
        size: 20,
      )
    ]);
  }
}
