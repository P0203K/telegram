import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderPhoneNumber;
  final String receiverPhoneNumber;
  final Timestamp timestamp;
  final String message;
  final String? imageUrl; // Add imageUrl field

  Message({
    required this.senderPhoneNumber,
    required this.receiverPhoneNumber,
    required this.timestamp,
    required this.message,
    this.imageUrl, // Initialize imageUrl field
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
