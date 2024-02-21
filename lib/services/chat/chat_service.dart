// chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverPhoneNumber, String message, {String? imageUrl}) async {
    final String currentUserPhoneNumber = _firebaseAuth.currentUser!.phoneNumber.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderPhoneNumber: currentUserPhoneNumber,
      receiverPhoneNumber: receiverPhoneNumber,
      timestamp: timestamp,
      message: message,
      imageUrl: imageUrl,
    );

    String chatRoomId = _constructChatRoomId(currentUserPhoneNumber, receiverPhoneNumber);

    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add({
      'senderPhoneNumber': newMessage.senderPhoneNumber,
      'receiverPhoneNumber': newMessage.receiverPhoneNumber,
      'message': newMessage.message,
      'imageUrl': newMessage.imageUrl,
      'timestamp': newMessage.timestamp,
    });

    await _firestore.collection('chat_rooms').doc(chatRoomId).update({
      'lastMessage': {
        'senderPhoneNumber': newMessage.senderPhoneNumber,
        'message': newMessage.message,
        'imageUrl': newMessage.imageUrl,
        'timestamp': newMessage.timestamp,
      }
    });
  }

  String _constructChatRoomId(String phoneNumber1, String phoneNumber2) {
    List<String> phoneNumbers = [phoneNumber1, phoneNumber2];
    phoneNumbers.sort();
    return phoneNumbers.join("");
  }

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
