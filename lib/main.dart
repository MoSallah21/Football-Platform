import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/splash_screen/splash_screen.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/features/prediction/presentation/bloc/predict_bloc.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/modules/league/state_management/leagues_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'core/bloc_observer.dart';
import 'core/cache/cache_helper.dart';
import 'injection_container.dart'as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize necessary components
  await CacheHelper.init();
  await Firebase.initializeApp();
  await PackageInfo.fromPlatform();
  await di.init();
  Bloc.observer = MyBlocObserver();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => LeagueCubit()),
        BlocProvider(create: (_)=>di.sl<QuizBloc>()),
        BlocProvider(create: (_)=>di.sl<PredictBloc>()),
        BlocProvider(create: (_)=>di.sl<BlogBloc>()..add(GetAllBlogsEvent())),
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
