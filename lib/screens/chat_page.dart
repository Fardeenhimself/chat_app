import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/chat/chat_service.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.recieverEmail, required this.recieverID});

  final String recieverEmail;
  final String recieverID;

  // auth and chat services
  final AuthService _auth = AuthService();
  final ChatService _chatService = ChatService();

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // send message method
  void sendMessage() async {
    // If the field is not empty send a message
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(recieverID, _messageController.text);
    }

    // Clear the field
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recieverEmail)),
      body: Column(
        children: [
          // Message list
          Expanded(child: _buildMessageList()),
          // Input field
          _buildUserInput(context),
        ],
      ),
    );
  }


  // B U I L D  M E S S A G E  L I S T
  Widget _buildMessageList() {
    String senderID = _auth.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(recieverID, senderID),
      builder: (context, snapshot) {
        // Error
        if (snapshot.hasError) {
          return Center(child: Text('Error loading chats'));
        }

        // Waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }

        // Listview
        return ListView(
          reverse: true,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc, context))
              .toList(),
        );
      },
    );
  }

  // B U I L D  M E S S A G E  I T E M
  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // if current user, send messages to right
    bool isCurrentUser = data['senderID'] == _auth.getCurrentUser()!.uid;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Colors.greenAccent.shade100
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              data['message'],
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // B U I L D  U S E R  I N P U T

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, right: 10),
      child: Row(
        children: [
          // User input
          Expanded(
            child: MyTextfield(
              hintText: 'Aa',
              obscureText: false,
              prefixIcon: Icon(Icons.add),
              controller: _messageController,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.arrow_upward, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
