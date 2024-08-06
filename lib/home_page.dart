import 'package:flutter/material.dart';

import 'dart:math' as math;

class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({super.key});

  @override
  State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: 200.0,
        height: 200.0,
        color: Colors.transparent,
        child: const Center(
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://images.pexels.com/photos/9811669/pexels-photo-9811669.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
            radius: 150.0,
          ),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * math.pi,
          child: child,
        );
      },
    );
  }
}

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
                  color: Colors.deepOrangeAccent[200],
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueGrey[800]),
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(26.0),
                child: AnimatedBuilderExample(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
