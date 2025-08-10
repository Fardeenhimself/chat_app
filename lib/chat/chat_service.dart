import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Instance of firestore and auth store
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GET USER METHOD
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
      message: message,
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
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
