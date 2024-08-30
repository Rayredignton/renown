import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:renown/models/messages_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  ChatViewModel() {
    // Load messages from local storage when the view model is initialized
    _loadMessagesFromLocalStorage();
  }

  // Fetch messages from Firestore and offline storage
  Future<void> fetchMessages(String userId1, String userId2)async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Device is offline; use offline messages
      print("Fetching messages from local storage.");
      _loadMessagesFromLocalStorage();
    } else {
      // Device is online; fetch messages from Firestore
      print("Fetching messages from Firestore.");
      await _fetchMessagesFromFirestore(userId1, userId2);
    }
  }

  // Fetch messages from Firestore
 Future<void> _fetchMessagesFromFirestore(String userId1, String userId2) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('messages')
          .where('senderId', whereIn: [userId1, userId2])
          .where('receiverId', whereIn: [userId1, userId2])
          .orderBy('timestamp', descending: true)
          .get();

      _messages = snapshot.docs
          .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching messages from Firestore: $e');
    }
  }

  // Load messages from local storage
  Future<void> _loadMessagesFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? messagesJson = prefs.getStringList('messages');

      if (messagesJson != null) {
        _messages = messagesJson.map((msg) => Message.fromJson(msg)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading messages from local storage: $e');
    }
  }

  // Save messages to local storage
  Future<void> _saveMessagesToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> messagesJson = _messages.map((msg) => msg.toJson()).toList();
      await prefs.setStringList('messages', messagesJson);
    } catch (e) {
      print('Error saving messages to local storage: $e');
    }
  }

  // Send a message
  Future<void> sendMessage(Message message) async {
    try {
      await _firestore.collection('messages').doc(message.id).set(message.toMap());
      _messages.insert(0, message); // Add the new message to the top of the list

      // Save the updated message list to local storage
      await _saveMessagesToLocalStorage();
      notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
