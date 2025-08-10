import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.userName, required this.onTap});

  final String userName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          children: [
            // User Icon (Image to be implemented lated)
            Icon(Icons.person),
            const SizedBox(width: 12),
            // User Name (User email for now)
            Text(userName),
          ],
        ),
      ),
    );
  }
}


