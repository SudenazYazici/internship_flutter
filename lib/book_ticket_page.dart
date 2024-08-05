import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class BookTicketPage extends StatefulWidget {
  const BookTicketPage({super.key});

  @override
  State<BookTicketPage> createState() => _BookTicketPageState();
}

class _BookTicketPageState extends State<BookTicketPage> {
  late Future<List<Cinema>> _theatres;
  Session? selectedSession;

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

  Future<List<Movie>> fetchMovies(cinemaId) async {
    if (cinemaId == null) return [];
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId/movies'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<CinemaHall>> fetchCinemaHalls(cinemaId) async {
    if (cinemaId == null) return [];
    final response = await http.get(
        Uri.parse('https://10.0.2.2:7030/api/Cinema/$cinemaId/cinemaHalls'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CinemaHall.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cinema halls');
    }
  }

  Future<List<Session>> fetchSessions(cinemaId, movieId, cinemaHallId) async {
    if (cinemaId == null || movieId == null || cinemaHallId == null) return [];
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:7030/api/Session/get-sessions/$cinemaId/$movieId/$cinemaHallId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<List<Seat>> fetchSeats(cinemaHallId) async {
    if (cinemaHallId == null) return [];
    final response = await http.get(
        Uri.parse('https://10.0.2.2:7030/api/CinemaHall/$cinemaHallId/seats'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Seat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load seats');
    }
  }

  Future<List<int>> fetchUnavailableSeats(
      cinemaId, movieId, cinemaHallId, startTime) async {
    if (cinemaId == null ||
        movieId == null ||
        cinemaHallId == null ||
        startTime == null) return [];

    final formattedStartTime = startTime.toIso8601String();
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:7030/api/Ticket/get-unavailable-seat-ids/$cinemaId/$movieId/$cinemaHallId/$formattedStartTime'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load unavailable seats');
    }
  }

  Future<List<Seat>> fetchAvailableSeats(int? cinemaId, int? movieId,
      int? cinemaHallId, DateTime? startTime) async {
    List<Seat> allSeats = await fetchSeats(cinemaHallId);
    List<int> unavailableSeatIds =
        await fetchUnavailableSeats(cinemaId, movieId, cinemaHallId, startTime);

    // Filter out the unavailable seats
    return allSeats
        .where((seat) => !unavailableSeatIds.contains(seat.id))
        .toList();
  }

  int? newTheatre;
  int? newMovie;
  int? newCinemaHall;
  int? newSession;
  int? newSeat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text("Book Ticket Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8.0,
            ),

            /// Theatre Dropdown
            FutureBuilder<List<Cinema>>(
              future: _theatres,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: newTheatre,
                    hint: Text('Select theatre'),
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      newTheatre = value;
                      newMovie = null;
                      newCinemaHall = null;
                      newSession = null;
                      newSeat = null;
                      setState(() {});
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 8.0,
            ),

            /// Movie Dropdown
            FutureBuilder<List<Movie>>(
              future: fetchMovies(newTheatre),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: newMovie,
                    hint: Text('Select movie'),
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      newMovie = value;
                      newCinemaHall = null;
                      newSession = null;
                      newSeat = null;
                      setState(() {});
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 8.0,
            ),

            /// Cinema Hall Dropdown
            FutureBuilder<List<CinemaHall>>(
              future: fetchCinemaHalls(newTheatre),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: newCinemaHall,
                    hint: Text('Select cinema hall'),
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem(
                        value: item.id,
                        child: Text(item.hallNum.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      newCinemaHall = value;
                      newSession = null;
                      newSeat = null;
                      setState(() {});
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 8.0,
            ),

            /// Session Dropdown
            FutureBuilder<List<Session>>(
              future: fetchSessions(newTheatre, newMovie, newCinemaHall),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: newSession,
                    hint: Text('Select session'),
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem(
                        value: item.id,
                        child: Text(item.startDate.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      newSession = value;
                      newSeat = null;
                      setState(() {
                        selectedSession = snapshot.data!
                            .firstWhere((session) => session.id == value);
                      });
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 8.0,
            ),

            /// Seat Dropdown
            FutureBuilder<List<Seat>>(
              future: fetchAvailableSeats(newTheatre, newMovie, newCinemaHall,
                  selectedSession?.startDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    // Initial Value
                    value: newSeat,
                    hint: Text('Select seat'),
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem(
                        value: item.id,
                        child: Text(item.seatNum.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      newSeat = value;
                      setState(() {});
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
