import 'package:flutter/material.dart';
import 'package:telegram/screen/h.dart';

class ChatPage extends StatefulWidget {
  final String receivedUserPhoneNumber;
  final String receivedUserID;
  const ChatPage(
      {super.key,
      required this.receivedUserID,
      required this.receivedUserPhoneNumber
      });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivedUserPhoneNumber),
      ),
    );
  }
}
