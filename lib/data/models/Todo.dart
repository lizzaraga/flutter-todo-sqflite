import 'package:flutter/material.dart';

class Todo{
  String title;
  bool done;
  int id;
  Todo({this.id = -1, @required this.title, this.done = false});

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "done": done ? 1 : 0,
      "title": title
    };
  }

  static Todo fromMap(Map<String, dynamic> map){
    return Todo(
      id: map['id'],
      title: map['title'],
      done: map['done'] == 1 ,
    );
  }
}

