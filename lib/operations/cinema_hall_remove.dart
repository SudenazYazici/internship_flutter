import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_flutter/models.dart';

class CinemaHallRemove extends StatefulWidget {
  const CinemaHallRemove({super.key});

  @override
  State<CinemaHallRemove> createState() => _CinemaHallRemoveState();
}

class _CinemaHallRemoveState extends State<CinemaHallRemove> {
  late Future<List<CinemaHall>> _cinemaHalls;

  @override
  void initState() {
    super.initState();
    _cinemaHalls = fetchCinemaHalls();
  }

  Future<List<CinemaHall>> fetchCinemaHalls() async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/CinemaHall'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CinemaHall.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cinema halls');
    }
  }

  Future<String> fetchCinemaName(int cinemaId) async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      Cinema cinema = Cinema.fromJson(data);
      return cinema.name;
    } else {
      throw Exception('Failed to fetch cinema');
    }
  }

  Future<void> deleteCinemaHall(int cinemaHallId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.delete(
      Uri.parse('https://10.0.2.2:7030/api/CinemaHall/$cinemaHallId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cinema hall removed successfully!')),
      );
      setState(() {
        _cinemaHalls = fetchCinemaHalls();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to remove cinema hall. Please try again.')),
      );
    }
  }

  Future<void> _confirmDeleteCinemaHall(int cinemaHallId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this cinema hall?'),
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
      deleteCinemaHall(cinemaHallId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<CinemaHall>>(
          future: _cinemaHalls,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No cinema halls found.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final cinemaHall = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.theaters),
                      title: Text('Cinema Hall ${cinemaHall.hallNum}'),
                      subtitle: FutureBuilder<String>(
                        future: fetchCinemaName(cinemaHall.cinemaId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(snapshot.data ?? 'Unknown Cinema');
                          }
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteCinemaHall(cinemaHall.id);
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
