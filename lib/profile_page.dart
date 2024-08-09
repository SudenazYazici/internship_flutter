import 'package:first_flutter/admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/ticket_model.dart';

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

Future<void> deleteTicket(int ticketId) async {
  final response = await http
      .delete(Uri.parse('https://10.0.2.2:7030/api/Ticket/$ticketId'));

  if (response.statusCode != 204) {
    throw Exception('Failed to delete ticket');
  }
}

Future<String> getCinema(int cinemaId) async {
  final response =
      await http.get(Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['name'];
  } else {
    throw Exception('Failed to load cinema');
  }
}

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;
  const ProfilePage({Key? key, required this.onLogout}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Ticket>>? _ticketsFuture = Future.value([]);
  late bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchUserTickets();
    getUserRole();
  }

  Future<void> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('userRole');
    if (userRole == "admin") {
      setState(() {
        isAdmin = true;
      });
    } else {
      setState(() {
        isAdmin = false;
      });
    }
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

  Future<void> _handleDeleteTicket(int ticketId) async {
    try {
      await deleteTicket(ticketId);
      _fetchUserTickets();
    } catch (e) {
      print('Failed to delete ticket: $e');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete ticket')),
      );
    }
  }

  Future<void> _confirmDeleteTicket(int ticketId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this ticket?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _handleDeleteTicket(ticketId);
    }
  }

  Future<void> _confirmLogout() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Log out'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _logout();
    }
  }

  Future<String> _getCinemaOfTicket(int cinemaId) async {
    try {
      return await getCinema(cinemaId);
    } catch (e) {
      print('Failed to get cinema of ticket: $e');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get cinema of ticket')),
      );
      return 'Unknown Cinema';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          if (isAdmin)
            TextButton.icon(
              icon: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white54,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanel()),
                );
              },
              label: Text(
                "Panel",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          TextButton.icon(
            icon: const Icon(
              Icons.logout,
              color: Colors.white54,
            ),
            onPressed: _confirmLogout,
            label: Text(
              "Log out",
              style: TextStyle(color: Colors.white54),
            ),
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800]),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.local_activity),
                            title: Text(ticket.movieName),
                            subtitle: FutureBuilder<String>(
                              future: _getCinemaOfTicket(ticket.cinemaId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                    'Cinema: ${snapshot.data} \nDate: ${ticket.date.toLocal()} \nPrice: \$${ticket.price}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  );
                                }
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _confirmDeleteTicket(ticket.id),
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
