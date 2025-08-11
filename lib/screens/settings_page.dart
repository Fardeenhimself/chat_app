import 'package:chat_app/auth/auth_gate.dart';
import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final AuthService authService = AuthService();

  // Delete account
  void confirmAndDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog first

              try {
                await AuthService().deleteAccount();

                // Show success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deleted successfully!'),
                  ),
                );

                // Navigate to login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('S E T T I N G S')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DARK MODE',
                  style: TextStyle(letterSpacing: 1.5, fontSize: 15),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).isDarkMode,
                  onChanged: (value) => Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme(),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: TextButton.icon(
                onPressed: () => confirmAndDeleteAccount(context),
                label: const Text(
                  'DELETE ACCOUNT',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    letterSpacing: 1.5,
                  ),
                ),
                icon: const Icon(
                  Icons.delete_forever,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
