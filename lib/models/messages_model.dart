import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final String senderName; 

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.senderName,
  });

  // Deserialize from Firestore
  factory Message.fromMap(Map<String, dynamic> map) {
    // Handle different types for the timestamp field
    final timestampField = map['timestamp'];
    DateTime timestamp;

    if (timestampField is Timestamp) {
      // If the field is a Firestore Timestamp
      timestamp = timestampField.toDate();
    } else if (timestampField is String) {
      // If the field is a String, parse it as a DateTime
      timestamp = DateTime.parse(timestampField);
    } else {
      // Handle other cases or default to the current time
      timestamp = DateTime.now();
    }

    return Message(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      timestamp: timestamp,
      senderName: map['senderName'],
    );
  }

  // Deserialize from JSON
  factory Message.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return Message.fromMap(map);
  }

  // Serialize to JSON
  String toJson() {
    return jsonEncode({
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'senderName': senderName,
    });
  }

  // Serialize to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp), // Convert DateTime to Firestore Timestamp
      'senderName': senderName,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
