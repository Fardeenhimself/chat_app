import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusHandler with WidgetsBindingObserver {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _setOnline();
  }

  void disposeHandler() {
    WidgetsBinding.instance.removeObserver(this);
    _setOffline();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_auth.currentUser != null) {
      if (state == AppLifecycleState.resumed) {
        _setOnline();
      } else if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.detached) {
        _setOffline();
      }
    }
  }

  void _setOnline() {
    final user = _auth.currentUser;
    if (user == null) return;
    _firestore.collection('Users').doc(user.uid).update({
      'status': 'online',
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  void _setOffline() {
    final user = _auth.currentUser;
    if (user == null) return;
    _firestore.collection('Users').doc(user.uid).update({
      'status': 'offline',
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}
