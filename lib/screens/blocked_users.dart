import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/chat/chat_service.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockedUsers extends StatelessWidget {
  BlockedUsers({super.key});

  // Services
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  // show unblock option
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: const Text('Are you sure you want to unblock this user?'),
        actions: [
          // cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          // Unblock
          ElevatedButton(
            onPressed: () {
              chatService.unblockUser(userId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: const Text('User unblocked!')));
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userID = authService.getCurrentUser()!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('BLOCKED USERS'), actions: []),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUsers(userID),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data!'));
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          // no user
          final blockerUsers = snapshot.data ?? [];
          if (blockerUsers.isEmpty) {
            return const Center(child: Text('No blocked users :)'));
          }

          // blocked users
          return ListView.builder(
            itemCount: blockerUsers.length,
            itemBuilder: (context, index) {
              final user = blockerUsers[index];
              return UserTile(
                userName: user['email'],
                onTap: () => _showUnblockBox(context, user['uid']),
              );
            },
          );
        },
      ),
    );
  }
}
