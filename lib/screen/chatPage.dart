import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/screen/h.dart';
import 'package:telegram/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receivedUserPhoneNumber;
  const ChatPage({
    Key? key,
    required this.receivedUserPhoneNumber,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send messages if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receivedUserPhoneNumber,
        _messageController.text,
      );
      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivedUserPhoneNumber),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput()
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receivedUserPhoneNumber, _firebaseAuth.currentUser!.phoneNumber.toString()),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          print("Error fetching messages: ${snapshots.error}");
          return Text('Error: ${snapshots.error}');
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          print("Waiting for messages...");
          return const Text('Loading...');
        }
        if (!snapshots.hasData) {
          print("No message data available.");
          return const Text('No messages yet.');
        }
        print("Received message data: ${snapshots.data}");
        return ListView(
          children: snapshots.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderPhoneNumber'] ==
        _firebaseAuth.currentUser!.phoneNumber)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: (data['senderPhoneNumber'] ==
                _firebaseAuth.currentUser!.phoneNumber)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(data['senderPhoneNumber']),
              Text(data['message']),
            ],
          ),
        ));
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //   textfield
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              hintText: 'Enter message',
            ),
            obscureText: false,
          ),
        ),

        //   send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        )
      ],
    );
  }
}
