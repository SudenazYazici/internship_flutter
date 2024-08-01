import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TheatresPage extends StatefulWidget {
  @override
  _TheatresPageState createState() => _TheatresPageState();
}

class _TheatresPageState extends State<TheatresPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Theatres'),
      ),
      body: FutureBuilder<List<Cinema>>(
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
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final theatre = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.location_on_sharp),
                    title: Text(theatre.name),
                    subtitle: Text(theatre.address),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Cinema {
  final int id;
  final String name;
  final String city;
  final String address;

  Cinema({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
    );
  }
}
