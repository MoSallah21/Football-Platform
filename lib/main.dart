import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/features/game/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:football_platform/modules/splash_screen/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'modules/predict/state_management/predict_cubit.dart';
import 'shared/network/local/remot/cachehelper.dart';
import 'injection_container.dart'as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize necessary components
  await CacheHelper.init();
  await Firebase.initializeApp();
  await PackageInfo.fromPlatform();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => LeagueCubit()),
        BlocProvider(create: (BuildContext context) => AboutCubit()),
        BlocProvider(create: (_)=>di.sl<QuizBloc>()),
        BlocProvider(create: (_)=>di.sl<BlogBloc>()..add(GetAllBlogsEvent())),
        BlocProvider(create: (BuildContext context) => PredictCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple,
          textTheme: GoogleFonts.latoTextTheme(),
          splashColor: Colors.purple,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.purple), // Set thumb color to purple
          ),
        ),
        home: SplashPage(),
      ),
    );
  }
}
