import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';


class NoteService {
  final _fire = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _col =>
      _fire.collection('users').doc(_uid).collection('diary');

  Stream<List<Note>> streamNotes() {
    return _col.orderBy('date', descending: true).snapshots().map(
          (s) => s.docs.map((d) => Note.fromDoc(d)).toList(),
    );
  }

  Future<void> addNote({
    required String emotion,
    required String text,
    required DateTime date,
  }) async {
    final now = DateTime.now();
    await _col.add({
      'emotion': emotion.trim(),
      'text': text.trim(),
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  Future<void> updateNote(Note note) async {
    await _col.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await _col.doc(id).delete();
  }
}
