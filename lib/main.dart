import 'package:first_flutter/login_page.dart';
import 'package:first_flutter/movies_page.dart';
import 'package:first_flutter/register_page.dart';
import 'package:first_flutter/theatres_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
      theme: ThemeData(useMaterial3: true),
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
  bool isAuthenticated = false;

  void _login() {
    setState(() {
      isAuthenticated = true;
    });
  }

  void _logout() {
    setState(() {
      isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
          NavigationDestination(
            selectedIcon: Icon(Icons.add_box),
            icon: Icon(Icons.add_box_outlined),
            label: 'Login',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_box),
            icon: Icon(Icons.add_box_outlined),
            label: 'Register',
          ),
        ],
      ),
      body: Container(
        color: Colors.blueGrey[100],
        child: <Widget>[
          /// Home page
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[800],
              title: Text("Cinema App"),
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "WELCOME",
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //borderRadius: BorderRadiusDirectional.circular(16.0),
                          color: Colors.blueGrey[800]),
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(26.0),
                      //color: Colors.blueGrey[800],

                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/2/2f/Sala_de_cine.jpg"),
                        radius: 150.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///Movies page
          MoviesPage(),

          ///Theatres page
          TheatresPage(),

          /// Book Ticket page
          ListView.builder(
            // do not forget to make the page later
            reverse: true,
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Hello',
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ),
                );
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hi!',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            },
          ),

          /// Profile page
          Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              title: const Text('Profile Page'),
            ),
            body: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.arrow_forward_ios),
                        title: Text('Ticket 1'),
                        subtitle: Text('This is a movie ticket'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.arrow_forward_ios),
                      title: Text('Ticket 2'),
                      subtitle: Text('This is a movie ticket'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///Login page
          LoginPage(),

          ///Register page
          RegisterPage(),
        ][currentPageIndex],
      ),
    );
  }
}
