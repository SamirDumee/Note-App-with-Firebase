import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();
  TextEditingController textController = TextEditingController();
  // open add dialog box
  void openAddNoteBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: docId == null ? Text("Add new note") : Text("Edit note"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId == null) {
                firestoreService.addNotes(textController.text);
              } else {
                firestoreService.updateNote(docId, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: docId == null
                ? const Text("Add")
                : const Text(
                    "Save",
                  ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
            ),
          )
        ],
      ),
    );
  }

  void deleteNote(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                firestoreService.deleteNote(docId);
                Navigator.pop(context);
              },
              child: Text(
                "Delete",
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddNoteBox,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docId = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data["note"];
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openAddNoteBox(docId: docId),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteNote(docId),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No notes at the moment");
          }
        },
      ),
    );
  }
}
