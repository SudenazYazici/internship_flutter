import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user_model.dart';

class AdminAdd extends StatefulWidget {
  const AdminAdd({Key? key}) : super(key: key);

  @override
  _AdminAddState createState() => _AdminAddState();
}

class _AdminAddState extends State<AdminAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  Future<void> _register() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    DateTime birthDate = DateTime.parse(_birthDateController.text);

    User user = User(
      id: 0,
      name: name,
      email: email,
      password: password,
      birthDate: birthDate,
      role: 'admin',
    );

    var url = Uri.parse('https://10.0.2.2:7030/api/User/register');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin registered successfully!')));
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to register admin: ${response.reasonPhrase}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 16),
          DatePickerField(controller: _birthDateController),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _register,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;

  const DatePickerField({Key? key, required this.controller}) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: 'BirthDate',
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            widget.controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }
}
