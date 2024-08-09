import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cinema_hall_model.dart';
import '../models/seat_model.dart';
import '../models/theatre_model.dart';

class SeatRemove extends StatefulWidget {
  const SeatRemove({super.key});

  @override
  State<SeatRemove> createState() => _SeatRemoveState();
}

class _SeatRemoveState extends State<SeatRemove> {
  late Future<List<Seat>> _seats;
  final Map<int, String> _cinemaNames = {};
  final Map<int, String> _cinemaHallNames = {};

  @override
  void initState() {
    super.initState();
    _seats = fetchSeats();
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

  Future<String> fetchCinemaHallName(int cinemaHallId) async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7030/api/CinemaHall/$cinemaHallId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      CinemaHall cinemaHall = CinemaHall.fromJson(data);
      final cinemaName = await fetchCinemaName(cinemaHall.cinemaId);
      setState(() {
        _cinemaNames[cinemaHall.id] = cinemaName;
      });
      return cinemaHall.hallNum.toString();
    } else {
      throw Exception('Failed to fetch cinema hall');
    }
  }

  Future<List<Seat>> fetchSeats() async {
    final response =
        await http.get(Uri.parse('https://10.0.2.2:7030/api/Seat'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Seat> seats = data.map((json) => Seat.fromJson(json)).toList();

      for (var seat in seats) {
        final cinemaHallName = await fetchCinemaHallName(seat.cinemaHallId);
        setState(() {
          _cinemaHallNames[seat.id] = cinemaHallName;
        });
      }

      return seats;
    } else {
      throw Exception('Failed to load seats');
    }
  }

  Future<void> deleteSeat(int seatId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.delete(
      Uri.parse('https://10.0.2.2:7030/api/Seat/$seatId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seat removed successfully!')),
      );
      setState(() {
        _seats = fetchSeats();
      });
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove seat. Please try again.')),
      );
    }
  }

  Future<void> _confirmDeleteSeat(int seatId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this seat?'),
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
      deleteSeat(seatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Seat>>(
          future: _seats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No seats found.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final seat = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.event_seat),
                      title: Text('Seat ${seat.seatNum}'),
                      subtitle: Text(
                          'Cinema Hall: ${_cinemaHallNames[seat.id]}\nCinema: ${_cinemaNames[seat.cinemaHallId]}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteSeat(seat.id);
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
