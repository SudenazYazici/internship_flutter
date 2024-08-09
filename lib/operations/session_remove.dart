import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_flutter/models.dart';

class SessionRemove extends StatefulWidget {
  const SessionRemove({super.key});

  @override
  State<SessionRemove> createState() => _SessionRemoveState();
}

class _SessionRemoveState extends State<SessionRemove> {
  late Future<List<Session>> _sessions;
  final Map<int, String> _cinemaNames = {};
  final Map<int, String> _cinemaHallNames = {};
  final Map<int, String> _movieNames = {};

  @override
  void initState() {
    super.initState();
    _sessions = fetchSessions();
  }

  Future<String> fetchCinemaName(int cinemaId) async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['name'];
    } else {
      throw Exception('Failed to load cinema');
    }
  }

  Future<String> fetchCinemaHallName(int cinemaHallId) async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7030/api/CinemaHall/$cinemaHallId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['hallNum'].toString();
    } else {
      throw Exception('Failed to load cinema hall');
    }
  }

  Future<String> fetchMovieName(int movieId) async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7030/api/Movie/by-id/$movieId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['name'];
    } else {
      throw Exception('Failed to load movie');
    }
  }

  Future<List<Session>> fetchSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.get(
      Uri.parse('https://10.0.2.2:7030/api/Session'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Session> sessions =
          data.map((json) => Session.fromJson(json)).toList();

      for (var session in sessions) {
        final cinemaName = await fetchCinemaName(session.cinemaId);
        final cinemaHallName = await fetchCinemaHallName(session.cinemaHallId);
        final movieName = await fetchMovieName(session.movieId);

        setState(() {
          _cinemaNames[session.cinemaId] = cinemaName;
          _cinemaHallNames[session.cinemaHallId] = cinemaHallName;
          _movieNames[session.movieId] = movieName;
        });
      }

      return sessions;
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<void> deleteSession(int sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.delete(
      Uri.parse('https://10.0.2.2:7030/api/Session/$sessionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session removed successfully!')),
      );
      setState(() {
        _sessions = fetchSessions();
      });
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove session. Please try again.')),
      );
    }
  }

  Future<void> _confirmDeleteSession(int sessionId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this session?'),
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
      deleteSession(sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Session>>(
          future: _sessions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No sessions found.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final session = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.schedule),
                      title: Text('Session Id: ${session.id}'),
                      subtitle: Text(
                        'Cinema: ${_cinemaNames[session.cinemaId]}'
                        '\nCinema Hall: ${_cinemaHallNames[session.cinemaHallId]}'
                        '\nMovie: ${_movieNames[session.movieId]}'
                        '\nStart Date: ${session.startDate}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteSession(session.id);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
