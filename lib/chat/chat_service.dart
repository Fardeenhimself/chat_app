import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // Instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get users
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      // go through all the users
      return snapshot.docs.map((doc) {
        final user = doc.data();

        // return user into a list
        return user;
      }).toList();
    });
  }
}
