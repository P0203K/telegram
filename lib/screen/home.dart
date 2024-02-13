import 'package:flutter/material.dart';
import 'package:telegram/screen/chat.dart';


// void main() {
//   runApp(TelegramApp());
// }

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
        title: Text('Telegram'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
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
    );
  }
}

class ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulated list of chats
    List<Chat> chats = [
      Chat(
        name: 'John Doe',
        message: 'Hello there!',
        time: '10:00 AM',
        unreadCount: 2,
      ),
      Chat(
        name: 'Jane Smith',
        message: 'Hi!',
        time: 'Yesterday',
        unreadCount: 0,
      ),
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(chats[index].name[0]), // Displaying first letter of name
          ),
          title: Text(chats[index].name),
          subtitle: Text(chats[index].message),
          trailing: chats[index].unreadCount > 0
              ? CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 10,
            child: Text(
              chats[index].unreadCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
              : null,
          onTap: () {
            // Open chat screen for the selected chat
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()));
          },
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
