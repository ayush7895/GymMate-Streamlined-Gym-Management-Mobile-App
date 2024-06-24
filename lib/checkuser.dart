import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/nav_bar.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, navigate to the NavBar screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const NavBar()));
      });
    } else {
      // No user is logged in, navigate to the Login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginP()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the async operation is happening
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
