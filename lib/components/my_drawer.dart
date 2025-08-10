import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/screens/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // Sign Out method
  void signOut() async {
    // Call the class
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Icon(
                  Icons.chat_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              ),

              // home
              ListTile(
                contentPadding: EdgeInsets.only(left: 30),
                leading: Icon(Icons.home_filled),
                title: Text('H O M E'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              // settings
              ListTile(
                contentPadding: EdgeInsets.only(left: 30),
                leading: Icon(Icons.settings),
                title: Text('S E T T I N G S'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => SettingsPage()));
                },
              ),
            ],
          ),

          // logout
          ListTile(
            contentPadding: EdgeInsets.only(left: 30, bottom: 30),
            leading: Icon(Icons.logout_rounded),
            title: Text('L O G  O U T'),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}
