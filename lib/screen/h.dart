import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram/screen/chatPage.dart';

import 'drawer/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() async {
    await _auth.signOut();
    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telegram', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var profileImageUrl = userData['profileImageUrl'] ?? '';
            var username = userData['username'] ?? '';
            var phoneNumber = userData['phone'] ?? '';

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        backgroundColor:
                            Colors.grey, // Default background color
                        radius: 30, // Adjust as needed
                        child: profileImageUrl.isEmpty
                            ? Icon(Icons.account_circle,
                                color: Colors.white,
                                size: 60) // Default icon if no image
                            : null,
                      ),
                      SizedBox(height: 8),
                      Text(
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        phoneNumber,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('New Group'),
                  onTap: () {
                    // Navigate to new group screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Contacts'),
                  onTap: () {
                    // Navigate to Contacts screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.emoji_people_outlined),
                  title: Text('People Nearby'),
                  onTap: () {
                    // Navigate to People Nearby screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.save),
                  title: Text('Saved Messages'),
                  onTap: () {
                    // Navigate to Saved Messages screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Navigate to settings screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    signOut();
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (_auth.currentUser != null &&
        _auth.currentUser!.phoneNumber != null &&
        data != null) {
      if (data['phone'] != null &&
          _auth.currentUser!.phoneNumber != data['phone']) {
        return ListTile(
          title: Text(data['phone'] ?? ''),
          leading: CircleAvatar(
            backgroundImage: data['profileImageUrl'] != null
                ? NetworkImage(data['profileImageUrl'])
                : null,
            backgroundColor: Colors.grey, // Default background color
            child: data['profileImageUrl'] == null
                ? Icon(Icons.account_circle, color: Colors.white)
                : null, // Default icon if no image
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receivedUserPhoneNumber: data['phone'] ?? '',
                ),
              ),
            );
          },
        );
      }
    }
    return Container();
  }
}
