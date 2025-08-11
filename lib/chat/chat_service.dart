import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // Instance of firestore and auth store
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GET ALL USER METHOD
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

  // GET ALL USERS EXCEPT BLOCKED
  // TODO

  // SEND MESSAGE METHOD
  Future<void> sendMessage(String recieverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recieverID: recieverID,
      messages: message,
      timestamp: timestamp,
    );

    // construst chat room ID
    List<String> ids = [currentUserID, recieverID];
    ids.sort(); // Ensures so that both users have a unique but same ID

    // create a new chatroom id and join the sorted id
    String chatRoomID = ids.join('_');

    // add message to db ( go to the database, create a collection called 'chat room', document the 'chat room id there', then open a new collection in that room called 'messages' and store the newMessage)

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGE METHOD
  Stream<QuerySnapshot> getMessage(userID, otherUserID) {
    // sort the id to generate unique chat room id
    List<String> ids = [userID, otherUserID];
    ids.sort(); // Ensures so that both users have a unique but same ID

    //construst chat room ID
    String chatRoomID = ids.join('_');

    // fetch from the db (go to the chat_room, from there get the chatRoomID, then get the messages from there according to the timestamp)
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Report User
  Future<void> reportUser(String messageID, String userID) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageID': messageID,
      'messageOwnerID': userID,
      'timestamp': Timestamp.now(),
    };
    // create a new collection and add it
    await _firestore.collection('Report').add(report);
  }

  // Block User
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('Blocked User')
        .doc(userID)
        .set({});
    notifyListeners();
  }

  // Unblock user
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('Blocked User')
        .doc(blockedUserID)
        .delete();
  }

  // GET BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getBlockedUsers(String userID) {
    return _firestore
        .collection('Users')
        .doc(userID)
        .collection('Blocked User')
        .snapshots()
        .asyncMap((snapshot) async {
          // get list of blocked users
          final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();

          //
          final userDocs = await Future.wait(
            blockedUserIDs.map(
              (id) => _firestore.collection('Users').doc(id).get(),
            ),
          );

          //return as list
          return userDocs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
  }
}
