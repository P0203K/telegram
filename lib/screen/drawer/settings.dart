import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _profileImageUrl = '';
  late String _username = '';
  late String _userStatus = '';
  late String _phoneNumber = '';
  late String _bio = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    setState(() {
      _profileImageUrl = userData['profileImageUrl'] ?? '';
      _username = userData['username'] ?? '';
      _userStatus = 'Online'; // You can replace this with dynamic data
      _phoneNumber = userData['phone'] ?? '';
      _bio = userData['bio'] ?? '';
      _isLoading = false; // Set loading state to false when data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildProfileDetails(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildProfileDetails() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          _buildProfileImage(),
          SizedBox(height: 16),
          // Username
          Text(
            'Username: $_username',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // User Status
          Text(
            'User Status: $_userStatus',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          // Phone Number
          Text(
            'Phone Number: $_phoneNumber',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          // Bio
          Text(
            'Bio: $_bio',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 50,
      child: Text(
        _username.isNotEmpty ? _username[0].toUpperCase() : '',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }
}
