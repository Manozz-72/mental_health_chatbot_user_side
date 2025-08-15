import 'package:cloud_firestore/cloud_firestore.dart';

class DbReference {
  // Returns the reference to the 'users' collection
  CollectionReference get userRef {
    return FirebaseFirestore.instance.collection('users');
  }

  get uid => null;
}
