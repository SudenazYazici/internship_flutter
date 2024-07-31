import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          title: Text("Cinema App"),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadiusDirectional.circular(16.0),
                  color: Colors.blueGrey[800]),
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(26.0),
              //color: Colors.blueGrey[800],
              child: Transform(
                transform: Matrix4.rotationZ(-0.2),
                alignment: FractionalOffset.center,
                child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/2/2f/Sala_de_cine.jpg"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
