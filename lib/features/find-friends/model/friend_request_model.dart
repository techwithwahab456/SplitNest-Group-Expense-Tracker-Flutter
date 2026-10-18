import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String receiverId;
  final String status; // 'pending', 'accepted'
  final DateTime? timestamp;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverId,
    required this.status,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'senderName': senderName,
    'senderEmail': senderEmail,
    'receiverId': receiverId,
    'status': status,
    'timestamp': timestamp ?? FieldValue.serverTimestamp(),
  };

  factory FriendRequestModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return FriendRequestModel(
      id: snap.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}