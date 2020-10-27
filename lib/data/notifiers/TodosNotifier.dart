import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_vs/data/models/Todo.dart';
import 'package:flutter_vs/data/repos/TodoRepository.dart';

class TodosNotifier extends ChangeNotifier{
  List<Todo> _todos = [];
  UnmodifiableListView<Todo> get items  => UnmodifiableListView(
    _todos.where((element) => element.done == false)
  );
  final TodoRepository _repository = TodoRepository();
  
  TodosNotifier(){
    _initData();
  }

  Future<void> _initData() async {
    _todos = await _repository.allTodos();
    notifyListeners();
  }

  Future createTodo(Todo todo) async{
    _todos.add(todo);
    notifyListeners();
    _repository.insertTodo(todo);

    _todos.forEach((element) {
      print(element.toMap().toString());
    });
  }

  Future deleteTodo(Todo todo) async{
    _todos.removeWhere((element) => element.id == todo.id);
    notifyListeners();
    _repository.deleteTodo(todo);
  }

  Future updateTodo(Todo todo) async{
    _repository.updateTodo(todo);
    notifyListeners();
    print('UPDATE');
    _todos.forEach((element) {
      print(element.toMap().toString());
    });
  }

  
}