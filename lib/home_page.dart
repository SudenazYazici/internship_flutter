import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    shape: BoxShape.circle, color: Colors.blueGrey[800]),
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(26.0),
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
    );
  }
}
