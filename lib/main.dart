import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // Initialize Firebase.
  runApp(MainApp()); // Your main app widget.
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen1()
    );
  }
}
