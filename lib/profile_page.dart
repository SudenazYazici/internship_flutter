import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;
  const ProfilePage({Key? key, required this.onLogout}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _buildUserProfile(),
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Remove user data
    widget.onLogout(); // Notify parent about the logout
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Your Tickets",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Example ticket list
          Card(
            child: ListTile(
              leading: Icon(Icons.arrow_forward_ios),
              title: Text('Ticket 1'),
              subtitle: Text('This is a movie ticket'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.arrow_forward_ios),
              title: Text('Ticket 2'),
              subtitle: Text('This is a movie ticket'),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
