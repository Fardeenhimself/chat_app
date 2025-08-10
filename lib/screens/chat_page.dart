import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/chat/chat_service.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(appBar: AppBar(title: Text(recieverEmail)));
  }
}
