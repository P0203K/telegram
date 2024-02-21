import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram/screen/chatPage.dart';
import 'package:telegram/search.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _sortAscending = true;

  void toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  void signOut() async {
    await _auth.signOut();
    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF588FBA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              // Navigate to search screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onPressed: () {
              toggleSort();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.group_outlined, color: Colors.grey,),
            title: Text('New Group'),
            onTap: () {
              // Navigate to new group screen
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.grey,),
            title: Text('New Secret Chat'),
            onTap: () {
              // Navigate to new secret chat screen
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement_outlined, color: Colors.grey,),
            title: Text('New Channel'),
            onTap: () {
              // Navigate to new channel screen
            },
          ),
          Divider(), // Add a separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              _sortAscending ? 'Sorting order: Ascending' : 'Sorting order: Descending',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800], // Dark grey text color
              ),
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add contact functionality
        },
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: Icon(
          Icons.person_add_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').orderBy('username', descending: !_sortAscending).snapshots(),
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
        String displayName = data['username'] ?? data['phone']; // Use username if available, otherwise use phone number

        // Generate random user status
        final bool isOnline = Random().nextBool();
        final String status = isOnline ? 'Online' : 'Offline';

        // Get the first letter of the username for the default profile icon
        String firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '';

        return ListTile(
          title: Text(
            displayName,
            style: TextStyle(fontWeight: FontWeight.bold), // Bold user name
          ),
          subtitle: Text(
            status,
            style: TextStyle(
              color: Colors.grey, // Grey font color for user status
              fontSize: 12, // Smaller font size for user status
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.orange, // Default background color
            radius: 25,
            child: Text(
              firstLetter,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
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
