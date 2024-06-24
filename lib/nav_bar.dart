import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_client.dart';
import 'package:flutter_application_1/client_list.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/renew_client.dart';
import 'package:flutter_application_1/search_client.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? user;
  late List<Widget> screens;
  int index = 0;

  @override
void initState() {
  super.initState();
  user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    screens = [
      HomeScreen(),
      ClientList(uid: user!.uid),
      SearchClientPage(uid: user!.uid),
      AddClient(),
      RenewClient(uid: user!.uid),
    ];
  } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginP())
      );
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("Please sign in to access the app."),
          
          
        ),
      );
    }

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: const Color.fromRGBO(19, 20, 23, 1),
        selectedIndex: index,
        onDestinationSelected: (int idx) => setState(() => index = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Clients',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined),
            selectedIcon: Icon(Icons.add),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.update),
            label: 'Renew',
          ),
        ],
      ),
    );
  }
}