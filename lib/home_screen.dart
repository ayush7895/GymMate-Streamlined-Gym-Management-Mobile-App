import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/uihelp.dart';
import 'package:flutter_application_1/datab.dart'; // Ensure you have this import for DataBaseS

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataBaseS? dataBaseS;

  @override
  void initState() {
    super.initState();
    initializeDataBase();
  }

  void initializeDataBase() {
    // Ensure you have some mechanism to get a valid UID, adjust accordingly
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      dataBaseS = DataBaseS(uid: uid);
    } else {
      print("User ID is null");
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("logged out successfully")));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginP()),
      );
    } on FirebaseAuthException catch (ex) {
      UiHelp1.CustomAlertBox(context, ex.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 20, 23, 1),
      appBar: AppBar(
        title: const Text(
          'My Database',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: logout,
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(168, 195, 221, 0.7),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<int>(
                  future: dataBaseS?.getTotalClients(),
                  builder: (context, snapshot) {
                    if (dataBaseS == null) {
                      return const Text('User not initialized',
                          style: TextStyle(color: Colors.white));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        height: 20, // Adjust the size as needed
                        width: 20,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white));
                    } else {
                      return Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        color: const Color.fromRGBO(103, 105, 117, 0.5),
                        alignment: Alignment.center,
                        child: Text('Total Clients : ${snapshot.data}',
                            style: const TextStyle(color: Colors.white)),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                FutureBuilder<int>(
                    future: dataBaseS?.getActiveClients(),
                    builder: (context, snapshot) {
                      if (dataBaseS == null) {
                        return const Text('User not initialized',
                            style: TextStyle(color: Colors.white));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox(
                          height: 20, // Adjust the size as needed
                          width: 20,
                          child:
                              const CircularProgressIndicator(strokeWidth: 2),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white));
                      } else {
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: const Color.fromRGBO(103, 105, 117, 0.5),
                          alignment: Alignment.center,
                          child: Text('Active Clients: ${snapshot.data}',
                              style: const TextStyle(color: Colors.white)),
                        );
                      }
                    }),
              ],
            )),
      ),
    );
  }
}
