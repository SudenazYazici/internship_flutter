import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Ticket>> fetchTickets(int userId) async {
  final response = await http
      .get(Uri.parse('https://10.0.2.2:7030/api/User/$userId/tickets'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Ticket.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load tickets');
  }
}

class Ticket {
  final int id;
  final String movieName;
  final DateTime date;
  final int price;

  Ticket(
      {required this.id,
      required this.movieName,
      required this.date,
      required this.price});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      movieName: json['movieName'],
      date: DateTime.parse(json['date']),
      price: json['price'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;
  const ProfilePage({Key? key, required this.onLogout}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Ticket>>? _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserTickets();
  }

  Future<void> _fetchUserTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    if (userId != 0) {
      setState(() {
        _ticketsFuture = fetchTickets(userId);
      });
    } else {
      setState(() {
        _ticketsFuture = Future.error('User ID not found');
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tickets found.'));
          } else {
            final tickets = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Your Tickets",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.arrow_forward_ios),
                            title: Text(ticket.movieName),
                            subtitle: Text(
                              'Date: ${ticket.date.toLocal()} \nPrice: \$${ticket.price}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Remove user data
    widget.onLogout(); // Notify parent about the logout
  }
}
