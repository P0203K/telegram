import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderPhoneNumber;
  final String receiverPhoneNumber;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderPhoneNumber,
    required this.receiverPhoneNumber,
    required this.timestamp,
    required this.message,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'senderPhoneNumber': senderPhoneNumber,
      'receiverPhoneNumber': receiverPhoneNumber,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
