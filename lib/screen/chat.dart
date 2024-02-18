import 'package:flutter/material.dart';

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
            profileName: 'Annabeth Chase',
            lastSeen: 'Last seen 5 minutes ago',
            onBackArrowPressed: () {
              Navigator.of(context).pop(); // Navigate back to previous screen
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 12, // Number of messages
              itemBuilder: (context, index) {
                // Simulating incoming, outgoing text, and image messages
                if (index.isEven) {
                  return IncomingMessage(
                    message: 'Hello $index',
                    time: '10:00 AM',
                  );
                } else if (index == 1) {
                  // Send image message
                  return OutgoingImageMessage(
                    imagePath: 'assets/images/telegram_logo.png',
                    time: '10:01 AM',
                    status: MessageStatus.sent,
                  );
                } else if (index == 2) {
                  // Replace with 'anything else?'
                  return OutgoingMessage(
                    message: 'anything else?',
                    time: '10:02 AM',
                    status: MessageStatus.sent,
                  );
                } else if (index == 3) {
                  // Replace with 'nope'
                  return OutgoingMessage(
                    message: 'nope',
                    time: '10:03 AM',
                    status: MessageStatus.sent,
                  );
                } else if (index == 4) {
                  // Replace with 'Thanks!'
                  return OutgoingMessage(
                    message: 'Thanks!',
                    time: '10:04 AM',
                    status: MessageStatus.sent,
                  );
                } else {
                  return OutgoingMessage(
                    message: 'Hi $index',
                    time: '10:01 AM',
                    status: MessageStatus.sent,
                  );
                }
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
  final String? profileImage;
  final String profileName;
  final String lastSeen;
  final VoidCallback? onBackArrowPressed;

  const ChatHeader({
    this.profileImage,
    required this.profileName,
    required this.lastSeen,
    this.onBackArrowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Set background color to blue
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
            icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon color set to white
            onPressed: onBackArrowPressed,
          ),
          SizedBox(width: 12.0),
          CircleAvatar(
            radius: 24.0,
            backgroundImage: profileImage != null
                ? AssetImage(profileImage!)
                : null, // Check if profile image is provided
            child: profileImage == null
                ? Text(profileName[0], style: TextStyle(color: Colors.white)) // Display first letter if profile image is not provided, set text color to white
                : null,
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
                  color: Colors.white, // Set text color to white
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                lastSeen,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.call, color: Colors.white), // Call icon color set to white
            onPressed: () {
              // Call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white), // Three dots icon color set to white
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

class OutgoingImageMessage extends StatelessWidget {
  final String imagePath;
  final String time;
  final MessageStatus status;

  const OutgoingImageMessage({
    required this.imagePath,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(imagePath, width: 150, height: 150), // Set width and height for the image
            SizedBox(height: 4.0),
            Text(
              time,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
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
