import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieAdd extends StatefulWidget {
  const MovieAdd({super.key});

  @override
  State<MovieAdd> createState() => _MovieAddState();
}

class _MovieAddState extends State<MovieAdd> {
  late String name, details;
  final formKey = GlobalKey<FormState>();

  Future<void> saveMovie() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.post(
      Uri.parse('https://10.0.2.2:7030/api/Movie'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'details': details,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add movie. Please try again.')),
      );
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
            decoration: InputDecoration(
                labelText: "Name",
                hintText: "Name",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter movie name';
              }
              return null;
            },
            onSaved: (data) => name = data!,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Details",
                hintText: "Details",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter movie details';
              }
              return null;
            },
            onSaved: (data) => details = data!,
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

  void _saveFormData() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      saveMovie();
    }
  }
}
