import 'package:flutter/material.dart';
import './note_detail.dart';
import 'dart:async';
import 'package:my_notekeeper/models/notes.dart';
import 'package:my_notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {

  @override
  State createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }


    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(

        appBar: AppBar(
          title: Text("Notes"),
          leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              }),
        ),
        body: getNoteListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Note('', 2, ''), 'Add Note');
          },
          child: Icon(Icons.add),
          tooltip: 'Add Note',

        ),

      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[index].priority),
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              this.noteList[index].title,
              style: textStyle,
            ),
            subtitle: Text(this.noteList[index].description),
            trailing:

            GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, noteList[index]);
              },
            ),
            onTap: () {
              //TODO Replace this with the action

              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[index], 'Edit Note');
            },
          ),
        );
      },
    );
  }


  //Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2 :
        return Colors.yellow;
        break;
      default :
        return Colors.yellow;
    }
  }

  //Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1 :
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default :
        return Icon(Icons.keyboard_arrow_right);
    }
  }


  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
    }
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }


  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true)
      updateListView();
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}