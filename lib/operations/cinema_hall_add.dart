import 'package:first_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CinemaHallAdd extends StatefulWidget {
  const CinemaHallAdd({super.key});

  @override
  State<CinemaHallAdd> createState() => _CinemaHallAddState();
}

class _CinemaHallAddState extends State<CinemaHallAdd> {
  late int hall_num;
  int? selectedCinemaId;
  late Future<List<Cinema>> _theatres;
  final formKey = GlobalKey<FormState>();

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

  Future<void> saveCinemaHall() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.post(
      Uri.parse('https://10.0.2.2:7030/api/CinemaHall'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'hallNum': hall_num.toString(),
        'cinemaId': selectedCinemaId.toString(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cinema hall added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add cinema hall. Please try again.')),
      );
    }
  }

  void _saveFormData() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      saveCinemaHall();
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
                labelText: "Hall Number",
                hintText: "Hall Number",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the hall number';
              }
              return null;
            },
            onSaved: (data) => hall_num = int.parse(data!),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<List<Cinema>>(
            future: _theatres,
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
                      child: Text(cinema.name),
                      value: cinema.id,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCinemaId = value!;
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
