import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  Future<void> _register() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String birthDate = _birthDateController.text;

    var url = Uri.parse('https://10.0.2.2:7030/api/User/register');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Name': name,
        'Email': email,
        'Password': password,
        'BirthDate': birthDate,
        'Role': "user",
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      var user = jsonDecode(response.body);
      // Handle the user data as needed
      print('User registered: $user');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully!')));
    } else {
      // If the server did not return a 200 OK response, show an error
      print('Failed to register user: ${response.reasonPhrase}');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to register user: ${response.reasonPhrase}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      /*appBar: AppBar(
        title: const Text('Register Page'),
      ),*/
      body: Center(
        child: SingleChildScrollView(
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
        ),
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
            widget.controller.text = "${pickedDate.toLocal()}"
                .split(' ')[0]; // Format the date as per your requirement
          });
        }
      },
    );
  }
}
