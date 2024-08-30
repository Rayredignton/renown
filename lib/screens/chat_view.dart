import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renown/models/messages_model.dart';
import 'package:renown/viewmodel/auth_viewmodel.dart';
import 'package:renown/viewmodel/chat_viewmodel.dart';

class ChatView extends StatefulWidget {
  final String receiverId; // Add receiverId parameter
  final String receiverName; // Add receiverName parameter

  ChatView({required this.receiverId, required this.receiverName});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  late ChatViewModel chatProvider;
  late AuthViewModel authProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatProvider = Provider.of<ChatViewModel>(context);
    authProvider = Provider.of<AuthViewModel>(context);

    // Replace with actual receiver ID
    final chatPartnerId = 'receiver-user-id';

    // Fetch messages for the current chat
    chatProvider.fetchMessages(authProvider.user!.uid, chatPartnerId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatViewModel>(context);
    final authProvider = Provider.of<AuthViewModel>(context);

    // Fetch messages between the current user and the receiver
    chatProvider.fetchMessages(authProvider.user!.uid, widget.receiverId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverName}'), // Show the receiver's name
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  reverse: true,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return ListTile(
                      title: Text(
                        message.content,
                        style: TextStyle(
                          color: message.senderId == authProvider.user!.uid
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                      subtitle: Text(
                        'Sent by: ${message.senderName}',
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.trim().isNotEmpty) {
                      final message = Message(
                        senderName:  authProvider.user!.displayName??"",
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        senderId: authProvider.user!.uid,
                        receiverId: widget.receiverId, // Use the actual receiver ID
                        content: _messageController.text.trim(),
                        timestamp: DateTime.now(),
                      );
                      await chatProvider.sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
