import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/chat/chat_service.dart';
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
  });

  final String recieverEmail;
  final String recieverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // auth and chat services
  final AuthService _auth = AuthService();

  final ChatService _chatService = ChatService();

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // send message method
  void sendMessage() async {
    // If the field is not empty send a message
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recieverID,
        _messageController.text,
      );
    }

    // Clear the field
    _messageController.clear();

    // automatically scroll down after new message is sent
    scrollDown();
  }

  // Focus Node
  final FocusNode _myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener
    _myFocusNode.addListener(() {
      if (_myFocusNode.hasFocus) {
        //delay the keyboard
        // then scroll to the bottom using scroll controller
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    // wait for the listview to build
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Scroller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recieverEmail)),
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
      stream: _chatService.getMessage(widget.recieverID, senderID),
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
          controller: _scrollController,
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
      child: ChatBubble(
        isCurrentUser: isCurrentUser,
        message: data['message'],
        messageID: doc.id,
        userID: doc['senderID'],
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
              focusNode: _myFocusNode,
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
