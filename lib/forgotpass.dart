import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/signp_page.dart';
import 'dart:ui';

import 'package:flutter_application_1/uihelp.dart';

class forgotpass extends StatefulWidget {
  const forgotpass({super.key});

  @override
  State<forgotpass> createState() => _forgotpassState();
}

class _forgotpassState extends State<forgotpass> {
  TextEditingController emailController = TextEditingController();
  forgotpassw(String email) async {
     if (email.isEmpty) {
    UiHelp1.CustomAlertBox(context, "Please enter your email to reset your password.");
    return; // Exit the function early.
  }
  // Additional validation for email format can be added here.

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // Inform the user that the reset email has been sent.
    UiHelp1.CustomAlertBox(context, "A password reset link has been sent to your email.");
    // Optionally clear the emailController here if desired:
    // emailController.clear();
  }on FirebaseAuthException catch (ex) {
    String errorMessage= ex.code.toString();
    if (ex.code == 'user-not-found') {
      errorMessage = "No user found with this email.";
    }
        return UiHelp1.CustomAlertBox(context, errorMessage);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log In',
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
                  UiHelp1.textf(
                      emailController, "Enter email here", Icons.mail, false),
                  SizedBox(height: 20),
                  UiHelp1.button(() {
                    forgotpassw(emailController.text.toString());
                  }, 'Send Reset email')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
