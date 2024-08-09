import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_flutter/models.dart';

class TheatreRemove extends StatefulWidget {
  const TheatreRemove({super.key});

  @override
  State<TheatreRemove> createState() => _TheatreRemoveState();
}

class _TheatreRemoveState extends State<TheatreRemove> {
  late Future<List<Cinema>> _theatres;

  @override
  void initState() {
    super.initState();
    _theatres = fetchTheatres();
  }

  Future<List<Cinema>> fetchTheatres() async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/Cinema'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cinema.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load theatres');
    }
  }

  Future<void> deleteTheatre(int theatreId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.delete(
      Uri.parse('https://10.0.2.2:7030/api/Cinema/$theatreId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Theatre removed successfully!')),
      );
      setState(() {
        _theatres = fetchTheatres();
      });
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove theatre. Please try again.')),
      );
    }
  }

  Future<void> _confirmDeleteTheatre(int theatreId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this theatre?'),
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
      deleteTheatre(theatreId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Cinema>>(
          future: _theatres,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No theatres found.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final theatre = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.location_on_sharp),
                      title: Text(theatre.name),
                      subtitle: Text(
                        theatre.address,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteTheatre(theatre.id);
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
