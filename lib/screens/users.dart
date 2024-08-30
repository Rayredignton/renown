import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:renown/screens/chat_view.dart';
import 'package:renown/viewmodel/auth_viewmodel.dart';


class ChatUsersView extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
     final authProvider = Provider.of<AuthViewModel>(context);
    final u= authProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              if(user['email'] == u!.email!.toLowerCase() ){
                return SizedBox();
              }else {
                return ListTile(
                title: Text(user['email'] ?? 'Unknown'),
                subtitle: Text(user['displayName'] ?? ''),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatView(
                        receiverId: user['uid'],
                        receiverName: user['displayName'] ?? user['email'],
                      ),
                    ),
                  );
                },
              );
              }
            },
          );
        },
      ),
    );
  }
}
