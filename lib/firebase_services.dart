import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> saveMessage(String text, String sender) async {
    await _firestore.collection('chat_history').add({
      'sender': sender,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
