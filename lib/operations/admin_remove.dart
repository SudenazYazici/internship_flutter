import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AdminRemove extends StatefulWidget {
  const AdminRemove({super.key});

  @override
  State<AdminRemove> createState() => _AdminRemoveState();
}

class _AdminRemoveState extends State<AdminRemove> {
  late Future<List<User>> _admins;

  @override
  void initState() {
    super.initState();
    _admins = fetchAdmins();
  }

  Future<List<User>> fetchAdmins() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.get(
      Uri.parse('https://10.0.2.2:7030/api/User'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<User> allUsers = data.map((json) => User.fromJson(json)).toList();
      List<User> admins =
          allUsers.where((user) => user.role == 'admin').toList();
      return admins;
    } else {
      throw Exception('Failed to load admins');
    }
  }

  Future<void> deleteAdmin(int adminId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    final response = await http.delete(
      Uri.parse('https://10.0.2.2:7030/api/User/$adminId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin removed successfully!')),
      );
      setState(() {
        _admins = fetchAdmins();
      });
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove admin. Please try again.')),
      );
    }
  }

  Future<void> _confirmDeleteAdmin(int adminId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this admin?'),
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
      deleteAdmin(adminId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<User>>(
          future: _admins,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No admins found.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final admin = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(admin.email),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteAdmin(admin.id);
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
