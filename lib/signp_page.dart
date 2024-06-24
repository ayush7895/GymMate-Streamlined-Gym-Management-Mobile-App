import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/nav_bar.dart';
import 'package:flutter_application_1/uihelp.dart';


class SignInP extends StatefulWidget {
  const SignInP({super.key});

  @override
  State<SignInP> createState() => _SignInPState();
}

class _SignInPState extends State<SignInP> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp(String email, String password) async {
    if (email == "" || password == "") {
      UiHelp1.CustomAlertBox(context, "Enter required Fields");
    } else {
      try {
        // Create user and wait for the operation to complete before moving on.
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        
        // After user creation, set the UID and navigate.
        if (userCredential.user != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavBar()));
        }
      } on FirebaseAuthException catch (ex) {
        UiHelp1.CustomAlertBox(context, ex.code.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: const Color.fromRGBO(168, 195, 221, 1),
      ),
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
            // Inside your Stack widget
            Positioned(
              bottom: 30, // Adjust as needed for your layout
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // This ensures the Row only takes as much width as its children need
                children: <Widget>[
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.white, // Adjust the color as needed
                      fontSize: 12,
                      // Add other text styling as needed
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginP()));
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue, // Adjust the color as needed
                        // Add other text styling as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(20), // Adjust the padding as needed
              width: MediaQuery.of(context).size.width *
                  0.85, // Adjust the width as needed
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // To make the container wrap its content
                children: [
                  Text(
                    'Email',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 5),
                  UiHelp1.textf(emailController, "Email", Icons.mail, false),
                  SizedBox(height: 20), // Spacing between the fields
                  Text(
                    'Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 5),
                  UiHelp1.textf(
                      passwordController, "Password", Icons.lock, true),
                  SizedBox(height: 20),
                  UiHelp1.button(() { signUp(emailController.text.toString(), passwordController.text.toString());}, 'Sign In'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
