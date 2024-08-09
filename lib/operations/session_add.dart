import 'package:first_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionAdd extends StatefulWidget {
  const SessionAdd({super.key});

  @override
  State<SessionAdd> createState() => _SessionAddState();
}

class _SessionAddState extends State<SessionAdd> {
  int? selectedCinemaId;
  int? selectedCinemaHallId;
  int? selectedMovieId;
  late Future<List<Cinema>> _cinemas;
  late Future<List<CinemaHall>> _cinemaHalls = Future.value([]);
  late Future<List<Movie>> _movies = Future.value([]);
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  int? durationInMinutes;
  final TextEditingController _durationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cinemas = fetchCinemas();
  }

  Future<List<Cinema>> fetchCinemas() async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/Cinema'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cinema.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cinemas');
    }
  }

  Future<List<CinemaHall>> fetchCinemaHalls(int cinemaId) async {
    final response = await http.get(
        Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId/cinemaHalls'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CinemaHall.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cinema halls');
    }
  }

  Future<List<Movie>> fetchMovies(int cinemaId) async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId/movies'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.post(
      Uri.parse('https://10.0.2.2:7030/api/Session'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'cinemaId': selectedCinemaId.toString(),
        'cinemaHallId': selectedCinemaHallId.toString(),
        'movieId': selectedMovieId.toString(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'durationInMinutes': durationInMinutes.toString(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Session. Please try again.')),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            startDate = selectedDateTime;
          } else {
            endDate = selectedDateTime;
          }
        });
      }
    }
  }

  void _saveFormData() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      saveSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            FutureBuilder<List<Cinema>>(
              future: _cinemas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No cinemas available.');
                } else {
                  return DropdownButton<int>(
                    hint: Text("Select a Cinema"),
                    items: snapshot.data!.map((cinema) {
                      return DropdownMenuItem<int>(
                        value: cinema.id,
                        child: Text(cinema.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCinemaId = value!;
                        _cinemaHalls = fetchCinemaHalls(selectedCinemaId!);
                        _movies = fetchMovies(selectedCinemaId!);
                        selectedCinemaHallId = null;
                        selectedMovieId = null;
                      });
                    },
                    value: selectedCinemaId,
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder<List<CinemaHall>>(
              future: _cinemaHalls,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No cinema halls available.');
                } else {
                  return DropdownButton<int>(
                    hint: Text("Select a Cinema Hall"),
                    items: snapshot.data!.map((cinemaHall) {
                      return DropdownMenuItem<int>(
                        child: Text('Cinema Hall ${cinemaHall.hallNum}'),
                        value: cinemaHall.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCinemaHallId = value!;
                      });
                    },
                    value: selectedCinemaHallId,
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder<List<Movie>>(
              future: _movies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No movies available.');
                } else {
                  return DropdownButton<int>(
                    hint: Text("Select a Movie"),
                    items: snapshot.data!.map((movie) {
                      return DropdownMenuItem<int>(
                        value: movie.id,
                        child: Text(movie.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMovieId = value!;
                      });
                    },
                    value: selectedMovieId,
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDateTime(context, true),
                    child: Text('Start: ${startDate.toString()}'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDateTime(context, false),
                    child: Text('End: ${endDate.toString()}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration in Minutes'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the duration';
                }
                final intValue = int.tryParse(value);
                if (intValue == null || intValue <= 0) {
                  return 'Please enter a valid duration';
                }
                return null;
              },
              onSaved: (value) {
                durationInMinutes = int.tryParse(value!);
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _saveFormData(),
                    icon: Icon(Icons.check),
                    label: Text("Save"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
