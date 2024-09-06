import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
// get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");
// CREATE
  Future<void> addNotes(String note) {
    return notes.add({
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

// READ
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy("timestamp", descending: true).snapshots();
    return notesStream;
  }

//UPDATE
  Future<void> updateNote(String docId, String newNoteText) {
    return notes.doc(docId).update({
      "note": newNoteText,
      "timestamp": Timestamp.now(),
    });
  }

// DELETE
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
