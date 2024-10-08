import 'package:first_flutter/book_ticket_page.dart';
import 'package:first_flutter/home_page.dart';
import 'package:first_flutter/login_page.dart';
import 'package:first_flutter/movies_page.dart';
import 'package:first_flutter/profile_page.dart';
import 'package:first_flutter/register_page.dart';
import 'package:first_flutter/theatres_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //!!!Be careful!!!
  // This should be used while in development mode,
  // do NOT do this when you want to release to production,
  // the aim of this to make the development a bit easier,
  // for production, you need to fix your certificate issue and use it properly,
  HttpOverrides.global = MyHttpOverrides();
  runApp(const NavigationBarApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          surface: Colors.blueGrey[800],
          seedColor: Colors.blueGrey,
        ),
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Remove user data
    setState(() {
      _isLoggedIn = false; // Update the state to reflect the logout
    });
  }

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blueGrey[100],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.movie_creation),
            icon: Icon(Icons.movie_creation_outlined),
            label: 'Movies',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on_outlined),
            label: 'Theatres',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_outlined),
            icon: Icon(Icons.add),
            label: 'Book Ticket',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: Container(
        color: Colors.blueGrey[100],
        child: <Widget>[
          /// Home page
          HomePage(),

          ///Movies page
          MoviesPage(),

          ///Theatres page
          TheatresPage(),

          /// Book Ticket page
          BookTicketPage(),

          /// Profile page or Login page based on authentication
          _isLoggedIn
              ? ProfilePage(onLogout: _logout)
              : Column(
                  children: [
                    Flexible(child: LoginPage(onLogin: _handleLogin)),
                    Flexible(child: RegisterPage()),
                  ],
                ),
        ][currentPageIndex],
      ),
    );
  }
}
