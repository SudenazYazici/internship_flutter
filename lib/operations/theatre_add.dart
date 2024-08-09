import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TheatreAdd extends StatefulWidget {
  const TheatreAdd({super.key});

  @override
  State<TheatreAdd> createState() => _TheatreAddState();
}

class _TheatreAddState extends State<TheatreAdd> {
  late String name, city, address;
  final formKey = GlobalKey<FormState>();

  Future<void> saveTheatre() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.post(
      Uri.parse('https://10.0.2.2:7030/api/Cinema'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'city': city,
        'address': address,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Theatre added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add theatre. Please try again.')),
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
                return 'Please enter the theatre name';
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
                labelText: "City",
                hintText: "City",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the city';
              }
              return null;
            },
            onSaved: (data) => city = data!,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Address",
                hintText: "Address",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the address';
              }
              return null;
            },
            onSaved: (data) => address = data!,
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

      saveTheatre();
    }
  }
}
