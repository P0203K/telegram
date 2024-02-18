import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/model/message.dart';

class ChatService extends ChangeNotifier {

  // Get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverPhoneNumber, String message) async {
    // Get current user info
    final String currentUserPhoneNumber = _firebaseAuth.currentUser!.phoneNumber.toString();
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderPhoneNumber: currentUserPhoneNumber,
      receiverPhoneNumber: receiverPhoneNumber,
      timestamp: timestamp,
      message: message,
    );

    // Construct a chat room id
    String chatRoomId = _constructChatRoomId(currentUserPhoneNumber, receiverPhoneNumber);
    print('Adding message to chat room: $chatRoomId');

    // Add new message to database
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  // Construct chat room id
  String _constructChatRoomId(String phoneNumber1, String phoneNumber2) {
    List<String> phoneNumbers = [phoneNumber1, phoneNumber2];
    phoneNumbers.sort();
    return phoneNumbers.join("");
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String phoneNumber1, String phoneNumber2) {
    String chatRoomId = _constructChatRoomId(phoneNumber1, phoneNumber2);

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
