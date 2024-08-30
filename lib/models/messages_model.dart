import 'dart:convert';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  final String senderName; 

  Message( {
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.senderName,
  });

  // Convert a Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
         
       'senderName': senderName, 
    };
  }

  // Convert a JSON object to a Message
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
       senderName: map['senderName'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  // Convert Message to JSON string
  String toJson() {
    return toMap().toString();
  }

  // Convert JSON string to Message
  factory Message.fromJson(String json) {
    final map = jsonDecode(json);
    return Message.fromMap(map);
  }
}
