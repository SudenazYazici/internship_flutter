import 'package:first_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SeatAdd extends StatefulWidget {
  const SeatAdd({super.key});

  @override
  State<SeatAdd> createState() => _SeatAddState();
}

class _SeatAddState extends State<SeatAdd> {
  late int seat_num;
  int? selectedCinemaHallId;
  late Future<List<CinemaHall>> _cinemaHalls;
  final formKey = GlobalKey<FormState>();
  final Map<int, String> _cinemaNames = {};

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
      List<CinemaHall> cinemaHalls =
          data.map((json) => CinemaHall.fromJson(json)).toList();

      for (var cinemaHall in cinemaHalls) {
        final cinemaName = await fetchCinemaName(cinemaHall.cinemaId);
        setState(() {
          _cinemaNames[cinemaHall.id] = cinemaName;
        });
      }

      return cinemaHalls;
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

  Future<void> saveSeat() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.post(
      Uri.parse('https://10.0.2.2:7030/api/Seat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'seatNum': seat_num.toString(),
        'cinemaHallId': selectedCinemaHallId.toString(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seat added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add seat. Please try again.')),
      );
    }
  }

  void _saveFormData() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      saveSeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Seat Number",
                hintText: "Seat Number",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter seat number';
              }
              return null;
            },
            onSaved: (data) => seat_num = int.parse(data!),
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
                      child: Text(
                          'Cinema Hall ${cinemaHall.hallNum}\nCinema: ${_cinemaNames[cinemaHall.id] ?? "Loading..."}'),
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
    );
  }
}
