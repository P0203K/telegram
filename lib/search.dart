import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:telegram/screen/chatPage.dart';

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _sortAscending = true;

  void toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.clear, color: Colors.grey), // Cross icon
            onSelected: (value) {
              // Show all users in the list
              _searchController.clear(); // Clear the search text
              setState(() {}); // Trigger a rebuild to show all users
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'clear',
                  child: Text('Show All'),
                ),
              ];
            },
          ),
        ],
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {}); // Trigger a rebuild when the search text changes
          },
        ),
      ),

      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').orderBy('username', descending: !_sortAscending).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the search text
        final searchText = _searchController.text.toLowerCase();

        // Filter users based on the search text
        final filteredUsers = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final displayName = data['username'] ?? data['phone'];
            return searchText.isEmpty || displayName.toLowerCase().startsWith(searchText);
          }
          return false;
        }).toList();

        return ListView(
          children: filteredUsers
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null) {
      String displayName = data['username'] ?? data['phone'];
      String lastSeenMessage = 'last seen recently'; // Default message

      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(data['phone'])
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var lastMessage = snapshot.data!.docs.first;
            var timestamp = lastMessage['timestamp'];
            var messageTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
            var difference = DateTime.now().difference(messageTimestamp);
            if (difference.inMinutes < 60) {
              lastSeenMessage = 'last seen recently';
            } else if (difference.inHours < 24) {
              lastSeenMessage = 'last seen today';
            } else {
              lastSeenMessage = 'last seen on ${DateFormat('dd MMM, yyyy').format(messageTimestamp)}';
            }
          }

          return Column(
            children: [
              ListTile(
                title: Text(
                  displayName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastSeenMessage,
                  style: TextStyle(
                    color: Colors.grey, // Set grey color for last seen message
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.orange, // Background color for default profile icon
                  radius: 25,
                  child: Text(
                    displayName.substring(0, 1).toUpperCase(), // Display first letter of username
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
            ],
          );
        },
      );
    }
    return Container();
  }



}

