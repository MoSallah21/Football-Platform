import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/layout/league_view/league_view.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:glass/glass.dart';

class HomeLeague extends StatelessWidget {
  const HomeLeague({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeagueCubit, LeagueState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = LeagueCubit.get(context);
        List<String> codes = ['39', '140', '135', '78', '61'];
        List<String> titles = [
          'الانكليزي الممتاز',
          'الاسباني',
          'الايطالي',
          'الالماني',
          'الفرنسي'
        ];
        List<String> paths = [
          'assets/images/pre.png',
          'assets/images/liga.png',
          'assets/images/seriea.png',
          'assets/images/bundesliga.png',
          'assets/images/Ligue1.png'
        ];
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BackGround(
              img: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 50),
                child: Column(
                  children: [
                    Text('الدوريات الاروبية',style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors
                                .purple, // Change to the desired purple color
                            offset: Offset(2,
                                1), // Adjust the offset based on your preference
                            blurRadius:
                            2, // Adjust the blur radius based on your preference
                          ),
                        ])),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 1.0,
                        children: List.generate(titles.length, (index) {
                          return buildGrid(
                              cubit, index, context, titles, paths, codes);
                        }),
                        shrinkWrap: false,
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                  ],
                ),
              ).asGlass(
                enabled: true,
                tintColor: Colors.transparent,
                clipBorderRadius: BorderRadius.circular(15.0),

              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildGrid(LeagueCubit cubit, int index, BuildContext context,
    List titles, List image, List codes) =>
    Column(children: [
      InkWell(
        onTap: () {
          navigateToWithPush(context, LeagueView(league: codes[index]));
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Image.asset(image[index]),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Center(
            child: Text(
              titles[index],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ]);