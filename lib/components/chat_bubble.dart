import 'package:chat_app/chat/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.userID,
    required this.messageID,
  });

  final String message;
  final bool isCurrentUser;
  final String messageID;
  final String userID;

  // show options
  void showOptions(BuildContext context, String messageID, String userID) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              // Report user button
              CupertinoListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Report'),
                onTap: () {
                  Navigator.of(context).pop();
                  _reportMessage(context, messageID, userID);
                },
              ),

              // Block user button
              CupertinoListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.of(context).pop();
                  _blockUser(context, userID);
                },
              ),

              // cancel
              CupertinoListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // report user
  void _reportMessage(BuildContext context, String messageId, String userID) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Message'),
        content: const Text('Are you sure you want to report this message?'),
        actions: [
          // cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          // report
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageID, userID);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Message Reported')));
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  // block user
  void _blockUser(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure you want to block this user?'),
        actions: [
          // cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          // report
          TextButton(
            onPressed: () {
              // perform the function
              ChatService().blockUser(userID);
              // pop the dialog
              Navigator.of(context).pop();
              // pop the page
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('User Blocked!')));
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  // cancel

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // show options for the user
        if (!isCurrentUser) {
          showOptions(context, messageID, userID);
        }
      },
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
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
