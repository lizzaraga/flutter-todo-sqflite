import 'package:flutter_vs/data/models/Todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';

class TodoRepository{


  TodoRepository(){
    _initDb();
  }

  Future _initDb() async{
    
  }

  Future<List<Todo>> allTodos() async{
    final db = await database;
    var todos = await db.query("todos");
    return List.generate(todos.length, (index) => Todo.fromMap(todos[index]));
  }

  Future<void> insertTodo(Todo todo) async{
    final db = await database;
    todo.id = await db.insert(
      "todos",
      todo.toMap()
    );
    print("Insert! ${todo.id}");
  }
  Future<void> deleteTodo(Todo todo) async{
    final db = await database;
    db.delete(
      "todos",
      where: 'id = ?',
      whereArgs: [todo.id]
    );
  }
  Future<void> updateTodo(Todo todo) async{
    final db = await database;
    db.update(
      "todos",
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id]
    );
  }
}