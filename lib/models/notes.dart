class Note {

  int _id;
  String _description;
  String _date;
  String _title;
  int _priority;


  Note(this._date, this._priority, this._title, [this._description]);
  Note.withId(this._id, this._title, this._priority, this._date, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description =>_description;

  int get priority => _priority;
  set title (String newTitle) {
    if(newTitle.length <=255)
         this._title = newTitle;
  }

  set priority (int newPriority) {
    if( newPriority >=1 && newPriority <=2){
      this._priority = newPriority;
    }
  }

  set date(String newDate){
    this._date = newDate;
  }

  set description(String description ){
    this.description = description;
  }

  set id( int id ){
    this.id = id;
  }

  Map<String, dynamic > toMap() {

    var map = Map<String, dynamic>();

    map['id'] = _id;

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = priority;
    map['date'] = _date;

    return map;
  }


  //Extract Note From a MapObject

Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];

    this._title = map['title'];
    this._description = map['description'];
    this.priority = map['priority'];
    this.date = map ['date'];
  }
}