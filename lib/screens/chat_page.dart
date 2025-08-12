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
    required this.recieverUsername,
  });

  final String recieverUsername;
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

  // block user
  void _blockUser(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Block User',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        content: Text(
          'Are you sure you want to block this user?',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          // cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),

          // report
          TextButton(
            onPressed: () {
              // perform the function
              _chatService.blockUser(userID);
              // pop the dialog
              Navigator.of(context).pop();
              // pop the page
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('User Blocked!')));
            },
            child: Text(
              'Block',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
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
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.recieverID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recieverEmail,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "Offline",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              );
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String statusText;

            if (userData['status'] == 'online') {
              statusText = "Online";
            } else if (userData['lastActive'] != null) {
              DateTime lastSeen = (userData['lastActive'] as Timestamp)
                  .toDate();
              statusText = "Last seen: ${_formatLastSeen(lastSeen)}";
            } else {
              statusText = "Offline";
            }

            return Column(
              children: [
                Text(
                  widget.recieverUsername,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _blockUser(context, widget.recieverID);
            },
            icon: Icon(Icons.person_off),
          ),
        ],
      ),
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
              icon: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // L A S T  S E E N  F O R M A T T E R
  String _formatLastSeen(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}
