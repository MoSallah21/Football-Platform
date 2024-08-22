import 'package:flutter/material.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late PackageInfo packageInfo;
  String? appVersion;
  late String version;
  double _opacity = 0;
  Future<void> _getVersionFromApp() async {
    packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }
  @override
  void initState() {
    super.initState();
    _getVersionFromApp();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackGround(
          img: 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LottieBuilder.asset(
                  'assets/lottie/splash_ball.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 5),
                  child: Column(
                    children: [
                      Text(
                        "Football Platform",
                        style: GoogleFonts.getFont(
                          'Caveat',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            shadows: [
                              Shadow(
                                color: Colors.purple,
                                offset: Offset(1, 1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Version: $appVersion",
                        style:GoogleFonts.getFont('Caveat',

                        textStyle:TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                color: Colors
                                    .white,
                                offset: Offset(1,
                                    1),
                                blurRadius:
                                5,
                              ),
                            ]
                        ), )



                      ),
                    ],
                  ),
                  onEnd: () {
                    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => HomeScreen()));

                  },
                ),
              ],
            ),
          ),
        ));
  }
}