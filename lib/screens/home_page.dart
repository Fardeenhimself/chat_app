import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/chat/chat_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('H O M E')),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // B U I L D  U S E R  L I S T
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching data'));
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }
        // listtile
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // B U I L D  U S E R  L I S T  I T E M
  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      // display all user except current user
      return UserTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ChatPage(
                recieverEmail: userData['email'],
                recieverID: userData['uid'],
              ),
            ),
          );
        },
        userName: userData['email'],
      );
    } else {
      return Container();
    }
  }
}
