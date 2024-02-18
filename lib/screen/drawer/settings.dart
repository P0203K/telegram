import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _profileImageUrl = '';
  late String _username = '';
  late String _bio = '';
  late String _phoneNumber = '';
  late bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      String userId = _auth.currentUser!.uid;
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

      setState(() {
        _profileImageUrl = userSnapshot['profileImageUrl'] ?? '';
        _username = userSnapshot['username'] ?? '';
        _bio = userSnapshot['bio'] ?? '';
        _phoneNumber = userSnapshot['phone'] ?? '';
        _isOnline = userSnapshot['isOnline'] ?? false;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print('Error logging out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : null,
                    backgroundColor: Colors.grey,
                    child: _profileImageUrl.isEmpty
                        ? Icon(Icons.account_circle, size: 100, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _username,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _isOnline ? 'Online' : 'Offline',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Implement Set Profile Photo functionality
              },
              child: Text('Set Profile Photo'),
            ),
            SizedBox(height: 16),
            Text('Account Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Phone number'),
              subtitle: Text(_phoneNumber),
            ),
            ListTile(
              title: Text('Username'),
              subtitle: Text(_username),
            ),
            ListTile(
              title: Text('Bio'),
              subtitle: Text(_bio),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
