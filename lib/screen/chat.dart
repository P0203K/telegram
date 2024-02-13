import 'package:flutter/material.dart';
import 'package:telegram/screen/home.dart';

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ChatHeader(
            profileImage: 'assets/profile_image.jpg',
            profileName: 'John Doe',
            lastSeen: 'Last seen 5 minutes ago',
            onBackArrowPressed: () {
              Navigator.of(context).pop(); // Navigate back to previous screen
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Number of messages
              itemBuilder: (context, index) {
                // Simulating incoming and outgoing messages alternately
                return index.isEven
                    ? IncomingMessage(
                  message: 'Hello $index',
                  time: '10:00 AM',
                )
                    : OutgoingMessage(
                  message: 'Hi $index',
                  time: '10:01 AM',
                  status: MessageStatus.sent,
                );
              },
            ),
          ),
          ChatInputField(),
        ],
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  final String profileImage;
  final String profileName;
  final String lastSeen;
  final VoidCallback? onBackArrowPressed;

  const ChatHeader({
    required this.profileImage,
    required this.profileName,
    required this.lastSeen,
    this.onBackArrowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onBackArrowPressed,
          ),
          SizedBox(width: 12.0),
          CircleAvatar(
            radius: 24.0,
            backgroundImage: AssetImage(profileImage),
          ),
          SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileName,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                lastSeen,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.call), // Call icon
            onPressed: () {
              // Call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More options functionality
            },
          ),
        ],
      ),
    );
  }
}

enum MessageStatus { sent, delivered, read }

class IncomingMessage extends StatelessWidget {
  final String message;
  final String time;

  const IncomingMessage({
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            SizedBox(height: 4.0),
            Text(
              time,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutgoingMessage extends StatelessWidget {
  final String message;
  final String time;
  final MessageStatus status;

  const OutgoingMessage({
    required this.message,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                SizedBox(width: 4.0),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            if (status == MessageStatus.sent)
              Icon(
                Icons.done,
                color: Colors.grey,
                size: 16.0,
              )
            else if (status == MessageStatus.delivered)
              Icon(
                Icons.done_all,
                color: Colors.grey,
                size: 16.0,
              )
            else if (status == MessageStatus.read)
                Icon(
                  Icons.done_all,
                  color: Colors.blue,
                  size: 16.0,
                ),
          ],
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Send message functionality
            },
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              // Attach file functionality
            },
          ),
        ],
      ),
    );
  }
}
