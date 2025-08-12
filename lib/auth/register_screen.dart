import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/components/my_authtextfield.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key, required this.onTap});

  final void Function()? onTap;

  // Controllers for text and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPWController = TextEditingController();

  // Helper method to validate email domain
  bool isValidEmailDomain(String email) {
    final allowedDomains = [
      'gmail.com',
      'outlook.com',
      'yahoo.com',
      'icloud.com',
      'hotmail.com',
      'live.com',
      'aol.com',
      // Add more valid domains if needed
    ];

    try {
      final domain = email.split('@').last.toLowerCase();
      return allowedDomains.contains(domain);
    } catch (e) {
      return false;
    }
  }

  // Registration function
  void register(BuildContext context) async {
    // call the class
    final authService = AuthService();

    // Check if email domain is valid
    if (!isValidEmailDomain(_emailController.text)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please use a valid email address.Must contain "@" and valid domain',
          ),
        ),
      );
      return;
    }

    // pw and cpw must match to create an account
    if (_confirmPWController.text == _passwordController.text) {
      try {
        await authService.signUpWithEmailAndPassword(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords don\'t match!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.chat_rounded,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            // Some Text
            Text(
              'Register Now and start chatting!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            // Username
            MyAuthtextfield(
              hintText: 'User Name',
              obscureText: false,
              prefixIcon: Icon(Icons.person),
              controller: _usernameController,
            ),
            // Email
            MyAuthtextfield(
              hintText: 'Email',
              obscureText: false,
              prefixIcon: Icon(Icons.email),
              controller: _emailController,
            ),
            // Password
            MyAuthtextfield(
              hintText: 'Password',
              obscureText: true,
              prefixIcon: Icon(Icons.password_rounded),
              controller: _passwordController,
            ),

            // Confirm Password
            MyAuthtextfield(
              hintText: 'Confirm Password',
              obscureText: true,
              prefixIcon: Icon(Icons.password_rounded),
              controller: _confirmPWController,
            ),
            // Login Button
            MyButton(text: 'Sign Up', onTap: () => register(context)),
            const SizedBox(height: 20),
            // Register Now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login Now',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
