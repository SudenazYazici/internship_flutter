import 'package:flutter/material.dart';

class BookTicketPage extends StatelessWidget {
  const BookTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text("Book Ticket Page"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
