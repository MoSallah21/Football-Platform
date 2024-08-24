import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:hexcolor/hexcolor.dart';

class TableView extends StatefulWidget {
  final String league;
  const TableView({super.key, required this.league});

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final LeagueCubit cubit = LeagueCubit();
  @override
  void initState() {
    super.initState();
    if (cubit.dataTable.isEmpty) cubit.getTableData(widget.league);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(
      bloc: cubit,
      builder: (BuildContext context, Object? state) {
        return Container(
            child: cubit.dataTable.length == 0
                ? Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  )
                : SizedBox.expand(
                    child: Container(
                      color: HexColor('#202124'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                child: Center(
                                    child: Text(
                                  'Pos',
                                  style: TextStyle(
                                    color: Color(0xFFeb67e5),
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                            1.5, // Adjust the blur radius based on your preference
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: 150,
                                child: Center(
                                    child: Text(
                                  'Club',
                                  style: TextStyle(
                                    color: Color(0xFFeb67e5),
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                            1.5, // Adjust the blur radius based on your preference
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: 40,
                                child: Center(
                                    child: Text(
                                  'MP',
                                  style: TextStyle(
                                    color: Color(0xFFeb67e5),
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                            1.5, // Adjust the blur radius based on your preference
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: 40,
                                child: Center(
                                    child: Text(
                                  'GD',
                                  style: TextStyle(
                                    color: Color(0xFFeb67e5),
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey,
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                            1.5, // Adjust the blur radius based on your preference
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                width: 40,
                                child: Center(
                                    child: Text(
                                  'Pts',
                                  style: TextStyle(
                                    color: Color(0xFFeb67e5),

                                    shadows: [
                                      Shadow(
                                        color: Colors.grey,
                                        offset: Offset(1,
                                            1), // Adjust the offset based on your preference
                                        blurRadius:
                                            1.5, // Adjust the blur radius based on your preference
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              child: buildTable(cubit),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ));
      },
    );
  }

  Widget buildTable(LeagueCubit cubit) {
    List<Widget> list = [];
    for (int i = 0; i < cubit.dataTable.length; i++) {
      list.add(Container(
          height: 80,
          color: HexColor('#202124'),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                  width: 40,
                  child: Center(
                      child: Text(
                    cubit.dataTable[i].rank.toString(),
                    style: TextStyle(
                      color: Colors.white,
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
                    ),
                  )),
                ),
                Container(
                  width: 150,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        cubit.dataTable[i].team.logo,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        cubit.dataTable[i].team.name,
                        style: TextStyle(
                          color: Colors.white,
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
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  width: 40,
                  child: Center(
                      child: Text(cubit.dataTable[i].all.played.toString(),
                          style: TextStyle(
                            color: Colors.white,
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
                Container(
                  width: 40,
                  child: Center(
                      child: Text(cubit.dataTable[i].goalsDiff.toString(),
                          style: TextStyle(
                            color: Colors.white,
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
                SizedBox(
                  width: 50,
                ),
                Container(
                  width: 40,
                  child: Center(
                      child: Text(cubit.dataTable[i].points.toString(),
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
                                    2, // Adjust the blur radius based on your preference
                              ),
                            ],
                          )
                      )),
                )
              ]),
              if (cubit.dataTable[i].rank == 1)
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.green,
                        Colors.purple,
                      ],
                      stops: [
                        0.0,
                        0.5,
                        1.0
                      ], // Stops to define color positions (0.0 = beginning, 0.5 = middle, 1.0 = end)
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              if (cubit.dataTable[i].rank == 4)
                Container(
                  width: double.infinity,
                  color: HexColor('#3562A6'),
                  height:1,
                ),
              if (cubit.dataTable[i].rank == 5)
                Container(
                  width: double.infinity,
                  color: Colors.orange,
                  height: 1,
                ),
              if (cubit.dataTable[i].rank == cubit.dataTable.length-3)
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  height: 1,
                ),
            ],
          )));
    }
    return Column(
      children: list,
    );
  }
}
