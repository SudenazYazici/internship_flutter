import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: Padding(
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.movie_creation),
                      title: Text(movie.name),
                      subtitle: Text(
                        movie.details,
                        style: TextStyle(color: Colors.grey[600]),
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

class Movie {
  final int id;
  final String name;
  final String details;

  Movie({
    required this.id,
    required this.name,
    required this.details,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      name: json['name'],
      details: json['details'],
    );
  }
}
