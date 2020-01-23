import 'package:flutter/material.dart';
import 'dart:async';
import 'package:my_notekeeper/models/notes.dart';
import 'package:my_notekeeper/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {

  final String title;
  final Note note;
  NoteDetail( this.note,this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NoteDetailState(this.note,this.title);
  }
}

class _NoteDetailState extends State<NoteDetail> {

  String title;
  Note note;
  _NoteDetailState(this.note,this.title);

  static var _priorities = ['High', 'Low'];

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            moveToLastScreen();
          },
          )
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectByUser');
                        updatePriorityAsInt(valueSelectByUser);
                      });
                    }),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(),
                    onChanged: (value) {
                      debugPrint("Something is changed ");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: TextStyle(),
                    onChanged: (value) {
                      debugPrint("Something is changed ");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  )),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save  Clicked");
                            _save();
                          });
                        }),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete Clicked");
                            _delete();
                          });
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value){
    switch(value){
      case 'High' : note.priority = 1;
      break;
      case 'Low' : note.priority = 2;
      break;
    }
  }

  String getPriorityAsString (int value) {
    String priority;
    switch(value){
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription(){
    note.description = descriptionController.text;
  }

  void _showAlertDialog(String title, String message){
      AlertDialog alertDialog = AlertDialog(title: Text(title), content: Text(message),);
      showDialog(context: context, builder: ((_)=> alertDialog));
  }

  void _delete() async{
    int result;
    if(note.id == null){
      _showAlertDialog("Status", 'No Note Was Deleted');
      return ;
    }
    
   result = await databaseHelper.deleteNote(note.id);
    if( result != 0){
      _showAlertDialog('Status', 'Deletion Was Successfull');
    }
    else
      {
        _showAlertDialog('Status', 'Deletion Failed! Please Try Again Later');
      }
  }

  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result ;
    if( note.id != null){
      result = await databaseHelper.updateNote(note);
    }
    else {
      result = await databaseHelper.insertNote(note);
    }
    if( result != 0){
      _showAlertDialog('Status ', 'Note Saved Successfully');
    }
    else
      {
        _showAlertDialog('Status ','Problem Saving Note ! Please try again later');
      }


}

}
