import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieRemove extends StatefulWidget {
  const MovieRemove({super.key});

  @override
  State<MovieRemove> createState() => _MovieRemoveState();
}

class _MovieRemoveState extends State<MovieRemove> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/Movie'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> deleteMovie(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.delete(
      Uri.parse('https://10.0.2.2:7030/api/Movie/$movieId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie removed successfully!')),
      );
      setState(() {
        _movies = fetchMovies();
      });
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove movie. Please try again.')),
      );
    }
  }

  Future<void> _confirmDeleteMovie(int movieId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this movie?'),
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
      deleteMovie(movieId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Movie>>(
          future: _movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No movies found.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.movie_creation),
                      title: Text(movie.name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteMovie(movie.id);
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
