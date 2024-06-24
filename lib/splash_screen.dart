import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/checkuser.dart'; // Correct the file name if necessary
import 'package:flutter_application_1/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xtreme app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen1(),
    );
  }
}

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    preloadAppData().then((_) {
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(_createRoute());
      });
    });
  }

  Future<void> preloadAppData() async {
    // Simulate preloading data
    await Future.delayed(Duration(seconds: 2)); // Simulating delay
    // Add your initialization logic here (like loading user data, config, etc.)
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  SplashScreen2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          child: Image.asset(
            'assets/Image1 (1).png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const CheckUser()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Image.asset(
                'assets/Image1 (1).png',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
            ),
            Image.asset("assets/GymMate-01-01-01-01.png"),
          ],
        ),
      ),
    );
  }
}
