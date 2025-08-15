import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String emotion;
  final String text;
  final DateTime date;       // user-selected date for the note
  final DateTime createdAt;  // when record created
  final DateTime updatedAt;  // when last updated

  Note({
    required this.id,
    required this.emotion,
    required this.text,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      emotion: d['emotion'] ?? '',
      text: d['text'] ?? '',
      date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'emotion': emotion,
    'text': text,
    'date': Timestamp.fromDate(date),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}
