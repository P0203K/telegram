import 'package:flutter/material.dart';
import 'package:telegram/screen/chat.dart';

void main() {
  runApp(TelegramApp());
}

class TelegramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telegram', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Set background color of app bar
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Telegram',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                // Navigate to profile screen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen
              },
            ),
          ],
        ),
      ),
      body: ChatsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding new chat
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.edit),
      ),
    );
  }
}

class ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulated list of chats
    List<Chat> chats = [
      Chat(
        name: 'Priya Khamkar',
        message: 'Hello there!',
        time: '10:00 AM',
        unreadCount: 2,
      ),
      Chat(
        name: 'Gargi Angne',
        message: 'Hi!',
        time: 'Yesterday',
        unreadCount: 0,
      ),
      Chat(
        name: 'Annabeth Chase',
        message: 'Thanks!',
        time: 'Yesterday',
        unreadCount: 0,
      ),
    ];

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => Divider(), // Add horizontal divider between list tiles
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: CircleAvatar(
                  child: Text(chats[index].name[0]), // Displaying first letter of name
                ),
                title: Text(chats[index].name),
                subtitle: Text(chats[index].message),
                onTap: () {
                  // Open chat screen for the selected chat
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chats[index].time, // Display timestamp
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (chats[index].unreadCount > 0)
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 10,
                      child: Text(
                        chats[index].unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class Chat {
  final String name;
  final String message;
  final String time;
  final int unreadCount;

  Chat({
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
  });
}
